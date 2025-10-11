import copy
import itertools
from collections import defaultdict, deque

def build_blocks(func):
    blocks = []
    cur = {"label": None, "instrs": []}
    for instr in func["instrs"]:
        if "label" in instr:

            if cur["label"] is not None or cur["instrs"]:
                blocks.append(cur)
            cur = {"label": instr["label"], "instrs": []}
        else:
            cur["instrs"].append(instr)

    if cur["label"] is not None or cur["instrs"]:
        blocks.append(cur)
    return blocks

def term_kind(instr):
    if instr.get("op") in ("jmp", "br", "ret"):
        return instr["op"]
    return None

def last_term(block):
    return block["instrs"][-1] if block["instrs"] else None

def succ_labels(block):
    t = last_term(block)
    if not t: 
        return []
    if t["op"] == "jmp":
        return [t["labels"][0]]
    if t["op"] == "br":
        return t["labels"]
    if t["op"] == "ret":
        return []
    return []

def index_blocks(blocks):
    lbl_to_i = {b["label"]: i for i,b in enumerate(blocks)}
    return lbl_to_i

def preds_succs(blocks):
    lbl_to_i = index_blocks(blocks)
    preds = {b["label"]: [] for b in blocks}
    succs = {b["label"]: [] for b in blocks}
    for b in blocks:
        for s in succ_labels(b):
            preds[s].append(b["label"])
            succs[b["label"]].append(s)
    return preds, succs

def collect_vars_and_types(func):
    Vars = set()
    type_of = {}

    for arg in func.get("args", []):
        v = arg["name"]
        Vars.add(v)
        type_of[v] = arg["type"]

    for instr in func["instrs"]:
        if "dest" in instr:
            v = instr["dest"]
            Vars.add(v)
            if "type" in instr:
                type_of.setdefault(v, instr["type"])
    return Vars, type_of

def fresh_gen():
    counter = itertools.count(1)
    def fresh(prefix):
        return f"{prefix}.{next(counter)}"
    return fresh

def to_ssa_basic(func):
    func = copy.deepcopy(func)
    blocks = build_blocks(func)
    assert all(b["label"] is not None for b in blocks), "Every block needs a label."

    preds, succs = preds_succs(blocks)
    Vars, type_of = collect_vars_and_types(func)

    in_name = {b["label"]: {v: f"{b['label']}.{v}.in" for v in Vars} for b in blocks}
    out_name = {b["label"]: {} for b in blocks}

    # rename within each block body
    renamed_blocks = []
    make_fresh = fresh_gen()

    param_set = {a["name"] for a in func.get("args", [])}

    for b in blocks:
        B = b["label"]
        current = {v: in_name[B][v] for v in Vars}
        new_instrs = []
        for instr in b["instrs"]:
            if "op" in instr:
                inst = copy.deepcopy(instr)

                if "args" in inst:
                    inst["args"] = [current.get(a, a) for a in inst["args"]]

                if "dest" in inst:
                    v = inst["dest"]
                    new = make_fresh(f"{B}.{v}")
                    inst["dest"] = new

                    current[v] = new
                new_instrs.append(inst)
            else:
                pass

        out_name[B] = {v: current[v] for v in Vars}
        renamed_blocks.append({"label": B, "instrs": new_instrs})

    # insert entry definitions (phi/id/undef) at top of each block
    final_blocks = []
    for b in renamed_blocks:
        B = b["label"]
        entry_instrs = []
        if len(preds[B]) == 0:

            for v in Vars:
                t = type_of.get(v)
                dest = in_name[B][v]
                if v in param_set:
                    entry_instrs.append({
                        "op": "id",
                        "args": [v],
                        "dest": dest,
                        "type": t
                    })
                else:

                    entry_instrs.append({
                        "op": "undef",
                        "dest": dest,
                        "type": t
                    })
        else:
            for v in Vars:
                t = type_of.get(v)
                dest = in_name[B][v]
                ph = {
                    "op": "phi",
                    "labels": [],
                    "args": [],
                    "dest": dest,
                    "type": t
                }
                for P in preds[B]:
                    ph["labels"].append(P)
                    ph["args"].append(out_name[P][v])
                entry_instrs.append(ph)

        final_blocks.append({"label": B, "instrs": entry_instrs + b["instrs"]})

    func["instrs"] = []
    for b in final_blocks:
        func["instrs"].append({"label": b["label"]})
        func["instrs"].extend(b["instrs"])
    return func

def parallel_copy_to_seq(copies, type_of_dest, fresh):

    copies = [(d, s) for (d, s) in copies if d != s]
    if not copies:
        return []

    dests = {d for d, _ in copies}
    srcs = {s for _, s in copies}

    pending = dict(copies)
    emitted = []

    def any_src_not_dest():
        for d,s in list(pending.items()):
            if s not in pending.keys(): 
                return d
        return None

    while pending:
        d = any_src_not_dest()
        if d is not None:
            s = pending.pop(d)
            emitted.append({"op":"id","args":[s],"dest":d,"type":type_of_dest(d)})
        else:
            d, s = next(iter(pending.items()))
            t = fresh(f"{d}.tmp")
            emitted.append({"op":"id","args":[s],"dest":t,"type":type_of_dest(d)})

            for k,v in list(pending.items()):
                if v == s:
                    pending[k] = t
    return emitted

def from_ssa_basic(func):
    func = copy.deepcopy(func)
    blocks = build_blocks(func)
    preds, succs = preds_succs(blocks)

    phis = {b["label"]: [] for b in blocks}
    for b in blocks:
        new_instrs = []
        for inst in b["instrs"]:
            if inst.get("op") == "phi":
                phis[b["label"]].append(inst)
            else:
                new_instrs.append(inst)
        b["instrs"] = new_instrs

    def phi_type_of_dest(d, blk_label):
        for ph in phis[blk_label]:
            if ph["dest"] == d:
                return ph["type"]

        return None

    make_fresh = fresh_gen()
    label_to_block = {b["label"]: b for b in blocks}

    for B in phis.keys():
        if not phis[B]:
            continue
        for P in preds[B]:

            copies = []
            def type_of_dest(d):
                return phi_type_of_dest(d, B)
            for ph in phis[B]:

                idx = ph["labels"].index(P)
                src = ph["args"][idx]
                dest = ph["dest"]
                copies.append((dest, src))
            seq = parallel_copy_to_seq(copies, type_of_dest, make_fresh)


            Pblk = label_to_block[P]
            term = last_term(Pblk)
            body = Pblk["instrs"]
            if term is None:
                body.extend(seq)
            else:
                body[:] = body[:-1] + seq + body[-1:]

    func["instrs"] = []
    for b in blocks:
        func["instrs"].append({"label": b["label"]})
        func["instrs"].extend(b["instrs"])
    return func

def measure_overhead(original_func):
    
    orig = copy.deepcopy(original_func)
    
    orig_count = sum(1 for i in orig["instrs"] if "op" in i)

    ssa_func = to_ssa_basic(orig)
    final_func = from_ssa_basic(ssa_func)

    final_count = sum(1 for i in final_func["instrs"] if "op" in i)
    
    return {
        "original": orig_count,
        "final": final_count,
        "overhead": final_count - orig_count,
        "ratio": final_count / orig_count if orig_count > 0 else 0
    }
