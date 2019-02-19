

.data
	list: .word -5,0,10,24,32,42,55,90,100,120
	value: .asciiz "The value "
	foundmessage: .asciiz " was found in index "
	oflist: .asciiz " of the list"
	notfoundmessage: .asciiz " was not found on the list"
	starting: .asciiz "bsearch - starting index = "
	ending: .asciiz " ending index = "
	return: .asciiz " return value= "
	newline: .asciiz "\n"
	prompt: .asciiz "Enter a number: "
	
.text
	
	li $v0,	4	# prompt user to enter a number to be searched
	la $a0, prompt
	syscall
	li $v0, 5       # get ready to read in integers
	syscall		# system waits for input, puts the value in $v0
	
	move $a0, $v0	# move the vaule in $vo to $a0, the first parameter
	la $s0, list	# store the list in $s0
	li $a1, 0	# the second parameter, the first index 
	li $a2, 9	# the third parameter, the second index
	
	jal recur
	
	########################## print ############################
	move $t7,$a0
	beq $t6, 1, printfind
	
	li $v0,	4
	la $a0,	value
	syscall
	li $v0,	1
	move $a0, $t7
	syscall
	li $v0,	4
	la $a0,	notfoundmessage
	syscall
	
	li $v0, 10 # finish running
	syscall
	
printfind:
	li $v0,	4
	la $a0,	value
	syscall
	li $v0,	1
	move $a0, $t7
	syscall
	li $v0,	4
	la $a0,	foundmessage
	syscall
	li $v0,	1
	move $a0, $t5
	syscall
	li $v0,	4
	la $a0,	oflist
	syscall

	########################## print ############################
		
	li $v0, 10 # finish running
	syscall
	 
recur:
	addi $sp, $sp, -20
	sw $ra, 20($sp)	# save return address
	sw $t0, 16($sp)	# save t0
	sw $t1, 12($sp)	# save t1
	sw $t2, 8($sp)	# save t2
	sw $t3, 4($sp)	# save t3
	sw $t4, 0($sp)	# save t4
	move $t0, $a0	# move the first parameter to $t0
	move $t1, $a1	# move the second parameter to $t1
	move $t2, $a2	# move the third parameter to $t2
	bgt $t1, $t2, notfound # if the first index is greater than second, not found
	########################## print ############################
	move $t7, $a0
	li $v0,	4
	la $a0,	starting
	syscall
	li $v0,	1
	move $a0, $a1
	syscall
	li $v0,	4
	la $a0,	ending
	syscall
	li $v0,	1
	move $a0, $a2
	syscall
	li $v0,	4
	la $a0,	return
	syscall
	move $a0,$t7
	########################## print ############################
	add $t3, $t1, $t2	# add two index togethers
	srl $t3, $t3, 1	# devide $t3 by 2
	sll $t4, $t3, 2	# mid value times 4
	add $t4, $s0, $t4	# get the address of the the middle value
	lw $t4,	0($t4)	# value of middle value
	beq $t4, $t0, found	# if it is equal, then found
	bgt $t4, $t0, left	# if the middle value is greater than the value search the leaft inteval
	blt $t4, $t0, right	# if the middle value is less than the value search the right inteval
	
	
	
found:
	########################## print ############################
	move $t7, $a0
	li $v0,	1
	move $a0, $t7
	syscall
	li $v0,	4
	la $a0,	newline
	syscall
	move $a0,$t7
	########################## print ############################
	
	move $t5, $t3	# set the $t5 to be the index
	li $t6, 1	# set the find flag to 1
	
	lw $t4, 0($sp)	# load t4
	lw $t3,	4($sp)	# load t3
	lw $t2,	8($sp)	# load t2
	lw $t1,	12($sp)	# load t1
	lw $t0,	16($sp)	# load t0
	lw $ra,	20($sp)	# load return address
	addi $sp, $sp, 20 # move stack pointer up
	jr $ra	# go back

left:
	addi $a2, $t3, -1	# change the second parameter

	########################## print ############################
	move $t7, $a0
	li $v0,	1
	li $a0, -1
	syscall
	li $v0,	4
	la $a0,	newline
	syscall
	move $a0,$t7
	########################## print ############################
	jal recur
	
	lw $t4, 0($sp)	# load t4
	lw $t3,	4($sp)	# load t3
	lw $t2,	8($sp)	# load t2
	lw $t1,	12($sp)	# load t1
	lw $t0,	16($sp)	# load t0
	lw $ra,	20($sp)	# load return address
	addi $sp, $sp, 20 # move stack pointer up
	
	jr $ra
	
right:
	addi $a1, $t3, 1	# change the first parameter	
	########################## print ############################
	move $t7, $a0
	li $v0,	1
	li $a0, -1
	syscall
	li $v0,	4
	la $a0,	newline
	syscall
	move $a0,$t7
	########################## print ############################
	jal recur
		
	lw $t4, 0($sp)	# load t4
	lw $t3,	4($sp)	# load t3
	lw $t2,	8($sp)	# load t2
	lw $t1,	12($sp)	# load t1
	lw $t0,	16($sp)	# load t0
	lw $ra,	20($sp)	# load return address
	addi $sp, $sp, 20 # move stack pointer up
	
	jr $ra

notfound:	
	li $t6, 0 # set the find flag to 0
	
	lw $t4, 0($sp)	# load t4
	lw $t3,	4($sp)	# load t3
	lw $t2,	8($sp)	# load t2
	lw $t1,	12($sp)	# load t1
	lw $t0,	16($sp)	# load t0
	lw $ra,	20($sp)	# load return address
	addi $sp, $sp, 20 # move stack pointer up
	jr $ra	# go back