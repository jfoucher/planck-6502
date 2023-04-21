ACIA_DELAY = CLOCK_SPEED / 250000

acia_init:
    sta ACIA_STATUS        ; soft reset (value not important)
                            ; set specific modes and functions
    lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
    sta ACIA_CMD        ; store to the command register
    lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 115.200k baud rate
    ;lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 1200 baud rate
    sta ACIA_CTRL          ; program the ctl register
aa_end:
    rts

acia_out:
    pha
    phy
    sta ACIA_DATA
.ifndef LCD_BUF                ; if the LCD is in the build, we do not need to delay
    ldy #ACIA_DELAY            ;minimal delay is $02
    jsr delay_short
.endif
    ply
    pla
    rts

acia_getc:
    lda ACIA_STATUS                 ; Read the ACIA status to   
    and #$08                        ; Check if there is character in the receiver
    beq @no_char      ; Exit now if we don't get one.
    lda ACIA_DATA
    sec
    rts
@no_char:
    clc
    rts
