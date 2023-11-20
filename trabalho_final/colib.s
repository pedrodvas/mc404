.bss
buffer_puts: .skip 1
.text


.globl set_engine
set_engine:
    #a0 movement direction //vertical
    #a1 movement angle //horizontal
    li a7, 10
    ecall
    jalr x0, ra, 0


.globl set_handbrake
set_handbrake:
    #a0 condition if brake will be activated
    #1 yes and 0 no // value

    li t0, 0
    blt a0, t0, 1f  #a0<0 --> error
    li t0, 1
    blt t0, a0, 1f  #1<a0 --> error
    
    #didn't branch --> ok parameter
    li a7, 11
    ecall
    li a0, 0    #success
    jalr x0, ra, 0

    1:
    li a0, -1   #error occurred
    jalr x0, ra, 0


.globl read_sensor_distance
read_sensor_distance:
    li a7, 13
    ecall
    jalr x0, ra, 0


.globl get_position
get_position:
    li a7, 15
    ecall
    jalr x0, ra, 0


.globl get_rotation
get_rotation:
    li a7, 16
    ecall
    jalr x0, ra, 0


.globl get_time
get_time:
    li a7, 20
    ecall
    jalr x0, ra, 0


.globl puts
puts:   #when this function is called a0 has the adress
        #of the string to be printed
    loop_chari: #will iterate until it finds a \0
        lbu t0, 0(a0)   #loads first char in t0
        beq t0, x0, string_ends #if t0=0 -> string ended
        
        #a0 already has address of char
        li a1, 1    #prints 1 char at a time
        li a7, 18
        ecall

        #end of print
        addi a0, a0, 1
        bne t0, x0, loop_chari

    string_ends:
        li t0, 10
        la a0, buffer_puts
        sb t0, 0(a0)   #has the address of \n
                #to be used on write syscall
        li a1, 1
        li a7, 18 
        ecall
        #end of print
    li a0, 0    #retorno de valor não negativo
    jalr x0, ra, 0


.globl gets
gets:   #when this function is called it will store
#the characters at the address until \n is found
    mv t6, a0

    loop_read:
        #a0 already has the address
        li a1, 1
        li a7, 17
        ecall   #stores the read byte on a0

        lb t1, 0(a0)    #loads the stored byte
        
        addi t3, x0, 10 #t3='\n'
        beq t1, t3, ignore_enter #if char='\n' ends string


        addi a0, a0, 1  #moves the memory position

        j loop_read

    ignore_enter:
        li t1, 0
        sb t1, 0(a0)

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
    beq t0, t1, 1f  #starts with '+'
    beq x0, x0, 2f  #starts with number

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


.globl strlen_custom
strlen_custom:
    #a0 address for string
    #returns int size of string
    addi t0, x0, 0
    4:
        lb t1, 0(a0)
        beq t1, x0, 5f
        #_if not null

        addi t0, t0, 1  #n_chars++
        addi a0, a0, 1  #next mem pos    
    5:
    mv a0, t0
    jalr x0, ra, 0


.globl approx_sqrt
approx_sqrt:
    #a0 value
    #a1 number of iterations
    #returns approximate sqrt(value)

    srai t0, a0, 1  #value/2

    1:
    bne a1, x0, 2f

    divu t1, a0, t0 #t1 = value/(guessN)
    add t2, t1, t0 #t2 = t1 + (guessN) = value/(guessN) + guessN
    srai t0, t2, 1 #guessN+1 = t2/2 = (value/(guessN)+guessN)/2

    addi a1, a1, -1 #1 less iteration left
    2:

    mv a0, t0
    jalr x0, ra, 0


.globl get_distance
get_distance:
    #a0 start x
    #a1 start y
    #a2 start z
    #a3 end x
    #a4 end y
    #a5 end z

    sub a0, a0, a3
    sub a1, a1, a4
    sub a2, a2, a5

    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2

    #dx², dy², dz²

    add a0, a0, a1
    add a0, a0, a2
    #sum of all squares

    li a1, 15
    addi sp, sp, -4
    sw ra, 0(sp)
    jal approx_sqrt #square root of a0, 15 iterations
    lw ra, 0(sp)
    addi sp, sp, 4


    #returns the distance after square root is used
    jalr x0, ra, 0

.globl fill_and_pop
fill_and_pop:
    #a0 head node address
    #a1 fill node address

    #will copy the parameters from a0 to a1
    #returns the address of head->next = a0->next
    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)
    lw t4, 16(a0)
    lw t5, 20(a0)
    lw t6, 24(a0)


    sw t0, 0(a1)
    sw t1, 4(a1)
    sw t2, 8(a1)
    sw t3, 12(a1)
    sw t4, 16(a1)
    sw t5, 20(a1)
    sw t6, 24(a1)

    #copies until Action action

    lw t0, 28(a0)
    sw t0, 28(a1)
    #Node* next copied

    lw a0, 28(a0) #a0 = a0->next
    jalr x0, ra, 0