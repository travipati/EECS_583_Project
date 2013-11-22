	.file	"modif3.bc"
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Ltmp2:
	.cfi_def_cfa_offset 16
.Ltmp3:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp4:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	movl	$1, i(%rip)
	movl	$0, i(%rip)
	jmp	.LBB0_1
	.align	16, 0x90
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	i(%rip)
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	cmpl	$9999, i(%rip)          # imm = 0x270F
	jle	.LBB0_2
# BB#3:                                 # %for.end
	movl	$.L.str1, %edi
	xorb	%al, %al
	callq	printf
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	ret
.Ltmp5:
	.size	main, .Ltmp5-main
	.cfi_endproc

	.type	i,@object               # @i
	.comm	i,4,4
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	 "i = %d \n"
	.size	.L.str, 9

	.type	.L.str1,@object         # @.str1
.L.str1:
	.asciz	 "done \n"
	.size	.L.str1, 7


	.section	".note.GNU-stack","",@progbits
