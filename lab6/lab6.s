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
s3 = stores how many bytes from the input were read
a0 = stores the value from each byte
a1 = stores the input before the square root
a2 = stores the value after each iteration from babylonian method
*/
.data
string:  .asciz "Hello! It works!!!\n"

.bss
input_address: .skip 20 # 20 byte buffer for the input
                        # AAAA BBBB CCCC DDDD
input_value: .skip 20
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
    jal read
    jal write_input

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

write_input:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, input_address       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

write_padrao:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall    

ascii_to_value:
    lbu t0, 0(s0)
    addi t0, t0, -48
    #parou aqui na hora de implementar a função de ascii->valor

input_to_register:  #will take each four byte input and move to a register
    lbu t0, 0(s0)
    addi t1, x0, 1000
    