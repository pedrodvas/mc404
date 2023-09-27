/*
Image opener:
-the image will be opened using open_image, then the file 
descriptor will be a0
-the read function will be used to store 10 bytes in 
image buffer
-each byte is byte=R=G=B, and alpha=255,
-knowing that all images are 10x10, we know that10n+m 
will have coordinates [n,m] (n=vertical...)
-using that the set pixel will be used with the info
from each byte + [n,m]
*/

.data
input_file: .asciz "image.pgm"
.bss
image_buffer: .skip 10
.text
.globl _start
_start:
    la a0, input_file


    li a0, 511
    li a1, 511
    jal set_canvas_size

    li a0, 255
    li a1, 255
    li a2, 511
    jal set_pixel
    li a0, 254
    li a1, 255
    li a2, 511
    jal set_pixel
    jal exit

read: #(file_descriptor=a0, buffer=a1, digits=a2)
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

set_pixel: #(x=a0, y=a1, color=a2)
    li a7, 2200
    ecall
    jalr x0, ra, 0

set_canvas_size: #(a0=width, a1=height); [0,512]
    li a7, 2201 
    ecall
    jalr x0, ra, 0

set_scaling: #(a0=horizontal, a1=vertical)
    li a7, 2202       # syscall open 
    ecall
    jalr x0, ra, 0


open_image: #(a0=adress for file)
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    jalr x0, ra, 0

exit: