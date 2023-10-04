/*
REGISTERS:
- s1 = address for current point
- s2 = input_address
- s3 = how many nodes
- s4 = value of the input
- s5 = output for value found
PLAN:
-receive the 6 char input
-there will be two functions, one for >=0 and other for <0
-analyze if there is a '-' in the input, if so -> input*-1
-store the input in s1
-then the first node address will be stored on s2
-the node counter will be counted s3
-FOR EACH NODE
-the 0->3 bytes will be stored on t0
-4->7 will be stored on t1
-if t1+t2 = input
    -input is printed
    -branch to exit
-else store 8->11 on s2
-go to node s2 and repeat
*/

.data
#input_address: .asciz "-64\n"
output_not_found: .asciz "-1\n"
.bss
output_number_nodes: .skip 8
input_address: .skip 6

.text
.globl _start
_start:
    jal read
    la s2, input_address
    jal convert_to_value
    #a1 is the value we're looking for
    mv s4, a1   #now it is s4
    la s1, head_node
    add s3, x0, x0  #counts number of nodes
    jal node_iterator
    jal exit

node_iterator:
    lw t0, 0(s1)
    lw t1, 4(s1)

    add t0, t0, t1
    beq t0, s4, node_iterator_found

    lw s1, 8(s1)    #address for next node
    beq s1, x0, node_iterator_not_exist
    /*if arrived on null pointer stops execution*/

    addi s3, s3, 1  #counts one node
    jal x0, node_iterator

node_iterator_found:
#write number of nodes read
    la s5, output_number_nodes

    addi t0, x0, 10
    sb t0, 7(s5)    #\n on last char

    addi t1, x0, 10 #10 used for remainder and division

    remu t2, s3, t1 #t2 = s3%10
    addi t2, t2, 48
    sb t2, 6(s5)
    divu s3, s3, t1 #s3 = s3/10

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 5(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 4(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 4(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 3(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 2(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 1(s5)
    divu s3, s3, t1

    beq s3, x0, write_nodes
    remu t2, s3, t1
    addi t2, t2, 48
    sb t2, 0(s5)


write_nodes:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_number_nodes       # buffer
    li a2, 8           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

node_iterator_not_exist:
#writes -1
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_not_found       # buffer
    li a2, 3           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0      #goes to main

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 6  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

convert_to_value:
#counts the amount of digits in order to multiply by the adequate
#10 power and then checks if is negative by the '-' char
    la s2, input_address

    mv t0, s2
    li t2, 10
digit_counter:  
    lb t1, 0(t0)
    beq t1, t2, digit_counter_end
    addi t0, t0, 1
    jal x0, digit_counter
digit_counter_end:
    sub a0, t0, s2  
/*sees how many bytes t0 had to jump to find the \n*/
/*after this point a0 is the amount of digits before \n*/

    lb t0, 0(s2)
    li t1, 45
    beq t0, t1, negative    #jumps to negative if first char is -

#a1 will be the value for the return
positive:
    add a1, x0, x0
    addi t2, s2, 0       #initial memory position
    add t0, t2, a0  #position of \n
    addi t5, x0, 10 #used to multiply the result
loop_positive_value:
    beq t0, t2, out #when the digit is \n loop breaks
    mul a1, a1, t5  #power correction
    lb t4, 0(t2)
    addi t4, t4, -48#ascii correction
    add a1, a1, t4
    addi t2, t2, 1 #checks other digits
    jal x0, loop_positive_value

negative:
    add a1, x0, x0
    addi t2, s2, 1  #initial memory position (after '-')
    add t0, t2, a0  #position of /n
    addi t0, t0, -1
    addi t5, x0, 10 #used to multiply the result
    addi t3, x0, -1
loop_negative_value:
    beq t0, t2, out #when /n breaks
    mul a1, a1, t5  #power correction
    lb t4, 0(t2)
    addi t4, t4, -48#ascii correction
    mul t4, t4, t3  #turns into negative
    add a1, a1, t4
    addi t2, t2, 1
    jal x0, loop_negative_value
    #aparentemente o primeiro digito que t4 pega é o -


out:
    jalr x0, ra, 0


exit:
    addi a7, x0, 93
    ecall