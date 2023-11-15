.data
interrupt_table:
.word Syscall_set_engine_and_steering   #EXCCODE = 0
.word Syscall_set_handbrake             #1
.word Syscall_read_sensors              #2
.word Syscall_get_position              #3
.bss
pos_x: .skip 1
pos_y: .skip 1
pos_z: .skip 1
light_values: .skip 256
.align 4
isr_stack: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
isr_stack_end: # Base da pilha das ISRs
.text
.set BASE_ADDRESS,    0xFFFF0100  #base address for controlling the car
.set COORDINATES,     0xFFFF0100  #address for turning on gps
.set SET_LINE_CAMERA, 0xFFFF0101  #=1 starts taking pic, 0 over
.set X_COORD,         0xFFFF0104  #x coordinate
.set Y_COORD,         0xFFFF0108  #y coordinate
.set Z_COORD,         0xFFFF010C  #z coordinate
.set STEERING_WHELL,  0xFFFF0120  #-127=left full, 127=right full
.set ENGINE,          0xFFFF0121  #-1=back, 0=off, 1=front
.set BRAKES,          0xFFFF0122  #1=break on
.set LINE_CAMERA,     0xFFFF0124  #256*byte array for image
.align 4

int_handler:
    ###### Syscall and Interrupts handler ######

    csrrw sp, mscratch, sp
    addi sp, sp, -64
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw a7, 28(sp)
    sw ra, 32(sp)
    sw t0, 36(sp)
    sw t1, 40(sp)
    sw t2, 44(sp)
    sw t3, 48(sp)
    sw t4, 52(sp)
    sw t5, 56(sp)
    sw t6, 60(sp)

    li t0, 10
    li t1, 11
    li t2, 12
    li t3, 15

    beq a7, t0, 1f
    beq a7, t1, 2f
    beq a7, t2, 3f
    beq a7, t3, 4f
    1:
        jal Syscall_set_engine_and_steering
        j 9f
    2:
        jal Syscall_set_handbrake
        j 9f
    3:
        jal Syscall_read_sensors
        j 9f
    4:
        jal Syscall_get_position
    9:

    lw t6, 60(sp)
    lw t5, 56(sp)
    lw t4, 52(sp)
    lw t3, 48(sp)
    lw t2, 44(sp)
    lw t1, 40(sp)
    lw t0, 36(sp)
    lw ra, 32(sp)
    lw a7, 28(sp)
    lw a6, 24(sp)
    lw a5, 20(sp)
    lw a4, 16(sp)
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    csrrw sp, mscratch, sp


    csrr t0, mepc   # load return address (address of 
                    # the instruction that invoked the syscall)
    addi t0, t0, 4  # adds 4 to the return address (to return after ecall) 
    csrw mepc, t0   # stores the return address back on mepc

    csrr t0, mstatus
    ori t0, t0, 0x8     #re-enables interruptions
    csrw mstatus, t0


    mret            # Recover remaining context (pc <- mepc)
  

.globl _start
_start:
    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0 # mscratch <= t0

    la t0, int_handler # Carrega o endereço da main_isr
    csrw mtvec, t0 # em mtvec

    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1
    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 3 (MIE)
    ori t1, t1, 0x8 # do registrador mstatus
    csrw mstatus, t1


    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, user_main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;

    jal user_main

# Write here the code to change to user mode and call the function 
# user_main (defined in another file). Remember to initialize
# the user stack so that your program can use it.

.globl control_logic
control_logic:
    # implement your control logic here, using only the defined syscalls
    li a0, 1
    li a1, -15
    li a7, 10
    ecall

    infinite_loop:
    j infinite_loop

#system calls located below
Syscall_set_engine_and_steering:
    #a0 = engine direction
    #a1 = steering angle
    li t0, ENGINE
    li t1, STEERING_WHELL
    sb a0, 0(t0)
    sb a1, 0(t1)
    jalr x0, ra, 0

Syscall_set_handbrake:
    #a0 if handbrakes must be used
    li t0, BRAKES
    sb a0, 0(t0)
    jalr x0, ra, 0

Syscall_read_sensors:
    //todo
    
    jalr x0, ra, 0

Syscall_get_position:
    #a0 address of variable of x pos
    #a1 ... y
    #a2 ... z
    #todo
    jalr x0, ra, 0

handle_exc:
    #won't be used