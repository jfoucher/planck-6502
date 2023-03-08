ACIA_DELAY = CLOCK_SPEED / 500000

acia_init:
    sta ACIA_STATUS        ; soft reset (value not important)
                            ; set specific modes and functions
    stz has_acia
    lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
    ;lda #$09               ; no parity, no echo, no Tx interrupt, Rx interrupt, enable Tx/Rx
    sta ACIA_CMD        ; store to the command register
    lda ACIA_CMD        ; load command register again
    cmp #$0B                ; if not the same
    bne acia_absent         ; then it means the ACIA is not connected
    lda ACIA_STATUS         ; Read the ACAI status to
    and #$60                ; check if present or absent
    bne acia_absent
    lda #1
    sta has_acia           ; remember that ACIA is here
    lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 115.200k baud rate
    ;lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 1200 baud rate
    sta ACIA_CTRL          ; program the ctl register

acia_absent:
        ldy #20
aa_loop:
        jsr delay_short
        lda ACIA_STATUS         ; Read ACIA data a few times
        lda ACIA_DATA           ; to try and prevent spurious characters
        dey
        bne aa_loop
aa_end:
        rts

acia_out:
    pha
    phy
    sta ACIA_DATA
    ldy #ACIA_DELAY            ;minimal delay is $02
    jsr delay_short
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
