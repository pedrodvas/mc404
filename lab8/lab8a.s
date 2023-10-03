/*
Image opener:
-the image will be opened using open_image, then the file 
descriptor will be a0
-Instructions below will be done for each line
-the read function will be used to store 10 bytes in 
image buffer
-each byte is byte=R=G=B, and alpha=255,
-knowing that all images are 10x10, we know that 10n+m 
will have coordinates [n,m] (n=vertical...)
-using that the set pixel will be used with the info
from each byte + [n,m]
*/
/*
s0: adress for buffer
s1: file descriptor
s2: bytes written
s3: constant for the iteration
*/
.data
input_file: .asciz "image.pgm"
.bss
buffer: .skip 10
file_header: .skip 12
.text
.globl _start
_start:
    la s0, buffer
    la a0, input_file
    jal open_image  #a0 = file descriptor
    d_guarda_fd:
    mv s1, a0       #s1 = file descriptor

    li a0, 10
    li a1, 10
    jal set_canvas_size #all images are assumed to be 10x10
    #so looking into the header won't be necessary

    mv a0, s1
    jal skip_header

    li s2, 0    #counts the written pixels
    li s3, 100
/*repeat 10 times*/
line_iterator:
    mv a0, s1   
    la a1, buffer
    li a2, 10
    jal read
    jal check_memory
    jal set_line
    addi s2, s2, 10
    bltu s2, s3, line_iterator #while s2<100 repeat 

    jal exit

set_line:   #this label will write a complete line
    li t0, 10
    divu a1, s2, t0 #a1 = s2/t0 = s2/10 = height

    sb t0, 0(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  #color bytes now written
    or a2, t0, 255  #alpha corrected
    li a0, 0

    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #-------

    sb t0, 1(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 1    #x coordinate

    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4
    
    #--------

    sb t0, 2(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 2    #x coordinate

    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4
    
    #--------

    sb t0, 3(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 3    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #-------
    
    sb t0, 4(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 4    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #-------
    
    sb t0, 5(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 5    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #--------
    
    sb t0, 6(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 6    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #---------
    
    sb t0, 7(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 7    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #--------
    
    sb t0, 8(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 8    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4

    #--------
    
    sb t0, 9(s0)
    slli t1, t0, 8
    slli t2, t0, 16
    slli t3, t0, 24
    add t0, t1, t2
    add t0, t0, t3  
    or a2, t0, 255  
    li a0, 9    #x coordinate
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal set_pixel
    lw ra, 0(sp)
    addi sp, sp, 4


    jalr x0, ra, 0

skip_header:
    la a1, file_header
    li a2, 12
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

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

check_memory:
    sb t0, 0(s0)
    sb t0, 1(s0)
    sb t0, 2(s0)
    sb t0, 3(s0)
    sb t0, 4(s0)
    sb t0, 5(s0)
    sb t0, 6(s0)
    sb t0, 7(s0)
    sb t0, 8(s0)
    sb t0, 9(s0)

    jalr x0, ra, 0

exit: