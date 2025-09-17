import json
import sys
from typing import Dict, List, Any, Tuple, Optional

TERMINATOR_OPS = {'br', 'jmp', 'ret'}
COMMUTATIVE_OPS = {'add', 'mul', 'and', 'or', 'eq', 'fadd', 'fmul', 'feq'}

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

def evaluate_constant_op(op: str, args: List[Any], typ: str) -> Optional[Any]:
    if op == 'const':
        return args[0] if args else None
    try:
        if typ == 'int':
            if op == 'add': return args[0] + args[1]
            if op == 'sub': return args[0] - args[1]
            if op == 'mul': return args[0] * args[1]
            if op == 'div' and args[1] != 0: return args[0] // args[1]
        if typ == 'bool':
            if op == 'not': return (not args[0])
            if op == 'and': return args[0] and args[1]
            if op == 'or':  return args[0] or args[1]
        if op == 'eq': return args[0] == args[1]
        if op == 'lt': return args[0] <  args[1]
        if op == 'gt': return args[0] >  args[1]
        if op == 'le': return args[0] <= args[1]
        if op == 'ge': return args[0] >= args[1]
    except (IndexError, TypeError):
        pass
    return None

def apply_algebraic_identities(op: str, args_pairs: List[Tuple[Optional[int], str]], table: Dict) -> Optional[Tuple[str, Any]]:
    if len(args_pairs) != 2:
        return None

    def const_of(pair):
        num, _ = pair
        if num is not None and num in table:
            return table[num][2]
        return None

    c0, c1 = const_of(args_pairs[0]), const_of(args_pairs[1])

    if op == 'add':
        if c1 == 0: return ('use_arg', 0)
        if c0 == 0: return ('use_arg', 1)

    elif op == 'sub':
        if c1 == 0: return ('use_arg', 0)
        if args_pairs[0][0] is not None and args_pairs[0][0] == args_pairs[1][0]:
            return ('const', 0)

    elif op == 'mul':
        if c1 == 1: return ('use_arg', 0)
        if c0 == 1: return ('use_arg', 1)
        if c0 == 0 or c1 == 0: return ('const', 0)

    elif op == 'div':
        if c1 == 1: return ('use_arg', 0)


    elif op == 'and':
        if c0 is True:  return ('use_arg', 1)
        if c1 is True:  return ('use_arg', 0)
        if c0 is False: return ('const', False)
        if c1 is False: return ('const', False)

    elif op == 'or':
        if c0 is False: return ('use_arg', 1)
        if c1 is False: return ('use_arg', 0)
        if c0 is True:  return ('const', True)
        if c1 is True:  return ('const', True)

    return None

def create_id_instr(dest: str, src: str, typ: str) -> Dict[str, Any]:
    return {'op': 'id', 'dest': dest, 'type': typ, 'args': [src]}

def create_const_instr(dest: Optional[str], value: Any, typ: str) -> Dict[str, Any]:
    instr = {'op': 'const', 'value': value, 'type': typ}
    if dest:
        instr['dest'] = dest
    return instr

def normalize_commutative(op: str, arg_nums: List[Tuple[Optional[int], str]]) -> List[Tuple[Optional[int], str]]:
    if op in COMMUTATIVE_OPS:

        return sorted(arg_nums, key=lambda p: (p[0] is None, p[0], p[1]))
    return arg_nums


def process_instruction(instr: Dict, var2num: Dict[int, int], table: Dict[int, Tuple[str, Any, Optional[Any]]]) -> Tuple[Optional[Tuple], Optional[Any], str]:
    op = instr.get('op')

    if op == 'const':
        return ('const', instr.get('value')), instr.get('value'), 'const'

    if 'args' not in instr:

        return (op,), None, op

    arg_nums: List[Tuple[Optional[int], str]] = []
    const_args: List[Optional[Any]] = []
    all_const = True

    for arg in instr['args']:
        if arg in var2num:
            num = var2num[arg]
            arg_nums.append((num, arg))
            if num in table and table[num][2] is not None:
                const_args.append(table[num][2])
            else:
                all_const = False
                const_args.append(None)
        else:
            arg_nums.append((None, arg))
            all_const = False
            const_args.append(None)

    arg_nums = normalize_commutative(op, arg_nums)

    if all_const and None not in const_args:
        const_result = evaluate_constant_op(op, const_args, instr.get('type', 'int'))
        if const_result is not None:
            return ('const', const_result), const_result, 'const'


    ident = apply_algebraic_identities(op, arg_nums, table)
    if ident:
        kind, payload = ident
        if kind == 'const':
            return ('const', payload), payload, 'const'
        elif kind == 'use_arg':
            idx = int(payload)
            num = arg_nums[idx][0]
            if num is not None and num in table:

                canon_var = table[num][0]
                return ('id_of', canon_var), None, 'identity'

            return ('use_arg_name', arg_nums[idx][1]), None, 'identity'


    value = (op, tuple(arg_nums))
    return value, None, op

def will_be_overwritten(instrs: List[Dict[str, Any]], start_idx: int, var: str) -> bool:
    """True iff `var` is redefined before its next use in the remainder of instrs."""
    for j in range(start_idx + 1, len(instrs)):
        inst = instrs[j]
        if 'op' not in inst:
            continue
        if 'args' in inst and var in inst['args']:
            return False  
        if inst.get('dest') == var:
            return True 
    return False

def lvn_block(block: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    labels = [i for i in block if 'label' in i]
    instrs = [i for i in block if 'op' in i]
    if not instrs:
        return block

    table: Dict[int, Tuple[str, Any, Optional[Any]]] = {}     
    value_to_num: Dict[Any, int] = {}                        
    var2num: Dict[str, int] = {}                          
    next_num = 0
    next_fresh_var = 0

    result: List[Dict[str, Any]] = []

    for idx, instr in enumerate(instrs):
        value, const_val, kind = process_instruction(instr, var2num, table)

        if kind == 'identity' and value:
            if value[0] == 'id_of' and 'dest' in instr:
                src_var = value[1]
                result.append(create_id_instr(instr['dest'], src_var, instr.get('type')))

                if src_var in var2num:
                    var2num[instr['dest']] = var2num[src_var]
                continue
            if value[0] == 'use_arg_name' and 'dest' in instr:
                src_var = value[1]
                result.append(create_id_instr(instr['dest'], src_var, instr.get('type')))
                if src_var in var2num:
                    var2num[instr['dest']] = var2num[src_var]
                continue

        if value and value in value_to_num:
            num = value_to_num[value]
            if 'dest' in instr:
                canon_var = table[num][0]
                result.append(create_id_instr(instr['dest'], canon_var, instr.get('type')))
                var2num[instr['dest']] = num
            continue

        new_instr = dict(instr)

        if kind == 'const' and value:
            new_instr = create_const_instr(instr.get('dest'), value[1], instr.get('type', 'int'))
        else:

            if 'args' in instr:
                rewritten_args = []
                for a in instr['args']:
                    if a in var2num and var2num[a] in table:
                        rewritten_args.append(table[var2num[a]][0])
                    else:
                        rewritten_args.append(a)
                new_instr['args'] = rewritten_args

        if 'dest' in new_instr:
            dest = new_instr['dest']
            if will_be_overwritten(instrs, idx, dest):
                fresh = f"{dest}#lvn{next_fresh_var}"
                next_fresh_var += 1
                new_instr['dest'] = fresh

        result.append(new_instr)

        if 'dest' in new_instr and value:
            num = next_num
            next_num += 1
            canon_var = new_instr['dest']
            table[num] = (canon_var, value, const_val)
            value_to_num[value] = num
            var2num[canon_var] = num

    return labels + result

def lvn(func: Dict[str, Any]) -> Dict[str, Any]:
    instrs = func.get('instrs', [])
    if not instrs:
        return func
    blocks = form_blocks(instrs)
    func['instrs'] = [instr for block in blocks for instr in lvn_block(block)]
    return func

def main():
    prog = json.load(sys.stdin)
    for func in prog.get('functions', []):
        lvn(func)
    json.dump(prog, sys.stdout, indent=2)

if __name__ == '__main__':
    main()
