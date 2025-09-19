[Source Code](https://github.com/itingtsai/cs6120_tasks/tree/main/task3)

**Implementation.**  
**Trivial dead code elimination (`tdce.py`):** Globally drops definitions whose destinations are never used anywhere and locally removes definitions that are killed before use by a later redefinition in the same basic block. I treat `call`/`print`/`ret`/`br`/`jmp`/`store` as side-effecting, so they are never removed. I iterate TDCE to a fixed point to catch secondary dead code after initial deletions.

**Local Value Numbering (`lvn.py`):** Works per basic block. It builds value keys using the operator and normalized arguments, handling commutativity, performs constant folding, and small algebraic identities, replaces redundant computations with copies from the first occurrence, and rewrites arguments to canonical producers. To preserve correctness inside the block, it freshens destinations that would otherwise be overwritten before their next use.

**Correctness.**  
TDCE never removes side-effects and deletes only provably dead definitions. LVN only substitutes equal values, normalizes commutative forms, folds constants, and applies sound identities; it does not move or drop side-effects. Freshening avoids name-clobbering.

**Evidence via Brench.**  
I ran Brench on several core Bril benchmarks with baseline, LVN, TDCE, and LVN+TDCE. Many benchmarks showed reductions with LVN and TDCE. This demonstrates that my implementation is functionally correct and optimizes programs across the standard Bril benchmarks.

**Michelin Star.**  
I would like to claim one Michelin star for completing the task. As a newbie to this area, I found learning the concept and coding / debugging all together very challenging. I apologize if anything was missed, and I’ll make sure to improve as I gain more experience.

<img width="1979" height="1180" alt="results" src="https://github.com/user-attachments/assets/d8931c7b-1e22-402f-8c85-4cd182b0744d" />
