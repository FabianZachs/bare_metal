CC=arm-none-eabi-gcc
MACH=cortex-m4
CFLAGS=-c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -nostdlib -O0 -Wall -g
LDFLAGS=-mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T linker.ld -Wl,-Map=final.map
LDFLAGS_SH=-mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=rdimon.specs -T linker.ld -Wl,-Map=final.map
GDBSTART=-ex "file final.elf" -ex 'target remote localhost:3333' -ex 'monitor reset init' -ex 'monitor flash write_image erase final.elf' -ex 'monitor reset halt' 
GDB=arm-none-eabi-gdb

all: final.elf

gdb: final.elf
	$(GDB) $(GDBSTART)

final.elf:main.o core.o syscalls.o
	$(CC) $(LDFLAGS) $^ -o $@

main.o:main.c
	$(CC) $(CFLAGS) $^ -o $@

core.o:core.s
	$(CC) $(CFLAGS) -c $^ -o $@

#start.o:start.c
#	$(CC) $(CFLAGS) -c $^ -o $@

syscalls.o:syscalls.c
	$(CC) $(CFLAGS) $^ -o $@

load:
	openocd -f board/stm32f4discovery.cfg


clean:
	rm -rf *.o *.elf
