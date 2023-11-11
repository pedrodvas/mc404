.data
.bss
buffer_puts: .skip 1
buffer_gets: .skip 1
.text

.globl recursive_tree_search
recursive_tree_search:
    #first checks the current node, then the leff,
    #then the right one

    #a0 = root address
    #a1 = value
    add a4, x0, x0
    addi a3, x0, 1  #a3 will be depth

    addi sp, sp, -4
    sw ra, 0(sp)
    jal recursion
    lw ra, 0(sp)
    addi sp, sp, 4

    addi a0, a3, 0
    debug_valor_final:
    beqz a4, not_found

    addi a0, a4, 0
    jalr x0, ra, 0

    not_found:
    add a0, x0, x0
    jalr x0, ra, 0
    

    recursion:
        #here a0 will point to the current node

        lw t0, 0(a0)
        beq t0, a1, return

        addi sp, sp, -4
        sw a0, 0(sp)    #original root stored
        lw a0, 4(a0)  #a0 = a0->left
        addi sp, sp, -4
        sw ra, 0(sp)    #stores return address
        addi a3, a3, 1  #changes the height of the tree
        beq x0, a0, skip_left   #skips the left when 
        #address is null
        jal recursion   #check left tree

        skip_left:
        addi a3, a3, -1
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4


        addi sp, sp, -4
        sw a0, 0(sp)
        lw a0, 8(a0)  #a0 = a0->right
        addi sp, sp, -4
        sw ra, 0(sp)
        addi a3, a3, 1#changes the height of the tree

        beq x0, a0, skip_right
        
        jal recursion

        skip_right:
        addi a3, a3, -1
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4
        

        jalr x0, ra, 0
    
        
    return:
        mv a4, a3
        jalr x0, ra, 0


.globl puts
puts:   #when this function is called a0 has the adress
        #of the string to be printed
    mv t6, a0
    loop_chari: #will iterate until it finds a \0
        lbu t0, 0(t6)   #loads first char in t0
        beq t0, x0, string_ends #if t0=0 -> string ended
        la t5, buffer_puts
        sb t0, 0(t5)    #otherwise saves char to be printed
        #command to print
        li a0, 1
        la a1, buffer_puts
        li a2, 1
        li a7, 64
        ecall
        #end of print
        addi t6, t6, 1
        bne t0, x0, loop_chari
    string_ends:
        li t0, 10
        sb t0, 0(t5)
        #will now print the \n
        li a0, 1
        la a1, buffer_puts
        li a2, 1
        li a7, 64
        ecall
        #end of print
    li a0, 0    #retorno de valor não negativo
    jalr x0, ra, 0


.globl gets
gets:   #when this function is called it will store
#the characters at the address until \n is found
    mv t0, a0
    mv t6, a0

    loop_read:
        li a0, 0
        la a1, buffer_gets
        li a2, 1
        li a7, 63
        ecall   #stores the read byte on memory

        la t2, buffer_gets
        lb t1, 0(t2)    #loads the stored byte
        
        addi t3, x0, 10 #t3='\n'
        beq t1, t3, ignore_enter#if char='\n' ends string

        sb t1, 0(t0)   #stores the char t1 on adress t0
        addi t0, t0, 1  #moves the memory position
        addi t3, x0, 10
        bne t1, t3, loop_read

    ignore_enter:
        li t1, 0
        sb t1, 0(t0)

    mv a0, t6
    jalr x0, ra, 0

.globl atoi
atoi:
    #a0 has the address
    addi t1, x0, 43 #ascii for '+'
    addi t2, x0, 45 #ascii for '-'
    addi t3, x0, 0
    add t0, x0, x0  #used for the value

    
    lb t0, 0(a0)
    beq t0, t2, 3f  #negative branch
    beq t0, t1, 1f
    beq x0, x0, 2f

    1:
        addi a0, a0, 1  #skips the '+'

    2:  #finds a + or a digit
        addi a1, x0, 1 #used to define the output sign

        lb t2, 0(a0)    #loads char

        addi t4, x0, 48 #checks lower limit for ascii
        blt t2, t4, 5f  
                        
        addi t4, x0, 58 #checks upper limit for ascii
        bge t2, t4, 5f

        #converts for ascii to number
        addi t2, t2, -48

        addi t4, x0, 10
        mul t3, t3, t4
        #t3 = t3*10
        add t3, t3, t2
        #t3 = t3 + digit found

        addi a0, a0, 1  #next digit

        beq x0, x0, 2b  #coes back to continue
        #the computation of the number

    3:  #finds a -
        addi a0, a0, 1  #skips the -
        addi a1, x0, -1 #defines the output sign
    4:
        lb t2, 0(a0)

        addi t4, x0, 48 #checks lower limit for ascii
        blt t2, t4, 5f

        addi t4, x0, 58 #checks upper limit for ascii
        bge t2, t4, 5f

        #converts for ascii to number
        addi t2, t2, -48

        addi t4, x0, 10
        mul t3, t3, t4
        #t3 = t3*10

        add t3, t3, t2
        #t3 = t3 + digit found

        addi a0, a0, 1  #next digit

        beq x0, x0, 4b  #coes back to continue
        #the computation of the number


    5:  #end of the function
        mul t3, t3, a1  #abs value * signal
        mv a0, t3
    
    fim:
    jalr x0, ra, 0
    
.globl itoa
itoa:
    #a0 = value
    #a1 = string address
    #a2 = base

    mv a3, a1

    add a4, x0, 0   #if printing has begun


    addi t0, x0, 10
    beq a2, t0, decimal

    addi t0, x0, 16
    beq a2, t0, hexadecimal

    decimal:
        bge a0, x0, value
        blt a0, x0, negative

        negative:
            addi a1, x0, -1 #*-1 if negative
            mul a0, a0, a1  #makes a0 positive
            addi t0, x0, 45 #ascii for '-'
            sb t0, 0(a1)    #char[0] = '-'
            addi a1, a1, 1 
        
        value:
            li t0, 1000
            remu t1, a0, t0
            #will have the lesser digits
            sub t2, a0, t1
            #t2 will have the biggest digit
            #multiplied by 1000
            div t3, t2, t0
            #t3 has digit*1

            beq t3, x0, 1f

            addi a4, a4, 1
            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1

            1:
            sub a0, a0, t2



            li t0, 100
            remu t1, a0, t0
            sub t2, a0, t1
            div t3, t2, t0

            bnez a4, 2f #if printing begun
            beqz t3, 3f
            2:
            addi a4, x0, 1
            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
            3:
            sub a0, a0, t2



            li t0, 10
            remu t1, a0, t0
            sub t2, a0, t1
            div t3, t2, t0

            bnez a4, 2f #if printing begun
            beqz t3, 3f
            2:
            addi a4, x0, 1
            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
            3:
            sub a0, a0, t2



            li t0, 1
            remu t1, a0, t0
            sub t2, a0, t1
            div t3, t2, t0


            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
            sub a0, a0, t2

            sb x0, 0(a1) #terminates with null
    
    mv a0, a3   #return the string pointer
    jalr x0, ra, 0


    hexadecimal:
        addi t0, x0, 1
        slli t0, t0, 12 #4096=0x1000 

        remu t1, a0, t0
        sub t2, a0, t1
        div t3, t2, t0
        #t3 has digit
        addi t4, x0, 10
        blt t3, t4, 1f
        bge t3, t4, 2f

        1: #for d<10
        addi t5, t3, 48
        beq x0, x0, 3f

        2: #for d>10
        addi t5, t3, 87
        beq x0, x0, 3f

        3:
        sb t5, 0(a1)
        addi a1, a1, 1


        srai t0, t0, 4

        remu t1, a0, t0
        sub t2, a0, t1
        div t3, t2, t0
        addi t4, x0, 10
        blt t3, t4, 1f
        bge t3, t4, 2f

        1: #for d<10
        addi t5, t3, 48
        beq x0, x0, 3f
        2: #for d>10
        addi t5, t3, 87
        beq x0, x0, 3f

        3:
        sb t5, 0(a1)
        addi a1, a1, 1


        srai t0, t0, 4

        remu t1, a0, t0
        sub t2, a0, t1
        div t3, t2, t0
        addi t4, x0, 10
        blt t3, t4, 1f
        bge t3, t4, 2f

        1: #for d<10
        addi t5, t3, 48
        beq x0, x0, 3f
        2: #for d>10
        addi t5, t3, 87
        beq x0, x0, 3f

        3:
        sb t5, 0(a1)
        addi a1, a1, 1

        srai t0, t0, 4

        remu t1, a0, t0
        sub t2, a0, t1
        div t3, t2, t0
        addi t4, x0, 10
        blt t3, t4, 1f
        bge t3, t4, 2f

        1: #for d<10
        addi t5, t3, 48
        beq x0, x0, 3f
        2: #for d>10
        addi t5, t3, 87
        beq x0, x0, 3f

        3:
        sb t5, 0(a1)
        addi a1, a1, 1

    mv a0, a3   #return the string pointer
    jalr x0, ra, 0

.globl exit
exit:
    addi a7, x0, 93
    ecall