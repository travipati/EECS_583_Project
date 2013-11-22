	.file	"simple.profile.ls.bc"
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
	xorl	%edi, %edi
	xorl	%esi, %esi
	movl	$EdgeProfCounters, %edx
	movl	$24, %ecx
	callq	llvm_start_edge_profiling
	incl	EdgeProfCounters(%rip)
	movl	$0, -4(%rbp)
	movl	$1, i(%rip)
	movl	$0, i(%rip)
	incl	EdgeProfCounters+4(%rip)
	jmp	.LBB0_1
	.align	16, 0x90
.LBB0_20:                               # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+88(%rip)
	incl	i(%rip)
	incl	EdgeProfCounters+92(%rip)
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	cmpl	$9999, i(%rip)          # imm = 0x270F
	jg	.LBB0_21
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+8(%rip)
	cmpl	$20000, i(%rip)         # imm = 0x4E20
	jle	.LBB0_3
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+16(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+24(%rip)
	jmp	.LBB0_5
	.align	16, 0x90
.LBB0_3:                                # %for.body.if.end_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+20(%rip)
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	cmpl	$30000, i(%rip)         # imm = 0x7530
	jle	.LBB0_6
# BB#7:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+28(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+36(%rip)
	jmp	.LBB0_8
	.align	16, 0x90
.LBB0_6:                                # %if.end.if.end5_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+32(%rip)
.LBB0_8:                                # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	cmpl	$40000, i(%rip)         # imm = 0x9C40
	jle	.LBB0_9
# BB#10:                                # %if.then7
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+40(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+48(%rip)
	jmp	.LBB0_11
	.align	16, 0x90
.LBB0_9:                                # %if.end5.if.end9_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+44(%rip)
.LBB0_11:                               # %if.end9
                                        #   in Loop: Header=BB0_1 Depth=1
	cmpl	$50000, i(%rip)         # imm = 0xC350
	jle	.LBB0_12
# BB#13:                                # %if.then11
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+52(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+60(%rip)
	jmp	.LBB0_14
	.align	16, 0x90
.LBB0_12:                               # %if.end9.if.end13_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+56(%rip)
.LBB0_14:                               # %if.end13
                                        #   in Loop: Header=BB0_1 Depth=1
	cmpl	$60000, i(%rip)         # imm = 0xEA60
	jle	.LBB0_15
# BB#16:                                # %if.then15
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+64(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+72(%rip)
	jmp	.LBB0_17
	.align	16, 0x90
.LBB0_15:                               # %if.end13.if.end17_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+68(%rip)
.LBB0_17:                               # %if.end17
                                        #   in Loop: Header=BB0_1 Depth=1
	cmpl	$70000, i(%rip)         # imm = 0x11170
	jle	.LBB0_18
# BB#19:                                # %if.then19
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+76(%rip)
	movl	i(%rip), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	incl	EdgeProfCounters+84(%rip)
	jmp	.LBB0_20
	.align	16, 0x90
.LBB0_18:                               # %if.end17.if.end21_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	incl	EdgeProfCounters+80(%rip)
	jmp	.LBB0_20
.LBB0_21:                               # %for.end
	incl	EdgeProfCounters+12(%rip)
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

	.type	EdgeProfCounters,@object # @EdgeProfCounters
	.local	EdgeProfCounters
	.comm	EdgeProfCounters,96,16

	.section	".note.GNU-stack","",@progbits
