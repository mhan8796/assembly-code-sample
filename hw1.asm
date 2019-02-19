

.data
	prompt: .asciiz "Enter an integer:"
	result1: .asciiz "\nThe sum of the numbers 1 + 2 + ... +  "
	result2: .asciiz " is : "
	errormessage: .asciiz "N: Improper value."

.text

	li $v0, 4       # system call code for printing a string = 4
	la $a0, prompt	# put prompt into $a0 to be printed
	syscall		# call operating system to perform print operation
	
	li $v0, 5       # get ready to read in integers
	syscall		# system waits for input, puts the value in $v0
	
	move $t0, $v0	# move the vaule in $vo to $to
	ble $t0,0,error	# check if the number is less than or equal to 0
	
	li $v0, 4       # system call code for printing a string = 4
	la $a0, result1	# put result1 into $a0 to be printed
	syscall		# call operating system to perform print operation
	
	li $v0,1	# system call code for printing a int = 1
	move $a0,$t0	# put numebr into $a0 to be printed
	syscall		# call operating system to perform print operation

loop:
	bge  $t1,$t0,exit	# start the loop for $t0 times
	addi $t1,$t1,1		# increment the counter
	add $t2,$t2,$t1		# store the result in $t2
	j loop
	
exit:
	li $v0, 4       # system call code for printing a string = 4
	la $a0, result2	# put prompt into $a0 to be printed
	syscall		# call operating system to perform print operation
	
	li $v0,1	# system call code for printing a int = 1
	move $a0,$t2	# put numebr from $t2 into $a0 to be printed
	syscall		# call operating system to perform print operation
	
	li $v0, 10	# end the program
	syscall		# call operating system to perform print operation
	
error:
	li $v0, 4       	# system call code for printing a string = 4
	la $a0, errormessage	# set errormessage to be printed
	syscall			# call operating system to perform print operation
	
	li $v0, 10	# end the program
	syscall		# call operating system to perform print operation
