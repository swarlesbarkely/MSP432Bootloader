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
	.global	akpfnInterruptVector
	.section	.interupt_vectors,"aw",%progbits
	.align	2
	.type	akpfnInterruptVector, %object
	.size	akpfnInterruptVector, 324
akpfnInterruptVector:
	.word	STACK_BEGIN
	.word	BOOTLOADER_JUMP_ADDRESS
	.space	316
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
