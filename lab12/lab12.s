.data
.bss
.text
.set set_write,   0xffff0100  #=1 then write byte, 0 when finished
.set write_byte,  0xffff0101  #has the byte to be written]
.set set_read,    0xffff0102  #=1 then starts reading
.set read_byte,   0xffff0103  #has the written byte

.globl _start
_start:
    jal read_op
    
    li t1, 1
    li t2, 2
    li t3, 3
    li t4, 4

    beq a0, t1, 1f
    
    beq a0, t2, 2f
    
    beq a0, t3, 3f
    
    beq a0, t4, 4f
    

    1:
        jal repeat_string
        j exit
        
    2:
        jal reverse_string
        j exit
    
    3:
        jal dec_to_hex
        j exit
    
    4:
        jal algebra
        j exit
    

algebra:
    addi a0, x0, 0
    addi a2, x0, 0
    li t5, 1
    li t6, 1

    read_first_num:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    
    li t0, read_byte
    lb t1, 0(t0)
    
    li t2, 32   #if ' ' is found the number ended
    beq t1, t2, 2f

    li t2, 45
    bne t1, t2, 1f
    li t5, -1
    j read_first_num    #if '-' is the char starts reading the next one
                        #after storing that n<0
    1:

    addi t1, t1, -48
    li t0, 10
    mul a0, a0, t0
    add a0, a0, t1
    
    j read_first_num
    2:

    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    li t0, read_byte
    lb t1, 0(t0)
    mv a1, t1
    
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    li t0, read_byte
    lb t1, 0(t0)


    read_sec_num:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    
    li t0, read_byte
    lb t1, 0(t0)
    
    li t2, 10   #if \n is found the number ended
    beq t1, t2, 2f

    li t2, 45
    bne t1, t2, 1f
    li t6, -1
    j read_sec_num
    1:

    addi t1, t1, -48
    li t0, 10
    mul a2, a2, t0
    add a2, a2, t1
    j read_sec_num

    2:

    mul a0, a0, t5
    mul a2, a2, t6
    #corrects the sign
    

    li t0, 43  #+
    li t1, 42  #*
    li t2, 45  #-
    li t3, 47  #/

    beq a1, t0, 1f
    beq a1, t1, 2f
    beq a1, t2, 3f
    beq a1, t3, 4f

    1:
    add a0, a0, a2
    j print_result
    2:
    mul a0, a0, a2
    j print_result
    3:
    sub a0, a0, a2
    j print_result
    4:
    div a0, a0, a2
    j print_result

    print_result:


    bge a0, x0, 2f  #checks if printing '-' is necessary
    li t0, write_byte
    li t1, 45
    sb t1, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    li t1, -1
    mul a0, a0, t1
    
    2:

    addi a1, x0, 0  #checks if printing has begun


    li t0, 10000000
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:


    li t0, 1000000
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t0, 100000
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t0, 10000
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t0, 1000
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t0, 100
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t0, 10
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:


    li t0, 1
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    bne a1, x0, 2f  #if printing begun prints any number
    li t4, 48
    beq t3, t4, 3f  #otherwise if n = '0' skips

        2:
        addi a1, a1, 1
        li t0, write_byte
        sb t3, 0(t0)
        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b

    3:

    li t1, 10
    li t0, write_byte
    sb t1, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    jalr x0, ra, 0

dec_to_hex:
    addi a0, x0, 0
    value_loop:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    
    li t0, read_byte
    lb t1, 0(t0)

    li t2, 10
    beq t1, t2, 2f
    #while char !=\n continues reading

    addi t1, t1, -48
    li t3, 10
    mul a0, a0, t3
    add a0, a0, t1
    j value_loop

    2:
    #a0 has value
    li t0, 256
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    li t0, write_byte
    sb t3, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    
    li t0, 16
    rem t1, a0, t0
    sub t2, a0, t1
    div t3, t2, t0
    addi t3, t3, 48

    sub a0, a0, t2

    li t0, write_byte
    sb t3, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b
    
    
    addi a0, a0, 48
    li t0, write_byte
    sb a0, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    
    li t1, 10
    li t0, write_byte
    sb t1, 0(t0)
    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    jalr x0, ra, 0

reverse_string:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal string_recursion
    lw ra, 0(sp)
    addi sp, sp, 4


    li t0, write_byte
    li t1, 10
    sb t1, 0(t0)

    li t0, set_write
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #waits until char is written
    
    jalr x0, ra, 0

    string_recursion:
        li t0, set_read
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bnez t1, 1b 
        
        li t0, read_byte
        lb a0, 0(t0)
        #a0 has char to be written
        li t2, 10
        beq a0, t2, 3f  #if not \n, then continues with
                #recursive calls to invert the string

        addi sp, sp, -4
        sw a0, 0(sp)
        addi sp, sp, -4
        sw ra, 0(sp)
        jal string_recursion
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4


        li t0, write_byte
        sb a0, 0(t0)    

        li t0, set_write
        li t1, 1
        sb t1, 0(t0)
        2:
            lb t1, 0(t0)
            bnez t1, 2b
        3:
        debug_string_ends:
        jalr x0, ra, 0


repeat_string:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until a char is stored

    li t0, read_byte
    lb t1, 0(t0)        #moves the char from read position
    li t0, write_byte   #to write position
    sb t1, 0(t0)

    mv t2, t1   #will be used to check for \n later

    li t0, set_write
    li t1, 1
    sb t1, 0(t0)    #write = on
    2:
        lb t1, 0(t0)
        bnez t1, 2b #stays on loop until write=off

    li t3, 10
    beq t2, t3, 3f  #if c=\n ends function

    j repeat_string


    3:
    debug:
    jalr x0, ra, 0


read_op:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    
    li t0, read_byte
    lb t1, 0(t0)
    mv a0, t1
    addi a0, a0, -48


    li t0, set_read
    li t1, 1
    sb t1, 0(t0)
    1:              
        lb t1, 0(t0)    
        bnez t1, 1b

    jalr x0, ra, 0

.globl exit
exit:
    addi a7, x0, 93
    ecall