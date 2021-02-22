
timer_init:
    lda IER
    ora #$C0        ;enable interrupt on timer1 timeout
    sta IER
    lda #$40        ; timer one free run mode
    sta ACR
    ; lda #$50      ; set timer to $C350 which is about 5 ms at 10Mhz
    
    ;lda #$60        ; set timer to $EA60 which is about 5 ms at 12Mhz
    lda #$D9        ; set timer to $F5D9 which is about 5 ms at 12.58Mhz
    sta T1CL
    ; lda #$C3       ; set timer to $C350 which is about 5 ms at 10Mhz
    ;lda #$ea       ; set timer to $EA60 which is about 5 ms at 12Mhz
    lda #$F5       ; set timer to $F5D9 which is about 5 ms at 12.58Mhz
    ;lda #$48        ; set timer to $4800 which is  0.1s at 1.8432Mhz
    sta T1CH        
    lda #0
    sta time
    sta time+1
    sta time+2
    sta time+3
    cli
    rts
    

timer_irq:
    inc time
    beq @inc1
@exit1:
    ; this resets the PS/2 temp variables
    jsr reset_ps2
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