MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
  SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

_estack = 0x20001000;
SECTIONS
{
  .text :
  {
    *(.isr_vector)
    /*core.o(.text)*/
    *(.text)
    *(.rodata)
    . = ALIGN(4);
  }> FLASH

  .data :
  {
    *(.data)
    . = ALIGN(4);
  }>SRAM AT>FLASH

  .bss :
  {
    __bss_start__ = .;
    *(.bss)
    . = ALIGN(4);
    __bss_end__ = .;
  }>SRAM
}
