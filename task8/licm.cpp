#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include <vector>

using namespace llvm;

namespace {

struct SkeletonPass : public PassInfoMixin<SkeletonPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
        auto &FAM = MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
        
        for (auto &F : M) {
            if (!F.isDeclaration()) {
                auto &Loops = FAM.getResult<LoopAnalysis>(F);
                auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
                
                for (auto &Loop : Loops) {
                    if (simplifyLoop(Loop, &DT, &Loops, nullptr, nullptr, nullptr, true)) {
                        // Step 1: Initialize all instructions as not loop-invariant
                        DenseMap<Instruction *, bool> LoopInvariantSet;
                        DenseSet<Instruction *> OutsideLoop;
                        
                        for (auto *Block : Loop->getBlocks()) {
                            for (auto &Inst : *Block) {
                                LoopInvariantSet[&Inst] = false;
                            }
                        }
                        
                        // Step 2: Identify loop-invariant instructions iteratively
                        int num_invariant = 0;
                        int num_new_invariant = 0;
                        do {
                            num_invariant = num_new_invariant;
                            num_new_invariant = 0;
                            
                            for (auto *Block : Loop->getBlocks()) {
                                for (auto &Inst : *Block) {
                                    if (LoopInvariantSet[&Inst]) {
                                        num_new_invariant++;
                                    }
                                    else if (Inst.isSafeToRemove() && 
                                             !Inst.mayHaveSideEffects() && 
                                             !isa<PHINode>(&Inst) &&
                                             !Inst.isTerminator()) {
                                        
                                        bool is_loop_invariant = true;
                                        
                                        // Check all operands
                                        for (auto &Op : Inst.operands()) {
                                            // Constants are always loop-invariant
                                            if (isa<Constant>(Op)) {
                                                continue;
                                            }
                                            
                                            if (auto *OpInst = dyn_cast<Instruction>(Op)) {
                                                // If operand is defined outside loop, it's invariant
                                                if (!Loop->contains(OpInst)) {
                                                    continue;
                                                }
                                                
                                                // If operand is inside loop but not marked as invariant yet
                                                if (!LoopInvariantSet[OpInst]) {
                                                    is_loop_invariant = false;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if (is_loop_invariant) {
                                            LoopInvariantSet[&Inst] = true;
                                            num_new_invariant++;
                                        }
                                    }
                                }
                            }
                        } while (num_invariant != num_new_invariant);
                        
                        // Step 3: Collect instructions that are safe to hoist
                        std::vector<Instruction *> HoistableInstructions;
                        for (auto *Block : Loop->getBlocks()) {
                            for (auto &Inst : *Block) {
                                if (Inst.isSafeToRemove() && 
                                    !Inst.mayHaveSideEffects() && 
                                    LoopInvariantSet[&Inst]) {
                                    
                                    // Safety check 1: Dominates all uses in the loop
                                    bool dominates_all_uses = true;
                                    for (auto &Use : Inst.uses()) {
                                        User* user = Use.getUser();
                                        if (Instruction *userInst = dyn_cast<Instruction>(user)) {
                                            if (Loop->contains(userInst)) {
                                                if (!DT.dominates(&Inst, userInst)) {
                                                    dominates_all_uses = false;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    if (!dominates_all_uses) continue;
                                    
                                    // Safety check 2: Not part of a recurrence (no PHI uses in loop)
                                    bool has_phi_use_in_loop = false;
                                    for (auto &Use : Inst.uses()) {
                                        User* user = Use.getUser();
                                        if (auto *PHI = dyn_cast<PHINode>(user)) {
                                            if (Loop->contains(PHI)) {
                                                has_phi_use_in_loop = true;
                                                break;
                                            }
                                        }
                                    }
                                    if (has_phi_use_in_loop) continue;
                                    
                                    // Safety check 3: Dominates all loop exits
                                    SmallVector<BasicBlock*, 8> ExitBlocks;
                                    Loop->getExitBlocks(ExitBlocks);
                                    bool dominates_all_exits = true;
                                    
                                    if (ExitBlocks.empty()) {
                                        dominates_all_exits = false;
                                    } else {
                                        for (BasicBlock *ExitBlock : ExitBlocks) {
                                            if (!DT.dominates(Inst.getParent(), ExitBlock)) {
                                                dominates_all_exits = false;
                                                break;
                                            }
                                        }
                                    }
                                    if (!dominates_all_exits) continue;
                                    
                                    HoistableInstructions.push_back(&Inst);
                                }
                            }
                        }
                        
                        // Step 4: Hoist instructions to preheader
                        auto preheader = Loop->getLoopPreheader();
                        for (auto *Inst : HoistableInstructions) {
                            Inst->moveBefore(preheader->getTerminator());
                        }
                    }
                }
            }
        }
        
        return PreservedAnalyses::none();
    };
};

}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        .APIVersion = LLVM_PLUGIN_API_VERSION,
        .PluginName = "Skeleton pass",
        .PluginVersion = "v0.1",
        .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel Level) {
                    MPM.addPass(SkeletonPass());
                });
        }
    };
}