/*
REGISTERS:
- s1 = address for current point
- s2 = input_address


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
input_address: .asciz "-1234\n"
.bss
#input_address: .skip 6
.text
.globl _start
_start:
    #jal read
    la s2, input_address
    jal convert_to_value
    jal exit

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
    addi t5, x0, 10 #used to multiply the result
    addi t3, x0, -1
loop_negative_value:
    beq t0, t2, out #when /n breaks
    mul a1, a1, t5  #power correction
    lb t4, 0(s2)
    addi t4, t4, -48#ascii correction
    mul t4, t4, t3  #turns into negative
    add a1, a1, t4
    addi t2, t2, 1
    jal x0, loop_negative_value
    #aparentemente o primeiro digito que t4 pega é o -


out:
    jalr x0, ra, 0


exit: