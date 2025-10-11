import json
import sys
from basic_ssa import to_ssa_basic, from_ssa_basic, measure_overhead

# copy paste from is_ssa.py
def is_ssa(bril):
    """Check whether a Bril program is in SSA form.
    Every function in the program may assign to each variable once.
    """
    for func in bril["functions"]:
        assigned = set()
        for instr in func["instrs"]:
            if "dest" in instr:
                if instr["dest"] in assigned:
                    return False
                else:
                    assigned.add(instr["dest"])
    return True

def print_function(func, title):
    print(f"\n{'='*60}")
    print(f"{title}")
    print('='*60)
    for instr in func["instrs"]:
        if "label" in instr:
            print(f"\n.{instr['label']}:")
        elif "op" in instr:
            parts = [f"  {instr['op']}"]
            if "dest" in instr:
                parts.append(f"{instr['dest']}")
                if "type" in instr:
                    parts.append(f": {instr['type']}")
                parts.append("=")
            if "args" in instr:
                parts.append(f"({', '.join(instr['args'])})")
            if "value" in instr:
                parts.append(str(instr["value"]))
            if "labels" in instr:
                parts.append(f"[{', '.join(instr['labels'])}]")
            print(" ".join(parts))
    print()

def count_instructions(func):
    return sum(1 for instr in func["instrs"] if "op" in instr)

def count_phi_functions(func):
    return sum(1 for instr in func["instrs"] if instr.get("op") == "phi")

def count_undef_instructions(func):
    return sum(1 for instr in func["instrs"] if instr.get("op") == "undef")

def analyze_function(func, func_name):
    print_function(func, "ORIGINAL FUNCTION")
    
    ssa_func = to_ssa_basic(func)
    ssa_program = {"functions": [ssa_func]}
    
    print_function(ssa_func, "SSA FORM")
    
    is_valid_ssa = is_ssa(ssa_program)
    print(f"\nSSA form is valid: {'YES' if is_valid_ssa else 'NO'}")
    
    phi_count = count_phi_functions(ssa_func)
    undef_count = count_undef_instructions(ssa_func)
    print(f"  phi-functions:        {phi_count}")
    print(f"  undef instructions: {undef_count}")
    
    final_func = from_ssa_basic(ssa_func)
    final_program = {"functions": [final_func]}
    
    print_function(final_func, "AFTER SSA ROUND TRIP")
    
    stats = measure_overhead(func)
    print(f"\n{'='*60}")
    print("OVERHEAD ANALYSIS")
    print('='*60)
    print(f"Original instruction count:     {stats['original']}")
    print(f"Final instruction count:        {stats['final']}")
    print(f"Added instructions:             {stats['overhead']}")
    print(f"Overhead ratio:                 {stats['ratio']:.2f}x")
    print(f"Percentage increase:            {(stats['ratio'] - 1) * 100:.1f}%")
    
    return stats, is_valid_ssa

if __name__ == "__main__":
    try:
        program = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Failed to parse JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    
    print("="*60)
    print("SSA TRANSFORMATION ANALYSIS")
    print("="*60)
    
    all_valid = True
    all_stats = []

    for func in program["functions"]:
        func_name = func.get("name", "unnamed")
        stats, is_valid = analyze_function(func, func_name)
        all_stats.append((func_name, stats))
        all_valid = all_valid and is_valid

    if len(all_stats) > 1:
        print(f"\n{'#'*60}")
        print("# SUMMARY")
        print(f"{'#'*60}")
        for func_name, stats in all_stats:
            print(f"\n{func_name}:")
            print(f"  Overhead: +{stats['overhead']} instructions ({stats['ratio']:.2f}x)")
    
    sys.exit(0 if all_valid else 1)