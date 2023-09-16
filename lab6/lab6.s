/*
program plan:
After receiving the 4x(4byte) inputs, the program will tranfer the value from each input into a register,
register_temporary = b0*1000; register0 = r0 + rt
register_temporary = b1*100; register0 = r0 + rt
register_temporary = b2*10; register0 = r0 + rt
register_temporary = b3*1; register0 = r0 + rt
*/
.data
string:  .asciz "Hello! It works!!!\n"

.bss
input_address: .skip 20 # 20 byte buffer for the input
                        # AAAA BBBB CCCC DDDD
output_address: .skip 20#same format for the input

.text
.globl start

start:
    jal main

main:
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
