.data
	  welcome_msg:	.asciiz	"Enter text, followed by @:\n"
		.globl main
          number_occ:	.space 104 # This is a string we reserve the number of times each letter appears
          
          msg: .asciiz "Enter a string \n"
          str: .space 30       # get the paragraph from the user
          ptr1 : .space 400     #ptr1[20][20]
          p: .space 400        #p[20][20]
          
          msg1: .asciiz "1 for charater frequency\n2 for word frequency\n3 for words and letter with frequency =3\n4 for search\n5 for find and replace\nElse Exit\n"
          
          stringlen: .asciiz "String length is "
          blankSpace: .ascii  " "
          next: .asciiz "\n Next while"
          sentence:        .space      100         # space for sentence
          input3:      .space      30          # space for word to scan for
          msg3:        .asciiz     "Please enter a sentence: "
          search:       .asciiz     "Please enter a word: "
          nomatch:    .asciiz     "No Match Found"
          found:      .asciiz     " Match(es) Found"

.text
main:





FindAndReplace:
		addi $sp,$sp,-4
                sw $ra 0($sp)	
                
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
		
strlen:
     addi $sp,$sp,-4
     sw $ra,0($sp)
     addi $t0,$0,0      # i=0
     addi $t1,$0,0      # len=0
  l: add $t2,$a0,$t0    # add base address to offset
     lbu $t3,0($t2)     # load base unsigned for char array
     beq $t3,$0,finish  # if value of array[i] = '\0'
     addi $t0,$t0,1     # i++
     addi $t1,$t1,1     # len++
     j l
 finish:
     subi $t1,$t1,1
     add $v0,$t1,$0
     lw $ra,0($sp)        # restore old $sp
     addi $sp,$sp,4 
     jr $ra
     
		