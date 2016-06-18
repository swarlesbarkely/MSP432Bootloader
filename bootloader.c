/**************************************************************************
* Description:  Simple bootloader for MSP432
*               On power up, press the P1.1 button and send hex file over
*               UART to program. Hold both buttons to program bootloader.
*               Accepts only Intel Hex files
*
* Author:       Zack Day
*
* Changelog:    01/01/2016 Zack Day | Initial revision
* 				06/04/2016 Zack Day | Use driverlib function for mass erase
*               06/17/2016 Zack Day | Updated flash program routine
*
* TODOs:        * Add check for valid application code
*
**************************************************************************/

#include "driverlib.h"
#include "msp432p401r.h"
#include "types.h"
#include "CommonMacros.h"

/* Configure these to control what pins will prepare bootloader for programming */
#define LAUNCHPAD_BUTTON_1          (BIT(1))
#define LAUNCHPAD_BUTTON_2          (BIT(4))
#define LAUNCHPAD_BOTH_BUTTONS      (LAUNCHPAD_BUTTON_1 | LAUNCHPAD_BUTTON_2)
#define PROGRAM_PIN_MASK            (!(P1IN & LAUNCHPAD_BUTTON_1))      // Pressing the button pulls the input low
#define ERASE_BOOTLOADER_PIN_MASK   (!(P1IN & LAUNCHPAD_BOTH_BUTTONS))  // Pressing the button pulls the input low

#define BUFFER_SIZE             77          /* Characters --> 64 data + 11 non-data + CR-LF */
#define DATA_BYTE_COUNT_INDEX   1           /* : */
#define ADDRESS_START_INDEX     2           /* : + Count */
#define CODE_INDEX              4           /* : + Count + 2 Address */
#define DATA_START_INDEX        5           /* : + Count + 2 Address + Code */

#define LINE_FEED	0x0A

/* Hex record types */
enum
{
    DATA,
    EOF,
    EXTENDED_ADDRESS,
    START_ADDRESS,
    EXTENDED_LINEAR_ADDRESS,
    START_LINEAR_ADDRESS
};

/* Linker variables */
extern const char BOOTLOADER_START_ADDRESS;
extern const char BOOTLOADER_SIZE;
extern const char BOOTLOADER_END_ADDRESS;
extern const char BOOTLOADER_JUMP_ADDRESS;
extern const char STACK_BEGIN;

static uint16 scu16BaseAddress;

static inline void CopyBootloaderToRAM (void);
static uint8 AsciiToHex (uint8 const ku8Char);
static void ProcessBuffer (uint8 * pau8Buffer, uint8 const ku8NumberOfBytes);
static void FlashProgram (uint32 const ku32StartAddress, uint8 const * pkau8Data, uint8 u8NumberOfBytes);
static inline void JumpToAppStartup (void);
static inline void GoToErrorState (void);

/**************************************************************************
* Description:  Main bootloader function. Make sure this function starts
*               at BOOTLOADER_START_ADDRESS!!! Controller jumps here
*               on reset.
*
* Inputs:       None
*
* Returns:      Doesn't
*
* History:      01/22/2016 ZMD Initial revision
**************************************************************************/
__attribute__((section(".bootloader"))) int main (void)
{
    uint8 u8BufferIndex = 0;
    uint8 au8SerialBuffer [BUFFER_SIZE];

	/* Stop the WDT */
    ROM_WDT_A_holdTimer ();

    DisableInterrupts ();

	/* Enable the LED on P1.0 */
    P1DIR |= BIT(0);

    /* Setup buttons as input on Launchpad */
    P1REN |= LAUNCHPAD_BOTH_BUTTONS;
    P1OUT |= LAUNCHPAD_BOTH_BUTTONS;    // Pull up resistor

    scu16BaseAddress = 0;

    /* Check program pin -- if it's high, wait for data */
    if (PROGRAM_PIN_MASK)
    {
        /* Erase flash */
        if (ERASE_BOOTLOADER_PIN_MASK)
        {
            /* Programming Bootloader --> Need to move it to RAM */
            CopyBootloaderToRAM ();
            ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK0, 0xFFFFFFFF);
        }
        else
        {
            ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK0, 0xFFFFFFFE);   // Leave 4k for Bootloader
        }

        ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK1, 0xFFFFFFFF);

		FlashInternal_performMassErase (TRUE);

        /* Setup clock */
        /* Want 12 MHz DCO Freq */
        CSKEY = CS_KEY;
        CSCTL0 = 3 << DCORSEL_OFS;
        CSKEY = 0;

        /* Setup communications */
        UCA0CTLW0 = 0x80;           /* No parity, SMCLK (DCO Freq) */
        P1SEL0 |= BIT(2) | BIT(3);  /* Setup Rx and Tx pin functions */
        /* Baud rate setup from manual for given frequency -- this baud rate / frequency
         * was chosen because it has very low error probability */
        /* Baud rate = 9600 */
        UCA0MCTLW |= UCOS16 | (2 << UCBRF_OFS);
        UCA0BRW = 78;

        /* Setup Flash programming */
        ROM_FlashCtl_setProgramVerification (FLASH_REGPRE | FLASH_REGPOST); /* Pre and Post verification */
        ROM_FlashCtl_enableWordProgramming (FLASH_IMMEDIATE_WRITE_MODE);

		/* Send something to show we're listening */
		UCA0TXBUF = '>';
		while (!(UCA0IFG & UCTXIFG));

        /* Wait for input */
        for (;;)
        {
            if (UCA0IFG & UCRXIFG)
            {
                /* We received a character */
                au8SerialBuffer [u8BufferIndex++] = UCA0RXBUF;

                /* See if buffer is full or line is ending */
                if (UCA0RXBUF == LINE_FEED)
                {
                    ProcessBuffer (au8SerialBuffer, u8BufferIndex - 2);	// Strip off CR-LF

                    /* Reset index */
                    u8BufferIndex = 0;

                    P1OUT ^= 1;
                }
                else if (u8BufferIndex > BUFFER_SIZE)
                {
                    /* Something seems fishy --> this is more data than we expect */
                    UCA0TXBUF = 'B';
                    GoToErrorState ();
                }

                UCA0IFG = 0;
            }
        }
    }

    /* Clean up before jumping to app */
    P1REN = 0;
    P1DIR = 0;
    P1OUT = 0;

    JumpToAppStartup ();

    return 0;
}

/**************************************************************************
* Description:  Moves bootloader to SRAM if it's not already there
*
* Inputs:       None
*
* Returns:      None
*
* History:      01/22/2016 ZMD Initial revision
**************************************************************************/
__attribute__((section(".bootloader"))) static inline void CopyBootloaderToRAM (void)
{
    __asm (
    "\n"
    "@ See if we're in RAM already\n"
    "   mov     r1, PC\n"
    "   ldr     r2, =SRAM_CODE_START\n"
    "   cmp     r1, r2\n"
    "   bhi     ExecutingInRAM\n"
    "\n"
    "@ Not in RAM --> Start copying\n"
    "   ldr     r1, =BOOTLOADER_START_ADDRESS\n"
    "   ldr     r3, =BOOTLOADER_END_ADDRESS\n"
    "CopyLoop:\n"
    "   @ r1 = Flash pointer, r2 = SRAM pointer\n"
    "   @ r3 = Address of end of bootloader, r4 = middle man for r1 and r2\n"
    "   ldr     r4, [r1], #4\n"
    "   str     r4, [r2], #4\n"
    "   cmp     r1, r3\n"
    "   bne     CopyLoop\n"
    "@ Jump to RAM\n"
    "   ldr     r1, =SRAM_CODE_START\n"
    "   orr     r1, r1, #1\n"
    "   bx      r1\n"
    "\n"
    "@ Label so we can skip copying if we're in RAM already\n"
    "ExecutingInRAM:\n"
        );
}

/**************************************************************************
* Description:	Converts ASCII character to hex value
*
* Inputs:		ASCII character (0-F)
*
* Returns:		Hex value -- 0x0-0x0F
*
* History:		05/08/2016 ZMD Initial revision
**************************************************************************/
__attribute__((section(".bootloader"))) static uint8 AsciiToHex (uint8 const ku8Char)
{
	uint8 u8Return = ku8Char;

	if ((ku8Char <= '9') && (ku8Char >= '0'))
	{
		u8Return = ku8Char - '0';
	}
	else if ((ku8Char <= 'F') && (ku8Char >= 'A'))
	{
		u8Return = ku8Char - 'A' + 0xA;
	}

	return u8Return;
}

/**************************************************************************
* Description:  Processes input buffer from UART
*
* Inputs:       pau8Buffer -- Pointer to buffer
*               ku8NumberOfBytes -- How many bytes to process
*
* Returns:      None
*
* History:      01/22/2016 ZMD Initial revision
**************************************************************************/
__attribute__((section(".bootloader"))) static void ProcessBuffer (uint8 * pau8Buffer, uint8 const ku8NumberOfBytes)
{
    uint32 u32DataByteCount;
    uint32 u32Index;
    uint32 u32Sum = 0;
    uint32 u32StartAddress;

	/* Convert ASCII values to hex values */
	for (u32Index = 2; u32Index <= ku8NumberOfBytes; u32Index += 2)
	{
		pau8Buffer[u32Index >> 1] = (AsciiToHex (pau8Buffer[u32Index - 1]) << 4) |
									 AsciiToHex (pau8Buffer[u32Index]);
	}

	u32DataByteCount = pau8Buffer [DATA_BYTE_COUNT_INDEX];

	/* Check the checksum */
	for (u32Index = 1; u32Index < (u32DataByteCount + DATA_START_INDEX); ++u32Index)
	{
		u32Sum += pau8Buffer [u32Index];
	}

	if ((uint8)(~u32Sum + 1) == pau8Buffer [u32DataByteCount + DATA_START_INDEX])
	{
		/* Checksum is ok --> check the code */
		if (pau8Buffer [CODE_INDEX] == DATA)
		{
			u32StartAddress = (uint32) ((scu16BaseAddress << 16) |
									   (pau8Buffer [ADDRESS_START_INDEX] << 8)  |
									   (pau8Buffer [ADDRESS_START_INDEX + 1]));

			FlashProgram (u32StartAddress, pau8Buffer + DATA_START_INDEX, u32DataByteCount);
		}
		else if (pau8Buffer [CODE_INDEX] == EXTENDED_LINEAR_ADDRESS)
		{
			scu16BaseAddress = (uint16) ((pau8Buffer [DATA_START_INDEX] << 8) | pau8Buffer [DATA_START_INDEX + 1]);
		}
		else if ((pau8Buffer [CODE_INDEX] == EOF) && !(FLCTL_IFG & 0x86))
		{
			/* End of data and no errors --> clean up and jump to startup code */
			ROM_FlashCtl_protectSector (FLASH_MAIN_MEMORY_SPACE_BANK0, 0xFFFFFFFF);
			ROM_FlashCtl_protectSector (FLASH_MAIN_MEMORY_SPACE_BANK1, 0xFFFFFFFF);
			P1REN = 0;
			P1DIR = 0;
			P1OUT = 0;
			JumpToAppStartup ();
		}
	}
	else
	{
		/* Bad Checksum */
		UCA0TXBUF = 'C';
		GoToErrorState ();
	}
}

/**************************************************************************
* Description:  Writes data to flash
*
* Inputs:       ku32StartAddress -- Start address of programming
*               pkau8Data -- Pointer to data
*               u8NumberOfBytes -- How many bytes to process
*
* Returns:      None
*
* History:      01/22/2016 ZMD Initial revision
*               06/17/2016 ZMD Use only immediate writes
**************************************************************************/
__attribute__((section(".bootloader"))) static void FlashProgram (uint32 const ku32StartAddress, uint8 const * pkau8Data, uint8 u8NumberOfBytes)
{
    uint8 * pu8Destination = (uint8 *) ku32StartAddress;

	while (u8NumberOfBytes > 3)
    {
        * (uint32 *) pu8Destination = * (uint32 *) pkau8Data;
        u8NumberOfBytes -= 4;
        pu8Destination += 4;
        pkau8Data += 4;
    }

    while (u8NumberOfBytes)
    {
        * pu8Destination++ = * pkau8Data++;
        --u8NumberOfBytes;
    }

    /* Check for errors */
    if (FLCTL_IFG & (FLCTL_IFG_PRG_ERR | FLCTL_IFG_AVPST | FLCTL_IFG_AVPRE))
    {
		UCA0TXBUF = 'F';
        GoToErrorState ();
    }
}

/**************************************************************************
* Description:  Jumps to application startup code
*
* Inputs:       None
*
* Returns:      Doesn't
*
* History:      01/22/2016 ZMD Initial revision
**************************************************************************/
__attribute__((section(".bootloader"))) static inline void JumpToAppStartup (void)
{
    __asm
    (
    "\n"
    "@ Reset stack and jump to startup code address\n"
    "   ldr     SP, =STACK_BEGIN\n"
    "   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS\n"
    );
}

/**************************************************************************
* Description:  Function to call when something goes wrong
*
* Inputs:       None
*
* Returns:      Doesn't
*
* History:      01/22/2016 ZMD Initial revision
*               06/02/2016 ZMD Added attempt to write interrupt vectors
*               06/17/2016 ZMD Removed attempt to write interrupt vectors -- they don't get erased anymore
**************************************************************************/
__attribute__((section(".bootloader"), always_inline, noreturn)) static inline void GoToErrorState (void)
{
    P2DIR |= BIT(0);

    /* Wait for reset */
    while (1)
    {
        P2OUT ^= 1;
    }
}
