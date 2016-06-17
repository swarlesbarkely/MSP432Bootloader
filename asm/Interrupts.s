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
	.type	DefaultISR, %function
DefaultISR:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
.L2:
	b	.L2
	.size	DefaultISR, .-DefaultISR
	.align	2
	.global	InitISRs
	.thumb
	.thumb_func
	.type	InitISRs, %function
InitISRs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L7+4
	ldr	r2, .L7+8
	ldr	r0, .L7
.LPIC8:
	add	r3, pc
	ldr	r1, [r3, r2]
	ldr	r2, .L7+12
	add	r3, r1, #-536870912
	orr	r3, r3, #536870912
.LPIC9:
	add	r2, pc
	str	r3, [r0]
	orr	r2, r2, #1
	subs	r3, r1, #4
	adds	r1, r1, #224
.L4:
	str	r2, [r3, #4]!
	cmp	r3, r1
	bne	.L4
	bx	lr
.L8:
	.align	2
.L7:
	.word	-536810232
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC8+4)
	.word	apfnISRs(GOT)
	.word	DefaultISR-(.LPIC9+4)
	.size	InitISRs, .-InitISRs
	.align	2
	.global	RegisterISR
	.thumb
	.thumb_func
	.type	RegisterISR, %function
RegisterISR:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L11
	cmp	r0, #56
.LPIC10:
	add	r3, pc
	bhi	.L9
	ldr	r2, .L11+4
	ldr	r3, [r3, r2]
	orr	r1, r1, #1
	str	r1, [r3, r0, lsl #2]
.L9:
	bx	lr
.L12:
	.align	2
.L11:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC10+4)
	.word	apfnISRs(GOT)
	.size	RegisterISR, .-RegisterISR
	.global	akpfnInterruptVector
	.global	apfnISRs
	.section	.isr_pointers,"aw",%progbits
	.align	2
	.type	apfnISRs, %object
	.size	apfnISRs, 228
apfnISRs:
	.space	228
	.section	.interupt_vectors,"aw",%progbits
	.align	2
	.type	akpfnInterruptVector, %object
	.size	akpfnInterruptVector, 324
akpfnInterruptVector:
	.word	STACK_BEGIN
	.word	BOOTLOADER_JUMP_ADDRESS
	.space	316
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
