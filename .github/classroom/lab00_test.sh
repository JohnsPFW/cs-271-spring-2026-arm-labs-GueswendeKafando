#!/bin/bash
# =============================================================================
# Lab 00 Autograder Test Script
# Verifies the environment is set up correctly
# =============================================================================

echo "🔧 Building Educore hardware..."
make build_educore
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Could not compile Verilog files"
    exit 1
fi

echo "🔧 Assembling Lab 00..."
make lab00
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Could not assemble hello_arm.s"
    exit 1
fi

echo "🚀 Running simulation..."
output=$(make sim_lab00 2>&1)
echo "$output"

if echo "$output" | grep -q "Apollo has landed"; then
    echo ""
    echo "✅ SUCCESS: Lab 00 passed! Environment is working correctly."
    exit 0
else
    echo ""
    echo "❌ FAILED: Simulation did not complete successfully."
    exit 1
fi
