
.data
	promptx:.asciiz "Enter a digit for X multiplicand: "
	prompty:.asciiz "Enter a digit for Y multiplier: "
	product:.asciiz "The product of "
	by:.asciiz " by "
	is:.asciiz " is "
	ends:.asciiz " ."
.text

loopx:
	bge $t7,4, afterx	# start the loop for 4 times
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, promptx		# put prompt into $a0 to be printed
	syscall			# call operating system to perform print operation
	
	li $v0, 5       # get ready to read in integers
	syscall		# system waits for input, puts the value in $v0
	
	move $t0, $v0	# move the vaule in $vo to $to
	add $t1,$t1,$t0	# add the new number to the least 4 bits
	sll $t1,$t1,4	# shift the first digit left for 4 digits
	addi $t7,$t7,1	# increment the counter
	j loopx		# jump back to loopx
	

	
afterx:
	srl $t1,$t1,4	# shift the extra 4 bits back
	move $s0,$t1	# store X in the $s0
	li $t7,0	# set the register to 0
	li $t1,0	# set the register to 0

loopy:
	bge $t7,4,aftery	# start the loop for 4 times
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, prompty		# put prompt into $a0 to be printed
	syscall			# call operating system to perform print operation
	
	li $v0, 5       # get ready to read in integers
	syscall		# system waits for input, puts the value in $v0
	
	move $t0, $v0	# move the vaule in $vo to $to
	add $t1,$t1,$t0	# add the new number to the least 4 bits
	sll $t1,$t1,4	# shift the first digit left for 4 digits
	addi $t7,$t7,1	# increment the counter
	j loopy		# jump back to loopx

aftery:
	srl $t1,$t1,4	# shift the extra 4 bits back
	move $s1,$t1	# store Y in the $s1
		

	
	############################################### Times start
	############################################### First bit start

	# times 1
	move $t0,$s0	# X
	move $t1,$s1	# Y
	
	andi $t0,0xf	# X0
	andi $t1,0xf	# Y0
	mul $t2,$t0,$t1 # X0*Y0
	div $t2,$t2,10	# get the carry bit value and the remainder
	mflo $t6	# quotient
	mfhi $t7	# remainder
	
	# times 2
	move $t0,$s0
	andi $t0,0xf0	
	srl $t0,$t0,4	# X1
	mul $t2,$t0,$t1	# X1*Y0
	div $t2,$t2,10	# get the carry bit value and the remainder
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6	# add the old carry
	div $t3,$t3,10	# see if it overflow
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,4	
	add $t7,$t7,$t2 # add to the result
	add $t6,$t4,$t0	# add the overflow bit
	
	# times 3
	move $t0,$s0
	andi $t0,0xf00	
	srl $t0,$t0,8	# X1
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,8
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 4
	move $t0,$s0
	andi $t0,0xf000	
	srl $t0,$t0,12	# X1
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,12
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	##############################################
	sll $t6,$t6,16	# the extra one bit, add it to the result
	add $t7,$t7,$t6
	
	move $s2,$t7 # store value of multiplication of first bit into $s2
	##############################################	First Bit finish
	
	############################################### Second bit start, similar to previous
	# times 1
	
	move $t0,$s0
	move $t1,$s1
	
	andi $t0,0xf
	andi $t1,0xf0	
	srl $t1,$t1,4
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t6	# quotient
	mfhi $t7	# remainder
	
	# times 2
	move $t0,$s0
	andi $t0,0xf0	
	srl $t0,$t0,4
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,4
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 3
	move $t0,$s0
	andi $t0,0xf00	
	srl $t0,$t0,8
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,8
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 4
	move $t0,$s0
	andi $t0,0xf000	
	srl $t0,$t0,12
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,12
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	##############################################
	sll $t6,$t6,16
	add $t7,$t7,$t6
	move $s3,$t7
	############################################### Second bit finish
	
	############################################### Third bit start, similar to previous
	# times 1
	
	move $t0,$s0	# X
	move $t1,$s1	# Y
	
	andi $t0,0xf
	andi $t1,0xf00	
	srl $t1,$t1,8
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t6	# quotient
	mfhi $t7	# remainder
	
	# times 2
	move $t0,$s0
	andi $t0,0xf0	
	srl $t0,$t0,4
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,4
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 3
	move $t0,$s0
	andi $t0,0xf00	
	srl $t0,$t0,8
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,8
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 4
	move $t0,$s0
	andi $t0,0xf000	
	srl $t0,$t0,12
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,12
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	##############################################
	sll $t6,$t6,16
	add $t7,$t7,$t6
	move $s4,$t7
	############################################### Third bit finish
	
	############################################### Fourth bit start,similar to previous
	# times 1
	
	move $t0,$s0	# X
	move $t1,$s1	# Y
	
	andi $t0,0xf
	andi $t1,0xf000	
	srl $t1,$t1,12
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t6	# quotient
	mfhi $t7	# remainder
	
	# times 2
	move $t0,$s0
	andi $t0,0xf0	
	srl $t0,$t0,4
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,4
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 3
	move $t0,$s0
	andi $t0,0xf00	
	srl $t0,$t0,8
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,8
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	# times 4
	move $t0,$s0
	andi $t0,0xf000	
	srl $t0,$t0,12
	mul $t2,$t0,$t1
	div $t2,$t2,10
	mflo $t4	# quotient
	mfhi $t5	# remainder
	add $t3,$t5,$t6
	div $t3,$t3,10
	mflo $t0	# quotient
	mfhi $t2	# remainder
	sll $t2,$t2,12
	add $t7,$t7,$t2 
	add $t6,$t4,$t0
	
	##############################################
	sll $t6,$t6,16
	add $t7,$t7,$t6
	move $s5,$t7
	############################################### Fourth bit finish
	############################################### Times finish
	
	
	
	
	
	move $t0,$s2	# load data from save register
	move $t1,$s3	# load data from save register
	move $t2,$s4	# load data from save register
	move $t3,$s5	# load data from save register
	
	sll $t1,$t1,4	# shift 
	sll $t2,$t2,8
	sll $t3,$t3,12
	
	move $s2,$t0	# save them back
	move $s3,$t1
	move $s4,$t2
	move $s5,$t3
	
	
	
	
	
	############################################	Add results
	li $t6,0	# set to 0
	li $t7,0
	
	# times 1
	andi $t0,$t0,0xf	
	add $t7,$t7,$t0		# add it to the final result
	
	# times 2
	move $t0,$s2
	
	andi $t0,$t0,0xf0	# get the right second bit
	andi $t1,$t1,0xf0
	andi $t2,$t2,0xf0
	andi $t3,$t3,0xf0
	srl $t0,$t0,4
	srl $t1,$t1,4
	srl $t2,$t2,4
	srl $t3,$t3,4
	add $t6,$t6,$t0		# add them together
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	
	div $t0,$t6,10		# divide it by 10, get the carry bit and the remainder
	mflo $t5	# quotient
	mfhi $t1	# remainder
	
	sll $t1,$t1,4	# shift the remainder and add it to the final result
	add $t7,$t7,$t1	
	
	# times 3 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf00
	andi $t1,$t1,0xf00
	andi $t2,$t2,0xf00
	andi $t3,$t3,0xf00
	srl $t0,$t0,8
	srl $t1,$t1,8
	srl $t2,$t2,8
	srl $t3,$t3,8
	add $t6,$t6,$t0
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10	# check the overflow of the remainder added with the old carry
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,8
	add $t7,$t7,$t3	
	
	# times 4 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf000
	andi $t1,$t1,0xf000
	andi $t2,$t2,0xf000
	andi $t3,$t3,0xf000
	srl $t0,$t0,12
	srl $t1,$t1,12
	srl $t2,$t2,12
	srl $t3,$t3,12
	add $t6,$t6,$t0	
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,12
	add $t7,$t7,$t3		
	
	# times 5 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf0000
	andi $t1,$t1,0xf0000
	andi $t2,$t2,0xf0000
	andi $t3,$t3,0xf0000
	srl $t0,$t0,16
	srl $t1,$t1,16
	srl $t2,$t2,16
	srl $t3,$t3,16
	add $t6,$t6,$t0	
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,16
	add $t7,$t7,$t3	
	
	# times 6 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf00000
	andi $t1,$t1,0xf00000
	andi $t2,$t2,0xf00000
	andi $t3,$t3,0xf00000
	srl $t0,$t0,20
	srl $t1,$t1,20
	srl $t2,$t2,20
	srl $t3,$t3,20
	add $t6,$t6,$t0	
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,20
	add $t7,$t7,$t3						

	# times 7 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf000000
	andi $t1,$t1,0xf000000
	andi $t2,$t2,0xf000000
	andi $t3,$t3,0xf000000
	srl $t0,$t0,24
	srl $t1,$t1,24
	srl $t2,$t2,24
	srl $t3,$t3,24
	add $t6,$t6,$t0
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,24
	add $t7,$t7,$t3	
	
	# times 8 similar to previous
	li $t6,0
	move $t0,$s2
	move $t1,$s3
	move $t2,$s4
	move $t3,$s5
	
	andi $t0,$t0,0xf0000000
	andi $t1,$t1,0xf0000000
	andi $t2,$t2,0xf0000000
	andi $t3,$t3,0xf0000000
	srl $t0,$t0,28
	srl $t1,$t1,28
	srl $t2,$t2,28
	srl $t3,$t3,28
	add $t6,$t6,$t0	
	add $t6,$t6,$t1
	add $t6,$t6,$t2
	add $t6,$t6,$t3
	div $t0,$t6,10
	mflo $t0
	mfhi $t1
	add $t1,$t1,$t5	
	div $t1,$t1,10
	mflo $t2
	mfhi $t3
	add $t5,$t0,$t2
	sll $t3,$t3,28
	add $t7,$t7,$t3			
	############################################	Add results finished
	
	
	
	
	
	
	############################################	Print the result
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, product		# put product into $a0 to be printed
	syscall			# call operating system to perform print operation

	############################################	Print the first number	
	move $t1,$s0		# load X

	andi $t2,$t1,0xf000	# get the first digit
	srl $t2,$t2,12		# shift to the corresponding bits
	li $v0, 1    		# print it
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x0f00
	srl $t2,$t2,8
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x00f0
	srl $t2,$t2,4
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x000f
	srl $t2,$t2,0
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	############################################	Print the first number finished 
	
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, by		# put by into $a0 to be printed
	syscall			# call operating system to perform print operation
	
	############################################	Print the second number	similar to previous
	move $t1,$s1		# load Y

	andi $t2,$t1,0xf000
	srl $t2,$t2,12
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x0f00
	srl $t2,$t2,8
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x00f0
	srl $t2,$t2,4
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x000f
	srl $t2,$t2,0
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	############################################	Print the second number finished
	
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, is		# put is into $a0 to be printed
	syscall			# call operating system to perform print operation
	
	############################################	Print the third number similar to previous	
	move $t1,$t7		# load result
	
	andi $t2,$t1,0xf0000000
	srl $t2,$t2,28
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x0f000000
	srl $t2,$t2,24
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x00f00000
	srl $t2,$t2,20
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x000f0000
	srl $t2,$t2,16
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x0000f000
	srl $t2,$t2,12
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x00000f00
	srl $t2,$t2,8
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x000000f0
	srl $t2,$t2,4
	li $v0, 1    	
	move $a0, $t2
	syscall	 
	andi $t2,$t1,0x0000000f
	srl $t2,$t2,0
	li $v0, 1    	
	move $a0, $t2
	syscall	 	
	############################################	Print the third number finished
	
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, ends		# put ends into $a0 to be printed
	syscall			# call operating system to perform print operation
	############################################	Print the result finished									
