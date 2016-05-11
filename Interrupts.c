#include "types.h"

static void ResetISR (void);
static void DefaultISR (void);

extern const char STACK_BEGIN;	// Linker variable

__attribute__((section(".interupt_vectors"))) void (* const akpfnInterrupts [81]) (void) =
{
	(void (*) (void)) &STACK_BEGIN,				/* The initial stack pointer */
	ResetISR,									/* The reset handler (first value for PC register) */
	DefaultISR,									/* The NMI handler   */
	DefaultISR,									/* The hard fault handler*/
	DefaultISR,									/* The MPU fault handler */
	DefaultISR,									/* The bus fault handler */
	DefaultISR,									/* The usage fault handler   */
	(void (*) (void)) NULL,						/* Reserved  */
	(void (*) (void)) NULL,						/* Reserved  */
	(void (*) (void)) NULL,						/* Reserved  */
	(void (*) (void)) NULL,						/* Reserved  */
	DefaultISR,									/* SVCall handler*/
	DefaultISR,									/* Debug monitor handler */
	(void (*) (void)) NULL,						/* Reserved  */
	DefaultISR,									/* The PendSV handler*/
	DefaultISR,									/* The SysTick handler   */
	DefaultISR,									/* PSS ISR   */
	DefaultISR,									/* CS ISR	 */
	DefaultISR,									/* PCM ISR   */
	DefaultISR,									/* WDT ISR   */
	DefaultISR,									/* FPU ISR   */
	DefaultISR,									/* FLCTL ISR */
	DefaultISR,									/* COMP0 ISR */
	DefaultISR,									/* COMP1 ISR */
	DefaultISR,									/* TA0_0 ISR */
	DefaultISR,									/* TA0_N ISR */
	DefaultISR,									/* TA1_0 ISR */
	DefaultISR,									/* TA1_N ISR */
	DefaultISR,									/* TA2_0 ISR */
	DefaultISR,									/* TA2_N ISR */
	DefaultISR,									/* TA3_0 ISR */
	DefaultISR,									/* TA3_N ISR */
	DefaultISR,									/* EUSCIA0 ISR   */
	DefaultISR,									/* EUSCIA1 ISR   */
	DefaultISR,									/* EUSCIA2 ISR   */
	DefaultISR,									/* EUSCIA3 ISR   */
	DefaultISR,									/* EUSCIB0 ISR   */
	DefaultISR,									/* EUSCIB1 ISR   */
	DefaultISR,									/* EUSCIB2 ISR   */
	DefaultISR,									/* EUSCIB3 ISR   */
	DefaultISR,									/* ADC14 ISR */
	DefaultISR,									/* T32_INT1 ISR  */
	DefaultISR,									/* T32_INT2 ISR  */
	DefaultISR,									/* T32_INTC ISR  */
	DefaultISR,									/* AES ISR   */
	DefaultISR,									/* RTC ISR   */
	DefaultISR,									/* DMA_ERR ISR   */
	DefaultISR,									/* DMA_INT3 ISR  */
	DefaultISR,									/* DMA_INT2 ISR  */
	DefaultISR,									/* DMA_INT1 ISR  */
	DefaultISR,									/* DMA_INT0 ISR  */
	DefaultISR,									/* PORT1 ISR */
	DefaultISR,									/* PORT2 ISR */
	DefaultISR,									/* PORT3 ISR */
	DefaultISR,									/* PORT4 ISR */
	DefaultISR,									/* PORT5 ISR */
	DefaultISR,									/* PORT6 ISR */
	DefaultISR,									/* Reserved 41   */
	DefaultISR,									/* Reserved 42   */
	DefaultISR,									/* Reserved 43   */
	DefaultISR,									/* Reserved 44   */
	DefaultISR,									/* Reserved 45   */
	DefaultISR,									/* Reserved 46   */
	DefaultISR,									/* Reserved 47   */
	DefaultISR,									/* Reserved 48   */
	DefaultISR,									/* Reserved 49   */
	DefaultISR,									/* Reserved 50   */
	DefaultISR,									/* Reserved 51   */
	DefaultISR,									/* Reserved 52   */
	DefaultISR,									/* Reserved 53   */
	DefaultISR,									/* Reserved 54   */
	DefaultISR,									/* Reserved 55   */
	DefaultISR,									/* Reserved 56   */
	DefaultISR,									/* Reserved 57   */
	DefaultISR,									/* Reserved 58   */
	DefaultISR,									/* Reserved 59   */
	DefaultISR,									/* Reserved 60   */
	DefaultISR,									/* Reserved 61   */
	DefaultISR,									/* Reserved 62   */
	DefaultISR,									/* Reserved 63   */
	DefaultISR									/* Reserved 63   */
};

__attribute__((naked)) static void ResetISR (void)
{
	/* Jump to bootloader address */
	__asm
	(
	"\n"
	"	ldr		r1,	=BOOTLOADER_JUMP_ADDRESS\n"
	"	bx		r1\n"
	);
}

__attribute__((naked)) static void DefaultISR (void)
{
    /* Pause for debugger */
    while (TRUE);
}
