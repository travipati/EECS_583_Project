	.file	"<stdin>"
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Ltmp3:
	.cfi_def_cfa_offset 16
.Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp5:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
.Ltmp6:
	.cfi_offset %rbx, -24
	movl	$26, %edi
	movl	$1, %esi
	movl	$1, %edx
	xorl	%ecx, %ecx
	callq	LAMP_init
	leaq	-12(%rbp), %rsi
	xorl	%edi, %edi
	xorl	%edx, %edx
	callq	LAMP_store4
	movl	$0, -12(%rbp)
	movl	$1, %edi
	movl	$i, %esi
	movl	$1, %edx
	callq	LAMP_store4
	movl	$1, i(%rip)
	movl	$2, %edi
	movl	$i, %esi
	xorl	%edx, %edx
	callq	LAMP_store4
	movl	$0, i(%rip)
	movl	$26, %edi
	callq	LAMP_loop_invocation
	jmp	.LBB0_1
	.align	16, 0x90
.LBB0_14:                               # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$22, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %eax
	incl	%eax
	movslq	%eax, %rbx
	movl	$23, %edi
	movl	$i, %esi
	movq	%rbx, %rdx
	callq	LAMP_store4
	movl	%ebx, i(%rip)
	callq	LAMP_loop_iteration_end
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	callq	LAMP_loop_iteration_begin
	movl	$3, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$9999, i(%rip)          # imm = 0x270F
	jg	.LBB0_15
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$4, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$20001, i(%rip)         # imm = 0x4E21
	jl	.LBB0_4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$5, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$6, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$7, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$30001, i(%rip)         # imm = 0x7531
	jl	.LBB0_6
# BB#5:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$8, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$9, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
.LBB0_6:                                # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$10, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$40001, i(%rip)         # imm = 0x9C41
	jl	.LBB0_8
# BB#7:                                 # %if.then7
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$11, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$12, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
.LBB0_8:                                # %if.end9
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$13, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$50001, i(%rip)         # imm = 0xC351
	jl	.LBB0_10
# BB#9:                                 # %if.then11
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$14, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$15, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
.LBB0_10:                               # %if.end13
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$16, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$60001, i(%rip)         # imm = 0xEA61
	jl	.LBB0_12
# BB#11:                                # %if.then15
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$17, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$18, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
.LBB0_12:                               # %if.end17
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$19, %edi
	movl	$i, %esi
	callq	LAMP_load4
	cmpl	$70001, i(%rip)         # imm = 0x11171
	jl	.LBB0_14
# BB#13:                                # %if.then19
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$20, %edi
	movl	$i, %esi
	callq	LAMP_load4
	movl	i(%rip), %ebx
	movl	$21, %edi
	callq	LAMP_register
	movl	$.L.str, %edi
	movl	%ebx, %esi
	xorb	%al, %al
	callq	printf
	jmp	.LBB0_14
.LBB0_15:                               # %for.end
	callq	LAMP_loop_iteration_end
	callq	LAMP_loop_exit
	movl	$24, %edi
	callq	LAMP_register
	movl	$.L.str1, %edi
	xorb	%al, %al
	callq	printf
	leaq	-12(%rbp), %rsi
	movl	$25, %edi
	callq	LAMP_load4
	movl	-12(%rbp), %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
.Ltmp7:
	.size	main, .Ltmp7-main
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
