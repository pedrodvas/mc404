.data
.bss
.text
.set set_write,   0xffff0100  #=1 then write byte, 0 when finished
.set write_byte,  0xffff0101  #has the byte to be written]
.set set_read,    0xffff0102  #=1 then starts reading
.set read_byte,   0xffff0103  #has the written byte

.globl _start
_start:

dec_to_hex:
/*
    addi a0, x0, 0
    addi t5, x0, 1
    read_dec:
    li t0, set_read
    li t1, 1
    sb t1, 0(t0)    #read = on
    1:
        lb t1, 0(t0)
        bnez t1, 1b     #repeatedly reads until read=off
    
    li t0, read_byte
    lb t1, 0(t0)
    
    li t2, 10   #if '\n' is found the number ended
    beq t1, t2, 2f

    li t2, 45
    bne t1, t2, 1f
    li t5, -1
    j read_dec    #if '-' is the char starts reading the next one
                        #after storing that n<0
    1:

    addi t1, t1, -48
    li t0, 10
    mul a0, a0, t0
    add a0, a0, t1
    
    j read_dec

    mul a0, a0, t5

    2:
    */



    srli t0, a0, 28
    mv t3, t0

    li t1, 0xfffffff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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


    srli t0, a0, 24
    mv t3, t0

    li t1, 0xffffff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:

    

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



    srli t0, a0, 20
    mv t3, t0

    li t1, 0xfffff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:

    

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


    srli t0, a0, 16
    mv t3, t0

    li t1, 0xffff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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



    srli t0, a0, 12
    mv t3, t0

    li t1, 0xfff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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



    srli t0, a0, 8
    mv t3, t0

    li t1, 0xff
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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


    srli t0, a0, 4
    mv t3, t0

    li t1, 0xf
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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



    srli t0, a0, 0
    mv t3, t0

    li t1, 0x1
    and a0, a0, t1

    addi t3, t3, 48

    li t4, 58
    blt t3, t4, 1f
        addi t3, t3, 7
    1:


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
    #writes the \n below

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

