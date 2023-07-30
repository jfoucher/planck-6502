
.segment "ZEROPAGE": zeropage
line: .res 1
char: .res 1

.segment "CODE"

.include "../fos/platform/planck/drivers/via.inc"
.include "../fos/platform/planck/drivers/vga.inc"
.include "../fos/platform/planck/drivers/vga.s"
.include "../fos/platform/planck/drivers/delayroutines.s"

reset:
    ; ldy #$10
    ; jsr delay_long
    lda #$FF
    sta DDRA
    sta DDRB
    lda #01
    sta PORTB
    ldx #0
@loop:
    stx PORTA
    stx VIDEO_DATA
    ; stx VIDEO_ADDR_LOW
    inx
    ldy #$FF
    jsr delay
    bra @loop
    ; jsr video_init
    ;set background color
    ; lda #$1E
    ; sta VIDEO_ADDR_LOW
    ; lda #$BF
    ; sta VIDEO_ADDR_HIGH
    ; lda #$1F            ; red background
    ; sta VIDEO_DATA
    ; lda #$C0            ; green foreground
    ; sta VIDEO_DATA

    ; lda #$00
    ; sta VIDEO_ADDR_LOW
    ; sta VIDEO_ADDR_HIGH
    lda #01
    sta PORTA
restart:
    ldx #0
loop:
    lda message,x
    beq restart
    jsr char_out
    
    ldy #$20
    jsr delay
    inx
    stx PORTA
    jmp loop

read_data:
    lda #$00
    sta VIDEO_ADDR_LOW
    lda #$00
    sta VIDEO_ADDR_HIGH
    ldx #0
read_loop:
    lda VIDEO_DATA
    sta buf,x
    inx
    cpx #100
    bne read_loop

write_again:
    lda #$04
    sta VIDEO_ADDR_LOW
    lda #$03
    sta VIDEO_ADDR_HIGH
    ldx #0
write_again_loop:
    lda buf,x
    sta VIDEO_DATA
    inx
    cpx #100
    bne write_again_loop

    ldy #$ff
    jsr delay_long
    jmp reset

message: .asciiz "The quick brown fox jumps over the lazy dog."

buf: .res 100
.segment "ROM_VECTORS"

.word reset
.word reset
.word reset