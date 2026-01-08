# Setting Up ARM Labs in GitHub Classroom

To set up Lab 0 and Lab 1 in GitHub Classroom, we need to create a **Template Repository**. This repository contains the configuration files that tell GitHub how to build the environment (via Codespaces) and how to grade the student's work automatically.

Since the Arm Education Core is a multi-file Verilog project, your repository structure must be organized so that the scripts can find the hardware source files and the student's assembly code.

---

## Phase 1: The Repository Structure

Your GitHub template repository should have the following structure:

```
CS271-ARM-Labs/
├── .devcontainer/
│   └── devcontainer.json          # Automates tool installation in Codespaces
├── Lab00/
│   └── hello_arm.s                # Starter code for "Getting Started"
├── Lab01/
│   ├── test_STRCPY.s              # Student assignment file
│   └── Educore-SingleCycle/       # Verilog processor implementation
│       ├── head/
│       │   └── Educore.vh         # Verilog header definitions
│       ├── src/
│       │   ├── ArithmeticLogicUnit.v
│       │   ├── BarrelShifter.v
│       │   ├── Educore.v
│       │   ├── ImmediateDecoder.v
│       │   ├── InstructionDecoder.v
│       │   └── RegisterFile.v
│       └── tests/
│           └── test_Educore.v     # Testbench for simulation
├── Makefile                       # Simplifies build commands
├── README.md                      # Student-facing documentation
└── .gitignore
```

---

## Phase 2: Automating the Environment (.devcontainer)

GitHub Codespaces uses the `.devcontainer/devcontainer.json` file to automatically configure the development environment. This ensures students don't have to manually install tools.

### Required Configuration

Create `.devcontainer/devcontainer.json`:

```json
{
    "name": "PFW ARM Lab Environment",
    "image": "mcr.microsoft.com/devcontainers/universal:2",
    "features": {
        "ghcr.io/devcontainers/features/common-utils:1": {}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "mshr-h.Verilog-HDL-Support",
                "surfer-project.surfer"
            ]
        }
    },
    "postCreateCommand": "sudo apt-get update && sudo apt-get install -y iverilog gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu"
}
```

### What This Installs

| Tool | Purpose |
|------|---------|
| `iverilog` | Icarus Verilog simulator for running the Educore processor |
| `gcc-aarch64-linux-gnu` | ARM64 cross-compiler for assembling `.s` files |
| `binutils-aarch64-linux-gnu` | Includes `objcopy` for converting binaries to Verilog memory format |
| `Verilog-HDL-Support` | VS Code syntax highlighting for Verilog |
| `surfer` | Waveform viewer for debugging simulations |

---

## Phase 3: The Makefile (Simplifying Complex Commands)

The commands required to assemble ARM code and run simulations are long and error-prone. The Makefile hides this complexity:

```makefile
# =============================================================================
# CS 271 ARM Labs - Makefile
# =============================================================================

EDUCORE_DIR := Lab01/Educore-SingleCycle
AS          := aarch64-linux-gnu-gcc
OBJCOPY     := aarch64-linux-gnu-objcopy
IVERILOG    := iverilog
VVP         := vvp
ASFLAGS     := -c -march=armv8-a

# Lab 00: Hello ARM
lab00:
	$(AS) $(ASFLAGS) -o Lab00/hello_arm.o Lab00/hello_arm.s
	$(OBJCOPY) -O verilog Lab00/hello_arm.o Lab00/hello_arm.mem

sim_lab00: lab00 build_educore
	$(VVP) test_Educore.vvp +TEST_CASE=Lab00/hello_arm.mem

# Lab 01: STRCPY
lab01:
	$(AS) $(ASFLAGS) -o Lab01/test_STRCPY.o Lab01/test_STRCPY.s
	$(OBJCOPY) -O verilog Lab01/test_STRCPY.o Lab01/test_STRCPY.mem

sim_lab01: lab01 build_educore
	$(VVP) test_Educore.vvp +TEST_CASE=Lab01/test_STRCPY.mem

# Build Educore Hardware
build_educore:
	$(IVERILOG) -g2012 -Wall \
		-I $(EDUCORE_DIR)/head \
		-y $(EDUCORE_DIR)/src \
		-s test_Educore \
		$(EDUCORE_DIR)/src/*.v \
		$(EDUCORE_DIR)/tests/*.v \
		-o test_Educore.vvp

clean:
	rm -f *.o *.mem *.vvp *.vcd Lab00/*.o Lab00/*.mem Lab01/*.o Lab01/*.mem
```

### Student Usage

| Command | Description |
|---------|-------------|
| `make lab00` | Assemble the "Hello ARM" program |
| `make sim_lab00` | Run Lab 00 on the Educore simulator |
| `make lab01` | Assemble the STRCPY program |
| `make sim_lab01` | Run Lab 01 on the Educore simulator |
| `make clean` | Remove all generated files |

---

## Phase 4: Setting Up Autograding in GitHub Classroom

When you create the assignment in GitHub Classroom, go to the **Autograding** tab and configure tests:

### Test 1: Lab 01 Execution

| Field | Value |
|-------|-------|
| **Name** | Verification of STRCPY Execution |
| **Setup Command** | `make build_educore && make lab01` |
| **Run Command** | `make sim_lab01` |
| **Comparison** | Output includes |
| **Expected Output** | `[EDUCORE LOG]: Apollo has landed` |
| **Points** | 10 |

### Test 2: Lab 00 Verification (Optional)

| Field | Value |
|-------|-------|
| **Name** | Hello ARM Verification |
| **Setup Command** | `make build_educore && make lab00` |
| **Run Command** | `make sim_lab00` |
| **Comparison** | Output includes |
| **Expected Output** | `[EDUCORE LOG]: Apollo has landed` |
| **Points** | 5 |

---

## Phase 5: Student Workflow

With this setup, the student's workflow is clear and simple:

1. **Open Codespace** - Click "Open in GitHub Codespaces" from their repository
2. **Wait for setup** - The `postCreateCommand` installs all required tools (~2 minutes)
3. **Edit the assembly file** - Modify `Lab01/test_STRCPY.s` to complete the TODO sections
4. **Build and test locally**:
   ```bash
   make sim_lab01
   ```
5. **View waveforms** - Open `dump.vcd` in Surfer extension to verify:
   - Register X0 holds `0x50`
   - Register X1 holds `0x13C`
6. **Commit and push** - Triggers the autograder
7. **Check results** - View autograding feedback on GitHub

---

## Differences from Original ARM Lab Instructions

The following changes were necessary for the Codespaces environment:

| Original Instruction | Codespaces Adaptation |
|---------------------|----------------------|
| Use Keil MDK or DS-5 | Use `aarch64-linux-gnu-gcc` cross-compiler |
| Full linking and ELF execution | Compile only (`-c` flag) + objcopy to `.mem` |
| Hardware board simulation | Icarus Verilog (`iverilog`) simulation |
| Native waveform viewer | Surfer VS Code extension |
| Manual tool installation | Automated via `devcontainer.json` |

---

## Troubleshooting

### Error: "Please specify the test case file"
- Ensure the `.mem` file was generated: `make lab01`
- Check that the path in the Makefile matches your structure

### Error: "Houston, we got a problem"
- The `YIELD` instruction was not reached
- Check for infinite loops or undefined instructions
- Review the waveform in Surfer

### Tools not found
- Ensure Codespace finished building
- Manually run: `sudo apt-get install -y iverilog gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu`

---

## Next Steps

- [ ] Create Lab 00 complete solution for instructor reference
- [ ] Create Lab 01 complete solution for instructor reference
- [ ] Add data verification tests (check memory contents)
- [ ] Create Lab 02-06 skeleton files