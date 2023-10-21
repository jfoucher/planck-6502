

video_init:
    ; set colors
    lda vga_enable          ; if VGA out is disabled,
    beq video_init_end       ; exit now
video_do_init:
    lda #$05
    sta VIDEO_CTRL
    lda #$1E
    sta VIDEO_ADDR_LOW
    lda #$FF
    sta VIDEO_ADDR_HIGH
    lda #$00
    sta VIDEO_DATA
    lda #$F0
    sta VIDEO_DATA
    jsr vga_clear
    lda #0
    sta VIDEO_IEN
    sta VIDEO_ADDR_LOW
    sta VIDEO_ADDR_HIGH
video_init_end:
    rts

char_out:
    pha
    phx
    phy
    ldx vga_enable          ; if VGA out is disabled,
    beq char_out_exit       ; exit now
    cmp #$0D
    beq next_line
    cmp #$0A
    beq next_line
    cmp #$08
    beq backspace
    sta VIDEO_DATA
    inc char
    ldx char
    cpx #VIDEO_LORES_HCHARS
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
    cpx #VIDEO_LORES_VCHARS
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
    jsr vga_clear
    rts
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
    stz line
    ;lda #$05                ; monochrome chars, increment by one
    ;sta VIDEO_CTRL
    
    stz VIDEO_ADDR_LOW
    stz VIDEO_ADDR_HIGH

    lda #$20
    ldy #VIDEO_LORES_HCHARS
outer:
    ldx #VIDEO_LORES_VCHARS
inner:
    sta VIDEO_DATA

    dex
    bne inner
    dey
    bne outer

    stz line
    stz char
    stz VIDEO_ADDR_LOW
    stz VIDEO_ADDR_HIGH
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

mult_table_low:
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10
    .byte $18
    .byte $00
    .byte $08
    .byte $10