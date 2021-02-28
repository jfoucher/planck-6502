video_init:
    ; set colors
    lda #$1E
    sta VIDEO_ADDR_LOW
    lda #$FF
    sta VIDEO_ADDR_HIGH
    lda #$E0
    sta VIDEO_DATA
    lda #$1c
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
    lda #1
    sta VIDEO_VSCROLL
    lda mult_table_high+60
    sta VIDEO_ADDR_HIGH
    lda mult_table_low+60
    sta VIDEO_ADDR_LOW
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
    .byte $03
    .byte $06
    .byte $09
    .byte $0c
    .byte $0f
    .byte $12
    .byte $15
    .byte $19
    .byte $1c
    .byte $1f
    .byte $22
    .byte $25
    .byte $28
    .byte $2b
    .byte $2e
    .byte $32
    .byte $35
    .byte $38
    .byte $3b
    .byte $3e
    .byte $41
    .byte $44
    .byte $47
    .byte $4b
    .byte $4e
    .byte $51
    .byte $54
    .byte $57
    .byte $5a
    .byte $5d
    .byte $60
    .byte $64
    .byte $67
    .byte $6a
    .byte $6d
    .byte $70
    .byte $73
    .byte $76
    .byte $79
    .byte $7d
    .byte $80
    .byte $83
    .byte $86
    .byte $89
    .byte $8c
    .byte $8f
    .byte $92
    .byte $96
    .byte $99
    .byte $9c
    .byte $9f
    .byte $a2
    .byte $a5
    .byte $a8
    .byte $ab
    .byte $af
    .byte $b2
    .byte $b5
    .byte $b8
    .byte $bb
    .byte $be
    .byte $c1
    .byte $c4
    .byte $c8
    .byte $cb
    .byte $ce
    .byte $d1
    .byte $d4
    .byte $d7
    .byte $da
    .byte $dd
    .byte $e1
    .byte $e4
    .byte $e7
    .byte $ea

mult_table_low:
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c
    .byte $10
    .byte $14
    .byte $18
    .byte $1c
    .byte $00
    .byte $04
    .byte $08
    .byte $0c