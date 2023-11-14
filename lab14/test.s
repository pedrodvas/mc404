.data
.bss
pos_x: .skip 1
pos_y: .skip 1
pos_z: .skip 1
light_values: .skip 256
.text
.align 4

.globl _start
_start:
    jal Syscall_read_sensors
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0

Syscall_read_sensors:
    #a0 address of 256bytes with values
    #of the luminosity sensor
    
    la a0, light_values
    li a7, 12
    ecall
    jalr x0, ra, 0