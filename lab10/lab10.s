#implementation of different functions 
#passed by the exercise
.data

.bss
buffer_puts: .skip 1
buffer_gets: .skip 1
.text
.globl _start
_start:





puts:   #when this function is called a0 has the adress
        #of the string to be printed
    mv t6, a0
    loop_chari: #will iterate until it finds a \0
        lbu t0, 0(t6)
        beq t0, x0, string_ends
        sb t0, 0(t6)
        addi t6, t6, 1
        #command to print
        li a0, 1
        la a1, buffer_puts
        li a2, 1
        li a7, 64
        ecall
        #end of print
        bne t0, x0, loop_chari
    string_ends:
        li t0, 10
        sb t0, 0(t6)
        #will now print the \n
        li a0, 1
        la a1, buffer_puts
        li a2, 1
        li a7, 64
        ecall
        #end of print
    li a0, 0    #retorno de valor não negativo
    jalr x0, ra, 0

gets:   #when this function is called it will store
#the characters at the address until \n is found
    mv t0, a0
    mv t6, a0

    loop_read:
        li a0, 0
        la a1, buffer_gets
        li a2, 1
        li a7, 64
        ecall

        la t2, buffer_gets
        lb t1, 0(t2)    #loads the stored byte
        
        beq t1, 10, ignore_enter

        sb t1, t0   #stores the char t1 on adress t0
        addi t0, t0, 1  #moves the memory position
        bne t1, 10, loop_read

    ignore_enter:
        addi t0, t0, 1
        li t1, 0
        sb t1, 0(t0)


    jalr x0, ra, 0


atoi:
    #a0 has the address
    addi t1, x0, 43 #ascii for '+'
    addi t2, x0, 45 #ascii for '-'
    add t0, x0, x0  #used for the value

    1:  #goes until it finds the specified chars
        #this part is incomplete
        lb t0, a0
        addi a0, a0, 1
        beq t0, t1, 2f
        beq t0, t2, 3f

    2:  #finds a + or a digit
        addi a1, x0, -1 #used to define the output sign

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
    

itoa:
    #a0 = value
    #a1 = string address
    #a2 = base

    mv a3, a1

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

            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
            sub a0, a0, t2



            li t0, 100
            remu t1, a0, t0
            sub t2, a0, t1
            div t3, t2, t0

            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
            sub a0, a0, t2



            li t0, 10
            remu t1, a0, t0
            sub t2, a0, t1
            div t3, t2, t0

            addi t4, t3, 48
            sb t4, 0(a1)
            addi a1, a1, 1
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

    hexadecimal:
        addi t0, x0, 1
        slli t0, t0, 12 #4096=0x1000 


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, buffer do write       # buffer
    li a2, 2           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, buffer do read #  buffer to write the data
    li a2, 20  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

exit:
    addi a7, x0, 93
    ecall