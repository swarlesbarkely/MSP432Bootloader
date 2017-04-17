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
	push	{r3, r4, r5, r6, r7, r8, r9, lr}
	mov	r6, r1
	lsls	r1, r0, #28
	mov	r4, r0
	mov	r5, r2
	bne	.L82
.L6:
	ldr	r3, .L88
	ldr	r3, [r3]
	movs	r0, #1
	ldr	r3, [r3, #52]
	blx	r3
	cmp	r5, #3
	bls	.L83
	subs	r5, r5, #4
	mov	r0, r4
	uxtb	lr, r5
	ldr	r3, [r6]
	str	r3, [r0], #4
	lsr	r2, lr, #2
	adds	r5, r2, #1
	ldr	r1, .L88+4
	ldr	r8, .L88+16
	add	r5, r4, r5, lsl #2
	mov	r7, r6
	mov	r4, r0
	movs	r3, #4
	mov	ip, #8
.L32:
	cmp	r4, r5
	beq	.L84
.L12:
	adds	r3, r3, #4
	uxth	r3, r3
	ldr	r9, [r7, #4]!
	str	r9, [r4], #4
	cmp	r3, #16
	bne	.L32
.L11:
	ldr	r3, [r1]
	lsls	r3, r3, #28
	bpl	.L11
	cmp	r4, r5
	str	ip, [r8]
	mov	r3, #0
	bne	.L12
.L84:
	lsls	r4, r2, #2
	rsb	r2, r2, r2, lsl #6
	add	r5, lr, r2, lsl #2
	adds	r1, r4, #4
	ands	r5, r5, #255
	add	r4, r4, r0
	add	r6, r6, r1
	beq	.L13
.L30:
	subs	r2, r5, #1
	uxtb	r2, r2
	ldr	r1, .L88+4
	ldr	lr, .L88+16
	adds	r7, r4, r2
	subs	r0, r4, #1
	movs	r5, #8
	b	.L16
.L14:
	cmp	r0, r7
	beq	.L85
.L16:
	adds	r3, r3, #1
	uxth	r3, r3
	ldrb	ip, [r6], #1	@ zero_extendqisi2
	strb	ip, [r0, #1]!
	cmp	r3, #16
	bne	.L14
.L15:
	ldr	r3, [r1]
	lsls	r3, r3, #28
	bpl	.L15
	cmp	r0, r7
	str	r5, [lr]
	mov	r3, #0
	bne	.L16
.L85:
	adds	r2, r2, #1
	add	r4, r4, r2
.L13:
	cmp	r3, #15
	bhi	.L27
	adds	r7, r3, #1
	uxth	r7, r7
	cmp	r7, #16
	rsb	r2, r3, #16
	rsb	r1, r4, #0
	it	hi
	movhi	r2, #1
	uxth	r2, r2
	and	r1, r1, #3
	cmp	r1, r2
	it	cs
	movcs	r1, r2
	cmp	r2, #6
	bhi	.L33
	mov	r5, r4
	movs	r1, #255
	cmp	r2, #1
	mov	lr, r3
	mov	r0, r2
	add	r4, r4, #1
	strb	r1, [r5]
	beq	.L36
.L87:
	adds	r3, r7, #1
	cmp	r2, #2
	strb	r1, [r5, #1]
	uxth	r3, r3
	add	r4, r5, #2
	beq	.L21
	adds	r3, r7, #2
	cmp	r2, #3
	strb	r1, [r5, #2]
	uxth	r3, r3
	add	r4, r5, #3
	beq	.L21
	adds	r3, r7, #3
	cmp	r2, #4
	strb	r1, [r5, #3]
	uxth	r3, r3
	add	r4, r5, #4
	beq	.L21
	adds	r3, r7, #4
	cmp	r2, #6
	strb	r1, [r5, #4]
	uxth	r3, r3
	add	r4, r5, #5
	bne	.L21
	adds	r3, r7, #5
	strb	r1, [r5, #5]
	uxth	r3, r3
	adds	r4, r5, #6
.L21:
	cmp	r2, r0
	beq	.L27
.L20:
	subs	r0, r0, r2
	cmp	r7, #16
	uxth	r6, r0
	rsb	r1, lr, #15
	sub	r0, r6, #4
	it	hi
	movhi	r1, #0
	ubfx	r0, r0, #2, #14
	subs	r1, r1, r2
	adds	r0, r0, #1
	uxth	r1, r1
	lsls	r7, r0, #2
	cmp	r1, #2
	uxth	r7, r7
	bls	.L23
	mov	r1, #-1
	cmp	r0, #1
	str	r1, [r5, r2]
	add	r2, r2, r5
	beq	.L24
	cmp	r0, #2
	str	r1, [r2, #4]
	beq	.L24
	cmp	r0, #3
	str	r1, [r2, #8]
	beq	.L24
	cmp	r0, #4
	str	r1, [r2, #12]
	beq	.L24
	str	r1, [r2, #16]
.L24:
	add	r3, r3, r7
	cmp	r6, r7
	uxth	r3, r3
	add	r4, r4, r7
	beq	.L27
.L23:
	adds	r1, r3, #1
	uxth	r1, r1
	movs	r2, #255
	cmp	r1, #16
	strb	r2, [r4]
	beq	.L27
	cmp	r3, #14
	strb	r2, [r4, #1]
	beq	.L27
	strb	r2, [r4, #2]
.L27:
	ldr	r3, .L88+4
.L18:
	ldr	r2, [r3]
	lsls	r2, r2, #28
	bpl	.L18
	ldr	r2, [r3]
	movw	r3, #518
	tst	r2, r3
	beq	.L28
	add	r3, r3, #1073741824
	addw	r3, r3, #3592
	ldr	r1, .L88+8
	ldr	r2, .L88+12
	movs	r0, #70
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L29:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L29
.L83:
	movs	r3, #0
	cmp	r5, #0
	bne	.L30
	negs	r1, r4
	mov	r3, r5
	and	r1, r1, #3
	movs	r2, #16
	movs	r7, #1
.L33:
	mov	r0, r2
	cbnz	r1, .L86
	mov	r5, r4
	mov	r2, r1
	mov	lr, r3
	b	.L20
.L28:
	ldr	r3, .L88+16
	movw	r2, #65535
	str	r2, [r3]
	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
.L82:
	ldr	r3, .L88
	ldr	r3, [r3]
	movs	r0, #2
	ldr	r3, [r3, #52]
	blx	r3
.L7:
	ldrb	r3, [r6], #1	@ zero_extendqisi2
	strb	r3, [r4], #1
	subs	r5, r5, #1
	lsls	r2, r4, #28
	uxtb	r5, r5
	bne	.L7
	b	.L6
.L86:
	mov	r2, r1
	mov	r5, r4
	movs	r1, #255
	cmp	r2, #1
	mov	lr, r3
	add	r4, r4, #1
	strb	r1, [r5]
	bne	.L87
.L36:
	mov	r3, r7
	b	.L21
.L89:
	.align	2
.L88:
	.word	33556508
	.word	1073811696
	.word	1073761285
	.word	1073761283
	.word	1073811704
	.size	FlashProgram, .-FlashProgram
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu fpv4-sp-d16
	.type	ProcessBuffer.part.0, %function
ProcessBuffer.part.0:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r1, r0
	ldrb	r0, [r0, #3]	@ zero_extendqisi2
	cbnz	r0, .L91
	ldr	r2, .L95
	ldrb	r3, [r1, #2]	@ zero_extendqisi2
	ldrh	r2, [r2]
	ldrb	r0, [r1, #1]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #16
	orr	r0, r3, r0, lsl #8
	ldrb	r2, [r1], #4	@ zero_extendqisi2
	pop	{r3, r4, r5, lr}
	b	FlashProgram
.L91:
	cmp	r0, #4
	bne	.L92
	ldrb	r0, [r1, #4]	@ zero_extendqisi2
	ldrb	r3, [r1, #5]	@ zero_extendqisi2
	ldr	r2, .L95
	orr	r3, r3, r0, lsl #8
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, pc}
.L92:
	cmp	r0, #1
	bne	.L90
	ldr	r3, .L95+4
	ldr	r4, [r3]
	ands	r4, r4, #134
	bne	.L90
	ldr	r5, .L95+8
	ldr	r3, [r5]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	blx	r3
	ldr	r3, [r5]
	mov	r1, #-1
	ldr	r3, [r3, #20]
	movs	r0, #2
	blx	r3
	ldr	r1, .L95+12
	ldr	r2, .L95+16
	ldr	r3, .L95+20
	strb	r4, [r1]
	strb	r4, [r2]
	strb	r4, [r3]
	.syntax unified
@ 394 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
.L90:
	pop	{r3, r4, r5, pc}
.L96:
	.align	2
.L95:
	.word	.LANCHOR0
	.word	1073811696
	.word	33556508
	.word	1073761286
	.word	1073761284
	.word	1073761282
	.size	ProcessBuffer.part.0, .-ProcessBuffer.part.0
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
	@ link register save eliminated.
	cbz	r1, .L97
	cmp	r1, #1
	push	{r4, r5}
	beq	.L103
	subs	r4, r1, #2
	add	r4, r4, r0
	subs	r2, r0, #1
	movs	r3, #0
.L100:
	ldrb	r5, [r2, #1]!	@ zero_extendqisi2
	cmp	r4, r2
	add	r3, r3, r5
	bne	.L100
	add	r1, r1, r0
	negs	r3, r3
	ldrb	r2, [r1, #-1]	@ zero_extendqisi2
	uxtb	r3, r3
	cmp	r2, r3
	beq	.L108
.L101:
	ldr	r3, .L109
	ldr	r1, .L109+4
	ldr	r2, .L109+8
	movs	r0, #67
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L102:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L102
.L97:
	bx	lr
.L103:
	add	r1, r1, r0
	movs	r3, #0
	ldrb	r2, [r1, #-1]	@ zero_extendqisi2
	cmp	r2, r3
	bne	.L101
.L108:
	pop	{r4, r5}
	b	ProcessBuffer.part.0
.L110:
	.align	2
.L109:
	.word	1073745934
	.word	1073761285
	.word	1073761283
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
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r7, fp, lr}
	ldr	r3, .L153
	ldr	r4, .L153+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r7, .L153+8
	ldr	r6, .L153+12
	tst	r3, #18
	ldr	r3, .L153+4
	ldr	r3, [r3]
	ite	eq
	moveq	r1, #-1
	mvnne	r1, #1
	sub	sp, sp, #68
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
	ldr	r3, .L153+16
	ldr	r0, [r4]
	ldr	r1, .L153+20
	ldr	r2, .L153+24
	movw	lr, #26970
	str	lr, [r3]
	mov	lr, #196608
	str	lr, [r7]
	mov	lr, #0
	movs	r7, #128
	str	lr, [r3]
	strh	r7, [r6]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #12
	strb	r3, [r1]
	ldrh	r3, [r2]
	ldr	r1, [r0, #44]
	add	r4, r4, #1040187392
	addw	r4, r4, #2026
	uxth	r3, r3
	orr	r3, r3, #17
	movs	r6, #39
	strh	r3, [r2]	@ movhi
	movs	r0, #12
	strh	r6, [r4]	@ movhi
	blx	r1
	ldr	r3, .L153+28
	ldr	r1, .L153+32
	movs	r2, #62
	strh	r2, [r3]	@ movhi
.L114:
	ldrh	r3, [r1]
	lsls	r0, r3, #30
	bpl	.L114
	movs	r2, #0
	ldr	r4, .L153+32
	ldr	r8, .L153+48
	ldr	r10, .L153+28
	ldr	r7, .L153+36
	mov	r6, r2
	mov	fp, #1
	mov	r9, #58
.L115:
	ldrh	r3, [r4]
	lsls	r1, r3, #31
	bpl	.L115
	ldrh	r3, [r8]
	uxtb	r3, r3
	cmp	r3, #13
	beq	.L116
	cmp	r3, #10
	beq	.L117
	cmp	r3, #58
	beq	.L116
	cmp	fp, #0
	beq	.L118
	sub	r5, r3, #48
	uxtb	r5, r5
	cmp	r5, #9
	bls	.L150
	sub	r1, r3, #65
	cmp	r1, #5
	bhi	.L129
	subs	r3, r3, #55
	uxtb	r5, r3
	mov	fp, #0
.L116:
	strh	r6, [r4]	@ movhi
	b	.L115
.L118:
	sub	r1, r3, #48
	uxtb	r1, r1
	adds	r0, r2, #1
	cmp	r1, #9
	uxtb	r0, r0
	bls	.L119
	sub	r1, r3, #65
	cmp	r1, #5
	itte	ls
	subls	r3, r3, #55
	uxtbls	r1, r3
	movhi	r1, r3
.L119:
	add	r3, sp, #64
	add	r2, r2, r3
	orr	r1, r1, r5, lsl #4
	cmp	r0, #64
	strb	r1, [r2, #-64]
	bhi	.L151
	mov	r2, r0
	mov	fp, #1
	b	.L116
.L129:
	mov	r5, r3
.L150:
	mov	fp, #0
	b	.L116
.L117:
	cbz	r2, .L121
	cmp	r2, #1
	beq	.L132
	subs	r0, r2, #1
	add	r0, r0, sp
	mov	r1, sp
	movs	r3, #0
.L123:
	ldrb	lr, [r1], #1	@ zero_extendqisi2
	cmp	r0, r1
	add	r3, r3, lr
	bne	.L123
	negs	r3, r3
	uxtb	r3, r3
.L122:
	add	r1, sp, #64
	add	r2, r2, r1
	ldrb	r2, [r2, #-65]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L152
	ldr	r3, .L153+28
	ldr	r1, .L153+40
	ldr	r2, .L153+44
	movs	r0, #67
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L125:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L125
.L152:
	mov	r0, sp
	bl	ProcessBuffer.part.0
.L121:
	strh	r9, [r10]	@ movhi
.L126:
	ldrh	r3, [r4]
	lsls	r3, r3, #30
	bpl	.L126
	ldrb	r3, [r7]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r7]
	movs	r2, #0
	b	.L116
.L151:
	ldr	r3, .L153+28
	ldr	r1, .L153+40
	ldr	r2, .L153+44
	movs	r0, #66
	strh	r0, [r3]	@ movhi
	ldrb	r3, [r1]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r1]
.L120:
	ldrb	r3, [r2]	@ zero_extendqisi2
	eor	r3, r3, #1
	strb	r3, [r2]
	b	.L120
.L132:
	movs	r3, #0
	b	.L122
.L154:
	.align	2
.L153:
	.word	1073761280
	.word	33556508
	.word	1073808388
	.word	1073745920
	.word	1073808384
	.word	1073761290
	.word	1073745928
	.word	1073745934
	.word	1073745948
	.word	1073761282
	.word	1073761285
	.word	1073761283
	.word	1073745932
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
	ldr	r3, .L161
	ldr	r3, [r3]
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	blx	r3
	.syntax unified
@ 83 "bootloader.c" 1
	       cpsid i
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r1, .L161+4
	ldr	r4, .L161+8
	ldrb	r3, [r1]	@ zero_extendqisi2
	ldr	r2, .L161+12
	ldr	r6, .L161+16
	ldr	r5, .L161+20
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
	beq	.L160
	strb	r0, [r4]
	strb	r0, [r1]
	strb	r0, [r2]
	.syntax unified
@ 394 "bootloader.c" 1
	
@ Reset stack and jump to startup code address
   ldr     SP, =STACK_BEGIN
   ldr     PC, =STARTUP_CODE_JUMP_ADDRESS

@ 0 "" 2
	.thumb
	.syntax unified
	pop	{r4, r5, r6, pc}
.L160:
	ldr	r2, .L161+24
	ldr	r4, .L161+28
	ldr	r0, .L161+32
	b	.L157
.L158:
	ldr	r1, [r4, r3]
	str	r1, [r2, r3]
	adds	r3, r3, #4
.L157:
	adds	r1, r2, r3
	cmp	r1, r0
	bcc	.L158
	bl	ProgrammingLoop
.L162:
	.align	2
.L161:
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
