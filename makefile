PROJECT = Bootloader

.PHONY: default clean lint

CC = arm-none-eabi-gcc

HEX_TOOL = arm-none-eabi-objcopy

LINT = cppcheck

GCC_INCLUDES = /usr/lib/gcc/arm-none-eabi/5.2.1/include
SHARED_FILES_PATH = ../SharedFiles
CMSIS_PATH = '/home/zackday/ti/workspace_v6_1/Shared Files/CMSIS'
DRIVERLIB_PATH = driverlib/MSP432P4xx

LINKER_SCRIPT = MSP432.ld
PASS_TO_LINKER = -Xlinker

VPATH = $(SHARED_FILES_PATH)
OBJECT_PATH = obj
ASSEMBLY_PATH = asm

CFLAGS = -Wall -Werror -I $(SHARED_FILES_PATH) -I $(CMSIS_PATH) -O3 -march=armv7e-m -mtune=cortex-m4 -mthumb -nostartfiles \
		  -T$(LINKER_SCRIPT) $(PASS_TO_LINKER) -Map=$(PROJECT).map --save-temps -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
		  -I $(DRIVERLIB_PATH) -D __MSP432P401R__ -D TARGET_IS_MSP432P4XX -fpic 	# These are needed specifically for bootloader

LINT_FLAGS = --enable=all --inline-suppr -I $(CMSIS_PATH) -I $(SHARED_FILES_PATH) -I $(GCC_INCLUDES) \
				-D __GNUC__ --suppress=variableScope -D __MSP432P401R__ \
				-I ./driverlib/MSP432P4xx # These are needed specifically for bootloader

HEX_TOOL_FLAGS = -I "elf32-littlearm" -O "ihex"

SOURCE_FILES =	$(wildcard *.c)

OBJECTS = $(addprefix $(OBJECT_PATH)/, $(SOURCE_FILES:.c=.o))

$(OBJECT_PATH)/%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(OBJECT_PATH)/%.o: $(SHARED_FILES_PATH)/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

default: $(PROJECT)

$(PROJECT): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(PROJECT).out $(OBJECTS)
	$(HEX_TOOL) $(HEX_TOOL_FLAGS) $(PROJECT).out $(PROJECT).hex
	rm --force *.i
	if ! [ -d $(ASSEMBLY_PATH) ]; then mkdir $(ASSEMBLY_PATH); fi
	for each in $$( ls *.s ); do mv --force $$each $(ASSEMBLY_PATH); done 2>/dev/null
	if [ -e $(PROJECT.out) ]; then arm-none-eabi-objdump -t $(PROJECT).out > $(PROJECT)_symtable.txt; fi

clean:
	if [ -e $(PROJECT)_symtable.txt ]; then rm $(PROJECT)_symtable.txt; fi
	for each in $$(ls $(OBJECT_PATH)/*.o); do rm $$each; done
	for each in $$(ls $(ASSEMBLY_PATH)/*.s); do rm $$each; done
	if [ -e $(PROJECT).out ]; then rm $(PROJECT).out; fi
	if [ -e $(PROJECT).hex ]; then rm $(PROJECT).hex; fi

lint:
	$(LINT) $(LINT_FLAGS) ./*.c
