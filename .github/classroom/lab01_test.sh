#!/bin/bash
# =============================================================================
# Lab 01 Autograder Test Script
# This script is called by GitHub Classroom to verify student submissions
# =============================================================================

echo "🔧 Building Educore hardware..."
make build_educore
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Could not compile Verilog files"
    exit 1
fi

echo "🔧 Assembling Lab 01..."
make lab01
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Could not assemble test_STRCPY.s"
    exit 1
fi

echo "🚀 Running simulation..."
output=$(make sim_lab01 2>&1)
echo "$output"

# Check if the simulation completed successfully
if echo "$output" | grep -q "Apollo has landed"; then
    echo ""
    echo "✅ SUCCESS: Lab 01 passed! STRCPY implementation is correct."
    exit 0
else
    echo ""
    echo "❌ FAILED: YIELD instruction was not reached."
    echo "   Check your loop logic and make sure the program terminates."
    exit 1
fi
