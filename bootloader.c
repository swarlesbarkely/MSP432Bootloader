/**********************************************************************//**
 * \file bootloader.c
 *
 * \brief Simple bootloader for MSP432
 *        On power up, press the P1.1 button and send hex file over
 *        UART to program. Hold both buttons to program bootloader.
 *        Accepts only Intel Hex files
 *
 * \todo Add check for valid application code
 *
 **************************************************************************/
#include <stdint.h>
#include <stdbool.h>
#include "driverlib.h"
#include "msp432p401r.h"
#include "CommonMacros.h"

/* Defining this will cause the bootloader to send a ':' after each line is processed */
/* This is helpful for programming via a python script */
#define _USE_PYTHON_PROGRAMMING_TOOL

#define BIT(x) (1 << (x))

/* Configure these to control what pins will prepare bootloader for programming */
#define LAUNCHPAD_BUTTON_1          (BIT(1))
#define LAUNCHPAD_BUTTON_2          (BIT(4))
#define LAUNCHPAD_BOTH_BUTTONS      (LAUNCHPAD_BUTTON_1 | LAUNCHPAD_BUTTON_2)
#define PROGRAM_PIN_MASK            (!(P1IN & LAUNCHPAD_BUTTON_1))      /**< Pressing the button pulls the input low */
#define ERASE_BOOTLOADER_PIN_MASK   (!(P1IN & LAUNCHPAD_BOTH_BUTTONS))  /**< Pressing the button pulls the input low */

#define PROGRAM_BUFFER_SIZE     64U
#define DATA_BYTE_COUNT_INDEX   0
#define ADDRESS_START_INDEX     1           /**< Count */
#define CODE_INDEX              3           /**< Count + 2 Address */
#define DATA_START_INDEX        4           /**< Count + 2 Address + Code */

#define LINE_FEED           0x0A
#define CARRIAGE_RETURN     '\r'

/**< Hex record types */
enum
{
    DATA,
    EOF,
    EXTENDED_ADDRESS,
    START_ADDRESS,
    EXTENDED_LINEAR_ADDRESS,
    START_LINEAR_ADDRESS
};

/**< Linker variables */
extern const char SRAM_CODE_LOAD_ADDRESS;
extern const char SRAM_CODE_START;
extern const char SRAM_CODE_JUMP_ADDRESS;
extern const char SRAM_CODE_END;
extern const char STACK_BEGIN;

static uint16_t scu16BaseAddress;

/* These are global to make them show up in the map file */
uint8_t AsciiToHex (uint8_t const ku8Char);
void ProcessBuffer (uint8_t const * pkau8Buffer, uint8_t const ku8NumberOfBytes);
void FlashProgram (uint32_t const ku32StartAddress, uint8_t const * pkau8Data, uint8_t u8NumberOfBytes);
inline void JumpToAppStartup (void);
inline void GoToErrorState (void);
void ProgrammingLoop (void);

/**********************************************************************//**
 * \brief Main bootloader function. Controller jumps here on reset.
 *
 * \param None
 *
 * \return Doesn't
 **************************************************************************/
__attribute__((section(".bootloader"))) int main (void)
{
    uint32_t const * pku32FlashLocation = (uint32_t const *) &SRAM_CODE_LOAD_ADDRESS;
    uint32_t * pu32SRAMLocation = (uint32_t *) &SRAM_CODE_START;

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
        /* Set up code in RAM */
        while (pu32SRAMLocation < (uint32_t *) &SRAM_CODE_END)
        {
            * pu32SRAMLocation++ = * pku32FlashLocation++;
        }

        /* Note: we will not come back from here */
        ProgrammingLoop ();
    }

    /* Clean up before jumping to app */
    P1REN = 0;
    P1DIR = 0;
    P1OUT = 0;

    JumpToAppStartup ();

    return 0;
}

/**********************************************************************//**
 * \brief Main loop for handling programming protocol
 **************************************************************************/
__attribute__((section(".sram_code"), noreturn)) void ProgrammingLoop (void)
{
    uint8_t u8BufferIndex = 0;
    uint8_t au8ProgramBuffer [PROGRAM_BUFFER_SIZE];
    uint8_t u8RxTemp;
    uint8_t u8UpperNibble;
    bool fUpperNibble = true;

    if (ERASE_BOOTLOADER_PIN_MASK)
    {
        /* Programming Bootloader --> Need to unprotect it */
        ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK0, 0xFFFFFFFF);
    }
    else
    {
        ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK0, 0xFFFFFFFE);   // Leave 4k for Bootloader
    }

    ROM_FlashCtl_unprotectSector (FLASH_MAIN_MEMORY_SPACE_BANK1, 0xFFFFFFFF);

    FlashInternal_performMassErase (true);

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
    /* Baud rate = 19200 */
    UCA0MCTLW |= UCOS16 | (1 << UCBRF_OFS);
    UCA0BRW = 39;

    /* Setup Flash programming */
    ROM_FlashCtl_setProgramVerification (FLASH_REGPRE | FLASH_REGPOST); /* Pre and Post verification */

    /* Send something to show we're listening */
    UCA0TXBUF = '>';
    while (!(UCA0IFG & UCTXIFG));

    /* Wait for input */
    for (EVER)
    {
        if (UCA0IFG & UCRXIFG)
        {
            /* We received a character */
            u8RxTemp = UCA0RXBUF;

            if ((u8RxTemp != CARRIAGE_RETURN) &&
                (u8RxTemp != LINE_FEED) &&
                (u8RxTemp != ':'))
            {
                if (fUpperNibble)
                {
                    u8UpperNibble = AsciiToHex (u8RxTemp);
                    fUpperNibble = false;
                }
                else
                {
                    au8ProgramBuffer [u8BufferIndex++] = AsciiToHex (u8RxTemp) |
                                                        (u8UpperNibble << 4);

                    fUpperNibble = true;

                    /* Check for buffer overflow */
                    if (u8BufferIndex > PROGRAM_BUFFER_SIZE)
                    {
                        /* Something seems fishy --> this is more data than we expect */
                        UCA0TXBUF = 'B';
                        GoToErrorState ();
                    }
                }
            }

            /* Check for end of line */
            else if (u8RxTemp == LINE_FEED)
            {
                ProcessBuffer (au8ProgramBuffer, u8BufferIndex);

                #ifdef _USE_PYTHON_PROGRAMMING_TOOL
                /* Send something to show we processed the line */
                UCA0TXBUF = ':';
                while (!(UCA0IFG & UCTXIFG));
                #endif

                /* Reset index */
                u8BufferIndex = 0;

                P1OUT ^= 1;
            }

            UCA0IFG = 0;
        }
    }
}

/**********************************************************************//**
 * \brief Converts ASCII character to hex value
 *
 * \param ASCII character (0-F)
 *
 * \return Hex value -- 0x0-0x0F
 **************************************************************************/
__attribute__((section(".sram_code"), always_inline)) inline uint8_t AsciiToHex (uint8_t const ku8Char)
{
    uint8_t u8Return = ku8Char;

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

/**********************************************************************//**
 * \brief Processes program buffer
 *
 * \param pkau8Buffer -- Pointer to buffer
 * \param ku8NumberOfBytes -- How many bytes to process
 *
 * \return None
 **************************************************************************/
__attribute__((section(".sram_code"))) void ProcessBuffer (uint8_t const * pkau8Buffer,
                                                           uint8_t const ku8NumberOfBytes)
{
    uint32_t u32Index;
    uint32_t u32Sum = 0;
    uint32_t u32StartAddress;

    /* Check the checksum */
    if (ku8NumberOfBytes > 0)
    {
        for (u32Index = 0; u32Index < (ku8NumberOfBytes - 1); ++u32Index)
        {
            u32Sum += pkau8Buffer [u32Index];
        }

        if ((uint8_t)(~u32Sum + 1) == pkau8Buffer [ku8NumberOfBytes - 1])
        {
            /* Checksum is ok --> check the code */
            if (pkau8Buffer [CODE_INDEX] == DATA)
            {
                u32StartAddress = (uint32_t) ((scu16BaseAddress << 16) |
                                           (pkau8Buffer [ADDRESS_START_INDEX] << 8)  |
                                           (pkau8Buffer [ADDRESS_START_INDEX + 1]));

                FlashProgram (u32StartAddress,
                              pkau8Buffer + DATA_START_INDEX,
                              pkau8Buffer [DATA_BYTE_COUNT_INDEX]);
            }
            else if (pkau8Buffer [CODE_INDEX] == EXTENDED_LINEAR_ADDRESS)
            {
                scu16BaseAddress = (uint16_t) ((pkau8Buffer [DATA_START_INDEX] << 8) | pkau8Buffer [DATA_START_INDEX + 1]);
            }
            else if ((pkau8Buffer [CODE_INDEX] == EOF) && !(FLCTL_IFG & 0x86))
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
}

/**********************************************************************//**
 * \brief Writes data to flash
 *
 * \param ku32StartAddress -- Start address of programming
 * \param pkau8Data -- Pointer to data
 * \param u8NumberOfBytes -- How many bytes to process
 *
 * \return None
 **************************************************************************/
__attribute__((section(".sram_code"))) void FlashProgram (uint32_t const ku32StartAddress,
                                                          uint8_t const * pkau8Data,
                                                          uint8_t u8NumberOfBytes)
{
    uint8_t * pu8Destination = (uint8_t *) ku32StartAddress;
    uint16_t u8BitBoundaryCounter = 0;

    /* Get to 128-bit (16-byte) boundary */
    if (ku32StartAddress & 0xF)
    {
        ROM_FlashCtl_enableWordProgramming (FLASH_IMMEDIATE_WRITE_MODE);
        while ((uintptr_t) pu8Destination & 0xF)
        {
            * pu8Destination++ = * pkau8Data++;
            --u8NumberOfBytes;
        }
    }

    ROM_FlashCtl_enableWordProgramming (FLASH_COLLATED_WRITE_MODE);

    while (u8NumberOfBytes > 3)
    {
        * (uint32_t *) pu8Destination = * (uint32_t *) pkau8Data;
        u8NumberOfBytes -= 4;
        pu8Destination += 4;
        pkau8Data += 4;
        u8BitBoundaryCounter += 4;

        if (u8BitBoundaryCounter == 16)
        {
            /* We hit a 128-bit boundary -- wait for program to finish */
            while (!(FLCTL_IFG & FLCTL_IFG_PRG));
            FLCTL_CLRIFG = FLCTL_IFG_PRG;
            u8BitBoundaryCounter = 0;
        }
    }

    while (u8NumberOfBytes)
    {
        * pu8Destination++ = * pkau8Data++;
        --u8NumberOfBytes;
        ++u8BitBoundaryCounter;

        if (u8BitBoundaryCounter == 16)
        {
            /* We hit a 128-bit boundary -- wait for program to finish */
            while (!(FLCTL_IFG & FLCTL_IFG_PRG));
            FLCTL_CLRIFG = FLCTL_IFG_PRG;
            u8BitBoundaryCounter = 0;
        }
    }

    /* Make sure we program 128 bits */
    while (u8BitBoundaryCounter < 16)
    {
        * pu8Destination++ = 0xFF;
        ++u8BitBoundaryCounter;
    }

    /* Wait until operation complete */
    while (!(FLCTL_IFG & FLCTL_IFG_PRG));

    /* Check for errors */
    if (FLCTL_IFG & (FLCTL_IFG_PRG_ERR | FLCTL_IFG_AVPST | FLCTL_IFG_AVPRE))
    {
        UCA0TXBUF = 'F';
        GoToErrorState ();
    }

    /* Clear flags */
    FLCTL_CLRIFG = 0xFFFF;
}

/**********************************************************************//**
 * \brief Jumps to application startup code
 *
 * \param None
 *
 * \return Doesn't
 **************************************************************************/
__attribute__((section(".bootloader"), always_inline)) inline void JumpToAppStartup (void)
{
    __asm
    (
    "\n"
    "@ Reset stack and jump to startup code address\n"
    "   ldr     SP, =STACK_BEGIN\n"
    "   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS\n"
    );
}

/**********************************************************************//**
 * \brief Function to call when something goes wrong
 *
 * \param None
 *
 * \return Doesn't
 **************************************************************************/
__attribute__((section(".sram_code"), always_inline, noreturn)) inline void GoToErrorState (void)
{
    P2DIR |= BIT(0);

    /* Wait for reset */
    while (1)
    {
        P2OUT ^= 1;
    }
}
