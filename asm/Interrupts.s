	.syntax unified
	.arch armv7e-m
	.eabi_attribute 27, 1
	.eabi_attribute 28, 1
	.fpu fpv4-sp-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.thumb
	.syntax unified
	.file	"Interrupts.c"
	.text
	.align	2
	.thumb
	.thumb_func
	.type	ResetISR, %function
ResetISR:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	.syntax unified
@ 96 "Interrupts.c" 1
	
	ldr		r1,	=BOOTLOADER_JUMP_ADDRESS
	bx		r1

@ 0 "" 2
	.thumb
	.syntax unified
	.size	ResetISR, .-ResetISR
	.align	2
	.thumb
	.thumb_func
	.type	DefaultISR, %function
DefaultISR:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
.L3:
	b	.L3
	.size	DefaultISR, .-DefaultISR
	.global	akpfnInterrupts
	.section	.interupt_vectors,"aw",%progbits
	.align	2
	.type	akpfnInterrupts, %object
	.size	akpfnInterrupts, 324
akpfnInterrupts:
	.word	STACK_BEGIN
	.word	ResetISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	0
	.word	0
	.word	0
	.word	0
	.word	DefaultISR
	.word	DefaultISR
	.word	0
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.word	DefaultISR
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
