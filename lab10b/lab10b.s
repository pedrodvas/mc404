.data
.bss
.text
.globl _start
_start:



recursive_tree_search:
    #first checks the current node, then the leff,
    #then the right one

    #a0 = root address
    #a1 = value

    addi a3, x0, 1  #a3 will be depth

    recursion:
        lw t0, 0(a0)
        beq t0, a1, return

        addi sp, sp, -4
        sw a0, 0(sp)
        addi a0, a0, 4  #a0 = a0->left
        addi sp, sp, -4
        sw ra, 0(sp)
        addi a3, a3, 1  #changes the height of the tree
        jal recursion
        addi a3, a3, -1
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4

        addi sp, sp, -4
        sw a0, 0(sp)
        addi a0, a0, 8  #a0 = a0->right
        addi sp, sp, -4
        sw ra, 0(sp)
        addi a3, a3, 1  #changes the height of the tree
        jal recursion
        addi a3, a3, -1
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4
        

        jalr x0, ra, 0
    
        #falta fazer o pra quando não achar
    return:

        mv a0, t0
        jalr x0, ra, 0