#include <stdint.h>

#define SRAM_START 0x20000000U
#define SRAM_SIZE (128U * 1024) // 128KB
#define SRAM_END (SRAM_START + SRAM_SIZE)

int main();
void Reset_Handler(void);

// we put this in its own section, then in linker we place this section at start of memory
uint32_t vectors[] __attribute__((section (".isr_vector"))) = {
  SRAM_END, // first word must be stack pointer
  (uint32_t) &Reset_Handler,
};

void Reset_Handler(void) {
  // 1) Copy .data to SRAM

  // 2) Initialise .bss section to 0

  // 3) Call main
  main();

}
