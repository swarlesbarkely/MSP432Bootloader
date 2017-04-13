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
	.file	"bootloader.c"
	.section	.sram_code,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	AsciiToHex
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	AsciiToHex, %function
AsciiToHex:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	r3, r0, #48
	mov	r2, r0
	uxtb	r0, r3
	cmp	r0, #9
	bls	.L2
	sub	r3, r2, #65
	cmp	r3, #5
	bhi	.L3
	sub	r0, r2, #55
	uxtb	r0, r0
	bx	lr
.L3:
	mov	r0, r2
.L2:
	bx	lr
	.size	AsciiToHex, .-AsciiToHex
	.align	1
	.p2align 2,,3
	.global	FlashProgram
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	FlashProgram, %function
FlashProgram:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r2, #3
	push	{r4, r5, r6, r7}
	mov	r4, r0
	bls	.L6
	subs	r3, r2, #4
	ubfx	r3, r3, #2, #6
	adds	r5, r0, #4
	add	r5, r5, r3, lsl #2
	subs	r6, r1, #4
.L7:
	ldr	r7, [r6, #4]!
	str	r7, [r4], #4
	cmp	r4, r5
	bne	.L7
	adds	r3, r3, #1
	lsls	r3, r3, #2
	adds	r4, r0, r3
	add	r1, r1, r3
	and	r2, r2, #3
.L6:
	cbz	r2, .L11
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r4]
	cmp	r2, #1
	beq	.L11
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	strb	r3, [r4, #1]
	cmp	r2, #2
	beq	.L11
	ldrb	r3, [r1, #2]	@ zero_extendqisi2
	strb	r3, [r4, #2]
.L11:
	ldr	r3, .L24
	ldr	r2, [r3]
	movw	r3, #518
	tst	r2, r3
	beq	.L23
	ldr	r3, .L24+4
	ldr	r1, .L24+8
	ldr	r2, .L24+12
	movs	r0, #70
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L12:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L12
.L23:
	pop	{r4, r5, r6, r7}
	bx	lr
.L25:
	.align	2
.L24:
	.word	1073811696
	.word	1073745934
	.word	1073761285
	.word	1073761283
	.size	FlashProgram, .-FlashProgram
	.align	1
	.p2align 2,,3
	.global	ProcessBuffer
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	ProcessBuffer, %function
ProcessBuffer:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #1
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	bls	.L32
	mov	r5, r0
	movs	r0, #2
.L31:
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	sub	r3, r2, #48
	uxtb	r3, r3
	cmp	r3, #9
	sub	r6, r2, #65
	lsr	r7, r0, #1
	bls	.L29
	cmp	r6, #5
	sub	r3, r2, #55
	ite	ls
	uxtbls	r3, r3
	movhi	r3, r2
.L29:
	ldrb	r6, [r5, #2]	@ zero_extendqisi2
	sub	r2, r6, #48
	uxtb	r2, r2
	lsls	r3, r3, #4
	cmp	r2, #9
	sub	lr, r6, #65
	sxtb	r3, r3
	bls	.L30
	cmp	lr, #5
	sub	r2, r6, #55
	ite	ls
	uxtbls	r2, r2
	movhi	r2, r6
.L30:
	adds	r0, r0, #2
	orrs	r3, r3, r2
	cmp	r0, r1
	strb	r3, [r4, r7]
	add	r5, r5, #2
	bls	.L31
.L32:
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	adds	r0, r2, #4
	add	r0, r0, r4
	adds	r5, r2, #5
	mov	r1, r4
	movs	r3, #0
.L28:
	ldrb	r6, [r1, #1]!	@ zero_extendqisi2
	cmp	r0, r1
	add	r3, r3, r6
	bne	.L28
	negs	r3, r3
	ldrb	r1, [r4, r5]	@ zero_extendqisi2
	uxtb	r3, r3
	cmp	r1, r3
	beq	.L43
	ldr	r3, .L47
	ldr	r1, .L47+4
	ldr	r2, .L47+8
	movs	r0, #67
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L37:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L37
.L43:
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	cbz	r0, .L44
	cmp	r0, #4
	beq	.L45
	cmp	r0, #1
	beq	.L46
.L26:
	pop	{r3, r4, r5, r6, r7, pc}
.L44:
	ldr	r1, .L47+12
	ldrb	r3, [r4, #3]	@ zero_extendqisi2
	ldrh	r1, [r1]
	ldrb	r0, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, r1, lsl #16
	orr	r0, r3, r0, lsl #8
	adds	r1, r4, #5
	pop	{r3, r4, r5, r6, r7, lr}
	b	FlashProgram
.L46:
	ldr	r3, .L47+16
	ldr	r4, [r3]
	ands	r4, r4, #134
	bne	.L26
	ldr	r5, .L47+20
	ldr	r3, [r5]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	blx	r3
	ldr	r3, [r5]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	movs	r0, #2
	blx	r3
	ldr	r1, .L47+24
	ldr	r2, .L47+28
	ldr	r3, .L47+32
	strb	r4, [r1]
	strb	r4, [r2]
	strb	r4, [r3]
	.syntax unified
@ 333 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	pop	{r3, r4, r5, r6, r7, pc}
.L45:
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L47+12
	orr	r3, r3, r1, lsl #8
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L48:
	.align	2
.L47:
	.word	1073745934
	.word	1073761285
	.word	1073761283
	.word	.LANCHOR0
	.word	1073811696
	.word	33556508
	.word	1073761286
	.word	1073761284
	.word	1073761282
	.size	ProcessBuffer, .-ProcessBuffer
	.align	1
	.p2align 2,,3
	.global	ProgrammingLoop
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	ProgrammingLoop, %function
ProgrammingLoop:
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r7, lr}
	ldr	r3, .L68
	ldr	r4, .L68+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r6, .L68+8
	ldr	r5, .L68+12
	tst	r3, #18
	ldr	r3, .L68+4
	ldr	r3, [r3]
	ite	eq
	moveq	r1, #-1
	mvnne	r1, #1
	sub	sp, sp, #80
	ldr	r3, [r3, #16]
	movs	r0, #1
	blx	r3
	ldr	r3, [r4]
	mov	r1, #-1
	ldr	r3, [r3, #16]
	movs	r0, #2
	blx	r3
	ldr	r3, [r4]
	movs	r0, #1
	ldr	r3, [r3, #32]
	blx	r3
	ldr	r3, .L68+16
	ldr	r0, [r4]
	ldr	r1, .L68+20
	ldr	r2, .L68+24
	movw	r7, #26970
	str	r7, [r3]
	mov	r7, #196608
	str	r7, [r6]
	movs	r6, #128
	movs	r7, #0
	str	r7, [r3]
	strh	r6, [r5]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #12
	strb	r3, [r1]
	ldrh	r3, [r2]
	ldr	r1, [r0, #44]
	uxth	r3, r3
	orr	r3, r3, #17
	movs	r6, #39
	strh	r3, [r2]	@ movhi
	movs	r0, #12
	strh	r6, [r5, #6]	@ movhi
	blx	r1
	ldr	r3, [r4]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
	ldr	r3, .L68+28
	ldr	r1, .L68+32
	movs	r2, #62
	strh	r2, [r3]	@ movhi
.L52:
	ldrh	r3, [r1]
	lsls	r0, r3, #30
	bpl	.L52
	movs	r2, #0
	ldr	r4, .L68+32
	ldr	r5, .L68+36
	ldr	r9, .L68+28
	ldr	r7, .L68+40
	mov	r6, r2
	mov	r8, #58
.L53:
	ldrh	r3, [r4]
	lsls	r1, r3, #31
	bpl	.L53
	add	r3, sp, #80
	add	r3, r3, r2
	ldrh	r1, [r5]
	strb	r1, [r3, #-80]
	ldrh	r1, [r5]
	uxth	r1, r1
	adds	r3, r2, #1
	cmp	r1, #10
	uxtb	r3, r3
	beq	.L66
	cmp	r3, #77
	bhi	.L67
.L56:
	strh	r6, [r4]	@ movhi
	mov	r2, r3
	b	.L53
.L66:
	subs	r2, r2, #1
	uxtb	r1, r2
	mov	r0, sp
	bl	ProcessBuffer
	strh	r8, [r9]	@ movhi
.L55:
	ldrh	r3, [r4]
	lsls	r3, r3, #30
	bpl	.L55
	ldrb	r3, [r7]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r7]
	movs	r3, #0
	b	.L56
.L67:
	ldr	r3, .L68+28
	ldr	r1, .L68+44
	ldr	r2, .L68+48
	movs	r0, #66
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L57:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L57
.L69:
	.align	2
.L68:
	.word	1073761280
	.word	33556508
	.word	1073808388
	.word	1073745920
	.word	1073808384
	.word	1073761290
	.word	1073745928
	.word	1073745934
	.word	1073745948
	.word	1073745932
	.word	1073761282
	.word	1073761285
	.word	1073761283
	.size	ProgrammingLoop, .-ProgrammingLoop
	.section	.bootloader,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L76
	ldr	r3, [r3]
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	blx	r3
	.syntax unified
@ 82 "bootloader.c" 1
	       cpsid i
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r1, .L76+4
	ldr	r4, .L76+8
	ldrb	r3, [r1]	@ zero_extendqisi2
	ldr	r2, .L76+12
	ldr	r6, .L76+16
	ldr	r5, .L76+20
	orr	r3, r3, #1
	strb	r3, [r1]
	ldrb	r3, [r4]	@ zero_extendqisi2
	orr	r3, r3, #18
	strb	r3, [r4]
	ldrb	r3, [r2]	@ zero_extendqisi2
	movs	r0, #0
	orr	r3, r3, #18
	strb	r3, [r2]
	strh	r0, [r6]	@ movhi
	ldrb	r3, [r5]	@ zero_extendqisi2
	ands	r3, r3, #2
	beq	.L75
	strb	r0, [r4]
	strb	r0, [r1]
	strb	r0, [r2]
	.syntax unified
@ 333 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	pop	{r4, r5, r6, pc}
.L75:
	ldr	r2, .L76+24
	ldr	r4, .L76+28
	ldr	r0, .L76+32
	b	.L72
.L73:
	ldr	r1, [r4, r3]
	str	r1, [r2, r3]
	adds	r3, r3, #4
.L72:
	adds	r1, r2, r3
	cmp	r1, r0
	bcc	.L73
	bl	ProgrammingLoop
.L77:
	.align	2
.L76:
	.word	33556580
	.word	1073761284
	.word	1073761286
	.word	1073761282
	.word	.LANCHOR0
	.word	1073761280
	.word	SRAM_CODE_START
	.word	SRAM_CODE_LOAD_ADDRESS
	.word	SRAM_CODE_END
	.size	main, .-main
	.bss
	.align	1
	.set	.LANCHOR0,. + 0
	.type	scu16BaseAddress, %object
	.size	scu16BaseAddress, 2
scu16BaseAddress:
	.space	2
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
