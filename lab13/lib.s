.data
.bss
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

.globl gpt_interruption
gpt_interruption:

.globl exit
exit:
    addi a7, x0, 93
    ecall