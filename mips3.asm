.data
welcome_msg:	.asciiz	"Enter text, followed by @:\n"
		.globl main
number_occ:	.space 104 # This is a string we reserve the number of times each letter appears

		.text
main:
		li $s0, 90 # Load the code
		li $s1, 64 # Store the $ character to detect string end
		li $s2, 32 # Store space
		li $s3, 9  # Store tab
		li $s4, 10 # Store new line
		li $s5, 15 # Store carriage return
		li $s6, 58 # Store formatting string
		li $v0, 4 # Load code el priting string.
		la $a0, welcome_msg # Print welcome message
		syscall

input:		
		li $v0,12 # Load code for reading a char.
		syscall # Read a char from the command line.
		
		beq $v0, $s1, print_pre # go to printing if encounter the end of the string(if $v0 == $s1)
		beq $v0, $s2, input # go to input if find space(if $v0 == $s2)
		beq $v0, $s3, input # go to input if find tab(if $v0 == $s3)
		beq $v0, $s4, input # go to input if find new line(if $v0 == $s4)
		beq $v0, $s5, input # go to input if find icarriage return(if $v0 == $s5)
		bgt $v0, $s0, lowercase # If encouter a lowercase letter give it to lowercase to process 
		addi $v0,$v0, -65 # get the input symbols so that A=0, B=1,...
array_fre:
		sll $v0, $v0, 2 # Multiplies $v0 to 4 to get the important position for the array element.
		la $t0, number_occ # Load the array in $t0
		add $t0, $t0, $v0 # get the counter to point to right position
		lw $t1, 0($t0) # Load the current number $t1
		addi $t1, $t1,1 # Increment the counter 
		sw $t1, number_occ($v0) # Store back in the array
		j input 

lowercase:
		addi $v0, $v0,-97 # get the input symbols so that a=0, b=1, ....
		j array_fre # go to the array.
print_pre:
		li $s0, 64 # $s0-->print the letters A, B... in the loop. 
		li $s1, 0 # Initial value in S1 and go to the array and get how many times each letter occured
		li $s3, 25 # This variable contains the number of English letters -1 (because we start counting from 0)
                         

		li $v0, 11 # Load code for priting char.
		move $a0, $s4 # Print new line to get formating.
		syscall 
print_loop:	
		addi $s0, $s0,1 # Increment the letter priting variable by one, so print the next letter
		move $a0, $s0 # go to printing address
		syscall

		move $a0, $s6 # go to colon symbol to priting address
		syscall

		move $a0, $s2 # go to space to priting address
		syscall

		li $t8,3 #load 3 in rigister t8
		sll $t8,$t8,2 #multibly t8 by 4 to can be checked
		sll $t0, $s1, 2 # Multiply the array variable by 4
		bgt $t0,$t8,print_loop #check if character appers more than 3 times
		lw $a0, number_occ($t0) # Load the integer value in the right position in the array to the printing address.
		li $v0, 1 # Load print integer code and print.
		syscall

		li $v0, 11 # Load code for priting char.
		move $a0, $s4 # Print new line to get formating.
		syscall

		beq $s3, $s1 end # Check if reached the end element of the array.
		addi $s1,$s1, 1 
		j print_loop # Repeat to print the next letter.

end:
		li $v0, 10
		syscall # Load the exit code and exit the program.
