.bss
.align 2

.text 
.globl set_engine
set_engine:
    li a7, 10
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl set_handbrake
set_handbrake:
    li a7, 11
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl read_sensor_distance
read_sensor_distance:
    li a7, 13
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl get_position
get_position:
    li a7, 15
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl get_rotation
get_rotation:
    li a7, 16
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl get_time
get_time:
    li a7, 20
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl puts
puts:
    mv a2, a0 # To preserve the initial adress of our buffer
    li a1, 0
    # First, we find the size of our string
    buffer_length: 
    lb t0, 0(a0)
    beqz t0, buffer_length_found
    addi a0, a0, 1 # Move to the next position of our buffer
    addi a1, a1, 1
    j buffer_length

    buffer_length_found:
    li t0, 10 # Newline character 
    sb t0, 0(a0)
    addi a1, a1, 1
    mv a0, a2 # Recover the initial adress of our buffer
    # Now, we have our buffer size 
    li a7, 18
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


.globl gets
gets:
    # a0: buffer to be filled
    mv a2, a0 # This will preserve the initial adress of our buffer
    mv a3, a0 # We will iterate our buffer with this register

    # Do notice that we are careful with register a0 since in our read syscall
    # a0 will return the number of bytes we read.
    gets_loop:
    li a1, 1 # To read only one byte per time
    mv a0, a3 # We load the next adress of our buffer in register a0
    li a7, 17 # Syscall to read with serial port
    addi sp, sp, -4
    sw ra, 0(sp)
    ecall # This will preserve the ra register value 
    lw ra, 0(sp)
    addi sp, sp, 4
    lb t0, 0(a3)
    li t1, 10
    beq t0, t1, gets_finished # See if we have reached a newline character
    beqz t0, gets_finished
    addi a3, a3, 1 # If not, move to the next position of our buffer
    j gets_loop

    gets_finished:
    addi a3, a3, 1
    li t0, 0
    sb t0, 0(a3) # We add a null character terminator to the end of our buffer
    mv a0, a2 # We recover the begin adress of our buffer
    ret


.globl atoi
atoi:
    # a0 has begin adress of our input buffer
    li t0, 0 # To temporarily store our number
    li t2, 10 # To make base 10 conversion

    # Checking if number is negative
    lbu t1, 0(a0) # Check first character
    li t3, 45 # Equals to '-', aka minus sign
    beq t1, t3, negative_number
    j positive_number


    positive_number:
    lbu t1, 0(a0) # Load character
    beq t1, t2, positive_over
    beqz t1, positive_over
    mul t0, t0, t2
    addi t1, t1, -48 # From ASCII to integer
    add t0, t0, t1
    addi a0, a0, 1 # Move to next character
    j positive_number

    positive_over:
    mv a0, t0 # Return our number in register a0
    ret

    negative_number:
    lbu t1, 1(a0) # Start in the second caracter
    beq t1, zero, negative_over
    mul t0, t0, t2
    addi t1, t1, -48 # From ASCII to integer
    add t0, t0, t1
    addi a0, a0, 1 # Move to the next index
    j negative_number

    negative_over:
    li t1, -1
    mul t0, t0, t1 # Convert number to negative equivalent
    mv a0, t0
    ret

.globl itoa
itoa:
    # a0: integer value to be converted, a1: buffer to be filled, a2: base 10 or 16
    mv a3, a1 # We temporarily store the initial adress of our buffer in register a3
    li t0, 0 # To check if its 0 or negative
    li t1, 0 # To count number of digits
    beq t0, a0, convert_to_zero
    blt a0, t0, convert_to_negative_decimal_number
    li t2, 16
    beq t2, a2, convert_to_hexadecimal_number
    li t2, 10
    j convert_to_decimal_number

    convert_to_zero:
    li t0, '0'
    sb t0, 0(a1)
    addi a1, a1, 1
    j adjust_decimal

    convert_to_negative_decimal_number:
    li t0, '-'
    sb t0, 0(a1)
    li t0, -1
    mul a0, a0, t0 # Get positive equivalent
    addi a1, a1, 1 # Move to the next position of our buffer
    j convert_to_decimal_number

    convert_to_decimal_number:
    beqz a0, decimal_conversion_finished
    remu t0, a0, a2 # t0 <- a0%10
    addi t0, t0, 48 # From int to ASCII
    addi sp, sp, -4
    sw t0, 0(sp) # Store digit in our stack
    div a0, a0, a2 # a0 <- a0/10
    addi t1, t1, 1 # Count one more digit
    j convert_to_decimal_number

    decimal_conversion_finished:
    beqz t1, adjust_decimal
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, 0(a1)
    addi a1, a1, 1 # Move to the next position of our buffer
    addi t1, t1, -1 # Loop will continue untill we have store all digits in our buffer
    j decimal_conversion_finished

    adjust_decimal:
    li t0, 0
    sb t0, 0(a1) # Store a null caracter at the end of our buffer
    mv a0, a3 # We recover the initial adress of our buffer
    ret

    convert_to_hexadecimal_number:
    beqz a0, hexadecimal_conversion_finished
    rem t0, a0, a2 # t0 <- a0%16
    li t2, 10
    blt t0, t2, number

        letter:
        addi t0, t0, 55
        j hexadecimal_stack
        
        number:
        addi t0, t0, 48

    hexadecimal_stack:
    addi sp, sp, -4
    sw t0, 0(sp)
    div a0, a0, a2 # a0 <- a0/16
    addi t1, t1, 1
    j convert_to_hexadecimal_number

    hexadecimal_conversion_finished:
    beqz t1, adjust_hexadecimal
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, 0(a1)
    addi a1, a1, 1
    addi t1, t1, -1
    j hexadecimal_conversion_finished

    adjust_hexadecimal:
    li t0, 0
    sb t0, 0(a1)
    mv a0, a3
    ret

a1:


.globl strlen_custom
strlen_custom:
    # a0: has the begin adress of our buffer terminated by \0
    li t0, 0 # Iterator to find the size of our string
    li t2, 10

    strlen_loop: 
    lb t1, 0(a0) # Load the current byte of our buffer
    beq t2, t1, strlen_finished
    beqz t1, strlen_finished # Check if we reached the null character terminator
    addi t0, t0, 1 # Count 1 char
    addi a0, a0, 1 # Move the next position of our buffer
    j strlen_loop

    strlen_finished:
    mv a0, t0 # Store the length we found in register a0 to return it
    ret


.globl approx_sqrt
approx_sqrt:
    # a0: y value to find its square root, a1: number of iterations
    srai t0, a0, 1

    sqrt_loop:
    divu t1, a0, t0
    add t2, t1, t0
    srai t0, t2, 1
    addi a1, a1, -1
    beqz a1, sqrt_finished
    j sqrt_loop

    sqrt_finished:
    mv a0, t0 # Store our sqrt in register a0
    ret


.globl get_distance
get_distance:
    # a0: xa, a1: ya, a2: za, a3: xb, a4: yb, a5: zb
    sub a0, a0, a3 # a0 <- xa - xb
    sub a1, a1, a4 # a1 <- ya - yb
    sub a2, a2, a5 # a2 <- za - zb

    mul a0, a0, a0 # a0 <- (xa - xb)^2
    mul a1, a1, a1 # a1 <- (ya - yb)^2
    mul a2, a2, a2 # a2 <- (za - yb)^2

    add a0, a0, a1 # a0 <- (xa - xb)^2 + (ya - yb)^2
    add a0, a0, a2 # a0 <- (xa - xb)^2 + (ya - yb)^2 + (za - yb)^2

    li a1, 15 # Make 15 iterations using Babylonian Method

    addi sp, sp, -4
    sw ra, 0(sp)
    jal approx_sqrt
    lw ra, 0(sp)
    addi sp, sp, 4

    ret

.globl fill_and_pop
fill_and_pop:
    # a0: head node, a1: fill
    mv a2, a0
    # x, y and z
    lw t0, 0(a2)
    lw t1, 4(a2)
    lw t2, 8(a2)
    # euler angles
    lw t3, 12(a2)
    lw t4, 16(a2)
    lw t5, 20(a2)
    # action
    lw a3, 24(a2)
    # next node adress
    lw a4, 28(a2)

    sw t0, 0(a1)
    sw t1, 4(a1)
    sw t2, 8(a1)
    sw t3, 12(a1)
    sw t4, 16(a1)
    sw t5, 20(a1)
    sw a3, 24(a1)
    sw a4, 28(a1)

    # Return the adress of the next node in register a0
    mv a0, a4
    ret