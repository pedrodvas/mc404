/*
Hamming code with 4 digit input and 3 parity as ppdpddd
plan:
-store the input in a memory label
-the digits from the input will be transcribed into
the corresponding output position
-each p digit will be converted ascii -> int
-they will be analyzed separatly and will be put
into the output directly

*/
/*
Registers:
s0 = input label
s1 = output label]

t0 -> t3 = each bit from the message
*/
.data
.bss
input_digits1: .skip 5  #will be codified
output_digits1: .skip 8

input_digits2: .skip 8
output_digits2: .skip 5 #will be decodified

error_detection: .skip 2 #"1\n" if wrong "0\n" if right
.text
.globl start
start:
    la s0, input_digits1
    la s1, output_digits1
    jal read_input_digits1
    jal copy_normal_digits
    jal parity_1
    jal parity_2
    jal parity_3

    lb t0, 4(s0)
    sb t0, 7(s1)    #transcribes '\n'

    jal write_output_digits1

    #part 1 above
    #part 2 

    la s2, input_digits2
    la s3, output_digits2

    jal read_input_digits2
    jal decode
    lb t0, 7(s2)
    sb t0, 4(s3)
    jal write_output_digits2

    #part 2
    #part 3

    la s4, error_detection
    jal error
    #a0 will be the error variable
    addi a0, a0, 48
    sb a0, 0(s4)
    li t0, 10
    sb t0, 1(s4)
    jal write_error_detection
    jal exit

error:
    lb t0, 0(s2)
    lb t1, 1(s2)
    lb t2, 2(s2)
    lb t3, 3(s2)
    lb t4, 4(s2)
    lb t5, 5(s2)
    lb t6, 6(s2)


    li a0, 0

    xor t0, t0, t2  #parity check for first one
    xor t0, t0, t4
    xor t0, t0, t6
    or a0, a0, t0

    xor t1, t1, t2
    xor t1, t1, t5
    xor t1, t1, t6
    or a0, a0, t1

    xor t3, t3, t4
    xor t3, t3, t5
    xor t3, t3, t6
    or a0, a0, t3

decode:
    lb t0, 2(s2)
    lb t1, 4(s2)
    lb t2, 5(s2)
    lb t3, 6(s2)

    sb t0, 0(s3)
    sb t1, 1(s3)
    sb t2, 2(s3)
    sb t3, 3(s3)
    jalr x0, ra, 0

copy_normal_digits:
    lb t0, 0(s0)
    lb t1, 1(s0)
    lb t2, 2(s0)
    lb t3, 3(s0)

    sb t0, 2(s1)
    sb t1, 4(s1)
    sb t2, 5(s1)
    sb t3, 6(s1)
    jalr x0, ra, 0

parity_1:
    lb t0, 0(s0)
    lb t1, 1(s0)
    lb t3, 3(s0)

    addi t0, t0, -48
    addi t1, t1, -48    #ascii -> int
    addi t3, t3, -48

    addi t4, x0, 0 #will check the sum
    add t4, t0, t1
    add t4, t4, t3  #t4 = t0 + t1 + t3

    andi a0, t4, 1  /*if t4 is odd the and will return 1
                    if even will return 0*/

    addi a0, a0, 48     #int -> ascii
    sb a0, 0(s1)
    jalr x0, ra, 0

parity_2:
    lb t0, 0(s0)
    lb t2, 2(s0)
    lb t3, 3(s0)

    addi t0, t0, -48
    addi t2, t2, -48    #ascii -> int
    addi t3, t3, -48

    addi t4, x0, 0 #will check the sum
    add t4, t0, t2
    add t4, t4, t3  #t4 = t0 + t2 + t3

    andi a0, t4, 1  /*if t4 is odd the and will return 1
                    if even will return 0*/

    addi a0, a0, 48     #int -> ascii
    sb a0, 1(s1)
    jalr x0, ra, 0

parity_3:
    lb t1, 1(s0)
    lb t2, 2(s0)
    lb t3, 3(s0)

    addi t1, t1, -48
    addi t2, t2, -48    #ascii -> int
    addi t3, t3, -48

    addi t4, x0, 0 #will check the sum
    add t4, t1, t2
    add t4, t4, t3  #t4 = t1 + t2 + t3

    andi a0, t4, 1  /*if t4 is odd the and will return 1
                    if even will return 0*/

    addi a0, a0, 48     #int -> ascii
    sb a0, 3(s1)
    jalr x0, ra, 0


read_input_digits1:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_digits1 #  buffer to write the data
    li a2, 5  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

write_output_digits1:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_digits1       # buffer
    li a2, 8           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

read_input_digits2:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_digits2 #  buffer to write the data
    li a2, 8  # size in bytes
    li a7, 63 # syscall read (63)
    ecall
    jalr x0, ra, 0

write_output_digits2:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_digits2       # buffer
    li a2, 5           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

write_error_detection:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, error_detection       # buffer
    li a2, 2           # size
    li a7, 64           # syscall write (64)
    ecall
    jalr x0, ra, 0

exit:
    li a0, 10
    ecall