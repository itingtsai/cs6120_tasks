import json
import sys
import copy
import graphviz

try:
    import briltxt
    instr_to_string = briltxt.instr_to_string
except ImportError:
    def instr_to_string(inst):
        if 'label' in inst:
            return f".{inst['label']}"
        op = inst.get('op', '')
        dest = inst.get('dest')
        args = inst.get('args', [])
        labels = inst.get('labels', [])
        
        parts = []
        if dest:
            parts.append(f"{dest} = {op}")
        else:
            parts.append(op)
        
        if args:
            parts.append(' '.join(args))
        if labels:
            parts.append(' '.join(f'.{l}' for l in labels))
        
        return ' '.join(parts)

def is_terminator(instr):
    return instr.get('op') in ['br', 'ret', 'jmp']

def build_cfg_edges(src, dst, successor_map, predecessor_map):
    if dst not in predecessor_map:
        predecessor_map[dst] = []
    predecessor_map[dst].append(src)
    
    if src not in successor_map:
        successor_map[src] = []
    successor_map[src].append(dst)

def annotate_line_numbers(program):
    annotated = copy.deepcopy(program)
    line_num = 0
    for function in annotated.get('functions', []):
        for instr in function.get('instrs', []):
            instr['line_number'] = line_num
            line_num += 1
    return annotated

def construct_cfg(function):
    blocks = []
    label_map = {}
    pred_map = {}
    succ_map = {}
    
    current_block = []
    current_label = None
    
    for instr in function['instrs']:
        if 'label' in instr:
            if current_block:
                blocks.append(current_block)
                if current_label:
                    label_map[current_label] = len(blocks) - 1
            current_block = [instr]
            current_label = instr['label']
        elif is_terminator(instr):
            current_block.append(instr)
            blocks.append(current_block)
            if current_label:
                label_map[current_label] = len(blocks) - 1
            current_block = []
            current_label = None
        else:
            current_block.append(instr)
    
    if current_block:
        blocks.append(current_block)
        if current_label:
            label_map[current_label] = len(blocks) - 1
    
    for idx, block in enumerate(blocks):
        last_instr = block[-1]
        
        if 'op' in last_instr:
            if last_instr['op'] in ['br', 'jmp']:
                for target_label in last_instr.get('labels', []):
                    if target_label in label_map:
                        build_cfg_edges(idx, label_map[target_label], succ_map, pred_map)
            elif last_instr['op'] == 'ret':
                pass
            else:
                if idx < len(blocks) - 1:
                    build_cfg_edges(idx, idx + 1, succ_map, pred_map)
        else:
            if idx < len(blocks) - 1:
                build_cfg_edges(idx, idx + 1, succ_map, pred_map)
    
    return blocks, pred_map, succ_map

class ReachingDefinitions:    
    def merge_predecessors(self, out_sets, predecessors):
        merged = {}
        for pred_idx in predecessors:
            for def_id, definition in out_sets[pred_idx].items():
                merged[def_id] = definition
        return merged
    
    def apply_transfer(self, block, in_set):
        result = copy.deepcopy(in_set)
        
        for instr in block:
            if 'dest' in instr:
                # Kill
                to_remove = []
                for def_id in result:
                    if 'dest' in result[def_id] and result[def_id]['dest'] == instr['dest']:
                        to_remove.append(def_id)
                
                for def_id in to_remove:
                    del result[def_id]
                
                result[str(instr['line_number'])] = instr
        
        return result
    
    def run_analysis(self, program):
        program_copy = copy.deepcopy(program)
        
        all_in_sets = []
        all_out_sets = []
        all_blocks = []
        all_pred_maps = []
        
        for function in program_copy['functions']:
            blocks, pred_map, succ_map = construct_cfg(function)
            
            num_blocks = len(blocks)
            in_sets = [{} for _ in range(num_blocks)]
            out_sets = [{} for _ in range(num_blocks)]
            
            if 'args' in function:
                for param in function['args']:
                    in_sets[0][param['name']] = {
                        'op': 'parameter',
                        'dest': param['name']
                    }
            
            worklist = set(range(num_blocks))
            
            while worklist:
                current = worklist.pop()
                
                if current in pred_map:
                    in_sets[current] = self.merge_predecessors(out_sets, pred_map[current])
                
                new_out = self.apply_transfer(blocks[current], in_sets[current])
                
                if new_out != out_sets[current]:
                    out_sets[current] = new_out
                    if current in succ_map:
                        for successor in succ_map[current]:
                            worklist.add(successor)
            
            all_in_sets.append(in_sets)
            all_out_sets.append(out_sets)
            all_blocks.append(blocks)
            all_pred_maps.append(pred_map)
        
        return all_in_sets, all_out_sets, all_blocks, all_pred_maps

def generate_cfg_visualization(in_sets, out_sets, blocks, pred_maps):
    graph = graphviz.Digraph(comment='Control Flow Graph')
    
    for func_idx, func_blocks in enumerate(blocks):
        for block_idx, block in enumerate(func_blocks):

            label_text = "── IN ──\n"
            if in_sets[func_idx][block_idx]:
                for def_id, defn in in_sets[func_idx][block_idx].items():
                    if 'op' in defn and defn['op'] != 'parameter':
                        label_text += f"[{defn['line_number']}] {instr_to_string(defn)}\n"
                    else:
                        label_text += f"param: {defn['dest']}\n"
            else:
                label_text += "(empty)\n"
            
            label_text += "\n── BLOCK ──\n"
            for instr in block:
                if 'label' in instr:
                    label_text += f"[{instr['line_number']}] .{instr['label']}:\n"
                else:
                    label_text += f"[{instr['line_number']}] {instr_to_string(instr)}\n"
            
            label_text += "\n── OUT ──\n"
            if out_sets[func_idx][block_idx]:
                for def_id, defn in out_sets[func_idx][block_idx].items():
                    if 'op' in defn and defn['op'] != 'parameter':
                        label_text += f"[{defn['line_number']}] {instr_to_string(defn)}\n"
                    else:
                        label_text += f"param: {defn['dest']}\n"
            else:
                label_text += "(empty)\n"
            
            graph.node(f"f{func_idx}_b{block_idx}", label_text, 
                      shape='rectangle', fontname='monospace')
        
        # Edges
        for block_idx in range(len(func_blocks)):
            if block_idx in pred_maps[func_idx]:
                for pred_idx in pred_maps[func_idx][block_idx]:
                    graph.edge(f"f{func_idx}_b{pred_idx}", 
                              f"f{func_idx}_b{block_idx}")
    
    return graph

if __name__ == "__main__":
    bril_program = json.load(sys.stdin)

    numbered_program = annotate_line_numbers(bril_program)
    
    analyzer = ReachingDefinitions()
    in_sets, out_sets, blocks, pred_maps = analyzer.run_analysis(numbered_program)
    
    print(json.dumps(bril_program))
    
    cfg_graph = generate_cfg_visualization(in_sets, out_sets, blocks, pred_maps)
    cfg_graph.render('./reaching_defs_cfg', format='pdf', view=True)