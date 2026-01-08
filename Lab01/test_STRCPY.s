// =============================================================================
// CS 271 Computer Architecture - Lab 01: String Copy (STRCPY)
// Purdue University Fort Wayne
// =============================================================================
// STUDENT NAME: ___________________
// DATE:         ___________________
// =============================================================================
// OBJECTIVE:
//   Implement a loop that copies a null-terminated string from a source
//   address to a destination address, simulating the classic C strcpy()
//   function.
//
// MEMORY LAYOUT:
//   - Source string starts at address 0x50 (80 decimal)
//   - Destination buffer starts at address 0x13C (316 decimal)
//   - The source string is: "Hello" (5 characters + null terminator)
//
// EXPECTED OUTCOME:
//   - Register X0 should hold 0x50 (source address)
//   - Register X1 should hold 0x13C (destination address)
//   - The string "Hello" should be copied to the destination
//   - Simulation output: "[EDUCORE LOG]: Apollo has landed"
//
// INSTRUCTIONS:
//   1. Complete the TODO sections below
//   2. Run: make sim_lab01
//   3. Open Surfer to verify X0=0x50 and X1=0x13C
//   4. Check that memory[0x13C] contains the copied string
// =============================================================================

    .text
    .global _start

_start:
    // =========================================================================
    // STEP 1: Initialize Pointers
    // =========================================================================
    // TODO: Load the source address (0x50) into X0
    // HINT: Use MOV with an immediate value
    
    MOV     X0, #0x50       // X0 = source pointer (address 80)
    
    // TODO: Load the destination address (0x13C = 316) into X1
    // HINT: 0x13C is too large for MOV, use MOVZ or load in parts
    
    MOV     X1, #0x13C      // X1 = destination pointer (address 316)

    // =========================================================================
    // STEP 2: Implement the Copy Loop
    // =========================================================================
copy_loop:
    // TODO: Load a byte from the source address [X0] into W2
    // HINT: Use LDRB (Load Register Byte)
    
    // YOUR CODE HERE
    
    // TODO: Store the byte from W2 to the destination address [X1]
    // HINT: Use STRB (Store Register Byte)
    
    // YOUR CODE HERE
    
    // TODO: Check if the byte we just copied was the null terminator (0)
    // HINT: Use CBZ (Compare and Branch if Zero)
    
    // YOUR CODE HERE → branch to 'done' if W2 == 0
    
    // TODO: Increment both pointers to the next byte
    // HINT: ADD X0, X0, #1 advances the source pointer
    
    // YOUR CODE HERE
    
    // TODO: Loop back to copy the next character
    // HINT: Use B (Branch) instruction
    
    // YOUR CODE HERE → branch back to 'copy_loop'

    // =========================================================================
    // STEP 3: Signal Completion
    // =========================================================================
done:
    // YIELD tells the testbench we finished successfully
    YIELD

// =============================================================================
// DATA SECTION
// =============================================================================
    .data
    .org 0x50               // Place the source string at address 0x50
source_string:
    .asciz "Hello"          // Null-terminated string

    .org 0x13C              // Reserve destination buffer at address 0x13C
dest_buffer:
    .space 16               // 16 bytes of space for the copied string
