CC=arm-none-eabi-gcc
OS=arm-none-eabi-size
MACH=cortex-m4
CFLAGS=-c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -nostdlib -O0 -Wall -g
LDFLAGS=-mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T linker.ld -Wl,-Map=final.map
LDFLAGS_SH=-mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=rdimon.specs -T linker.ld -Wl,-Map=final.map
GDBSTART=-ex "file final.elf" -ex 'target remote localhost:3333' -ex 'monitor reset init' -ex 'monitor flash write_image erase final.elf' -ex 'monitor reset halt' 
GDB=arm-none-eabi-gdb


BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

TARGET_EXEC=final.elf
SSRCS := $(shell find $(SRC_DIRS) -name *.s)
CSRCS := $(shell find $(SRC_DIRS) -name *.c)
SOBJS=$(SSRCS:%.s=$(BUILD_DIR)/%.o)
COBJS=$(CSRCS:%.c=$(BUILD_DIR)/%.o)
OBJS=$(COBJS) $(SOBJS)


.PHONY: all

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
	$(OS) $(BUILD_DIR)/$(TARGET_EXEC)
	mv  $(BUILD_DIR)/$(TARGET_EXEC) $(TARGET_EXEC)


# assembly
$(BUILD_DIR)/%.o: %.s 
	$(MKDIR_P) $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.c
	$(MKDIR_P) $(dir $@) # dir extracts the directors of all files in $@
	$(CC) $(CFLAGS) $< -o $@


load:
	openocd -f board/stm32f4discovery.cfg

# to run gdb we require the target executable
gdb: $(BUILD_DIR)/$(TARGET_EXEC)
	$(GDB) $(GDBSTART)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/* final.map

-include $(DEPS)
MKDIR_P ?= mkdir -p
