.segment "ZEROPAGE"
time: .res 4

.segment "DATA"

COUNTER = CLOCK_SPEED/200        ; n/s
; 200 ticks per second, or 5ms per tick
timer_init:
    lda IER
    ora #$C0        ;enable interrupt on timer1 timeout
    sta IER
    lda #$40        ; timer one free run mode
    sta ACR
    lda #<COUNTER     ; set timer to low byte to calculated value from defined clock speed
    sta T1CL
    lda #>COUNTER       ; set timer to high byte to calculated value from defined clock speed
    sta T1CH        
    stz time
    stz time+1
    stz time+2
    stz time+3
    cli
    rts
    

timer_irq:
    inc time
    beq @inc1
@exit1:
    ; this resets the PS/2 temp variables
    ;jsr reset_ps2
    rts
@inc1:
    inc time+1
    beq @inc2
    bra @exit1
@inc2:
    inc time+2
    beq @inc3
    bra @exit1
@inc3:
    inc time+3
    bra @exit1
    rts