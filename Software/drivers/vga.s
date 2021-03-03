video_init:
    ; set colors
    lda #$3E
    sta VIDEO_ADDR_LOW
    lda #$7F
    sta VIDEO_ADDR_HIGH
    lda #$00
    sta VIDEO_DATA
    lda #$F0
    sta VIDEO_DATA
    lda #0
    sta VIDEO_IEN
    sta VIDEO_ADDR_LOW
    sta VIDEO_ADDR_HIGH
    lda #$05
    sta VIDEO_CTRL
    jsr vga_clear
    rts

char_out:
    pha
    phx
    phy
    cmp #$0D
    beq next_line
    cmp #$0A
    beq next_line
    cmp #$08
    beq backspace
    sta VIDEO_DATA
    inc char
    ldx char
    cpx #VIDEO_HIRES_HCHARS
    beq next_line
    
char_out_exit:
    ply
    plx
    pla
    rts

backspace:
    dec char
    lda #$85        ; make increment negative
    sta VIDEO_CTRL
    lda #$20
    sta VIDEO_DATA  ;write a space to go back one
    lda #$01        ; make increment zero
    sta VIDEO_CTRL
    lda #$20
    sta VIDEO_DATA  ; replace with a space
    lda #$05        ; make increment positive again
    sta VIDEO_CTRL
    bra char_out_exit

next_line:
    inc line
    stz char
    ldx line
    cpx #VIDEO_HIRES_VCHARS
    bcc nl
    jsr scroll_up
    bra char_out_exit
nl:
    lda mult_table_high,x
    sta VIDEO_ADDR_HIGH
    lda mult_table_low,x
    sta VIDEO_ADDR_LOW
    bra char_out_exit

scroll_up:
    pha
    ; lda #1
    ; sta VIDEO_VSCROLL
    ; lda mult_table_high+60
    ; sta VIDEO_ADDR_HIGH
    ; lda mult_table_low+60
    ; sta VIDEO_ADDR_LOW
    lda #0
    sta VIDEO_ADDR_HIGH
    sta VIDEO_ADDR_LOW
    sta char
    sta line
    pla
    rts

vga_clear:
    pha
    phx
    phy
    lda #0
    sta line
    ;lda #$05                ; monochrome chars, increment by one
    ;sta VIDEO_CTRL
    
    lda #$00                ; set start address
    sta VIDEO_ADDR_HIGH
    sta VIDEO_ADDR_LOW

    lda #$20
    ldy #VIDEO_HIRES_HCHARS
outer:
    ldx #VIDEO_HIRES_VCHARS
inner:
    sta VIDEO_DATA

    dex
    bne inner
    dey
    bne outer

    lda #0
    sta line
    lda #$00
    sta VIDEO_ADDR_HIGH
    sta VIDEO_ADDR_LOW
    ply
    plx
    pla
    rts



; These are precalculated multiplications for ADDR_LOW and ADDR_HIGH depending on the line number
mult_table_high:
    .byte $00
    .byte $01
    .byte $03
    .byte $04
    .byte $06
    .byte $07
    .byte $09
    .byte $0a
    .byte $0c
    .byte $0e
    .byte $0f
    .byte $11
    .byte $12
    .byte $14
    .byte $15
    .byte $17
    .byte $19
    .byte $1a
    .byte $1c
    .byte $1d
    .byte $1f
    .byte $20
    .byte $22
    .byte $23
    .byte $25
    .byte $27
    .byte $28
    .byte $2a
    .byte $2b
    .byte $2d
    .byte $2e
    .byte $30
    .byte $32
    .byte $33
    .byte $35
    .byte $36
    .byte $38
    .byte $39
    .byte $3b
    .byte $3c
    .byte $3e
    .byte $40
    .byte $41
    .byte $43
    .byte $44
    .byte $46
    .byte $47
    .byte $49
    .byte $4b
    .byte $4c
    .byte $4e
    .byte $4f
    .byte $51
    .byte $52
    .byte $54
    .byte $55
    .byte $57
    .byte $59
    .byte $5a
    .byte $5c
    .byte $5d
    .byte $5f
    .byte $60
    .byte $62
    .byte $64
    .byte $65
    .byte $67
    .byte $68
    .byte $6a
    .byte $6b
    .byte $6d
    .byte $6e
    .byte $70
    .byte $72
    .byte $73
    .byte $75

mult_table_low:
    .byte $00
    .byte $24
    .byte $08
    .byte $2c
    .byte $10
    .byte $34
    .byte $18
    .byte $3c
    .byte $20
    .byte $04
    .byte $28
    .byte $0c
    .byte $30
    .byte $14
    .byte $38
    .byte $1c
    .byte $00
    .byte $24
    .byte $08
    .byte $2c
    .byte $10
    .byte $34
    .byte $18
    .byte $3c
    .byte $20
    .byte $04
    .byte $28
    .byte $0c
    .byte $30
    .byte $14
    .byte $38
    .byte $1c
    .byte $00
    .byte $24
    .byte $08
    .byte $2c
    .byte $10
    .byte $34
    .byte $18
    .byte $3c
    .byte $20
    .byte $04
    .byte $28
    .byte $0c
    .byte $30
    .byte $14
    .byte $38
    .byte $1c
    .byte $00
    .byte $24
    .byte $08
    .byte $2c
    .byte $10
    .byte $34
    .byte $18
    .byte $3c
    .byte $20
    .byte $04
    .byte $28
    .byte $0c
    .byte $30
    .byte $14
    .byte $38
    .byte $1c
    .byte $00
    .byte $24
    .byte $08
    .byte $2c
    .byte $10
    .byte $34
    .byte $18
    .byte $3c
    .byte $20
    .byte $04
    .byte $28
    .byte $0c