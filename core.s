// Instructions to define attributes of our chip and the assembly lang. used
// https://sourceware.org/binutils/docs/as/ARM-Directives.html
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb


.global Reset_Handler

/*
 * Reset handler called on reset
 * MOV works for immediates 0-255, hence we need LDR to load 40byte work form mem to reg
 * = symbol to put hex word nearby in mem and load that address into the register
 */
.type Reset_Handler, %function
Reset_Handler:
  LDR r7, =0xDEADBEEF

  // 1) copy .data section from FLASH (LMA) to RAM (VMA)
  MOVS r0, #0 // used to store current progress
  LDR r1, =_sdata;
  LDR r2, =_edata;
  LDR r3, =_la_data

  B copy_data_loop
    



  // copy next word
  copy_data:
    LDR r4, [r3, r0] // get FLASH data at current offset
    STR r4, [r1, r0] // store in SRAM
    ADDS r0, r0, #4  // incr. to next word
    
  // until gone through entire .data section, copy data from FLASH -> SRAM
  copy_data_loop:
    ADDS r4, r1, r0
    CMP r2, r4 // r2-r4 (_edata - current_offset)
    BGT copy_data // copy more data if r2 (_edata) greater than r4 (current_offset)

  // 2) Clear .bss section to 0x0
  MOVS r0, #0
  LDR r1, =__bss_start__
  LDR r2, =__bss_end__
  B reset_bss_loop

  reset_bss:
    STR r0, [r1]
    ADDS r1, r1, #4


  reset_bss_loop:
    CMP r2, r1
    BGT reset_bss

  // 3) Branch to main
  B main

.size Reset_Handler, .-Reset_Handler


