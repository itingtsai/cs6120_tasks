import json
import sys
from typing import Dict, List, Set, Tuple

class CFGAnalyzer:
    def __init__(self, func):
        self.func = func
        self.blocks: List[List[dict]] = []
        self.label_map: Dict[str, int] = {}
        self.successors: Dict[int, List[int]] = {}
        self.predecessors: Dict[int, List[int]] = {}
        self.dominators: List[Set[int]] = []
        self.idom: List[int | None] = []
        self.dom_tree: Dict[int, List[int]] = {}
        self.dom_frontier: Dict[int, Set[int]] = {}
        
        self._build_cfg()
        self._compute_dominators()
        self._build_dom_tree()
        self._compute_dom_frontier()
    
    def _is_terminator(self, inst):
        return inst.get('op') in ['br', 'ret', 'jmp']
    
    def _build_cfg(self):
        current = []
        current_label = None
        
        for inst in self.func['instrs']:
            if 'label' in inst:
                if current:
                    self.blocks.append(current)
                    if current_label:
                        self.label_map[current_label] = len(self.blocks) - 1
                current = [inst]
                current_label = inst['label']
            elif self._is_terminator(inst):
                current.append(inst)
                self.blocks.append(current)
                if current_label:
                    self.label_map[current_label] = len(self.blocks) - 1
                current = []
                current_label = None
            else:
                current.append(inst)
        
        if current:
            self.blocks.append(current)
            if current_label:
                self.label_map[current_label] = len(self.blocks) - 1
        
        for i, block in enumerate(self.blocks):
            if not block:
                continue
            last = block[-1]
            if 'op' in last:
                if last['op'] in ['br', 'jmp']:
                    for label in last.get('labels', []):
                        if label in self.label_map:
                            self._add_edge(i, self.label_map[label])
                elif last['op'] != 'ret' and i < len(self.blocks) - 1:
                    self._add_edge(i, i + 1)
            else:
                if i < len(self.blocks) - 1:
                    self._add_edge(i, i + 1)
    
    def _add_edge(self, from_idx, to_idx):
        self.successors.setdefault(from_idx, []).append(to_idx)
        self.predecessors.setdefault(to_idx, []).append(from_idx)
    
    def _compute_dominators(self):
        n = len(self.blocks)
        self.dominators = [set(range(n)) for _ in range(n)]
        if n > 0:
            self.dominators[0] = {0}
        
        changed = True
        while changed:
            changed = False
            for i in range(1, n):
                preds = self.predecessors.get(i, [])
                if not preds:
                    new_dom = {i}
                else:
                    new_dom = set(range(n))
                    for p in preds:
                        new_dom &= self.dominators[p]
                    new_dom.add(i)
                if new_dom != self.dominators[i]:
                    self.dominators[i] = new_dom
                    changed = True
    
    def _build_dom_tree(self):
        n = len(self.blocks)
        self.idom = [None] * n
        if n == 0:
            self.dom_tree = {}
            return
        
        for b in range(1, n):
            candidates = self.dominators[b] - {b}
            idom_b = None
            for d in candidates:
                is_idom = True
                for c in candidates:
                    if c != d and d in self.dominators[c]:
                        is_idom = False
                        break
                if is_idom:
                    idom_b = d
                    break
            self.idom[b] = idom_b
        
        self.dom_tree = {}
        for b in range(n):
            p = self.idom[b]
            if p is not None:
                self.dom_tree.setdefault(p, []).append(b)
    
    def _compute_dom_frontier(self):
        n = len(self.blocks)
        self.dom_frontier = {b: set() for b in range(n)}
        for b in range(n):
            preds = self.predecessors.get(b, [])
            if len(preds) >= 2:
                for p in preds:
                    runner = p
                    while runner is not None and runner != self.idom[b]:
                        self.dom_frontier[runner].add(b)
                        runner = self.idom[runner]
    
    def verify_dominators(self) -> bool:
        def find_all_paths(start, end, path=[]):
            path = path + [start]
            if start == end:
                return [path]
            paths = []
            for node in self.successors.get(start, []):
                if node not in path:
                    paths.extend(find_all_paths(node, end, path))
            return paths
        
        n = len(self.blocks)
        if n == 0:
            return True
        
        for i in range(n):
            paths = find_all_paths(0, i)
            if not paths and i != 0:
                continue
            computed = set(paths[0]) if paths else {0}
            for path in paths:
                computed &= set(path)
            if computed != self.dominators[i]:
                print(f"[verify] Block {i}: path-intersection={sorted(computed)} != dominators={sorted(self.dominators[i])}")
                return False
        return True

    def print_blocks(self):
        print("Basic Blocks:")
        for i, block in enumerate(self.blocks):
            label = next((inst['label'] for inst in block if 'label' in inst), None)
            last_op = block[-1].get('op') if block and 'op' in block[-1] else None
            succs = self.successors.get(i, [])
            preds = self.predecessors.get(i, [])
            print(f"  B{i}: label={label!r:>8}  last_op={str(last_op):>5}  preds={sorted(preds)}  succs={sorted(succs)}")

    def print_dominators(self):
        print("\nDominators:")
        for i, doms in enumerate(self.dominators):
            print(f"  B{i}: doms={sorted(doms)}")

    def print_idom_tree(self):
        print("\nImmediate Dominators (idom):")
        for i, p in enumerate(self.idom):
            if i == 0:
                print("  B0: idom=None (entry)")
            else:
                print(f"  B{i}: idom={('B'+str(p)) if p is not None else 'None'}")
        print("\nDominator Tree (parent -> children):")
        if not self.dom_tree:
            print("  (empty)")
        else:
            for parent, kids in sorted(self.dom_tree.items()):
                print(f"  B{parent} -> {', '.join('B'+str(k) for k in sorted(kids))}")

    def print_dom_frontier(self):
        print("\nDominance Frontier (DF):")
        for b in range(len(self.blocks)):
            df = sorted(self.dom_frontier.get(b, set()))
            df_str = "phi" if not df else ", ".join(f"B{x}" for x in df)
            print(f"  DF(B{b})={df_str}")


def main():
    program = json.load(sys.stdin)
    analyzers: List[CFGAnalyzer] = []
    
    for func in program.get('functions', []):
        analyzer = CFGAnalyzer(func)
        analyzers.append(analyzer)
        
        name = func.get('name', 'unnamed')
        print(f"\n")
        analyzer.print_blocks()
        
        ok = analyzer.verify_dominators()
        print("\nDominator verification:", "PASS" if ok else "FAIL")
        analyzer.print_dominators()
        analyzer.print_idom_tree()
        analyzer.print_dom_frontier()
        
        non_empty_df = sum(1 for v in analyzer.dom_frontier.values() if v)
        print("\nSummary:")
        print(f"  Blocks={len(analyzer.blocks)}")
        print(f"  Edges={sum(len(v) for v in analyzer.successors.values())}")
        print(f"  DomTree_edges={sum(len(v) for v in analyzer.dom_tree.values())}")
        print(f"  Nodes_with_non-empty_DF={non_empty_df}")
        print(f"\n")
        
if __name__ == "__main__":
    main()
