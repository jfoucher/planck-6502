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

K_NO = 0;
K_GUI = 1;
K_SFT = 2;
K_CTL = 3;
K_ALT = 4;
K_CAPS = 5;
K_BSPC = $08;
K_TAB = 9;
K_ENT = $0A
K_ESC = $1B;
K_SCLN = $3B


KB_COUNTER = CLOCK_SPEED/2048


max_key_rollover = 4

.segment "ZEROPAGE": zeropage
new_keys: .byte 0, 0, 0, 0, 0, 0, 0, 0
kb_time: .res 1
keys: .byte 0, 0, 0, 0, 0, 0, 0, 0

.segment "BSS"
key_quantity: .res 1
buffer_quantity: .res 1
old_keys: .res 8


scan_result: .res 8
too_many_keys: .res 1
simultaneous_keys: .res 1
kb_control_keys_mask: .res 1

.segment "RODATA"

keymap:
          ; SHIFT                             CTRL
.byte K_NO, K_NO,  K_TAB, '4', 'r', 'f', 'c', K_NO  ; COL 1
          ; CAPS
.byte K_NO, K_NO, K_ESC, '8', 'i', 'k', 'm', K_NO   ; COL 2
; $10                                     WIN
.byte K_NO, '`', 'q', '5', 't', 'g', 'v', K_NO   ; COL 3
; $18                                      ALT
.byte K_NO, 'a', '1', '9', 'o', 'l', ',',  K_NO   ; COL 4
; $20
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' '   ; COL 5
;$28
.byte K_NO, 's', '2', '0', 'p', K_SCLN, '.', '/'   ; COL 6
; $30                                      RSHIFT FN
.byte K_NO, 'd', '3', K_BSPC, K_ENT, K_NO, K_NO, K_NO   ; COL 7
; $38
.byte K_NO, 'z', 'w', '7', 'u', 'j', 'n', K_NO   ; COL 8


fn_keymap:
          ; SHIFT                             CTRL
.byte K_NO, K_NO,  K_TAB, '4', 'r', 'f', 'c', K_NO  ; COL 1
          ; CAPS
.byte K_NO, K_NO, K_ESC, '8', 'i', 'k', 'm', K_NO   ; COL 2
; $10                                     WIN
.byte K_NO, '`', 'q', '5', 't', 'g', 'v', K_NO   ; COL 3
; $18                                      ALT
.byte K_NO, 'a', '1', '9', 'o', 'l', ',',  K_NO   ; COL 4
; $20
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' '   ; COL 5
;$28
.byte K_NO, 's', '2', '0', 'p', K_SCLN, '.', '/'   ; COL 6
; $30                                      RSHIFT FN
.byte K_NO, 'd', '3', K_BSPC, K_ENT, K_NO, K_NO, K_NO   ; COL 7
; $38
.byte K_NO, 'z', 'w', '7', 'u', 'j', 'n', K_NO   ; COL 8

shifted_keymap:
          ; SHIFT                             CTRL
.byte K_NO, K_NO,  K_TAB, '$', 'R', 'F', 'C', K_NO  ; COL 1
          ; CAPS
.byte K_NO, K_NO, K_ESC, '*', 'I', 'K', 'M', K_NO   ; COL 2
; $10                                     WIN
.byte K_NO, '~', 'Q', '%', 'T', 'G', 'V', K_NO   ; COL 3
; $18                                      ALT
.byte K_NO, 'A', '!', '(', 'O', 'L', '<',  K_NO   ; COL 4
; $20
.byte K_NO, 'X', 'E', '^', 'Y', 'H', 'B', ' '   ; COL 5
;$28
.byte K_NO, 'S', '@', ')', 'P', K_SCLN, '>', '?'   ; COL 6
; $30                                      RSHIFT FN
.byte K_NO, 'D', '#', K_BSPC, K_ENT, K_NO, K_NO, K_NO   ; COL 7
; $38
.byte K_NO, 'Z', 'W', '&', 'U', 'J', 'N', K_NO   ; COL 8

.segment "DATA"

;Initialize the VIA for keyboard scanning
kb_init:
  sei
  ; Set PORTA as ouput for cols
  lda #$FF
  sta buffer_quantity
  sta KB_DDRA
  ; Set PORTB as input for rows
  stz KB_DDRB
  ; reset key buffer
  stz new_keys
  stz new_keys+1
  stz new_keys+2
  stz new_keys+3
  stz new_keys+4
  stz new_keys+5
  stz new_keys+6
  stz new_keys+7

  stz keys
  stz keys+1
  stz keys+2
  stz keys+3
  stz keys+4
  stz keys+5
  stz keys+6
  stz keys+7

  

  ; set timer
  lda KB_IER
  ora #$C0        ;enable interrupt on timer1 timeout
  sta KB_IER
  lda #$40        ; timer one free run mode
  sta KB_ACR
  lda #<KB_COUNTER     ; set timer to low byte to calculated value from defined clock speed
  sta KB_T1CL
  lda #>KB_COUNTER       ; set timer to high byte to calculated value from defined clock speed
  sta KB_T1CH        
  cli


  rts



nothing_pressed:
  ;stz PORTA
  stz old_keys
  stz old_keys+1
  stz old_keys+2
  stz old_keys+3
  stz too_many_keys
  lda #0
  ply
  plx
  clc
  rts

kb_get_char:
  phx
  phy
  ; ldy #$40
  ; jsr delay_short
  ; check if anything is pressed
  lda #$FF
  sta KB_PORTA
  lda KB_PORTB
  beq nothing_pressed
  ;sta PORTA
  ; make sure we don't have too many keys pressed at once
  lda too_many_keys
  beq @go
  lda #0
  ply
  plx
  clc
  rts
@go:
  ; scan matrix
  SCAN_DELAY = $10
  lda #1
@u1:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+7
  ldy KB_PORTB
  cpy scan_result+7
  bne @u1
  asl
@u2:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+6
  ldy KB_PORTB
  cpy scan_result+6
  bne @u2
  asl
@u3:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+5
  ldy KB_PORTB
  cpy scan_result+5
  bne @u3
  asl
@u4:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+4
  ldy KB_PORTB
  cpy scan_result+4
  bne @u4
  asl
@u5:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+3
  ldy KB_PORTB
  cpy scan_result+3
  bne @u5
  asl
@u6:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+2
  ldy KB_PORTB
  cpy scan_result+2
  bne @u6
  asl
@u7:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+1
  ldy KB_PORTB
  cpy scan_result+1
  bne @u7
  asl
@u8:
  ldy #SCAN_DELAY
  jsr delay_short
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result
  ldy KB_PORTB
  cpy scan_result
  bne @u8
  ;reset read buffer
  stz new_keys
  stz new_keys+1
  stz new_keys+2
  stz new_keys+3
  ; set max allowed keys presses
  lda #max_key_rollover
  sta key_quantity

  stz kb_control_keys_mask

  lda #($FF - (max_key_rollover-1))
  sta simultaneous_keys
  ; Scan complete
  ; TODO check for control keys
  ; left shift
  lda scan_result+7
  and #$40
  bne @shift
  lda scan_result+1
  and #$02
  beq @no_shift
@shift:
  sta kb_control_keys_mask

@no_shift:
  ;

  lda scan_result+7
  beq @1
  ldx #0
  jsr keys_in_row
@1:
  lda scan_result+6
  beq @2
  ldx #8
  jsr keys_in_row
@2:
  lda scan_result+5
  beq @3
  ldx #16
  jsr keys_in_row
@3:
  lda scan_result+4
  beq @4
  ldx #24
  jsr keys_in_row
@4:
  lda scan_result+3
  beq @5
  ldx #32
  jsr keys_in_row
@5:
  lda scan_result+2
  beq @6
  ldx #40
  jsr keys_in_row
@6:
  lda scan_result+1
  beq @7
  ldx #48
  jsr keys_in_row
@7:
  lda scan_result
  beq @8
  ldx #56
  jsr keys_in_row
@8:



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Key Scan Completed

; Put any new key (not in old scan) into buffer
  ldx #max_key_rollover-1
next_key:
  lda new_keys, x
  beq @exist        ; Handle 'null' values
  cmp old_keys
  beq @exist
  cmp old_keys+1
  beq @exist
  cmp old_keys+2
  beq @exist
  cmp old_keys+3
  beq @exist
  cmp old_keys+4
  beq @exist
  cmp old_keys+5
  beq @exist
  cmp old_keys+6
  beq @exist
  cmp old_keys+7
  beq @exist
  ; New Key Detected
  inc buffer_quantity
  ldy buffer_quantity
  sta keys,y
  ; Keep track of how many new Alphanumeric keys are detected
  inc simultaneous_keys
  beq too_many_new_keys
@exist:
  dex
  bpl next_key

  ; Anything in Buffer?
  ldy buffer_quantity
  bmi buffer_empty
  ; Yes: Then return it and tidy up the buffer
  dec buffer_quantity
  lda keys
  ldx keys+1
  stx keys
  ldx keys+2
  stx keys+1
  ldx keys+3
  stx keys+2
  ldx keys+4
  stx keys+3
  ldx keys+5
  stx keys+4
  ldx keys+6
  stx keys+5
  ldx keys+7
  stx keys+6
  stz keys+7
  ; cmp kb_prev_char
  ; beq buffer_empty
  sec
  bra return


buffer_empty:  ;No new Alphanumeric keys to handle.
  lda #0
  clc

return: 
  ; sta kb_prev_char
; Copy BufferNew to BufferOld
  ldx new_keys
  stx old_keys
  ldx new_keys+1
  stx old_keys+1
  ldx new_keys+2
  stx old_keys+2
  ldx new_keys+3
  stx old_keys+3
  ldx new_keys+4
  stx old_keys+4
  ldx new_keys+5
  stx old_keys+5
  ldx new_keys+6
  stx old_keys+6
  ldx new_keys+7
  stx old_keys+7
  ply
  plx
  rts

too_many_new_keys:
    clc
    lda #$ff
    sta buffer_quantity
    sta simultaneous_keys
    lda #$0
    ply
    plx
    rts

keys_in_row:
  asl
  bcc @1
  jsr key_found
@1:
  inx
  asl
  bcc @2
  jsr key_found
@2:
  inx
  asl
  bcc @3
  jsr key_found
@3:
  inx
  asl
  bcc @4
  jsr key_found
@4:
  inx
  asl
  bcc @5
  jsr key_found
@5:
  inx
  asl
  bcc @6
  jsr key_found
@6:
  inx
  asl
  bcc @7
  jsr key_found
@7:
  inx
  asl
  bcc @8
  jsr key_found
@8:

  rts

key_found:
  phx
  stx PORTA
  dec key_quantity
  bmi overflow
  ; pha
  ; txa
  ldy kb_control_keys_mask
  bne @shifted

  ldy keymap,x
  bra @unshifted
@shifted:
  ldy shifted_keymap,x
@unshifted:
  ldx key_quantity
  sty new_keys,x
  ; sta new_keys,x
  ; pla
  plx
  rts

overflow:
  plx
  pla  ; Dirty hack to handle 2 layers of JSR
  pla
  pla
  pla
  ply
  plx
  lda #0
  clc
  rts