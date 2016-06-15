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
	ldr	r3, .L7
	ldr	r2, .L7+4
	ldr	r1, .L7+8
.LPIC8:
	add	r3, pc
.LPIC9:
	add	r1, pc
	ldr	r2, [r3, r2]
	subs	r3, r2, #4
	adds	r2, r2, #196
.L4:
	str	r1, [r3, #4]!
	cmp	r3, r2
	bne	.L4
	bx	lr
.L8:
	.align	2
.L7:
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
	cmp	r0, #49
.LPIC10:
	add	r3, pc
	bhi	.L9
	ldr	r2, .L11+4
	ldr	r3, [r3, r2]
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
	.size	apfnISRs, 200
apfnISRs:
	.space	200
	.section	.interupt_vectors,"aw",%progbits
	.align	2
	.type	akpfnInterruptVector, %object
	.size	akpfnInterruptVector, 324
akpfnInterruptVector:
	.word	STACK_BEGIN
	.word	BOOTLOADER_JUMP_ADDRESS
	.word	apfnISRs
	.word	apfnISRs+4
	.word	apfnISRs+8
	.word	apfnISRs+12
	.word	apfnISRs+16
	.word	0
	.word	0
	.word	0
	.word	0
	.word	apfnISRs+20
	.word	apfnISRs+24
	.word	0
	.word	apfnISRs+28
	.word	apfnISRs+32
	.word	apfnISRs+36
	.word	apfnISRs+40
	.word	apfnISRs+44
	.word	apfnISRs+48
	.word	apfnISRs+52
	.word	apfnISRs+56
	.word	apfnISRs+60
	.word	apfnISRs+64
	.word	apfnISRs+68
	.word	apfnISRs+72
	.word	apfnISRs+76
	.word	apfnISRs+80
	.word	apfnISRs+84
	.word	apfnISRs+88
	.word	apfnISRs+92
	.word	apfnISRs+96
	.word	apfnISRs+100
	.word	apfnISRs+104
	.word	apfnISRs+108
	.word	apfnISRs+112
	.word	apfnISRs+116
	.word	apfnISRs+120
	.word	apfnISRs+124
	.word	apfnISRs+128
	.word	apfnISRs+132
	.word	apfnISRs+136
	.word	apfnISRs+140
	.word	apfnISRs+144
	.word	apfnISRs+148
	.word	apfnISRs+152
	.word	apfnISRs+156
	.word	apfnISRs+160
	.word	apfnISRs+164
	.word	apfnISRs+168
	.word	apfnISRs+172
	.word	apfnISRs+176
	.word	apfnISRs+180
	.word	apfnISRs+184
	.word	apfnISRs+188
	.word	apfnISRs+192
	.word	apfnISRs+196
	.word	apfnISRs+200
	.word	apfnISRs+204
	.word	apfnISRs+208
	.word	apfnISRs+212
	.word	apfnISRs+216
	.word	apfnISRs+220
	.word	apfnISRs+224
	.word	apfnISRs+228
	.word	apfnISRs+232
	.word	apfnISRs+236
	.word	apfnISRs+240
	.word	apfnISRs+244
	.word	apfnISRs+248
	.word	apfnISRs+252
	.word	apfnISRs+256
	.word	apfnISRs+260
	.word	apfnISRs+264
	.word	apfnISRs+268
	.word	apfnISRs+272
	.word	apfnISRs+276
	.word	apfnISRs+280
	.word	apfnISRs+284
	.word	apfnISRs+288
	.word	apfnISRs+292
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
