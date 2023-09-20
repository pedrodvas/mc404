/*
program plan:
    After receiving the 4x(4byte) inputs, 
the program will tranfer the value from each input into a register, one at a time,
converting from ascii into value
register_temporary = b0*1000; register0 = r0 + rt
register_temporary = b1*100; register0 = r0 + rt
register_temporary = b2*10; register0 = r0 + rt
register_temporary = b3*1; register0 = r0 + rt
    after that the square root will be calculated 
using the babylonian method iterating 10 times
    and then the value from the register will be transfered to the output adress
by taking the remainder from 1 to 100 and storing each result in one byte for
the output address
*/
/*
registers:
ra = stores the address for jalr
t0 = used to store each byte from the input
t1 = stores the power of 10 that will multiply t0
t2 = result of multiplication, then its added into a1
s0 = will store the address from the input_ascii
s1 = will store the adress from the output
s2 = address from input_values
s3 = debug adress
a0 = stores the value from each byte
a1 = stores the input before the square root
a2 = stores the value after the babylonian method
a3 = adress from current input
a4 = adress from current output
*/
.data
input_address: .asciz "0016 0025 0036 0049\n"

.bss
 # 20 byte buffer for the input
                        # AAAA BBBB CCCC DDDD
input_value: .skip 20
string:  .skip 20
to_print_register: .skip 5
output_address: .skip 20#same format for the input

.text
.globl start

start:
    jal main

main:
    add a0, x0, x0  #clears the register that stores bytes read
    la s0, input_address
    la s1, output_address
    la s2, input_value
    la s3, to_print_register
    jal read
    jal ascii_to_value

    #a1 will be the value for input on the babylonian method
    #a2 will be the square root
    #a3 current input
    #a4 current output
    mv a3, s2
    mv a4, s1
    jal input_to_register
    jal babylonian_root
    jal a2_to_output_adress

    parada1:

    addi a3, a3, 5
    addi a4, a4, 5
    jal input_to_register
    jal babylonian_root
    jal a2_to_output_adress

    parada2:

    addi a3, a3, 5
    addi a4, a4, 5
    jal input_to_register
    jal babylonian_root
    jal a2_to_output_adress

    parada3:

    addi a3, a3, 5
    addi a4, a4, 5
    jal input_to_register
    jal babylonian_root
    jal a2_to_output_adress

    parada4:

    addi t0, x0, 10
    sb t0, 19(s1)

    jal write_output

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

write_output:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_address       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

write_input_adress:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, input_address       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0


ascii_to_value: #converts the char input to its int value
    lbu t0, 0(s0)
    addi t0, t0, -48
    sb t0, 0(s2)
    lbu t0, 1(s0)
    addi t0, t0, -48
    sb t0, 1(s2)
    lbu t0, 2(s0)
    addi t0, t0, -48
    sb t0, 2(s2)
    lbu t0, 3(s0)
    addi t0, t0, -48
    sb t0, 3(s2)

    lbu t0, 5(s0)
    addi t0, t0, -48
    sb t0, 5(s2)
    lbu t0, 6(s0)
    addi t0, t0, -48
    sb t0, 6(s2)
    lbu t0, 7(s0)
    addi t0, t0, -48
    sb t0, 7(s2)
    lbu t0, 8(s0)
    addi t0, t0, -48
    sb t0, 8(s2)

    lbu t0, 10(s0)
    addi t0, t0, -48
    sb t0, 10(s2)
    lbu t0, 11(s0)
    addi t0, t0, -48
    sb t0, 11(s2)
    lbu t0, 12(s0)
    addi t0, t0, -48
    sb t0, 12(s2)
    lbu t0, 13(s0)
    addi t0, t0, -48
    sb t0, 13(s2)

    lbu t0, 15(s0)
    addi t0, t0, -48
    sb t0, 15(s2)
    lbu t0, 16(s0)
    addi t0, t0, -48
    sb t0, 16(s2)
    lbu t0, 17(s0)
    addi t0, t0, -48
    sb t0, 17(s2)
    lbu t0, 18(s0)
    addi t0, t0, -48
    sb t0, 18(s2)
    
    jalr x0, ra, 0


input_to_register:  #will take each four byte input and move to a register
    
    addi a1, x0, 0  #sets a1 to 0
    
    lbu t0, 0(a3)
    addi t1, x0, 1000   #sets t1 to 1000
    mul t2, t1, t0  #multiplies the first digit by 1000
    add a1, a1, t2 #and adds to a1

    lbu t0, 1(a3)
    addi t1, x0, 100    #sets t1 to 100
    mul t2, t1, t0  #multiplies the second digit by 100
    add a1, a1, t2 #and adds to a1

    lbu t0, 2(a3)
    addi t1, x0, 10
    mul t2, t1, t0  #multiplies the third digit by 10
    add a1, a1, t2 #and adds to a1

    lbu t0, 3(a3)
    addi t1, x0, 1
    mul t2, t1, t0  #multiplies the first digit by 1
    add a1, a1, t2 #and adds to a1

    jalr x0, ra, 0

babylonian_root:

    srai t0, a1, 1 #initial guess

    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1
    
    divu t1, a1, t0
    add t2, t1, t0
    srai t0, t2, 1

    mv a2, t0

    jalr x0, ra, 0

a2_to_output_adress:

    addi t0, x0, 32
    sb t0, 4(a4)    #char space

    mv t1, a2
    addi t2, x0, 10 #parameter 10 for the division

    remu t0, t1, t2
    addi t3, t0, 48
    sb t3, 3(a4)
    sub t1, t1, t0
    divu t1, t1, t2

    remu t0, t1, t2
    addi t3, t0, 48
    sb t3, 2(a4)
    sub t1, t1, t0
    divu t1, t1, t2

    remu t0, t1, t2
    addi t3, t0, 48
    sb t3, 1(a4)
    sub t1, t1, t0
    divu t1, t1, t2

    remu t0, t1, t2
    addi t3, t0, 48
    sb t3, 0(a4)
    
    
    jalr x0, ra, 0