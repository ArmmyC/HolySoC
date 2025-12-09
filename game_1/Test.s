	.file	"Test.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	li	a5,268435456
	addi	sp,sp,-16
	sw	zero,8(a5)
	li	a5,268435456
	sw	zero,4(a5)
	li	a4,268435456
	li	a3,127
	sw	a3,12(a4)
	mv	a5,a4
	li	a4,15
	sw	a4,16(a5)
	sw	zero,12(sp)
	lw	a5,12(sp)
	li	a4,299008
	addi	a4,a4,991
	bgtu	a5,a4,.L2
.L3:
	lw	a5,12(sp)
	addi	a5,a5,1
	sw	a5,12(sp)
	lw	a5,12(sp)
	bleu	a5,a4,.L3
.L2:
	li	a3,65536
	li	a5,268435456
	addi	a3,a3,-1
	sw	a3,4(a5)
	sw	zero,12(a5)
	sw	zero,16(a5)
.L4:
	j	.L4
	.size	_start, .-_start
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
