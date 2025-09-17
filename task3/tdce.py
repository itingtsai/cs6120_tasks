import json
import sys
from typing import Dict, Set, List, Any

SIDE_EFFECT_OPS = {'call', 'print', 'ret', 'br', 'jmp', 'store'}
TERMINATOR_OPS = {'br', 'jmp', 'ret'}

def form_blocks(instrs: List[Dict[str, Any]]) -> List[List[Dict[str, Any]]]:
    blocks, current = [], []
    
    for instr in instrs:
        if 'op' in instr:
            current.append(instr)
            if instr['op'] in TERMINATOR_OPS:
                blocks.append(current)
                current = []
        else:
            if current:
                blocks.append(current)
            blocks.append([instr])
            current = []
    
    if current:
        blocks.append(current)
    
    return blocks

def get_uses(instrs: List[Dict[str, Any]]) -> Set[str]:
    return {arg for instr in instrs if 'args' in instr for arg in instr['args']}

def should_keep(instr: Dict[str, Any], uses: Set[str]) -> bool:
    if 'dest' not in instr:
        return True
    if instr.get('op') in SIDE_EFFECT_OPS:
        return True
    return instr.get('dest') in uses

def remove_globally_unused(instrs: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    uses = get_uses(instrs)
    return [instr for instr in instrs if should_keep(instr, uses)]

def remove_locally_killed(block: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    result = []
    
    for i, instr in enumerate(block):
        if 'dest' not in instr or instr.get('op') in SIDE_EFFECT_OPS:
            result.append(instr)
            continue
        
        dest = instr['dest']

        for future in block[i + 1:]:
            if 'args' in future and dest in future['args']:
                result.append(instr)
                break
            if future.get('dest') == dest:
                break
        else:
            result.append(instr)
    
    return result

def tdce(func: Dict[str, Any]) -> Dict[str, Any]:
    instrs = func.get('instrs', [])
    if not instrs:
        return func
    
    while True:
        original_count = len(instrs)
        
        instrs = remove_globally_unused(instrs)
        
        blocks = form_blocks(instrs)
        new_blocks = []
        for block in blocks:
            labels = [i for i in block if 'label' in i]
            ops = [i for i in block if 'op' in i]
            
            if ops:
                ops = remove_locally_killed(ops)
            
            new_blocks.append(labels + ops)
        
        instrs = [instr for block in new_blocks for instr in block]
        
        if len(instrs) >= original_count:
            break
    
    func['instrs'] = instrs
    return func

def main():
    prog = json.load(sys.stdin)
    
    for func in prog.get('functions', []):
        tdce(func)
    
    json.dump(prog, sys.stdout, indent=2)

if __name__ == '__main__':
    main()