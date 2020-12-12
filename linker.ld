MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
  SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* used to throw linker error if not enough space left for stack and heap 1KB */
_MIN_RAM = 0x400;

_estack = 0x20002000;

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

  _la_data = LOADADDR(.data);
  .data :
  {
    _sdata = .;
    *(.data)
    _edata = .;
    . = ALIGN(4);
  }>SRAM AT>FLASH

  .bss :
  {
    __bss_start__ = .;
    *(.bss)
    . = ALIGN(4);
    __bss_end__ = .;
  }>SRAM

  /* Space set aside for the application's heap/stack. */
  .dynamic_allocations :
  {
    _ssystem_ram = .;
    . = . + _MIN_RAM;
    . = ALIGN(4);
    _esystem_ram = .;
  }
}
