/*=============================================
* See MSP432 Datasheet for memory layout
* Flash has been sectioned off to include
* constant placement for bootloader and
* startup code
==============================================*/

INTERRUPT_VECTOR_SIZE		= 81*4;
/* Force bootloader to occupy one sector of flash for easy erasing */
BOOTLOADER_SIZE				= 4k;
STACK_SIZE					= 2k;

TARGET ("elf32-littlearm")
OUTPUT_ARCH (arm)
OUTPUT_FORMAT ("elf32-littlearm")
SEARCH_DIR ("=/usr/lib/gcc")

MEMORY
{
	FLASH_MAIN 			(rx) : ORIGIN = 0x00000000, LENGTH = 0x00040000

	FLASH_INFO			(rx) : ORIGIN = 0x00200000, LENGTH = 0x4000

	SRAM_CODE			(rwx): ORIGIN = 0x01000000, LENGTH = 0x10000
	SRAM_DATA			(rw) : ORIGIN = 0x20000000, LENGTH = 0x10000
}

SECTIONS
{
	/* Interrupt vectors always at 0x00000000 */
	.interupt_vectors
	0x00000000 :
	{
		*(.interrupt_vectors)
	}

	/* Next place startup code */
	.startup_code
	ALIGN (2) :
	{
		STARTUP_CODE_START_ADDRESS = ABSOLUTE (.);		/* For defining boundary of startup section */
		STARTUP_CODE_JUMP_ADDRESS = ABSOLUTE (.) | 1;	/* For jumping to startup section */
		*(.startup_code)
		STARTUP_CODE_END_ADDRESS = ABSOLUTE (.);
	}

	/* Now normal code */
	.text
	ALIGN (2) :
	{
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)
		SRAM_CODE_LOAD_ADDRESS = ABSOLUTE (.);
		. += SIZEOF (.sram_code);
		SRAM_DATA_LOAD_ADDRESS = ABSOLUTE (.);
	}

	/* Lastly we'll place the bootloader -- we put it at the end of flash so we can program interurpt vectors with the app */
	.bootloader
	LENGTH (FLASH_MAIN) - BOOTLOADER_SIZE :
	{
		BOOTLOADER_START_ADDRESS = ABSOLUTE (.);	/* For defining boundary of bootloader */
		BOOTLOADER_JUMP_ADDRESS = ABSOLUTE (.) | 1;	/* For jumping to bootloader (address of "main") */
		*(.bootloader)
		BOOTLOADER_END_ADDRESS = ABSOLUTE (.);
		. = ALIGN (4);	/* Align on 32-bit boundary to make moving to RAM easier */

	} =0xFF	/* Fill value = 0xFF */

	.sram_code : AT (SRAM_CODE_LOAD_ADDRESS)
	{
		SRAM_CODE_START = ABSOLUTE(.);
		*(.sram_code)
		SRAM_CODE_END = ABSOLUTE(.);

	}	> SRAM_CODE


	.stack :
	{
		/* Descending stack */
		STACK_END = ABSOLUTE(.);
		. += (STACK_SIZE - 1);
		STACK_BEGIN = ABSOLUTE(.);

	}	> SRAM_DATA

	.data
	STACK_BEGIN + 1 : AT (SRAM_DATA_LOAD_ADDRESS)
	{
		SRAM_DATA_START = ABSOLUTE(.);
		*(.data)
		SRAM_DATA_END = ABSOLUTE(.);

	}	> SRAM_DATA

	.bss
	:
	{
		ZERO_INIT_BEGIN = ABSOLUTE(.);
		*(.bss)
		*(COMMON)
		ZERO_INIT_END = ABSOLUTE(.);

	}	> SRAM_DATA
}
