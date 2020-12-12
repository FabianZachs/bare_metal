// Instructions to define attributes of our chip and the assembly lang. used
// https://sourceware.org/binutils/docs/as/ARM-Directives.html
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

// Global memory locations (.global gives symbol external linkage, to be used by other files)
// so the label can be used by other files
// https://www.ic.unicamp.br/~celio/mc404-2014/docs/gnu-arm-directives.pdf
.global vtable
.global reset_handler

/* Vector table
 * .type used to set type of symbol https://developer.arm.com/documentation/dui0774/i/armclang-Integrated-Assembler-Directives/Type-directive
 * .word puts 32 bits at the address of the label vtable assigned by the linker
 * .size placed at end of function (size is end of function-beginning)
 * We set the vtable to be a data object (apposed to a func or tls_object)
 */
 // https://sourceware.org/binutils/docs/as/Section.html
.section .isr_vector
.type vtable, %object
vtable:
  .word _estack
  .word reset_handler
.size vtable, .-vtable

/*
 * Reset handler called on reset
 * MOV wroks for immediates 0-255, hence we need LDR to load 40byte work form mem to reg
 * = symbol to put hex word nearby in mem and load that address into the register
 */
.type reset_handler, %function
reset_handler:
  // Set sp to end of stack
  // _estack defined in linker script
  MOV sp, r0
  LDR r7, =0xDEADBEEF

  // Set dummy values
  //LDR r8, =0xDEADBEDD
  MOVS r0, #0

  main_loop:
    // ADDS to update flags
    ADDS r0, r0, #1
    B main_loop
.size reset_handler, .-reset_handler


