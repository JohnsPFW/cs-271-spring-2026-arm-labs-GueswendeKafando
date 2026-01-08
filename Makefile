# =============================================================================
# CS 271 Computer Architecture - ARM Labs Makefile
# Purdue University Fort Wayne
# =============================================================================
# This Makefile simplifies the complex multi-step build and simulation process
# for ARM assembly targeting the Educore processor.
# =============================================================================

# -----------------------------------------------------------------------------
# Directory Configuration
# -----------------------------------------------------------------------------
EDUCORE_DIR   := Lab01/Educore-SingleCycle
HEAD_DIR      := $(EDUCORE_DIR)/head
SRC_DIR       := $(EDUCORE_DIR)/src
TESTS_DIR     := $(EDUCORE_DIR)/tests

# -----------------------------------------------------------------------------
# Tool Configuration
# -----------------------------------------------------------------------------
AS            := aarch64-linux-gnu-gcc
OBJCOPY       := aarch64-linux-gnu-objcopy
IVERILOG      := iverilog
VVP           := vvp
ASFLAGS       := -c -march=armv8-a

# =============================================================================
# Lab 00: Getting Started (Hello ARM)
# =============================================================================
.PHONY: lab00 sim_lab00

lab00: Lab00/hello_arm.s
	@echo "[BUILD] Assembling Lab00/hello_arm.s..."
	$(AS) $(ASFLAGS) -o Lab00/hello_arm.o Lab00/hello_arm.s
	$(OBJCOPY) -O verilog Lab00/hello_arm.o Lab00/hello_arm.mem
	@echo "[BUILD] Generated Lab00/hello_arm.mem"

sim_lab00: lab00 build_educore
	@echo "[SIM] Running Lab 00 simulation..."
	$(VVP) test_Educore.vvp +TEST_CASE=Lab00/hello_arm.mem

# =============================================================================
# Lab 01: STRCPY Exercise
# =============================================================================
.PHONY: lab01 sim_lab01

lab01: Lab01/test_STRCPY.s
	@echo "[BUILD] Assembling Lab01/test_STRCPY.s..."
	$(AS) $(ASFLAGS) -o Lab01/test_STRCPY.o Lab01/test_STRCPY.s
	$(OBJCOPY) -O verilog Lab01/test_STRCPY.o Lab01/test_STRCPY.mem
	@echo "[BUILD] Generated Lab01/test_STRCPY.mem"

sim_lab01: lab01 build_educore
	@echo "[SIM] Running Lab 01 simulation..."
	$(VVP) test_Educore.vvp +TEST_CASE=Lab01/test_STRCPY.mem

# =============================================================================
# Hardware Simulation (Educore Build)
# =============================================================================
.PHONY: build_educore

build_educore:
	@echo "[HW] Compiling Educore Verilog..."
	$(IVERILOG) -g2012 -Wall \
		-I $(HEAD_DIR) \
		-y $(SRC_DIR) \
		-s test_Educore \
		$(SRC_DIR)/*.v \
		$(TESTS_DIR)/*.v \
		-o test_Educore.vvp
	@echo "[HW] Educore compiled to test_Educore.vvp"

# =============================================================================
# Utilities
# =============================================================================
.PHONY: clean help

clean:
	@echo "[CLEAN] Removing build artifacts..."
	rm -f *.o *.mem *.vvp *.vcd
	rm -f Lab00/*.o Lab00/*.mem
	rm -f Lab01/*.o Lab01/*.mem
	@echo "[CLEAN] Done."

help:
	@echo "CS 271 ARM Labs - Available Commands:"
	@echo "  make lab00      - Assemble Lab 00 (hello_arm.s)"
	@echo "  make sim_lab00  - Simulate Lab 00 on Educore"
	@echo "  make lab01      - Assemble Lab 01 (test_STRCPY.s)"
	@echo "  make sim_lab01  - Simulate Lab 01 on Educore"
	@echo "  make clean      - Remove all build artifacts"
	@echo "  make help       - Show this help message"
