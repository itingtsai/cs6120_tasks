#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct FDivDetectorPass : public PassInfoMixin<FDivDetectorPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
        bool modified = false;
        
        // count floating-point operations first
        int fdivCount = 0;
        for (auto &F : M) {
            if (F.isDeclaration()) continue;
            for (auto &BB : F) {
                for (auto &I : BB) {
                    if (auto *binOp = dyn_cast<BinaryOperator>(&I)) {
                        if (binOp->getOpcode() == Instruction::FDiv) {
                            fdivCount++;
                        }
                    }
                }
            }
        }
        
        // print how many floating-point operations in total
        errs() << "Found " << fdivCount << " FDiv operations in module\n";
        
        // If no FDiv operations, return early WITHOUT creating global variables
        if (fdivCount == 0) {
            errs() << "No FDiv operations found.\n";
            return PreservedAnalyses::all();
        }
        
        // Only create these if found FDiv operations
        // printf function for RUNTIME messages
        FunctionType *printfType = FunctionType::get(
            IntegerType::getInt32Ty(M.getContext()),
            PointerType::get(M.getContext(), 0),
            true
        );
        FunctionCallee printfFunc = M.getOrInsertFunction("printf", printfType);
        
        // global counter variable to track floating-point operations
        GlobalVariable *fdivCounter = new GlobalVariable(
            M,
            Type::getInt32Ty(M.getContext()),
            false,
            GlobalValue::InternalLinkage,
            ConstantInt::get(Type::getInt32Ty(M.getContext()), 0),
            "fdiv_counter"
        );
        
        Function *mainFunc = M.getFunction("main");
        
        // summary print before return in main at RUNTIME (only if main exists)
        if (mainFunc && !mainFunc->isDeclaration()) {
            for (auto &BB : *mainFunc) {
                for (auto I = BB.begin(); I != BB.end(); ++I) {
                    if (auto *retInst = dyn_cast<ReturnInst>(&*I)) {
                        IRBuilder<> builder(retInst);
                        
                        Value *finalCount = builder.CreateLoad(
                            Type::getInt32Ty(M.getContext()),
                            fdivCounter,
                            "final_count"
                        );
                        
                        Value *summaryStr = builder.CreateGlobalString(
                            "Total floating-point divisions: %d\n",
                            "",
                            0
                        );
                        
                        builder.CreateCall(printfFunc, {summaryStr, finalCount});
                        modified = true;
                    }
                }
            }
        }
        
        // instrument all floating-point division operations
        for (auto &F : M) {
            if (F.isDeclaration()) continue;
                
            for (auto &BB : F) {
                std::vector<BinaryOperator*> fdivInsts;
                for (auto &I : BB) {
                    if (auto *binOp = dyn_cast<BinaryOperator>(&I)) {
                        if (binOp->getOpcode() == Instruction::FDiv) {
                            fdivInsts.push_back(binOp);
                        }
                    }
                }
                
                for (auto *binOp : fdivInsts) {
                    IRBuilder<> builder(binOp);
                    
                    // counter increment
                    Value *currentCount = builder.CreateLoad(
                        Type::getInt32Ty(M.getContext()),
                        fdivCounter,
                        "load_counter"
                    );
                    Value *incrementedCount = builder.CreateAdd(
                        currentCount,
                        ConstantInt::get(Type::getInt32Ty(M.getContext()), 1),
                        "inc_counter"
                    );
                    builder.CreateStore(incrementedCount, fdivCounter);
                    
                    // print every time floating-point division executes at RUNTIME
                    Value *formatStr = builder.CreateGlobalString(
                        "Floating-point Division in function: %s\n",
                        "",
                        0
                    );
                    
                    Value *funcName = builder.CreateGlobalString(
                        F.getName(),
                        "",
                        0
                    );
                    
                    // printf execute at runtime every time the division runs
                    builder.CreateCall(printfFunc, {formatStr, funcName});
                    
                    modified = true;
                    
                    // COMPILE-TIME MESSAGE
                    errs() << "Floating-point Division in function: " << F.getName() << "\n";
                }
            }
        }
        
        return modified ? PreservedAnalyses::none() : PreservedAnalyses::all();
    }
};

}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        .APIVersion = LLVM_PLUGIN_API_VERSION,
        .PluginName = "FDiv Detector pass",
        .PluginVersion = "v0.1",
        .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel Level) {
                    MPM.addPass(FDivDetectorPass());
                });
        }
    };
}