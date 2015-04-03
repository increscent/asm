.equ OVLCNT, 40
.equ RAMEND, 0x8ff
.equ SREG, 0x3f
.equ SPL, 0x3d
.equ SPH, 0x3e

.equ PORTB, 0x05
.equ DDRB, 0x04
.equ PINB, 0x03
.equ TCCR0A, 0x24
.equ TCCR0B, 0x25
.equ TCNT0, 0x26
.equ TIMSK0, 0x6e

.org 0
   rjmp  main

.org 0x40
   rjmp t0_handler

t0_handler:       ; timer 0 interrupt handler
   in    r19,SREG
   dec   r18
   out   SREG,r19
   reti
   
main:
   ldi   r16,0    ; reset system status
   out   SREG,r16 ; init stack pointer
   ldi   r16,lo8(RAMEND)
   out   SPL,r16
   ldi   r16,hi8(RAMEND)
   out   SPH,r16

   ldi   r16,0x20    ; set port bits to output mode
   out   DDRB,r16

   clr   r16         ; init timer 0
   out   TCCR0A,r16
   ldi   r16,0x05
   out   TCCR0B,r16
   clr   r16
   out   TCNT0,r16
   ldi   r16,1       ; enable timer interrupt
   ldi   r28,lo8(TIMSK0)
   ldi   r29,hi8(TIMSK0)
   st    Y,r16

   ldi   r18,OVLCNT
   ldi   r16,0x20
   clr   r17
   sei               ; globally enable interrupts

mainloop:
   sleep
   tst   r18         ; test if r18 is 0
   brne  mainloop
   ldi   r18,OVLCNT  ; reset r18 to init val
   eor   r17,r16     ; invert output bit
   out   PORTB,r17   ; write to port
   rjmp  mainloop    ; loop forever
   