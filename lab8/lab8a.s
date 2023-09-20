/*
ecalls
2200 = set pixel
2201 = set size
2202 = set scaling
*/
.data
input_file: .asciz "image.pgm"

.bss

.text
.globl _start
start:
    jal open_image
    jal end


set_size:
    li a0, 512
    li a1, 512
    li a7, 2201          # syscall open 
    ecall
    jalr x0, ra, 0

set_scaling:
    li a0, 10
    li a1, 10
    li a7, 2202       # syscall open 
    ecall
    jalr x0, ra, 0


open_image:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    jalr x0, ra, 0

end: