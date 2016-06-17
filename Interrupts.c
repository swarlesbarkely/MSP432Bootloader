#include "CommonMacros.h"
#include "types.h"
#include "msp432p401r.h"

typedef enum
{
    Reset_ISR             ,
    NonMaskableInt_ISR = 2,    /* Non Maskable Interrupt */
    HardFault_ISR         ,    /* Hard Fault Interrupt */
    MemoryManagement_ISR  ,    /* Memory Management Interrupt */
    BusFault_ISR          ,    /* Bus Fault Interrupt */
    UsageFault_ISR        ,    /* Usage Fault Interrupt */
    SVCall_ISR = 11       ,    /* SV Call Interrupt */
    DebugMonitor_ISR      ,    /* Debug Monitor Interrupt */
    PendSV_ISR = 14       ,    /* Pend SV Interrupt */
    SysTick_ISR           ,    /* System Tick Interrupt */
    PSS_ISR               ,    /* PSS Interrupt */
    CS_ISR                ,    /* CS Interrupt */
    PCM_ISR               ,    /* PCM Interrupt */
    WDT_A_ISR             ,    /* WDT_A Interrupt */
    FPU_ISR               ,    /* FPU Interrupt */
    FLCTL_ISR             ,    /* FLCTL Interrupt */
    COMP_E0_ISR           ,    /* COMP_E0 Interrupt */
    COMP_E1_ISR           ,    /* COMP_E1 Interrupt */
    TA0_0_ISR             ,    /* TA0_0 Interrupt */
    TA0_N_ISR             ,    /* TA0_N Interrupt */
    TA1_0_ISR             ,    /* TA1_0 Interrupt */
    TA1_N_ISR             ,    /* TA1_N Interrupt */
    TA2_0_ISR             ,    /* TA2_0 Interrupt */
    TA2_N_ISR             ,    /* TA2_N Interrupt */
    TA3_0_ISR             ,    /* TA3_0 Interrupt */
    TA3_N_ISR             ,    /* TA3_N Interrupt */
    EUSCIA0_ISR           ,    /* EUSCIA0 Interrupt */
    EUSCIA1_ISR           ,    /* EUSCIA1 Interrupt */
    EUSCIA2_ISR           ,    /* EUSCIA2 Interrupt */
    EUSCIA3_ISR           ,    /* EUSCIA3 Interrupt */
    EUSCIB0_ISR           ,    /* EUSCIB0 Interrupt */
    EUSCIB1_ISR           ,    /* EUSCIB1 Interrupt */
    EUSCIB2_ISR           ,    /* EUSCIB2 Interrupt */
    EUSCIB3_ISR           ,    /* EUSCIB3 Interrupt */
    ADC14_ISR             ,    /* ADC14 Interrupt */
    T32_INT1_ISR          ,    /* T32_INT1 Interrupt */
    T32_INT2_ISR          ,    /* T32_INT2 Interrupt */
    T32_INTC_ISR          ,    /* T32_INTC Interrupt */
    AES256_ISR            ,    /* AES256 Interrupt */
    RTC_C_ISR             ,    /* RTC_C Interrupt */
    DMA_ERR_ISR           ,    /* DMA_ERR Interrupt */
    DMA_INT3_ISR          ,    /* DMA_INT3 Interrupt */
    DMA_INT2_ISR          ,    /* DMA_INT2 Interrupt */
    DMA_INT1_ISR          ,    /* DMA_INT1 Interrupt */
    DMA_INT0_ISR          ,    /* DMA_INT0 Interrupt */
    PORT1_ISR             ,    /* PORT1 Interrupt */
    PORT2_ISR             ,    /* PORT2 Interrupt */
    PORT3_ISR             ,    /* PORT3 Interrupt */
    PORT4_ISR             ,    /* PORT4 Interrupt */
    PORT5_ISR             ,    /* PORT5 Interrupt */
    PORT6_ISR             ,    /* PORT6 Interrupt */

    NUMBER_OF_ISRs

} ISR_E;

void InitISRs (void);
void RegisterISR (ISR_E const keInterrupt, void (* const kpfnISR) (void));

static void DefaultISR (void);

extern const char STACK_BEGIN;              // Linker variable
extern const char BOOTLOADER_JUMP_ADDRESS;  // Linker variable

__attribute__((section (".isr_pointers"))) void (* apfnISRs [NUMBER_OF_ISRs]) (void);

__attribute__((section (".interupt_vectors"))) void (* const akpfnInterruptVector [81]) (void) =
{
    (void (*) (void)) &STACK_BEGIN,                 /* The initial stack pointer */
    (void (*) (void)) &BOOTLOADER_JUMP_ADDRESS     /* The reset handler (first value for PC register) */
//    (void (*) (void)) &apfnISRs[0],                 /* The NMI handler   */
//    (void (*) (void)) &apfnISRs[1],                 /* The hard fault handler*/
//    (void (*) (void)) &apfnISRs[2],                 /* The MPU fault handler */
//    (void (*) (void)) &apfnISRs[3],                 /* The bus fault handler */
//    (void (*) (void)) &apfnISRs[4],                 /* The usage fault handler   */
//    (void (*) (void)) NULL,                         /* Reserved  */
//    (void (*) (void)) NULL,                         /* Reserved  */
//    (void (*) (void)) NULL,                         /* Reserved  */
//    (void (*) (void)) NULL,                         /* Reserved  */
//    (void (*) (void)) &apfnISRs[5],                 /* SVCall handler*/
//    (void (*) (void)) &apfnISRs[6],                 /* Debug monitor handler */
//    (void (*) (void)) NULL,                         /* Reserved  */
//    (void (*) (void)) &apfnISRs[7],                 /* The PendSV handler*/
//    (void (*) (void)) &apfnISRs[8],                 /* The SysTick handler   */
//    (void (*) (void)) &apfnISRs[9],                 /* PSS ISR   */
//    (void (*) (void)) &apfnISRs[10],                /* CS ISR    */
//    (void (*) (void)) &apfnISRs[11],                /* PCM ISR   */
//    (void (*) (void)) &apfnISRs[12],                /* WDT ISR   */
//    (void (*) (void)) &apfnISRs[13],                /* FPU ISR   */
//    (void (*) (void)) &apfnISRs[14],                /* FLCTL ISR */
//    (void (*) (void)) &apfnISRs[15],                /* COMP0 ISR */
//    (void (*) (void)) &apfnISRs[16],                /* COMP1 ISR */
//    (void (*) (void)) &apfnISRs[17],                /* TA0_0 ISR */
//    (void (*) (void)) &apfnISRs[18],                /* TA0_N ISR */
//    (void (*) (void)) &apfnISRs[19],                /* TA1_0 ISR */
//    (void (*) (void)) &apfnISRs[20],                /* TA1_N ISR */
//    (void (*) (void)) &apfnISRs[21],                /* TA2_0 ISR */
//    (void (*) (void)) &apfnISRs[22],                /* TA2_N ISR */
//    (void (*) (void)) &apfnISRs[23],                /* TA3_0 ISR */
//    (void (*) (void)) &apfnISRs[24],                /* TA3_N ISR */
//    (void (*) (void)) &apfnISRs[25],                /* EUSCIA0 ISR   */
//    (void (*) (void)) &apfnISRs[26],                /* EUSCIA1 ISR   */
//    (void (*) (void)) &apfnISRs[27],                /* EUSCIA2 ISR   */
//    (void (*) (void)) &apfnISRs[28],                /* EUSCIA3 ISR   */
//    (void (*) (void)) &apfnISRs[29],                /* EUSCIB0 ISR   */
//    (void (*) (void)) &apfnISRs[30],                /* EUSCIB1 ISR   */
//    (void (*) (void)) &apfnISRs[31],                /* EUSCIB2 ISR   */
//    (void (*) (void)) &apfnISRs[32],                /* EUSCIB3 ISR   */
//    (void (*) (void)) &apfnISRs[33],                /* ADC14 ISR */
//    (void (*) (void)) &apfnISRs[34],                /* T32_INT1 ISR  */
//    (void (*) (void)) &apfnISRs[35],                /* T32_INT2 ISR  */
//    (void (*) (void)) &apfnISRs[36],                /* T32_INTC ISR  */
//    (void (*) (void)) &apfnISRs[37],                /* AES ISR   */
//    (void (*) (void)) &apfnISRs[38],                /* RTC ISR   */
//    (void (*) (void)) &apfnISRs[39],                /* DMA_ERR ISR   */
//    (void (*) (void)) &apfnISRs[40],                /* DMA_INT3 ISR  */
//    (void (*) (void)) &apfnISRs[41],                /* DMA_INT2 ISR  */
//    (void (*) (void)) &apfnISRs[42],                /* DMA_INT1 ISR  */
//    (void (*) (void)) &apfnISRs[43],                /* DMA_INT0 ISR  */
//    (void (*) (void)) &apfnISRs[44],                /* PORT1 ISR */
//    (void (*) (void)) &apfnISRs[45],                /* PORT2 ISR */
//    (void (*) (void)) &apfnISRs[46],                /* PORT3 ISR */
//    (void (*) (void)) &apfnISRs[47],                /* PORT4 ISR */
//    (void (*) (void)) &apfnISRs[48],                /* PORT5 ISR */
//    (void (*) (void)) &apfnISRs[49],                /* PORT6 ISR */
//    (void (*) (void)) &apfnISRs[50],                /* Reserved 41   */
//    (void (*) (void)) &apfnISRs[51],                /* Reserved 42   */
//    (void (*) (void)) &apfnISRs[52],                /* Reserved 43   */
//    (void (*) (void)) &apfnISRs[53],                /* Reserved 44   */
//    (void (*) (void)) &apfnISRs[54],                /* Reserved 45   */
//    (void (*) (void)) &apfnISRs[55],                /* Reserved 46   */
//    (void (*) (void)) &apfnISRs[56],                /* Reserved 47   */
//    (void (*) (void)) &apfnISRs[57],                /* Reserved 48   */
//    (void (*) (void)) &apfnISRs[58],                /* Reserved 49   */
//    (void (*) (void)) &apfnISRs[59],                /* Reserved 50   */
//    (void (*) (void)) &apfnISRs[60],                /* Reserved 51   */
//    (void (*) (void)) &apfnISRs[61],                /* Reserved 52   */
//    (void (*) (void)) &apfnISRs[62],                /* Reserved 53   */
//    (void (*) (void)) &apfnISRs[63],                /* Reserved 54   */
//    (void (*) (void)) &apfnISRs[64],                /* Reserved 55   */
//    (void (*) (void)) &apfnISRs[65],                /* Reserved 56   */
//    (void (*) (void)) &apfnISRs[66],                /* Reserved 57   */
//    (void (*) (void)) &apfnISRs[67],                /* Reserved 58   */
//    (void (*) (void)) &apfnISRs[68],                /* Reserved 59   */
//    (void (*) (void)) &apfnISRs[69],                /* Reserved 60   */
//    (void (*) (void)) &apfnISRs[70],                /* Reserved 61   */
//    (void (*) (void)) &apfnISRs[71],                /* Reserved 62   */
//    (void (*) (void)) &apfnISRs[72],                /* Reserved 63   */
//    (void (*) (void)) &apfnISRs[73]                 /* Reserved 64   */
};

__attribute__((naked)) static void DefaultISR (void)
{
    /* Pause for debugger */
    while (TRUE);
}

void InitISRs (void)
{
    uint8 u8Index;

    /* Setup the vector table offset */
    SCB_VTOR = ((uint32) apfnISRs - 0x20000000) | BIT (SCB_VTOR_TBLBASE_OFS);

    for (u8Index = 0; u8Index < NUMBER_OF_ISRs; ++u8Index)
    {
        /* Need to jump to odd boundary */
        apfnISRs [u8Index] = (void (*) (void)) ((uint32) &DefaultISR | 1);
    }
}

void RegisterISR (ISR_E const keInterrupt, void (* const kpfnISR) (void))
{
    if (keInterrupt < NUMBER_OF_ISRs)
    {
        /* Need to jump to odd boundary */
        apfnISRs [keInterrupt] = (void (*) (void)) ((uint32) kpfnISR | 1);
    }
}
