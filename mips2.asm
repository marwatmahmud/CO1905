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
                 li $v0,4     
                 la $a0,msg1   
                 syscall              # choose number
                 li $v0,5             #read integer
                 syscall
                 beq $v0,1,num1
                 beq $v0,2,num2
                 beq $v0,5,num5
                 li $v0 ,10
                 syscall            # Exit terminating the program
         num1:   jal char_count
                 j main
         num2:   jal word_stat  
                 j main
         num5:   jal searchf
                 j main
#-----------------------------------------------------------Mariam------------------------------------------------------------
char_count:	
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

		sll $t0, $s1, 2 # Multiply the array variable by 4
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
		lw $ra,0($sp)        # restore old $sp
                addi $sp,$sp,4 
                jr $ra               # return main 
#-----------------------------------------------------------------abdelrahman-------------------------------------------------------
word_stat:
     addi $sp,$sp,-4
     sw $ra 0($sp)
    
     li $v0,4     
     la $a0,msg   
     syscall              # printing the message to the user
     
     li $v0,8
     la $a0,str
     li $a1,30
     syscall              # getting a paragraph from the user
     
     li $v0,4
     la $a0,stringlen     #"String length is "
     syscall
     la $a0,str
     jal strlen
     addi $a0,$v0,0
     addi $s3,$a0,0      #strlen value   $s3
     li $v0,1
     syscall              # calling the strlen function to count the string length
     
     la $a3,blankSpace
     lb $s4,0($a3)      # $s4 =blankspace
     
     addi $s2,$0,0     # space =0
     addi $t0,$0,0     # i=0
     la $a1,str
     
 while1: slt $t5,$t0,$s3   #set $t5=1 if i < strlength
         beq $t5,$0,L5     #if i>strlength
         add $t6,$a1,$t0   # $a0 = str[]
         lbu $t6,0($t6)    # str[i]
         beq $t6,$s4,L2    #if str[i]==' ' branch 
 L3:     addi $t0,$t0,1    # i++
         j while1
     
 L2:     addi $s2,$s2,1    # space ++ if str[i]==' '
         j L3             

 L5:     la,$a2,p       
         
         la $s5,str      # address start of str
         la $s6,p        # address start of p
         la $s7,ptr1     # address start of ptrl
         li $t9,20       # width =20
         li $t0,0        # i=0
         li $t2,0        # j=0
         li $t3,0        # k=0
      
      
 WHILE:
      bge $t2,$s3,End_While   # branch if j<=strlength
      add $t5,$t2,$s5
      lb $t7,($t5)           # $t7 = str[j]
      beq $t7,$s4,L           # if str[j]== ' ' branch L
      
      mul $t8,$t9,$t0         # width *i
      add $t8,$t8,$t3         # width * i+k
      add $t8,$t8,$s6         # base array (width *i+k)
      sb $t7,($t8)            # p[i][k++]=str[j]
      addi $t3,$t3,1          # k++
      
 L10: addi $t2,$t2,1          # j++
      j WHILE
      
  L:  mul $t8,$t9,$t0         # array width * i 
      add $t8,$t8,$t3         # width * i+k
      add $t8,$t8,$s6         # base array +(width * i+k)  
      sb $zero,($t8)            # p[i][k++]='\0'
      addi $t0,$t0,1          # i++
      addi $t3,$zero,0        # k=0
      j L10           
 End_While:
         
             li $t0,0     # i=0
             li $s0,0     # count=0
             li $t3,0     # k=0
             la $s6,p        # address start of p
             la $s7,ptr1     # address start of ptrl
      
 While2:
             slt $t4,$s2,$t0         # set $t4=1 if i>space
             beq $t4,1,End_While2    # End While loop if i>space
             addi $t2,$zero,0        # j=o
             
 While3:
             slt $t4,$s2,$t2         # set $t4=1 if j>space
             beq $t4,1,End_While3    # End while loop if j > space
             bne $t0,$t2,Else        # if i==j
             add $t8,$t3,$s7         # $t8 = add base address of ptr1 to offset k
             lb $a2,($t8)            # a2=ptr1[k]
             add $t6,$t0,$s6         # t6 = add base address of p to offset i
             lb $a3,($t6)            # a3 = p[i]
             jal strcpy              # jump strcmp function
             addi $t3,$t3,1          # k++
             addi $s0,$s0,1          # count ++
             addi $t2,$t2,1          # j++
             j End_While3            # break
             
  Else:      
             add $t8,$t2,$s7         # add base ptr1 to offset j
             lb $a2,($t8)            # $a2 = ptr1[j]
             add $t6,$t0,$s6         # add base p to offset i
             lb $a3,($t6)            # $a3 = p[i]
             jal strcmp              # jump strcmp
             move $t5,$v0            # move v0 value to t5
             beq $t5,$zero,Else2     # if strcmp(ptr1[j],p[i]!=0) branch else2
             addi $t2,$t2,1          # j++
             j While3                # continue
             
  Else2:
            addi $t2,$t2,1           # j++
            j End_While3             # break
                       
             
            j While3
 End_While3:
             addi $t0,$t0,1          # i++
             j While2
 End_While2:         

         li $t0,0   # i=0
         li $t3,0   # c=0
         
  While5:
         bge $t0,$s0,End_While5    # End loop if i >= count
         li $t2,0                  # j=0
  While6:
         slt $t5,$s2,$t2           # set t5=1 if j > space
         beq $t5,1,End_while6      # End loop if j > space
         add $t7,$t0,$s7           # base address of ptr1 + offset i
         lb $a2,($t7)              # a2 = ptr1[i]
         add $t8,$t2,$s6           # add base address p to offset j
         lb $a3,($t8)              # a3 =p[j]
         j strcmp
         move $t6,$v0              # return of function strcmp
         bne $t6,0,Loo             # if strcmp != 0
         addi $t3,$t3,1            # c++
     Loo:
         addi $t2,$t2,1            # j++
         j  While6
 End_while6:
         li $v0,4     
         move $a0,$a2
         syscall                  # print(ptr1[i]) word to count
         
         li $v0,1
         move $a0,$t3
         syscall                   # print c (word count number)
         
         addi $t3,$zero,0          # c=0
         addi $t0,$t0,1            # i++
         j While5
 End_While5:             
      
       li $v0,4     
       la $a0,next  
       syscall 
       
       li $v0 ,10
       syscall            # Exit terminating the program  
    
       lw $ra,0($sp)      # restore old $sp
       addi $sp,$sp,4 
       jr $ra


strcmp:
     addi $sp,$sp,-4
     sw $t0 0($sp)
     
     addi $t0,$0,0         # i=0
     add $t1,$t0,$t8       # pass argument a2 to $t1
     add $t2,$t0,$t6       # pass argument a3 to $t2
     
L6:  lb $t3,($t1)  #load a byte from each string
     lb $t4,($t2)
     beqz $t3,T4Check #str1 end
     beqz $t4,missmatch
     subu $t5,$t3,$t4  #compare two bytes
     bnez $t5,missmatch
     addi $t0,$t0,1  #t1 points to the next byte of str1
     j L6
     
missmatch: 
     addi $v0,$0,1
     j finish2
T4Check:
     bnez $t4,missmatch
     addi $v0,$0,0     
finish2:
     lw $t0,0($sp)        # restore old $sp
     addi $sp,$sp,4 
     jr $ra

strcpy:
     addi $sp,$sp,-4
     sw $t0,0($sp)
     
     addi $t0,$0,0        # i=0
L1:  add $t1,$t6,$t0      # address of y[i]
     lb $t2,($t1)         # load byte y[i] in $t2 
     add $t3,$t8,$t0      # similar address for x[i]
     sb $t2,($t3)        # store byte y[i] into x[i]
     addi $t0,$t0,1       # i++
     bne $t2,$0,L1        # if y[i]!=0 go to L1
     
     lw $t0,0($sp)        # restore old $s0
     addi $sp,$sp,4 
     jr $ra


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
     
#----------------------------------------------------------------------------------------------------------------------------
searchf: 	#args p in $a0, word in $a1, plen in $a2, wordLen in $a3
        addi $sp,$sp,-4
        sw $ra 0($sp)
        
            # read sentence
    la      $a0,msg                 # prompt
    la      $a1,100                 # length of buffer
    la      $a2,sentence                 # buffer address
    # prompt user
    li      $v0,4                   # syscall to print string
    syscall

    # get the string
    move    $a0,$a2                 # get buffer address
    li      $v0,8                   # read string input from user
    syscall

    # read scan word
    la      $a0,search                # prompt
    la      $a1,30                  # length of buffer
    la      $a2,input3               # buffer address
    # prompt user
    li      $v0,4                   # syscall to print string
    syscall

    # get the string
    move    $a0,$a2                 # get buffer address
    li      $v0,8                   # read string input from user
    syscall
	addi $s0, $0, 0 	#i=0
	addi $s1, $0, 0 	#j=0
	addi $s2, $0, 1 	#found = 1
loopI:
	slt $t0, $s0, $a2	#set to 1 if (i < plen)
	beq $t0, $0, loopIend 	#exit if equals 0 
	
	j loopJ
	loopJ:
		slt $t1, $s1, $a3 #set to 1 if (i < wordLen)
		beq $t1, $0, loopJend 	#exit if equals 0
		add $s3, $s0, $s1 	# i+j
		add $t1, $a0, $s3	#address of p[0] + (i+j)
		lbu $t2, 0($t1) 	#t2 = p[i+j]
		add $t3, $a1, $s1 	#address of word[0] + j
		lbu $t4, 0($t3) 	#t4 = word[j]
		beq $t2, $t4, endif 	#if $t2 == $t4 end if, else if not equal continue
		addi $s2, $0, 0 	#found = 0
	endif:
		addi $s1, $s1, 1 	#j++
		j loopJ
	loopJend:
		beq $s2, 1, printFound #if found == 1 print matches else print not
		li $v0, 4
		la $a0, found	
		syscall
		li $v0, 10
		syscall
		printFound:
			li $v0, 4
			la $a0, found	
			syscall
			lw $t0,0($sp)        # restore old $s0
                        addi $sp,$sp,4 
                        jr $ra
			
			j loopI 	#exit from loopJ to loopI
loopIend:
	lw $t0,0($sp)        # restore old $s0
        addi $sp,$sp,4 
        jr $ra
