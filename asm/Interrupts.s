	.arch armv7e-m
	.eabi_attribute 27, 1
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"Interrupts.c"
	.global	akpfnInterruptVector
	.section	.interupt_vectors,"a",%progbits
	.align	2
	.type	akpfnInterruptVector, %object
	.size	akpfnInterruptVector, 324
akpfnInterruptVector:
	.word	STACK_BEGIN
	.word	main+1
	.space	316
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
