.bss
isr_stack: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
isr_stack_end: # Base da pilha das ISRs
.text
.set GPT_BASE,        0xFFFF0100
.set SET_GPT,         0xFFFF0100  #=1 starts reading time
.set LAST_TIME,       0xFFFF0104  #miliseconds of last reading
.set SET_INTERRUPT,   0xFFFF0108  #interrupt after n milis

.set CAR_BASE,        0xFFFF0300  #base address for controlling the car
.set SET_GPS,         0xFFFF0300  #=1 starts gps
.set COORDINATES,     0xFFFF0300  #address for turning on gps
.set SET_LINE_CAMERA, 0xFFFF0301  #=1 starts taking pic, 0 over
.set SET_ULTRASONIC,  0xFFFF0302  #=1 starts reading distance
.set X_ANGLE,         0xFFFF0304  #x angle
.set Y_ANGLE,         0xFFFF0308  #y angle
.set Z_ANGLE,         0xFFFF030c  #z angle
.set X_COORD,         0xFFFF0310  #x coordinate
.set Y_COORD,         0xFFFF0314  #y coordinate
.set Z_COORD,         0xFFFF0318  #z coordinate
.set ULTRA_DISTANCE,  0xFFFF031C  #distance [cm] nearest obstacle
.set STEERING_WHELL,  0xFFFF0320  #-127=left full, 127=right full
.set ENGINE,          0xFFFF0321  #-1=back, 0=off, 1=front
.set BRAKES,          0xFFFF0322  #1=break on
.set LINE_CAMERA,     0xFFFF0324  #256*byte array for image

.set SERIAL_BASE,     0xFFFF0500
.set SET_WRITE,       0xFFFF0500  #=1 writes, 0 complete
.set WRITE_BYTE,      0xFFFF0501  #stores char to write
.set SET_READ,        0xFFFF0502  #=1 reads, 0 complete
.set READ_BYTE,       0xFFFF0503  #stores char read
.align 4

.globl _start
_start:
    li sp, 0x07FFFFFC


    la a0, isr_stack_end
    csrw mscratch, a0

    # Allow external interruptions
    csrr t1, mie # Set bit 11 (MEIE)
    li t2, 0x800
    or t1, t1, t2
    csrw mie, t1

    # Allow global interruptions
    csrr t1, mstatus # Set bit 3 (MIE)
    ori t1, t1, 0x8
    csrw mstatus, t1

    la a0, int_handler 
    csrw mtvec, a0      

    # Change to user mode
    jal user_main
    jal main

    ret


user_main:
    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;

int_handler:
    ###### Syscall and Interrupts handler ######

    csrrw sp, mscratch, sp
    addi sp, sp, -60
    sw a1, 0(sp)    #a0 will be dealt with later
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw a5, 16(sp)
    sw a6, 20(sp)
    sw a7, 24(sp)
    sw ra, 28(sp)
    sw t0, 32(sp)
    sw t1, 36(sp)
    sw t2, 40(sp)
    sw t3, 44(sp)
    sw t4, 48(sp)
    sw t5, 52(sp)
    sw t6, 56(sp)

    li t0, 10
    beq t0, a7, 1f
    li t0, 11
    beq t0, a7, 2f
    li t0, 12
    beq t0, a7, 3f
    li t0, 13
    beq t0, a7, 4f
    li t0, 15
    beq t0, a7, 5f
    li t0, 16
    beq t0, a7, 6f
    li t0, 17
    beq t0, a7, 7f
    li t0, 18
    beq t0, a7, 8f
    li t0, 20
    beq t0, a7, 9f    

    j end_syscalls

    1:
        jal Syscall_set_engine_and_steering
        j end_syscalls
    2:
        addi sp, sp, -4
        sw a0, 0(sp)
        jal Syscall_set_handbrake
        lw a0, 0(sp)
        addi sp, sp, 4
        j end_syscalls
    3:
        addi sp, sp, -4
        sw a0, 0(sp)
        jal Syscall_read_sensors
        lw a0, 0(sp)
        addi sp, sp, 4
        j end_syscalls
    4:
        jal Syscall_read_sensor_distance
        j end_syscalls
    5:
        addi sp, sp, -4
        sw a0, 0(sp)
        jal Syscall_get_position
        lw a0, 0(sp)
        addi sp, sp, 4
        j end_syscalls
    6:
        addi sp, sp, -4
        sw a0, 0(sp)
        jal Syscall_get_rotation
        lw a0, 0(sp)
        addi sp, sp, 4
        j end_syscalls
    7:
        jal Syscall_read_serial
        j end_syscalls
    8:
        addi sp, sp, -4
        sw a0, 0(sp)
        jal Syscall_write_serial
        lw a0, 0(sp)
        addi sp, sp, 4
        j end_syscalls
    9:
        jal Syscall_get_systime

    end_syscalls:

    lw t6, 56(sp)
    lw t5, 52(sp)
    lw t4, 48(sp)
    lw t3, 44(sp)
    lw t2, 40(sp)
    lw t1, 36(sp)
    lw t0, 32(sp)
    lw ra, 28(sp)
    lw a7, 24(sp)
    lw a6, 20(sp)
    lw a5, 16(sp)
    lw a4, 12(sp)
    lw a3, 8(sp)
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 60
    csrrw sp, mscratch, sp


    interruption_end:

    csrr t0, mepc   # load return address (address of 
                    # the instruction that invoked the syscall)
    addi t0, t0, 4  # adds 4 to the return address (to return after ecall) 
    csrw mepc, t0   # stores the return address back on mepc

    csrr t0, mstatus
    ori t0, t0, 0x8     #re-enables interruptions
    csrw mstatus, t0


    mret            # Recover remaining context (pc <- mepc)

Syscall_set_engine_and_steering:
    #a0 = engine direction
    #a1 = steering angle

    li t0, -127
    blt a1, t0, 1f  #if a1<-127 error
    li t0, 127
    blt t0, a1, 1f  #if 127<a1 error

    li t0, -1
    blt a0, t0, 1f  #if a0<-1 error
    li t0, 1
    blt t0, a0, 1f  #if 1<a0 error


    li t0, ENGINE
    sb a0, 0(t0)
    li t1, STEERING_WHELL
    sb a1, 0(t1)


    li a0, 0        #no errors
    jalr x0, ra, 0

    1:
    li a0, -1       #not valid inputs
    jalr x0, ra, 0

Syscall_set_handbrake:
    #a0 if handbrakes must be used
    li t0, BRAKES
    sb a0, 0(t0)
    jalr x0, ra, 0

Syscall_read_sensors:
    #a0 address of 256 elements array
    li t0, SET_LINE_CAMERA
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bne t1, x0, 1b
    #reading complete

    li t0, LINE_CAMERA
    addi t2, x0, 0
    addi t3, x0, 256

    2:
        lb t1, 0(t0)
        sb t1, 0(a0)
        addi a0, a0, 1  #next pos of array
        addi t0, t0, 1  #next pos of line
        addi t2, t2, 1  #number of bytes transfered
        blt t2, t3, 2b  #checks if all have been transfered
        #t2=[0,255]

    jalr x0, ra, 0

Syscall_read_sensor_distance:
    li t0, SET_ULTRASONIC
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bne t1, x0, 1b
    #now distance has been read

    li t0, ULTRA_DISTANCE
    lw a0, 0(t0)
    #returns cm distance or -1 if no object
    jalr x0, ra, 0

Syscall_get_position:
    #a0 address of variable of x pos
    #a1 ... y
    #a2 ... z
    li t0, SET_GPS
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bne t1, x0, 1b
    
    li t0, X_COORD
    li t1, Y_COORD
    li t2, Z_COORD
    
    lw t3, 0(t0)  #storing x on a0
    sw t3, 0(a0)

    lw t3, 0(t1)  #storing y on a1
    sw t3, 0(a1)

    lw t3, 0(t2)  #storing z on a2
    sw t3, 0(a2)

    jalr x0, ra, 0

Syscall_get_rotation:
    #a0 address of variable of x angle
    #a1 ... y
    #a2 ... z
    li t0, SET_GPS
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bne t1, x0, 1b

    li t0, X_ANGLE
    li t1, Y_ANGLE
    li t2, Z_ANGLE
    
    lw t3, 0(t0)
    sw t3, 0(a0)

    lw t3, 0(t1)
    sw t3, 0(a1)

    lw t3, 0(t2)
    sw t3, 0(a2)

    jalr x0, ra, 0


Syscall_read_serial:
    #a0 buffer address
    #a1 size = characters to be read
    beq a1, x0, 5f
    addi a2, x0, 0
    4:
        li t0, SET_READ
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bne t1, x0, 1b
        
        li t0, READ_BYTE
        lb t1, 0(t0)
        #t1 has the char

        beq t1, x0, 5f  #if null is read the function ends
        li t2, 10
        beq t1, t2, 5f  #same for \n

        sb t1, 0(a0)

        addi a0, a0, 1  #next pos of buffer
        addi a2, a2, 1  #increases the number of chars read

        blt a2, a1, 4b  #if chars_read < size
        #then continues reading
        #otherwise the function ends

    5:
    li t1, 0
    sb t1, 0(a0)    #terminates string in \0
    addi a0, a2, 0  #stores the number of chars read on return
    jalr x0, ra, 0

Syscall_write_serial:
    #a0 buffer address
    #a1 size of buffer
    addi a2, x0, 0
    4:
        lb t1, 0(a0)
        #first char loaded
        li t0, WRITE_BYTE
        sb t1, 0(t0)  #char on write memory

        li t0, SET_WRITE
        li t1, 1
        sb t1, 0(t0)
        1:
            lb t1, 0(t0)
            bne t1, x0, 1b
        
        addi a0, a0, 1  #next char
        addi a2, a2, 1  #number of chars written

        blt a2, a1, 4b  #if less chars then size
        #then continues writing

    jalr x0, ra, 0

Syscall_get_systime:
    #returns time since booting
    li t0, SET_GPT
    li t1, 1
    sb t1, 0(t0)
    1:
        lb t1, 0(t0)
        bne t1, x0, 1b
    
    li t0, LAST_TIME
    lw a0, 0(t0)
    jalr x0, ra, 0