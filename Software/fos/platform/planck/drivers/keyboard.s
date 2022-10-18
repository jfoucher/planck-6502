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


KB_COUNTER = CLOCK_SPEED/2048

; keymap:
; .byte K_NO, '=', '/', ' ', K_ALT,  K_CTL, K_NO, K_GUI
; .byte 'n', K_SFT, '.', 'b', ',', 'v', 'm'  , 'c'
; .byte 'j', K_ENT, ';', 'h', 'l', 'g', 'k', 'f'
; .byte 'u', K_ENT, 'p', 'y', 'o', 't', 'i', 'r'
; .byte '7', K_BSPC, '0', '6', '9', '5', '8', '4'
; .byte 'w', '3', '2', 'e', '1', 'q', K_ESC, K_TAB
; .byte 'z',   'd',   's', 'x', 'a', '`', K_CAPS, K_SFT

; shifted_keymap:
; .byte K_NO, '+', '?', ' ', K_ALT,  K_CTL, K_NO, K_GUI
; .byte 'N', K_SFT, '>', 'B', '<', 'V', 'M'  , 'C'
; .byte 'J', K_ENT, ':', 'H', 'L', 'G', 'K', 'F'
; .byte 'U', K_ENT, 'P', 'Y', 'O', 'T', 'I', 'R'
; .byte '&', K_BSPC, ')', '^', '(', '%', '*', '$'
; .byte 'W', '#', '@', 'E', '!', 'Q', K_ESC, K_TAB
; .byte 'Z',   'D',   'S', 'X', 'A', '~', K_CAPS, K_SFT


KB_SHIFT_MASK = 1
KB_ALT_MASK = 2
KB_CTL_MASK = 4
kb_pressed_keys: .res 64
kb_pressed_keys_ptr: .res 1
kb_control_keys_mask: .res 1
kb_time: .res 1
kb_prev_char: .res 8
kb_keypressed: .res 1

kb_buffer_write_pointer: .res 1

;Initialize the VIA for keyboard scanning
kb_init:
  sei
  ; Set PORTA as ouput for cols
  lda #$FF
  sta KB_DDRA
  ; Set PORTB as input for rows
  stz KB_DDRB
  ; reset key buffer

  stz kb_pressed_keys_ptr
  ldx #$40
@reset_loop:
  stz kb_pressed_keys, x
  dex
  bne @reset_loop
  
  stz kb_time
  stz kb_prev_char
  stz kb_prev_char+1
  stz kb_prev_char+2
  stz kb_prev_char+3
  stz kb_prev_char+4
  stz kb_prev_char+5
  stz kb_prev_char+6
  stz kb_prev_char+7
  stz kb_keypressed
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

; Outputs are cols, inputs are rows
; We have 8 cols and 7 rows
; add pulldowns to rows
; COLS are on PORTB
kb_scan:
  ; inc kb_time
  ; bne @rts
  phx
  phy
  stz kb_keypressed
  ; stz kb_pressed_keys
  ; stz kb_pressed_keys+1
  ; stz kb_pressed_keys+2
  ; stz kb_pressed_keys+3
  ; stz kb_pressed_keys+4
  ; stz kb_pressed_keys+5
  ; stz kb_pressed_keys+6
  ; stz kb_pressed_keys+7
  ; set pressed keys pointer to zero
  ;stz kb_pressed_keys_ptr
  inc kb_time               ; increment elasped time
  lda kb_time
  cmp #$20
  bcc @repeat_not_expired
  ; if enough time has passed (kb_time > 128), erase prev char
  stz kb_prev_char
  stz kb_prev_char+1
  stz kb_prev_char+2
  stz kb_prev_char+3
  stz kb_prev_char+4
  stz kb_prev_char+5
  stz kb_prev_char+6
  stz kb_prev_char+7
  stz kb_time
@repeat_not_expired:
  ; start with $40 in A and unset carry to be able to ROR
  clc
  lda #$80
  ldx #0
@scan_col:
  sta KB_PORTA
  pha
  lda KB_PORTB
  ;beq @row_empty

  ; we have the current column in X and the row data in A
  jsr save_pressed_keys
  
@row_empty:
  inx
  pla

  ror
  bne @scan_col

@exit:
  ; We have all pressed keys,
  ; check modifier keys
  ; and put the character in a buffer
  ; but only if the previous character is different,
  ; or all non modifier keys have been released,
  ; or the timer has elapsed


@exit_nokey:
  ply
  plx
@rts:
  rts


; TODO try to have an array of 64 bytes,
; and populate it with a value if the key is pressed, and zero if not pressed
;key_number = self.len_cols * row + col

save_pressed_keys:
  phx
  ; current col is in X
  ; current row data is in A
  ; multiply X by 8 while ror A carry is unset
  stx kb_temp_var ; save original column number
  ldx #$FF          ; start with row -1 so that the first time through it gets to 0
@ror_loop:
  inx
  cpx #7
  bcs @exit
  clc
  ror
  bcc @ror_loop   ; we don't have a keypress yet, keep looping

; we have a key pressed on col X and row Y

  pha
  txa
  jsr save_pressed_key ; restores X
  pla   ; restore what is left of current row data
  ; if x if less than 8, keep going to see if other keys are pressed on this column
  cpx #7
  bcc @ror_loop
@exit:
  clc
  plx
  rts

save_pressed_key:
  ; Current row is in A
  ; current col is in kb_temp_var
  ; multiply row by 8
  phx
  clc
  asl
  asl
  asl   ; A now contains row * 8
  clc
  adc kb_temp_var  ; add current column to it

  ; A now contains the character position in the keymap
  tax
  sta kb_pressed_keys, x  ; save current key position in keymap
  plx
  rts

control_key_mask:
; for each position in kb_pressed_keys
; check if it is a control character
  stz kb_control_keys_mask
  ldx #0
@control_loop:
  ; stz kb_pressed_keys, x
  ; bra @no_control_key
  ldy kb_pressed_keys, x
  beq @no_control_key
  lda keymap, y
  cmp #K_SFT
  bne @no_shift_key
  stz kb_pressed_keys, x
  sta PORTB
  pha
  lda #KB_SHIFT_MASK
  ora kb_control_keys_mask
  sta kb_control_keys_mask
  pla
  bra @no_control_key
@no_shift_key:
  cmp #K_ALT
  bne @no_alt_key
  pha
  lda #KB_ALT_MASK
  ora kb_control_keys_mask
  sta kb_control_keys_mask
  stz kb_pressed_keys, x
  pla
  bra @no_control_key
@no_alt_key:
  cmp #K_CTL
  bne @no_control_key
  pha
  lda #KB_CTL_MASK
  ora kb_control_keys_mask
  sta kb_control_keys_mask
  stz kb_pressed_keys, x
  pla
@no_control_key:
  inx
  cpx #8
  bcc @control_loop
  rts

kb_clear_prev_char:
  pha
  lda #$55
  sta PORTA
  ; if no pressed key, reset prev key
  lda kb_pressed_keys
  bne @exit
  lda kb_pressed_keys+1
  bne @exit
  lda kb_pressed_keys+2
  bne @exit
  lda kb_pressed_keys+3
  bne @exit
  lda kb_pressed_keys+4
  bne @exit
  lda kb_pressed_keys+5
  bne @exit
  lda kb_pressed_keys+6
  bne @exit
  lda kb_pressed_keys+7
  bne @exit
  lda kb_pressed_keys+8
  bne @exit
  lda #0
  sta PORTA
  stz kb_prev_char
  stz kb_prev_char+1
  stz kb_prev_char+2
  stz kb_prev_char+3
  stz kb_prev_char+4
  stz kb_prev_char+5
  stz kb_prev_char+6
  stz kb_prev_char+7
  
@exit: 
  pla
  rts

is_prev_char:
; check in all prev chars to see if we have used it recently
; carry set if char already exists
  cmp kb_prev_char
  beq @exit_exists
  cmp kb_prev_char+1
  beq @exit_exists
  cmp kb_prev_char+2
  beq @exit_exists
  cmp kb_prev_char+3
  beq @exit_exists
  cmp kb_prev_char+4
  beq @exit_exists
  cmp kb_prev_char+5
  beq @exit_exists
  cmp kb_prev_char+6
  beq @exit_exists
  cmp kb_prev_char+7
  beq @exit_exists
@exit_not_exists:
  clc
  rts
@exit_exists:
  sec
  rts

kb_get_char:
  sei     ; prevent interrupts from hitting in the middle of this routine
  phx
  phy

  ; set control keys mask, removing control keys
  jsr control_key_mask
  
  jsr kb_clear_prev_char

; We now have the control keys in kb_control_keys_mask
; Loop again, using other keycode tables

  ; TEST
  ; if we have something in the element of the buffer, set carry and put it in A
  ldx #0
@output_loop:
  ldy kb_pressed_keys, x
  beq @no_key
  lda kb_control_keys_mask
  and #KB_SHIFT_MASK
  beq @normal_char
  lda shifted_keymap, y
  bra @shifted_char
@normal_char:
  lda keymap, y
@shifted_char:
  jsr is_prev_char
  bcs @no_char      ; do not output
  sta kb_prev_char, x
  stz kb_pressed_keys, x
  stz kb_time
  ply
  plx
  cli
  sec
  rts
@no_key:
@no_char:
  stz kb_pressed_keys, x
  inx
  cpx #8
  bcc @output_loop

@no_char_exit:
  ply
  plx
  cli
  clc
  rts

max_key_rollover = 4

.segment "ZEROPAGE": zeropage
new_keys: .byte 0, 0, 0, 0
key_quantity: .res 1
buffer_quantity: .byte $ff
keys: .byte 0, 0, 0, 0
.segment "DATA"

old_keys: .byte 0, 0, 0, 0


scan_result: .res 8
too_many_keys: .res 1
simultaneous_keys: .res 1

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


keymap:
.byte K_NO, K_NO, K_TAB, '4', 'r', 'f', 'c', K_NO  ; COL 1
.byte K_NO, K_ESC, K_TAB, '8', 'i', 'k', 'm', K_NO   ; COL 2
.byte K_NO, '`', 'q', '5', 't', 'g', 'v', K_NO, K_NO   ; COL 3
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' ', K_NO   ; COL 4
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' ', K_NO   ; COL 5
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' ', K_NO   ; COL 6
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' ', K_NO   ; COL 7
.byte K_NO, 'x', 'e', '6', 'y', 'h', 'b', ' ', K_NO   ; COL 8

shifted_keymap:
.byte K_NO, K_NO, K_TAB, '$', 'R', 'F', 'C', K_NO   ; COL 1
.byte K_NO, K_ESC, K_TAB, '*', 'I', 'K', 'M', K_NO   ; COL 2

kb_get_char_2:
  phx
  phy
  
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
  lda #1
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+7
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+6
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+5
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+4
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+3
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+2
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result+1
  asl
  sta KB_PORTA
  ldy KB_PORTB
  sty scan_result
  ;reset read buffer
  stz new_keys
  stz new_keys+1
  stz new_keys+2
  stz new_keys+3
  ; set max allowed keys presses
  lda #max_key_rollover
  sta key_quantity

  lda #($FF - (max_key_rollover-1))
  sta simultaneous_keys
  ; Scan complete
  ; TODO check for control keys
  ; lda scan_result+7
  ; and #$1
  ; beq @no_shift
  ; sta kb_control_keys_mask

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
  dec key_quantity
  bmi overflow
  pha
  ;txa
  ldy keymap,x
  ldx key_quantity
  sty new_keys,x
  ;sta new_keys,x
  pla
  plx
  rts

overflow:
  pla  ; Dirty hack to handle 2 layers of JSR
  pla
  pla
  pla
  lda #0
  clc
  rts