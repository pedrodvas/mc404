	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"pre_riscv.c"
	.globl	main
	.p2align	2
	.type	main,@function














	li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall    
	string:  .asciz "Hello! It works!!!\n"

.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.ident	"clang version 15.0.7 (Fedora 15.0.7-1.fc37)"
	.section	".note.GNU-stack","",@progbits
	.addrsig