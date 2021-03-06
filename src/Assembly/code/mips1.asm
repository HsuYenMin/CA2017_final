.text
main:	addi $s0,$zero,50	# $s0 store the number of integers

	addi $s1,$zero,0		#base, the start of the integer	
	add $t1,$s0,$zero
	add $t0,$s1,$zero		# $t0 is a pointer pointing to to integer being processed
scanlp:	beq $t1,$zero,bbst	# i == n , scan over, bubblesort
	sw $t1,0($t0)	
	addi $t0,$t0,4
	addi $t1,$t1,-1
	j scanlp
bbst:	addi $t1,$zero,0		# i,counts for the bigloop
biglp:	add $t0,$s1,$zero		# $t0 points to the integer being processed
	addi $t1,$t1,1
	bge $t1,$s0,endst		# if i == n, then the bubblesort is finished
	addi $t2,$zero,0		# j, counts fot the smallloop
	sub $t5,$s0,$t1		# $t5 = n - i
smlp:	bge $t2,$t5,biglp	# when j >== n - i, the smallloop is finished
	lw $t3,0($t0)		# $t3 = base[j]
	lw $t4,4($t0)		# $t4 = base[j+1]
	bge $t3,$t4,swap	#if base[j]>base[j+1], swap base[j] and base[j+1]
	addi $t0,$t0,4
	addi $t2,$t2,1		# j++
	j smlp
swap:	sw $t3,4($t0)
	sw $t4,0($t0)
	addi $t0,$t0,4
	addi $t2,$t2,1		# j++
	j smlp
endst:	add $t0,$s1,$zero	#t0:address
	add $t1,$zero,$zero	#t1:count
	addi $t2,$zero,0x0932 
	sw $t2,0x0100($zero)
check:	beq $t1,$s0,over	#t1 = s0,over
	lw $t2,0($t0)
	sw $t2,0x0100($zero)
	addi $t0,$t0,4
	j check

over:	addi $t2,$zero,0x0D5D
	sw $t2,0x0100($zero)
trap:	j trap
