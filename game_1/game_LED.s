	.file	"game_LED.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-32
	li	a2,268435456
	sw	s0,28(sp)
	sw	s1,24(sp)
	sw	s2,20(sp)
	li	a1,268435456
	sw	zero,8(a2)
	li	t6,268435456
	li	a5,127
	li	t5,268435456
	sw	zero,4(a1)
	sw	a5,12(t6)
	addi	t5,t5,16
	li	a5,15
	li	t2,65536
	li	t3,69632
	li	a7,999424
	li	t1,299008
	addi	a2,a2,8
	addi	a1,a1,4
	addi	t6,t6,12
	sw	a5,0(t5)
	addi	t3,t3,368
	addi	a7,a7,575
	addi	t2,t2,-1
	addi	t1,t1,991
	li	t4,268435456
	li	a0,1
	li	a6,16
	li	t0,8
	li	s2,64
	li	s1,121
	li	s0,36
.L2:
	lw	a4,0(t4)
	li	a3,0
	sw	zero,0(a2)
	slli	a4,a4,16
	srli	a4,a4,16
	sub	a4,t3,a4
.L8:
	sll	a5,a0,a3
	sw	a5,0(a1)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bleu	a4,a5,.L3
.L4:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bltu	a5,a4,.L4
.L3:
	lw	a5,0(a2)
	bne	a5,zero,.L28
	addi	a3,a3,1
	bne	a3,a6,.L8
	sw	zero,0(a1)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bgtu	a5,a7,.L2
.L9:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,a7,.L9
	j	.L2
.L28:
	sw	zero,0(a2)
	beq	a3,t0,.L29
	sw	zero,0(a1)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bgtu	a5,a7,.L2
.L16:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,a7,.L16
	j	.L2
.L29:
	sw	t2,0(a1)
	sw	s2,0(t6)
	sw	zero,0(t5)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bgtu	a5,t1,.L11
.L12:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,t1,.L12
.L11:
	sw	zero,0(a1)
	sw	s1,0(t6)
	sw	zero,0(t5)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bgtu	a5,t1,.L13
.L14:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,t1,.L14
.L13:
	sw	t2,0(a1)
	sw	s0,0(t6)
	sw	zero,0(t5)
	sw	zero,12(sp)
	lw	a5,12(sp)
	bgtu	a5,t1,.L2
.L15:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,t1,.L15
	j	.L2
	.size	_start, .-_start
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
