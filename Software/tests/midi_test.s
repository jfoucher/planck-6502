ACIA_BASE   = $FFE0
ACIA_DATA = ACIA_BASE
ACIA_STATUS = ACIA_BASE + 1
ACIA_CMD = ACIA_BASE + 2
ACIA_CTRL = ACIA_BASE + 3

MIDI_BASE   = $FF80
MIDI_DATA = MIDI_BASE
MIDI_STATUS = MIDI_BASE + 1
MIDI_CMD = MIDI_BASE + 2
MIDI_CTRL = MIDI_BASE + 3

SOUND_CARD_ADDRESS = $FFA0
REGISTER_ADDRESS = SOUND_CARD_ADDRESS
REGISTER_DATA = SOUND_CARD_ADDRESS + 1

VIA1_BASE   = $FF90
PORTB = VIA1_BASE
PORTA  = VIA1_BASE+1
DDRB = VIA1_BASE+2
DDRA = VIA1_BASE+3


T1CL = VIA1_BASE + 4
T1CH = VIA1_BASE + 5
T1LL = VIA1_BASE + 6
T1LH = VIA1_BASE + 7
ACR = VIA1_BASE + 11
PCR = VIA1_BASE + 12
IFR = VIA1_BASE + 13
IER = VIA1_BASE + 14

COUNTER=12

MIDI_NONE = 0
MIDI_NOTE_ON = 1
MIDI_NOTE_OFF = 2
MIDI_CTRL_CHANGE = 3
MIDI_UNKNOWN = $FF

KON = $20

.macro  printascii   addr
.local @loop
.local @done
    phx
    ldx #0
@loop:
    lda addr,x
    beq @done
    jsr acia_out
    inx
    bra @loop
@done:
    plx
.endmacro

.segment "BSS"
midi_current_command: .res 1
midi_current_note: .res 1
midi_current_vel: .res 1
midi_bytes_left: .res 1
controller_values: .res 120
last_played_note: .res 1
ctrl_tmp: .res 1

.segment "CODE"

timer_init:
    lda IER
    ora #$C0        ;enable interrupt on timer1 timeout
    sta IER
    lda #$40        ; timer one free run mode
    sta ACR
    lda #COUNTER     ; set timer to low byte to calculated value from defined clock speed
    sta T1CL
    stz T1CH        
    stz PORTB
    cli
    rts

ACIA_DELAY = $10
MIDI_DELAY = $10

acia_init:
    sta ACIA_STATUS        ; soft reset (value not important)
                            ; set specific modes and functions
    lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
    sta ACIA_CMD            ; store to the command register
    lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 115.200k baud rate

    sta ACIA_CTRL          ; program the ctl register

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


midi_init:
    sta MIDI_STATUS        ; soft reset (value not important)
                            ; set specific modes and functions
    lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
    sta MIDI_CMD            ; store to the command register
    lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 115.200k baud rate

    sta MIDI_CTRL          ; program the ctl register

    rts

midi_out:
    pha
    phy
    sta MIDI_DATA

    ldy #MIDI_DELAY            ;minimal delay is $02
    jsr delay_short

    ply
    pla
    rts

midi_getc:
    lda MIDI_STATUS                 ; Read the ACIA status to   
    and #$08                        ; Check if there is character in the receiver
    beq @no_char      ; Exit now if we don't get one.
    lda MIDI_DATA
    sec
    rts
@no_char:
    clc
    rts

reset: 
    cld
    lda #$FF
    sta DDRB
    sta DDRA
    lda #$0
    sta PORTB
    
    jsr acia_init
    jsr midi_init
    jsr load_instrument

    lda #'A'
    jsr acia_out
loop:
    jsr midi_getc
    bcc loop
    ; pha
    ; jsr byte_to_ascii
    ; pla
    bmi midi_command
midi_data:
    ; DATA byte in A
    pha
    lda midi_current_command
    cmp MIDI_NOTE_ON
    beq midi_get_note_data
    cmp MIDI_NOTE_OFF
    beq midi_get_note_data
    cmp MIDI_CTRL_CHANGE
    beq midi_get_controller_data
    bra midi_data_end
midi_get_note_data:
    lda midi_bytes_left
    beq midi_prep_next_data
    cmp #2                  ; two bytes left, this is the note
    beq midi_save_note
    cmp #1                  ; one byte left, this is the velocity
    beq midi_save_vel
    bra midi_data_end       ; unknown number of bytes, skip
midi_get_controller_data:
    lda midi_bytes_left
    beq midi_prep_next_data
    cmp #2                  ; two bytes left, this is the controller number
    beq midi_save_ctrl_num
    cmp #1                  ; one byte left, this is the controller value
    beq midi_save_ctrl_value
    bra midi_data_end       ; unknown number of bytes, skip
midi_save_ctrl_num:
    plx                     ; put controller number in X
    dec midi_bytes_left
    phx
    bra midi_data_end
midi_save_ctrl_value:
    pla
    sta controller_values, x
    pha
    jsr midi_show_controller_data
    dec midi_bytes_left
    bra midi_prep_next_data
midi_save_vel:
    pla
    sta midi_current_vel
    pha
    ; We have the note and the velocity, play the note
    jsr midi_play_note
    dec midi_bytes_left
    bra midi_prep_next_data
midi_save_note:
    pla
    sta midi_current_note
    pha
    dec midi_bytes_left
    bra midi_data_end
midi_prep_next_data:
    lda #2
    sta midi_bytes_left
midi_data_end:
    pla
    bra midi_end

midi_command:
    
    ; Command byte in A
    cmp #$FE
    beq midi_keepalive
    and #$F0
    cmp #$90
    beq midi_note_on
    cmp #$80
    beq midi_note_off
    cmp #$B0
    beq midi_ctrl
midi_unknown:
    lda MIDI_UNKNOWN
    sta midi_current_command
    lda #0
    sta midi_bytes_left
    bra midi_end
midi_note_on:
    lda MIDI_NOTE_ON
    sta midi_current_command
    lda #2
    sta midi_bytes_left
    bra midi_end
midi_note_off:
    lda MIDI_NOTE_OFF
    sta midi_current_command
    lda #2
    sta midi_bytes_left
    bra midi_end
midi_ctrl:
    lda MIDI_CTRL_CHANGE
    sta midi_current_command
    lda #2
    sta midi_bytes_left
    bra midi_end
midi_keepalive:
    lda MIDI_NONE
    sta midi_current_command
    lda #0
    sta midi_bytes_left
    bra midi_end

midi_end:

    ; output data from ACIA
    ;jsr byte_to_ascii
    jmp loop


midi_play_note:
    pha
    lda midi_current_vel
    beq play_note_off
    ; printascii midi_note_on_msg
    ; lda #' '
    ; jsr acia_out
    lda midi_current_note
    ; pha
    jsr play_midi_note
    ; pla
    ; jsr byte_to_ascii
    ; lda #' '
    ; jsr acia_out
    ;lda midi_current_vel
    ; jsr byte_to_ascii
    bra midi_play_end
play_note_off:
    ; printascii midi_note_off_msg
    ; lda #'-'
    ; jsr acia_out
    lda midi_current_note
    ; pha
    ; jsr byte_to_ascii
    ; pla
    jsr stop_midi_note
midi_play_end:
    ; lda #$0A
    ; jsr acia_out
    ; lda #$0D
    ; jsr acia_out
    pla
    rts

midi_show_controller_data:
    ; controller number is in X
    ; controller value is in controller_values, x
    phx
    cpx #$0A            ; 0A is attack
    beq @attack_decay
    cpx #$0B             ; 0B is decay
    beq @attack_decay
    cpx #$07             ; 07 is volume
    beq @volume
    bra @exit
@volume:
    sec
    lda #127     ; load current volume
    sbc controller_values + $07
    lsr                             ; move one bit left since top bit is always zero
    ldx #$40
    jsr set_reg
    ldx #$43
    jsr set_reg
    plx
    bra @exit
@attack_decay:
    lda controller_values + $0B     ; load current decay
    lsr ; keep only the 4 most significant bits
    lsr
    lsr
    sta ctrl_tmp
    lda controller_values + $0A     ; load current attack
    asl                             ; move one bit left since top bit is always zero
    and #$F0                        ; keep only high bits
    ora ctrl_tmp
    ldx #$60
    jsr set_reg
    ldx #$63
    jsr set_reg
    ; pha
    ; jsr byte_to_ascii
    ; pla
    plx
@exit:
    ; plx
    ; pha
    ; printascii midi_ctrl_msg
    ; txa
    ; jsr byte_to_ascii
    ; lda controller_values, x
    ; jsr byte_to_ascii
    ; lda #$0A
    ; jsr acia_out
    ; lda #$0D
    ; jsr acia_out
    ; pla
    rts

midi_note_on_msg: .asciiz "Note on"
midi_note_off_msg: .asciiz "Note off"
midi_ctrl_msg: .asciiz "Ctrl change"
v_irq:
    pha
    ; lda #'I'
    ; jsr acia_out
    ; lda IFR
    ; bpl irq_exit  ; Interrupt not from VIA, exit
    ; and #$40
    ; beq irq_exit
v_irq_timer:
    lda T1CL  
    ; clear timer interrupt
    inc PORTB
irq_exit:
    pla
    rti



byte_to_ascii:
; """Convert byte in A to two ASCII hex digits and EMIT them"""
.scope
    pha
    lsr             ; convert high nibble first
    lsr
    lsr
    lsr
    jsr _nibble_to_ascii
    pla

    ; fall through to _nibble_to_ascii

_nibble_to_ascii:
; """Private helper function for byte_to_ascii: Print lower nibble
; of A and and EMIT it. This does the actual work.
; """
    and #$0F
    ora #'0'
    cmp #$3A        ; '9+1
    bcc @1
    adc #$06

@1:             
    jsr acia_out

    rts
.endscope

; register address is in X
; register data is in A
set_reg:
    stx REGISTER_ADDRESS
    ldy #$10
    jsr delay_short
    sta REGISTER_DATA

    ldy #$10
    jsr delay_short
    rts

play_midi_note:
    ; the midi note to play is in A
    ; cmp last_played_note
;     bne @play
;     jsr kill_note
; @play:
    sta last_played_note    ; save it temporalily for legato
    asl                     ; multiply note by two because we have 2 bytes per note
    tax
    phx
    lda midi_freqs, x   ; this loads the low byte (which come first in memory)
    ldx #$A0            ; this is the low byte of the frequency
    jsr set_reg
    plx
    inx                 ; this will get high byte of word, 
    lda midi_freqs, x   ; containing the rest of the freq and the block number
    ora #KON
    ldx #$B0            ; put it in the proper register
    jsr set_reg
    rts

stop_midi_note:
    cmp last_played_note        ; only stop note if it is the note currently playing
    bne stop_exit
kill_note:
    lda #0
    ldx #$B0
    jsr set_reg
stop_exit:
    rts


load_instrument:
    ldx #$20
    lda BANJO1
    jsr set_reg
    ldx #$40
    lda BANJO1+1
    jsr set_reg
    ldx #$60
    lda BANJO1+2
    jsr set_reg
    ldx #$80
    lda BANJO1+3
    jsr set_reg
    ldx #$C0
    lda BANJO1+4
    jsr set_reg

    ldx #$23
    lda BANJO1+5
    jsr set_reg
    ldx #$43
    lda BANJO1+6
    jsr set_reg
    ldx #$63
    lda BANJO1+7
    jsr set_reg
    ldx #$83
    lda BANJO1+8
    jsr set_reg
    ldx #$C3
    lda BANJO1+9
    jsr set_reg

    ldx #$E0
    lda BANJO1+10
    jsr set_reg
    rts

BANJO1:   .byte $00, $31, $87, $A1, $11, $08, $16, $80, $7D, $43, $00

; this array starts at midi note 0 and goes up to 127
; the low byte of each word is the calculated frequency number
; the high byte of the word is the block number
midi_freqs:
.word $AD
.word $B7
.word $C2
.word $CD
.word $D9
.word $E6
.word $F4
.word $102
.word $112
.word $122
.word $133
.word $145
.word $159
.word $16D
.word $183
.word $19A
.word $1B2
.word $1CC
.word $1E8
.word $205
.word $224
.word $244
.word $267
.word $28B
.word $2B2
.word $2DB
.word $306
.word $334
.word $365
.word $399
.word $3CF
.word $205 | $400
.word $223 | $400
.word $244 | $400
.word $266 | $400
.word $28B | $400
.word $2B2 | $400
.word $2DB | $400
.word $306 | $400
.word $334 | $400
.word $365 | $400
.word $399 | $400
.word $3CF | $400
.word $205 | $800
.word $223 | $800
.word $244 | $800
.word $266 | $800
.word $28B | $800
.word $2B2 | $800
.word $2DB | $800
.word $306 | $800
.word $334 | $800
.word $365 | $800
.word $399 | $800
.word $3CF | $800
.word $205 | $C00
.word $223 | $C00
.word $244 | $C00
.word $266 | $C00
.word $28B | $C00
.word $2B2 | $C00
.word $2DB | $C00
.word $306 | $C00
.word $334 | $C00
.word $365 | $C00
.word $399 | $C00
.word $3CF | $C00
.word $205 | $1000
.word $223 | $1000
.word $244 | $1000
.word $266 | $1000
.word $28B | $1000
.word $2B2 | $1000
.word $2DB | $1000
.word $306 | $1000
.word $334 | $1000
.word $365 | $1000
.word $399 | $1000
.word $3CF | $1000
.word $205 | $1400
.word $223 | $1400
.word $244 | $1400
.word $266 | $1400
.word $28B | $1400
.word $2B2 | $1400
.word $2DB | $1400
.word $306 | $1400
.word $334 | $1400
.word $365 | $1400
.word $399 | $1400
.word $3CF | $1400
.word $205 | $1800
.word $223 | $1800
.word $244 | $1800
.word $266 | $1800
.word $28B | $1800
.word $2B2 | $1800
.word $2DB | $1800
.word $306 | $1800
.word $334 | $1800
.word $365 | $1800
.word $399 | $1800
.word $3CF | $1800
.word $205 | $1C00
.word $223 | $1C00
.word $244 | $1C00
.word $266 | $1C00
.word $28B | $1C00
.word $2B2 | $1C00
.word $2DB | $1C00
.word $306 | $1C00
.word $334 | $1C00
.word $365 | $1C00
.word $399 | $1C00
.word $3CF | $1C00






















    .include "../fos/platform/planck/drivers/delayroutines.s"
    .segment "ROM_VECTORS"  
nmivec: 
    .WORD  reset
resvec:
    .WORD  reset
irqvec:
    .WORD  v_irq 
