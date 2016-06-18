#include "CommonMacros.h"
#include "types.h"
#include "msp432p401r.h"

extern const char STACK_BEGIN;              // Linker variable
extern const char BOOTLOADER_JUMP_ADDRESS;  // Linker variable

__attribute__((section (".interupt_vectors"))) void (* const akpfnInterruptVector [81]) (void) =
{
    (void (*) (void)) &STACK_BEGIN,                 /* The initial stack pointer */
    (void (*) (void)) &BOOTLOADER_JUMP_ADDRESS     /* The reset handler (first value for PC register) */
};

