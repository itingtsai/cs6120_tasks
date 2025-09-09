import json
import sys

TERMINATORS = {"jmp", "br", "ret"}

def split_blocks(instrs):
    blocks, cur, labels = [], [], {}
    def flush():
        nonlocal cur
        if not cur: return
        first = cur[0]
        name = first.get("label", f"@B{len(blocks)}")
        blocks.append({"name": name, "instrs": cur})
        if "label" in first: labels[first["label"]] = name
        cur = []
    for ins in instrs:
        if "label" in ins and cur: flush()
        cur.append(ins)
        if ins.get("op") in TERMINATORS: flush()
    flush()
    return blocks, labels

def build_succ(blocks, labels):
    succ = {b["name"]: [] for b in blocks}
    for i, b in enumerate(blocks):
        if not b["instrs"]: continue
        last = b["instrs"][-1]
        op = last.get("op")
        if op == "jmp":
            succ[b["name"]].append(labels.get(last["labels"][0], last["labels"][0]))
        elif op == "br":
            t, f = last["labels"][:2]
            succ[b["name"]].extend([labels.get(t, t), labels.get(f, f)])
        elif op != "ret" and i+1 < len(blocks):
            succ[b["name"]].append(blocks[i+1]["name"])
    return succ

def mycfg():
    prog = json.load(sys.stdin)
    for func in prog.get("functions", []):
        blocks, labels = split_blocks(func.get("instrs", []))
        succ = build_succ(blocks, labels)
        print(f"Function {func['name']}:")
        for b in blocks:
            outs = succ[b["name"]]
            print(f"  {b['name']} -> {', '.join(outs) if outs else '(exit)'}")

if __name__ == "__main__":
    mycfg()
