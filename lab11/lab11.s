.data
.bss
.text
.set BASE_ADDRESS,   0xFFFF0100  #base address for controlling the car
.set COORDINATES,    0xFFFF0100  #address for turning on gps
.set X_COORD,        0xFFFF0104  #x coordinate
.set Y_COORD,        0xFFFF0108  #y coordinate
.set Z_COORD,        0xFFFF010C  #z coordinate
.set STEERING_WHELL, 0XFFFF0120  #-127=left full, 127=right full
.set ENGINE,         0xFFFF0121  #-1=back, 0=off, 1=front
.set BRAKES,         0xFFFF0122  #1=break on

#test begins at x=73, y=1, z=-19
#reached the destination when distance < 15 meters
#destination = (86, 2, -17)
.globl _start
_start:
    
    addi t0, x0, -15
    li t1, STEERING_WHELL
    sw t0, 0(t1)    #sets steering wheel to left

    addi t0, x0, 1
    li t1, ENGINE
    sw t0, 0(t1)
    
    1:
    add x0, x0, x0
    beq x0, x0, 1b
    /*
    debug_check_pos:
    1:
    li t0, 1
    li t1, COORDINATES
    sw t0, 0(t1)    #turns on the gps

    2:

    lw t0, 0(t1)
    bnez t0, 2b #while t0 isn't zero stays on loop


    3:

    li t1, X_COORD
    lw t2, 0(t1)
    li t1, Y_COORD
    lw t3, 0(t1)
    li t1, Z_COORD
    lw t4, 0(t1)

    debug_pos_ready:

    addi t2, t2, -86  #distance until target
    addi t3, t3, -2
    addi t4, t4, 17

    mul t2, t2, t2  #pithagorean theorem
    mul t3, t3, t3
    mul t4, t4, t4
    add t2, t2, t3
    add t2, t2, t4

    addi t5, x0, 225
    blt t2, t5, para
    j 1b

    para:
    li t0, 0
    li t1, ENGINE
    sw t0, 0(t1)

    li t0, 1
    li t1, BRAKES
    sw t0, 0(t1)
    */


.globl exit
exit:
    addi a7, x0, 93
    ecall