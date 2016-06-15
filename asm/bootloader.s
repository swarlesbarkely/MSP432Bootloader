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
	ldr	r3, .L83
	ldr	r4, .L83+68
	ldr	r3, [r3]
	ldr	r6, .L83+4
	ldr	r3, [r3]
	sub	sp, sp, #92
	blx	r3
	ldr	r2, .L83+8
	ldr	r1, .L83+12
	ldrb	r0, [r2]	@ zero_extendqisi2
	ldr	r3, .L83+16
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
@ 183 "bootloader.c" 1
	
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
	ldr	r3, .L83+20
	ldr	r3, [r3]
	mov	r1, #-1
	ldr	r3, [r3, #16]
	movs	r0, #1
	blx	r3
.L4:
	ldr	r4, .L83+20
	ldr	r6, .L83+24
	ldr	r3, [r4]
	ldr	r5, .L83+28
	ldr	r3, [r3, #16]
	mov	r1, #-1
	movs	r0, #2
	blx	r3
	ldr	r3, [r4]
	movs	r0, #1
	ldr	r3, [r3, #32]
	blx	r3
	ldr	r3, .L83+32
	ldr	r0, [r4]
	ldr	r2, .L83+36
	ldr	r1, .L83+40
	movw	r7, #26970
	str	r7, [r3]
	mov	r7, #196608
	str	r7, [r6]
	movs	r7, #0
	movs	r6, #128
	str	r7, [r3]
	strh	r6, [r5]	@ movhi
	ldrb	r3, [r2]	@ zero_extendqisi2
	orr	r3, r3, #12
	strb	r3, [r2]
	ldrh	r3, [r1]
	ldr	r2, [r0, #44]
	add	r4, r4, #1040187392
	addw	r4, r4, #2026
	uxth	r3, r3
	orr	r3, r3, #33
	movs	r5, #78
	strh	r3, [r1]	@ movhi
	movs	r0, #12
	strh	r5, [r4]	@ movhi
	blx	r2
	ldr	r3, .L83+44
	ldr	r1, .L83+48
	movs	r2, #62
	strh	r2, [r3]	@ movhi
.L5:
	ldrh	r3, [r1]
	lsls	r2, r3, #30
	bpl	.L5
	ldr	r3, .L83+72
	ldr	r8, .L83+76
	ldr	r9, .L83+48
	ldr	r7, .L83+52
.LPIC17:
	add	r3, pc
.LPIC18:
	add	r8, pc
	str	r3, [sp, #4]
	movs	r2, #0
	add	r5, sp, #8
	add	r6, sp, #13
.L6:
	ldrh	r3, [r9]
	lsls	r3, r3, #31
	bpl	.L6
	ldr	r1, .L83+56
	add	r3, sp, #88
	add	r3, r3, r2
	ldrh	r0, [r1]
	strb	r0, [r3, #-80]
	ldrh	r1, [r1]
	uxth	r1, r1
	adds	r3, r2, #1
	cmp	r1, #10
	uxtb	r3, r3
	beq	.L76
	cmp	r3, #77
	bhi	.L77
.L35:
	movs	r1, #0
	mov	r2, r3
	strh	r1, [r9]	@ movhi
	b	.L6
.L3:
	ldr	r3, .L83+20
	ldr	r3, [r3]
	mvn	r1, #1
	ldr	r3, [r3, #16]
	movs	r0, #1
	blx	r3
	b	.L4
.L2:
	strb	r0, [r1]
	strb	r0, [r2]
	strb	r0, [r3]
	.syntax unified
@ 382 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L76:
	subs	r2, r2, #1
	uxtb	r1, r2
	cmp	r1, #1
	it	hi
	movhi	r0, #2
	bls	.L13
.L12:
	adds	r3, r5, r0
	lsrs	r4, r0, #1
	ldrb	r2, [r3, #-1]	@ zero_extendqisi2
	sub	r3, r2, #48
	uxtb	r3, r3
	cmp	r3, #9
	sub	lr, r2, #65
	bls	.L10
	cmp	lr, #5
	sub	r3, r2, #55
	ite	ls
	uxtbls	r3, r3
	movhi	r3, r2
.L10:
	ldrb	lr, [r5, r0]	@ zero_extendqisi2
	sub	r2, lr, #48
	uxtb	r2, r2
	lsls	r3, r3, #4
	cmp	r2, #9
	sub	ip, lr, #65
	sxtb	r3, r3
	bls	.L11
	cmp	ip, #5
	sub	r2, lr, #55
	ite	ls
	uxtbls	r2, r2
	movhi	r2, lr
.L11:
	adds	r0, r0, #2
	orrs	r3, r3, r2
	cmp	r0, r1
	strb	r3, [r5, r4]
	bls	.L12
.L13:
	ldrb	r4, [sp, #9]	@ zero_extendqisi2
	adds	r0, r4, #4
	add	r0, r0, r5
	adds	r2, r4, #5
	mov	r1, r5
	movs	r3, #0
.L9:
	ldrb	lr, [r1, #1]!	@ zero_extendqisi2
	cmp	r1, r0
	add	r3, r3, lr
	bne	.L9
	add	r1, sp, #88
	add	r2, r2, r1
	negs	r3, r3
	ldrb	r2, [r2, #-80]	@ zero_extendqisi2
	uxtb	r3, r3
	cmp	r2, r3
	beq	.L78
	ldr	r3, .L83+44
	ldr	r1, .L83+60
	ldr	r2, .L83+64
	movs	r0, #67
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L34:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L34
.L77:
	ldr	r3, .L83+44
	ldr	r1, .L83+60
	ldr	r2, .L83+64
	movs	r0, #66
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L36:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L36
.L78:
	ldrb	r0, [sp, #12]	@ zero_extendqisi2
	cbz	r0, .L79
	cmp	r0, #4
	beq	.L80
	cmp	r0, #1
	beq	.L81
.L33:
	ldr	r2, .L83+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	movs	r3, #0
	b	.L35
.L79:
	ldr	r1, [sp, #4]
	ldrb	r3, [sp, #10]	@ zero_extendqisi2
	ldr	r2, .L83+20
	ldrh	r1, [r1]
	ldr	r2, [r2]
	ldrb	fp, [sp, #11]	@ zero_extendqisi2
	ldr	r2, [r2, #52]
	lsls	r3, r3, #8
	orr	r3, r3, r1, lsl #16
	orr	fp, r3, fp
	movs	r0, #2
	blx	r2
	tst	fp, #3
	beq	.L41
	cmp	r4, #0
	beq	.L17
	mov	r10, r6
	b	.L18
.L82:
	cmp	r4, #0
	beq	.L17
.L18:
	ldrb	r3, [r10], #1	@ zero_extendqisi2
	strb	r3, [fp], #1
	subs	r4, r4, #1
	tst	fp, #3
	uxtb	r4, r4
	bne	.L82
.L16:
	ldr	r3, .L83+20
	ldr	r3, [r3]
	movs	r0, #1
	ldr	r3, [r3, #52]
	blx	r3
	cmp	r4, #3
	bls	.L20
	mov	r1, fp
	subs	r4, r4, #4
	ldr	r3, [r10]
	str	r3, [r1], #4
	uxtb	r4, r4
	lsrs	r2, r4, #2
	adds	r3, r2, #1
	add	fp, fp, r3, lsl #2
	mov	r0, r1
	mov	lr, r10
	movs	r3, #32
	b	.L38
.L84:
	.align	2
.L83:
	.word	33556580
	.word	1073761280
	.word	1073761284
	.word	1073761286
	.word	1073761282
	.word	33556508
	.word	1073808388
	.word	1073745920
	.word	1073808384
	.word	1073761290
	.word	1073745928
	.word	1073745934
	.word	1073745948
	.word	1073811536
	.word	1073745932
	.word	1073761285
	.word	1073761283
	.word	.LANCHOR0-(.LPIC16+4)
	.word	.LANCHOR0-(.LPIC17+4)
	.word	.LANCHOR0-(.LPIC18+4)
.L23:
	adds	r3, r3, #32
	uxtb	r3, r3
	ldr	ip, [lr, #4]!
	str	ip, [r0], #4
	tst	r3, #128
	bne	.L57
.L38:
	cmp	r0, fp
	bne	.L23
	lsl	fp, r2, #2
	sub	r4, r4, r2, lsl #2
	add	r2, fp, #4
	add	r10, r10, r2
	add	fp, fp, r1
	and	r4, r4, #255
	cmp	r3, #0
	beq	.L20
	mov	r2, #-1
.L24:
	lsls	r1, r3, #24
	bmi	.L56
	adds	r3, r3, #32
	uxtb	r3, r3
	str	r2, [fp]
	b	.L24
.L81:
	ldr	r3, .L85
	ldr	r4, [r3]
	ands	r4, r4, #134
	bne	.L33
	ldr	r10, .L85+16
	ldr	r3, [r10]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	blx	r3
	ldr	r3, [r10]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	movs	r0, #2
	blx	r3
	ldr	r1, .L85+4
	ldr	r2, .L85+8
	ldr	r3, .L85+12
	strb	r4, [r1]
	strb	r4, [r2]
	strb	r4, [r3]
	.syntax unified
@ 382 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	b	.L33
.L80:
	ldrb	r2, [sp, #10]	@ zero_extendqisi2
	ldrb	r3, [sp, #11]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #8
	strh	r3, [r8]	@ movhi
	b	.L33
.L57:
	ldr	r3, [r7]
	ands	r3, r3, #196608
	beq	.L38
	ldr	r3, [r7]
	ands	r3, r3, #196608
	bne	.L57
	b	.L38
.L56:
	ldr	r3, [r7]
	tst	r3, #196608
	bne	.L56
.L20:
	ldr	r3, .L85+16
	ldr	r3, [r3]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
	cbz	r4, .L28
	ldrb	r3, [r10]	@ zero_extendqisi2
	strb	r3, [fp]
	cmp	r4, #1
	beq	.L28
	ldrb	r3, [r10, #1]	@ zero_extendqisi2
	strb	r3, [fp, #1]
	cmp	r4, #2
	itt	ne
	ldrbne	r3, [r10, #2]	@ zero_extendqisi2
	strbne	r3, [fp, #2]
.L28:
	ldr	r3, .L85
	ldr	r2, [r3]
	movw	r3, #518
	ands	r3, r3, r2
	cmp	r3, #0
	beq	.L33
	ldr	r3, .L85+20
	ldr	r1, .L85+24
	ldr	r2, .L85+28
	movs	r0, #70
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L31:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L31
.L17:
	ldr	r4, .L85+16
	ldr	r3, [r4]
	movs	r0, #1
	ldr	r3, [r3, #52]
	blx	r3
	ldr	r3, [r4]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
	b	.L28
.L41:
	mov	r10, r6
	b	.L16
.L86:
	.align	2
.L85:
	.word	1073811696
	.word	1073761286
	.word	1073761284
	.word	1073761282
	.word	33556508
	.word	1073745934
	.word	1073761285
	.word	1073761283
	.size	main, .-main
	.bss
	.align	1
	.set	.LANCHOR0,. + 0
	.type	scu16BaseAddress, %object
	.size	scu16BaseAddress, 2
scu16BaseAddress:
	.space	2
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 5.3.1 20160307 (release) [ARM/embedded-5-branch revision 234589]"
