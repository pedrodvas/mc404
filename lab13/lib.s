.data
.globl _system_time
_system_time: .word 0
.bss
.section .bss
.align 4

.globl isr_stack_begin
isr_stack_begin: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
.globl isr_stack_end
isr_stack_end: # Base da pilha das ISRs
.section .text
.align 2


.text
#general purpose timer (GPT), stores time in miiseconds
.set BASE_GPT,        0xffff0100  #1-> starts reading the current system time
                                  #0-> the time reading is complete
.set LAST_READING,    0xffff0104  #stores the last reading
.set DELAY_INTERRUPT  0xffff0108  #v>0 creates interrupt after v mili

#MIDI synthesizer
.set BASE_MIDI,      0xffff0300, if value>=0 than channel[value] plays midi note
.set INSTRUMENT_ID,  0xffff0302 
.set NOTE,           0xffff0304
.set NOTE_VELOCITY,  0xffff0305
.set NOTE_DURATION,  0xffff0306


.globl _start
_start:
    #habilitando interrupção externa
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1



    # Configura mscratch com o topo da pilha das ISRs.
    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0 # mscratch <= t0

    jal main


.globl play_note
play_note:
#a0=channel, a1=ID, a2=note, a3=velocity, a4=duration
    li t0, BASE_MIDI
    sb a0, 0(t0)
    li t0, INSTRUMENT_ID
    sb a1, 0(t0)
    li t0, NOTE
    sb a2, 0(t0)
    li t0, NOTE_VELOCITY
    sb a3, 0(t0)
    li t0, NOTE_DURATION
    sb a4, 0(t0)

    jalr x0, ra, 0

interrupt_handler:
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

    jal gpt_interruption

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

gpt_interruption:

    li t0, BASE_GPT
    li t1, 1
    sw t1, 0(t0)
    #starts reading
    1:
        lw t1, 0(t0)
        bne t1, x0, 1b
    #loops until reading is done

    li t0, LAST_READING
    lw t1, 0(t0)

    la _system_time
    sw t1, 0(t0)    #updates system time

    li t0, DELAY_INTERRUPT
    li t1, 100
    sw t1, 0(t0)    #next interrupt on 100ms

    jalr x0, ra, 0