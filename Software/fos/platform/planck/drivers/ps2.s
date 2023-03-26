; Copyright 2020 Jonathan Foucher

; Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
; and associated documentation files (the "Software"), to deal in the Software without restriction, 
; including without limitation the rights to use, copy, modify, merge, publish, distribute, 
; sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
; is furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all copies or 
; substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
; PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
; FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
; OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
; DEALINGS IN THE SOFTWARE.

.segment "ZEROPAGE": zeropage

last_ps2_time: .res 4
KB_BUF_W_PTR: .res 1
KB_BUF_R_PTR: .res 1
control_keys: .res 1
character: .res 1

.segment "BSS"
.align 16
KB_BUF: .res 128
KB_STATE: .res 1
KB_TEMP: .res 1
KB_PARITY: .res 1
KB_BIT: .res 1
KB_INIT_STATE: .res 1
KB_INIT_WAIT: .res 1
ready: .res 1
to_send: .res 1
ignore_next: .res 1

.segment "RODATA"

.include "drivers/keycodes.s"

.segment "DATA"

ps2_init:
  sei ; prevent interrupts while initializing
kb_conn_msg:
  ldx #0
kb_conn_loop:
  lda kb_conn_msg_text,x
  beq kb_conn_msg_end
  jsr kernel_putc
  inx
  bra kb_conn_loop
kb_conn_msg_text: .byte "Detecting keyboard", $0D, $00
kb_conn_msg_end:

  lda IER
  ora #$88      ;enable interrupt on neg transition on CB2
  sta IER

  lda #0
  sta PCR
  sta KB_TEMP
  sta KB_BIT
  sta KB_STATE
  sta to_send
  sta KB_PARITY
  sta KB_BUF_W_PTR
  sta KB_BUF_R_PTR
  sta KB_INIT_STATE
  sta KB_INIT_WAIT
  sta ready
  sta ignore_next
  sta character
  jsr clear_buffer
  
  ; jsr kb_reset
  ; jsr kb_leds
  ; jsr kb_leds_data
  ; maybe remove this to make PS2 work ?
  jmp done_init

  lda #KB_INIT_STATE_RESET
  sta KB_INIT_STATE
  cli           ;enable interrupts

@wait1:
  ldy #10
  jsr delay
  inc KB_INIT_WAIT
  beq done_init     ; nothing to show yet
  lda to_send
  bne @wait1       ; do nothing while sending
  
  ;jsr lcd_print
  
  ldx KB_INIT_STATE
  cpx #KB_INIT_STATE_RESET
  beq @do_reset
  cpx #KB_INIT_STATE_RESET_ACK
  beq done_init
  ; beq @self_test_ok  ; Wait for 256 loops with nothing. if still nothing, reset keyboard

  bra done_init
  ;sta PORTA
  ; wait for keyboard self test (#$AA)

@do_reset: 
  jsr kb_reset
  lda #KB_INIT_STATE_RESET_ACK  ; next state should be an acknowledgment
  sta KB_INIT_STATE
  bra @wait1


done_init:
  lda #0
  sta DDRB
  sta PCR
  sta ignore_next
  sta ready
  sta control_keys
  sta to_send
  sta ready
  sta character
  sta KB_TEMP
  sta KB_INIT_STATE
  sta KB_BIT
  sta KB_STATE
  sta KB_BUF_W_PTR
  sta KB_BUF_R_PTR
  jsr clear_buffer
  cli ; enable interrupts again
  rts


kb_reset:
  lda #0
  sta KB_INIT_WAIT
  lda #$F0
  ;sta PORTA
  sei                   ;disable interrupts
  jsr prepare_send
  lda #$FF
  sta to_send
  cli                   ; enable interrupts
  rts

no_kb_msg:
  ldx #0
no_kb_loop:
  lda no_kb_msg_text,x
  beq done_init
  jsr kernel_putc
  inx
  bra no_kb_loop
no_kb_msg_text: .byte "No keyboard connected", $0D, $00


prepare_send:
  pha
  phy
  ; ready to send, pull clock low for a while
  lda #$C0
  sta PCR       ;set CB2 low
  ;delay 
  ldy #$80
  jsr delay
  ; delay end
  ; pull data low now
  lda PORTB
  and #($FF^DATA)
  sta PORTB
  lda DDRB
  ora #DATA   ;data as output to set it low
  sta DDRB
  ldy #$40
  jsr delay
  lda #KB_STATE_DATA    ; no start bit when sending
  sta KB_STATE
  ; release clock
  lda #0
  sta to_send
  sta KB_PARITY
  sta PCR       ;set CB2 to negative edge input
  
  ply
  pla
  rts


reset_ps2:          ; routine called during a timer interrupt to check 
  pha
                    ; if the elasped time since the last ps2 interrupt allows us to reset it
  lda time+3
  cmp last_ps2_time+3
  bcc @reset
  lda time+2
  cmp last_ps2_time+2
  bcc @reset
  lda time+1
  cmp last_ps2_time+1
  bcc @reset
  lda time
  adc #$1
  cmp last_ps2_time
  bcc @reset
@exit2:
  pla
  rts
@reset:
  lda #0
  sta KB_TEMP
  sta KB_BIT
  sta KB_STATE
  sta KB_BUF_W_PTR
  sta KB_BUF_R_PTR
  beq @exit2

clear_buffer:
  phx
  ldx #$84
@clear_loop:
  stz KB_BUF, x
  dex
  bne @clear_loop
  stz KB_BUF
  plx
  rts


ps2_get_char:
    phx                             ; save X
    ldx KB_BUF_R_PTR                ; check the keyboard buffer
    lda KB_BUF, x                   
    ; jsr kernel_putc
    ; pha
    ; txa
    ; jsr kernel_putc
    ; pla
    beq no_ps2_char_available       ; exit if nothing found
    stz KB_BUF, x                   ; if there was a character, reset this buffer cell
    inc KB_BUF_R_PTR                ; and increment the read pointer
    bpl @nomore
    stz KB_BUF_R_PTR
@nomore:
    plx                             ; restore X
    sec                             ; mark character present
    rts                             ; return
no_ps2_char_available:                  ; no keyboard char
    inc KB_BUF_R_PTR                ; increment read pointer for next time
    bpl @nomore
    stz KB_BUF_R_PTR
@nomore:
    plx                             ; restore X
    clc
    rts
  .include "ps2_irq.s"
