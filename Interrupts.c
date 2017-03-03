#include "CommonMacros.h"
#include "types.h"
#include "msp432p401r.h"

extern const char STACK_BEGIN;  // Linker variable

extern int main (void);

__attribute__((section (".interupt_vectors"))) void (* const akpfnInterruptVector [81]) (void) =
{
    (void (*) (void)) &STACK_BEGIN,     /* The initial stack pointer */
    (void (*) (void)) (&main + 1)       /* The reset handler (first value for PC register) */
};
