#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./test_one.sh <benchmark_name>"
    echo ""
    echo "Available benchmarks:"
    echo "  aha-mont64, crc32, cubic, edn, huffbench, matmult-int"
    echo "  minver, nbody, nettle-aes, nettle-sha256, nsichneu"
    echo "  picojpeg, qrduino, slre, st, ud, wikisort"
    exit 1
fi

BENCH=$1
PASS_PATH="$HOME/Desktop/GitHub/llvm-pass-skeleton/build/skeleton/SkeletonPass.dylib"
EMBENCH_ROOT="$HOME/Desktop/GitHub/embench-iot"
EMBENCH_SRC="$EMBENCH_ROOT/src"

echo "Testing LICM pass on: $BENCH"
echo "========================================"

# Find source files
BENCH_DIR="$EMBENCH_SRC/$BENCH"
if [ ! -d "$BENCH_DIR" ]; then
    echo "Error: Benchmark directory not found: $BENCH_DIR"
    exit 1
fi

C_FILES=$(find $BENCH_DIR -name "*.c")
echo "Source files:"
echo "$C_FILES"
echo ""

# Compile to LLVM IR with support includes
echo "Step 1: Compiling to LLVM IR..."
clang -O1 -emit-llvm -c $C_FILES \
    -I$BENCH_DIR \
    -I$EMBENCH_ROOT/support \
    -DCPU_MHZ=1

# Link the .bc files
BC_FILES=$(ls *.bc 2>/dev/null)
if [ -z "$BC_FILES" ]; then
    echo "ERROR: No .bc files generated"
    exit 1
fi

llvm-link $BC_FILES -o ${BENCH}.bc
llvm-dis ${BENCH}.bc -o ${BENCH}.ll

# Clean up intermediate files
rm -f *.bc

echo "✓ Generated ${BENCH}.ll ($(wc -l < ${BENCH}.ll) lines)"
echo ""

# Run your LICM pass
echo "Step 2: Running LICM pass..."
opt -load-pass-plugin=$PASS_PATH \
    -passes="skeleton-pass" \
    -S ${BENCH}.ll -o ${BENCH}_licm.ll

if [ $? -ne 0 ]; then
    echo "ERROR: Pass failed"
    exit 1
fi

echo "✓ Generated ${BENCH}_licm.ll ($(wc -l < ${BENCH}_licm.ll) lines)"
echo ""

# Compare
echo "Step 3: Comparing results..."
if diff -q ${BENCH}.ll ${BENCH}_licm.ll > /dev/null; then
    echo "⚠ No changes made (IR identical)"
else
    echo "✓ Pass modified the IR"
    echo ""
    echo "Change statistics:"
    LINES_CHANGED=$(diff ${BENCH}.ll ${BENCH}_licm.ll | grep -E "^[<>]" | wc -l)
    LOOPEXIT_ADDED=$(diff ${BENCH}.ll ${BENCH}_licm.ll | grep "^>" | grep -c "loopexit" || echo 0)
    echo "  - Total lines changed: $LINES_CHANGED"
    echo "  - Loop exit blocks added: $LOOPEXIT_ADDED"
fi

echo ""
echo "========================================"
echo "Test completed successfully!"
echo ""
echo "Files generated:"
echo "  - ${BENCH}.ll          (original)"
echo "  - ${BENCH}_licm.ll     (after LICM)"
