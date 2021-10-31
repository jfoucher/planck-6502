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
    .byte $02
    .byte $03
    .byte $05
    .byte $06
    .byte $07
    .byte $08
    .byte $0a
    .byte $0b
    .byte $0c
    .byte $0d
    .byte $0f
    .byte $10
    .byte $11
    .byte $12
    .byte $14
    .byte $15
    .byte $16
    .byte $17
    .byte $19
    .byte $1a
    .byte $1b
    .byte $1c
    .byte $1e
    .byte $1f
    .byte $20
    .byte $21
    .byte $23
    .byte $24
    .byte $25
    .byte $26
    .byte $28
    .byte $29
    .byte $2a
    .byte $2b
    .byte $2d
    .byte $2e
    .byte $2f
    .byte $30
    .byte $32
    .byte $33
    .byte $34
    .byte $35
    .byte $37
    .byte $38
    .byte $39
    .byte $3a
    .byte $3c
    .byte $3d
    .byte $3e
    .byte $3f
    .byte $41
    .byte $42
    .byte $43
    .byte $44
    .byte $46
    .byte $47
    .byte $48
    .byte $49
    .byte $4b

mult_table_low:
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00
    .byte $10
    .byte $20
    .byte $30
    .byte $00