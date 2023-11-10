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
    jal recursion
    addi a0, x0, 0
    jalr x0, ra, 0
    

    recursion:
        lw t0, 0(a0)
        beq t0, a1, return

        addi sp, sp, -4
        sw a0, 0(sp)    #original root stored
        addi a0, a0, 4  #a0 = a0->left
        addi sp, sp, -4
        sw ra, 0(sp)    #stores return address
        addi a3, a3, 1  #changes the height of the tree
        beq x0, a0, skip_left   #skips the left when 
        #address is null
        jal recursion   #check left tree

        skip_left:
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
        beq x0, a0, skip_right
        jal recursion

        skip_right:
        addi a3, a3, -1
        lw ra, 0(sp)
        addi sp, sp, 4
        lw a0, 0(sp)
        addi sp, sp, 4
        

        jalr x0, ra, 0
    
        
    return:
        mv a0, t0
        jalr x0, ra, 0