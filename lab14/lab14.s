.data
.bss
pos_x: .skip 1
pos_y: .skip 1
pos_z: .skip 1
light_values: .skip 256
.text
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

    #interrupt

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
    mret            # Recover remaining context (pc <- mepc)
  

.globl _start
_start:

    la t0, int_handler  # Load the address of the routine that will handle interrupts
    csrw mtvec, t0      # (and syscalls) on the register MTVEC to set
                        # the interrupt array.

# Write here the code to change to user mode and call the function 
# user_main (defined in another file). Remember to initialize
# the user stack so that your program can use it.

.globl control_logic
control_logic:
    # implement your control logic here, using only the defined syscalls


#system calls located below
Syscall_set_engine_and_steering:
    #a0 movement direction
    #a1 steering wheel angle

    #returns 0 on success and otherwise -1
    li a7, 10
    ecall
    jalr x0, ra, 0

Syscall_set_handbrake:
    #a0 if handbrakes must be used

    li a7, 11
    ecall
    jalr x0, ra, 0

Syscall_read_sensors:
    #a0 address of 256bytes with values
    #of the luminosity sensor
    
    la a0, light_values
    li a7, 12
    ecall
    jalr x0, ra, 0

Syscall_get_position:
    #a0 address of variable of x pos
    #a1 ... y
    #a2 ... z
    la a0, pos_x
    la a1, pos_y
    la a2, pos_z

    li a7, 15
    ecall
    jalr x0, ra, 0