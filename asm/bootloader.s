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
	.file	"bootloader.c"
	.section	.bootloader,"ax",%progbits
	.align	2
	.global	main
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	ldr	r3, .L74
	ldr	r4, .L74+64
	ldr	r3, [r3]
	ldr	r6, .L74+4
	ldr	r3, [r3]
	sub	sp, sp, #92
	blx	r3
	ldr	r2, .L74+8
	ldr	r1, .L74+12
	ldrb	r0, [r2]	@ zero_extendqisi2
	ldr	r3, .L74+16
	orr	r0, r0, #1
	strb	r0, [r2]
	ldrb	r0, [r1]	@ zero_extendqisi2
	orr	r0, r0, #18
	strb	r0, [r1]
	ldrb	r5, [r3]	@ zero_extendqisi2
.LPIC16:
	add	r4, pc
	movs	r0, #0
	orr	r5, r5, #18
	strb	r5, [r3]
	strh	r0, [r4]	@ movhi
	ldrb	r4, [r6]	@ zero_extendqisi2
	lsls	r4, r4, #30
	bmi	.L2
	ldrb	r3, [r6]	@ zero_extendqisi2
	tst	r3, #18
	bne	.L3
	.syntax unified
@ 184 "bootloader.c" 1
	
@ See if we're in RAM already
   mov     r1, PC
   ldr     r2, =SRAM_CODE_START
   cmp     r1, r2
   bhi     ExecutingInRAM

@ Not in RAM --> Start copying
   ldr     r1, =BOOTLOADER_START_ADDRESS
   ldr     r3, =BOOTLOADER_END_ADDRESS
CopyLoop:
   @ r1 = Flash pointer, r2 = SRAM pointer
   @ r3 = Address of end of bootloader, r4 = middle man for r1 and r2
   ldr     r4, [r1], #4
   str     r4, [r2], #4
   cmp     r1, r3
   bne     CopyLoop
@ Jump to RAM
   ldr     r1, =SRAM_CODE_START
   orr     r1, r1, #1
   bx      r1

@ Label so we can skip copying if we're in RAM already
ExecutingInRAM:

@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, .L74+20
	ldr	r3, [r3]
	mov	r1, #-1
	ldr	r3, [r3, #16]
	movs	r0, #2
	blx	r3
.L4:
	ldr	r4, .L74+20
	ldr	r5, .L74+24
	ldr	r3, [r4]
	ldr	r7, .L74+28
	ldr	r3, [r3, #16]
	mov	r1, #-1
	movs	r0, #1
	blx	r3
	ldr	r3, .L74+32
	ldr	r6, [r4]
	ldr	r2, [r3]
	ldr	lr, .L74+68
	ldr	r0, .L74+36
	ldr	r1, .L74+40
	orr	r2, r2, #524288
	orr	r2, r2, #2
	str	r2, [r3]
	ldr	r2, [r3]
	orr	r2, r2, #1
	str	r2, [r3]
	movs	r2, #0
	ldr	r4, [r3]
	str	r2, [r3]
	movw	r3, #26970
	str	r3, [r5]
	mov	r3, #196608
	str	r3, [lr]
	movs	r3, #128
	str	r2, [r5]
	strh	r3, [r7]	@ movhi
	ldrb	r3, [r0]	@ zero_extendqisi2
	ldr	r4, .L74+44
	orr	r3, r3, #12
	strb	r3, [r0]
	ldrh	r3, [r1]
	ldr	r2, [r6, #44]
	uxth	r3, r3
	orr	r3, r3, #33
	movs	r5, #78
	strh	r3, [r1]	@ movhi
	movs	r0, #12
	strh	r5, [r4]	@ movhi
	blx	r2
	ldr	r3, .L74+48
	ldr	r1, .L74+52
	movs	r2, #62
	strh	r2, [r3]	@ movhi
.L5:
	ldrh	r3, [r1]
	lsls	r0, r3, #30
	bpl	.L5
	ldr	r7, .L74+72
	ldr	fp, .L74+76
	ldr	r4, .L74+52
	ldr	r6, .L74+56
	ldr	r5, .L74+32
.LPIC18:
	add	r7, pc
.LPIC17:
	add	fp, pc
	movs	r2, #0
.L6:
	ldrh	r3, [r4]
	lsls	r1, r3, #31
	bpl	.L6
	add	r3, sp, #88
	add	r3, r3, r2
	ldrh	r1, [r6]
	strb	r1, [r3, #-80]
	ldrh	r1, [r6]
	uxth	r1, r1
	adds	r3, r2, #1
	cmp	r1, #10
	uxtb	r3, r3
	beq	.L66
	cmp	r3, #77
	bhi	.L67
.L31:
	movs	r1, #0
	mov	r2, r3
	strh	r1, [r4]	@ movhi
	b	.L6
.L66:
	subs	r2, r2, #1
	uxtb	ip, r2
	cmp	ip, #1
	bls	.L68
	mov	lr, #2
	add	r0, sp, #8
.L12:
	add	r3, r0, lr
	add	r1, r0, lr, lsr #1
	ldrb	r2, [r3, #-1]	@ zero_extendqisi2
	sub	r3, r2, #48
	uxtb	r3, r3
	cmp	r3, #9
	bls	.L10
	sub	r3, r2, #65
	cmp	r3, #5
	itte	ls
	subls	r3, r2, #55
	uxtbls	r3, r3
	movhi	r3, r2
.L10:
	ldrb	r8, [r0, lr]	@ zero_extendqisi2
	sub	r2, r8, #48
	uxtb	r2, r2
	lsls	r3, r3, #4
	cmp	r2, #9
	sxtb	r3, r3
	bls	.L11
	sub	r2, r8, #65
	cmp	r2, #5
	itte	ls
	subls	r2, r8, #55
	uxtbls	r2, r2
	movhi	r2, r8
.L11:
	add	lr, lr, #2
	orrs	r3, r3, r2
	cmp	lr, ip
	strb	r3, [r1]
	bls	.L12
.L13:
	ldrb	r10, [sp, #9]	@ zero_extendqisi2
	add	r2, r10, #4
	add	r2, r2, r0
	add	r1, r10, #5
	movs	r3, #0
.L9:
	ldrb	lr, [r0, #1]!	@ zero_extendqisi2
	cmp	r0, r2
	add	r3, r3, lr
	bne	.L9
	add	r2, sp, #88
	add	r2, r2, r1
	negs	r3, r3
	ldrb	r2, [r2, #-80]	@ zero_extendqisi2
	uxtb	r3, r3
	cmp	r2, r3
	bne	.L14
	ldrb	r0, [sp, #12]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L69
	cmp	r0, #4
	beq	.L70
	cmp	r0, #1
	beq	.L71
.L30:
	ldr	r2, .L74+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	movs	r3, #0
	b	.L31
.L67:
	ldr	r3, .L74+20
	ldr	r2, .L74+48
	ldr	r3, [r3]
	movs	r1, #66
.L64:
	ldr	r3, [r3, #52]
	strh	r1, [r2]	@ movhi
	movs	r0, #2
	blx	r3
	movs	r3, #0
	str	r3, [r3]
	.inst	0xdeff
.L14:
	ldr	r3, .L74+20
	ldr	r2, .L74+48
	ldr	r3, [r3]
	movs	r1, #67
	b	.L64
.L3:
	ldr	r3, .L74+20
	ldr	r3, [r3]
	mvn	r1, #-2147483648
	ldr	r3, [r3, #16]
	movs	r0, #2
	blx	r3
	b	.L4
.L2:
	strb	r0, [r1]
	strb	r0, [r2]
	strb	r0, [r3]
	.syntax unified
@ 400 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L68:
	add	r0, sp, #8
	b	.L13
.L71:
	ldr	r3, .L74+60
	ldr	r3, [r3]
	ands	r8, r3, #134
	bne	.L30
	ldr	r9, .L74+20
	ldr	r3, [r9]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	blx	r3
	ldr	r3, [r9]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	movs	r0, #2
	blx	r3
	ldr	r1, .L74+12
	ldr	r2, .L74+8
	ldr	r3, .L74+16
	strb	r8, [r1]
	strb	r8, [r2]
	strb	r8, [r3]
	.syntax unified
@ 400 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	b	.L30
.L70:
	ldrb	r2, [sp, #10]	@ zero_extendqisi2
	ldrb	r3, [sp, #11]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #8
	strh	r3, [r7]	@ movhi
	b	.L30
.L75:
	.align	2
.L74:
	.word	33556580
	.word	1073761280
	.word	1073761284
	.word	1073761286
	.word	1073761282
	.word	33556508
	.word	1073808384
	.word	1073745920
	.word	1073811616
	.word	1073761290
	.word	1073745928
	.word	1073745926
	.word	1073745934
	.word	1073745948
	.word	1073745932
	.word	1073811696
	.word	.LANCHOR0-(.LPIC16+4)
	.word	1073808388
	.word	.LANCHOR0-(.LPIC18+4)
	.word	.LANCHOR0-(.LPIC17+4)
.L69:
	ldr	r2, .L76
	ldrb	r3, [sp, #10]	@ zero_extendqisi2
	ldr	r2, [r2]
	ldrh	r9, [fp]
	ldr	r1, [r5]
	ldr	r1, [r2, #52]
	ldrb	r2, [sp, #11]	@ zero_extendqisi2
	str	r0, [r5]
	lsls	r3, r3, #8
	orr	r3, r3, r9, lsl #16
	orr	r9, r3, r2
	movs	r0, #2
	blx	r1
	tst	r9, #3
	beq	.L35
	cmp	r10, #0
	beq	.L17
	add	r8, sp, #13
	mov	r2, r10
	b	.L18
.L72:
	cmp	r2, #0
	beq	.L17
.L18:
	ldrb	r3, [r8], #1	@ zero_extendqisi2
	strb	r3, [r9], #1
	add	r10, r2, #-1
	tst	r9, #3
	uxtb	r2, r10
	bne	.L72
	mov	r10, r2
	b	.L16
.L35:
	add	r8, sp, #13
.L16:
	ldr	r3, .L76
	ldr	r3, [r3]
	movs	r0, #1
	ldr	r3, [r3, #52]
	blx	r3
	cmp	r10, #3
	bls	.L19
	mov	r0, r9
	sub	r3, r10, #4
	uxtb	r3, r3
	ldr	r2, [r8]
	str	r2, [r0], #4
	lsr	lr, r3, #2
	add	r2, lr, #1
	add	r2, r9, r2, lsl #2
	mov	ip, r0
	mov	r9, r8
	movs	r1, #32
	mov	r10, #0
	str	r3, [sp, #4]
.L20:
	cmp	ip, r2
	beq	.L73
	adds	r1, r1, #32
	ldr	r3, [r9, #4]!
	str	r3, [ip], #4
	uxtb	r1, r1
	lsls	r3, r1, #24
	bpl	.L20
	ldr	r1, [r5]
	str	r10, [r5]
	movs	r1, #0
	b	.L20
.L73:
	ldr	r3, [sp, #4]
	lsl	r2, lr, #2
	sub	r3, r3, lr, lsl #2
	add	lr, r2, #4
	add	r9, r0, r2
	add	r8, r8, lr
	and	r10, r3, #255
	cbz	r1, .L19
	mov	r3, #-1
	b	.L23
.L24:
	adds	r1, r1, #32
	uxtb	r1, r1
	str	r3, [r9]
.L23:
	lsls	r2, r1, #24
	bpl	.L24
	movs	r3, #0
	ldr	r2, [r5]
	str	r3, [r5]
.L19:
	ldr	r3, .L76
	ldr	r3, [r3]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
	cmp	r10, #0
	beq	.L26
	ldrb	r3, [r8]	@ zero_extendqisi2
	strb	r3, [r9]
	cmp	r10, #1
	beq	.L26
	ldrb	r3, [r8, #1]	@ zero_extendqisi2
	strb	r3, [r9, #1]
	cmp	r10, #2
	itt	ne
	ldrbne	r3, [r8, #2]	@ zero_extendqisi2
	strbne	r3, [r9, #2]
.L26:
	ldr	r3, .L76+4
	ldr	r2, [r3]
	movw	r3, #518
	ands	r3, r3, r2
	cmp	r3, #0
	beq	.L30
	ldr	r3, .L76
	ldr	r2, .L76+8
	ldr	r3, [r3]
	movs	r1, #70
	b	.L64
.L17:
	ldr	r8, .L76
	ldr	r3, [r8]
	movs	r0, #1
	ldr	r3, [r3, #52]
	blx	r3
	ldr	r3, [r8]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
	b	.L26
.L77:
	.align	2
.L76:
	.word	33556508
	.word	1073811696
	.word	1073745934
	.size	main, .-main
	.bss
	.align	1
	.set	.LANCHOR0,. + 0
	.type	scu16BaseAddress, %object
	.size	scu16BaseAddress, 2
scu16BaseAddress:
	.space	2
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
