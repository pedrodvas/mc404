.data
.bss
.text
.set set_write,   0xffff0100  #=1 then write byte, 0 when finished
.set write_byte,  0xffff0101  #has the byte to be written]
.set set_read,    0xffff0102  #=1 then starts reading
.set read_byte,   0xffff0103  #has the written byte

.globl _start
_start:


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
    mv a1, t1

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
    1:

    addi t1, t1, -48
    li t0, 10
    mul a2, a2, t0
    add a2, a2, t1
    j read_sec_num

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
    li t0, 10000000
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



    li t0, 1000000
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



    li t0, 100000
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



    li t0, 10000
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



    li t0, 1000
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
    
    
    li t0, 100
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



    li t0, 10
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
    


    li t0, 1
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