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
K_BSLH = $5C;
K_EQL = $3D
K_SPC = $20;
K_GRV = $60;
K_COM = $2C;
K_SCLN = $3B;
K_ESC = $1B;
K_ENT = $0A
K_TAB = 9;
K_DOT = $2E
K_0 = $30;
K_1 = $31;
K_2 = $32;
K_3 = $33;
K_4 = $34;
K_5 = $35;
K_6 = $36;
K_7 = $37;
K_8 = $38;
K_9 = $39;
K_A = $61;
K_B = $62;
K_C = $63;
K_D = $64
K_E = $65
K_F = $66
K_G = $67
K_H = $68
K_I = $69
K_J = $6A
K_K = $6B
K_L = $6C
K_M = $6D
K_N = $6E;
K_O = $6F
K_P = $70
K_Q = $71
K_R = $72
K_S = $73
K_T = $74
K_U = $75
K_V = $76;
K_W = $77;
K_X = $78
K_Y = $79
K_Z = $7A;

KB_COUNTER = CLOCK_SPEED/512

keymap:
.byte K_NO, K_BSLH, K_EQL, K_SPC, K_GUI,  K_CTL, K_NO, K_ALT
.byte K_N, K_SFT, K_DOT, K_B, K_COM, K_V, K_M  , K_C
.byte K_J, K_ENT, K_SCLN, K_H, K_L, K_G, K_K, K_F
.byte K_U, K_ENT, K_P, K_Y, K_O, K_T, K_I, K_R
.byte K_7, K_BSPC, K_0, K_6, K_9, K_5, K_8, K_4
.byte K_W, K_3, K_2, K_E, K_1, K_Q, K_ESC, K_TAB
.byte K_Z,   K_D,   K_S, K_X, K_A, K_GRV, K_CAPS, K_SFT

shifted_keymap:
.byte K_BSLH, K_EQL, K_SPC, K_GUI,  K_CTL, K_NO, K_ALT
.byte K_N-$20, K_SFT, K_DOT, K_B-$20, K_COM, K_V-$20, K_M-$20  , K_C-$20
.byte K_J-$20, K_ENT, K_SCLN, K_H-$20, K_L-$20, K_G-$20, K_K-$20, K_F-$20
.byte K_U-$20, K_ENT, K_P-$20, K_Y-$20, K_O-$20, K_T-$20, K_I-$20, K_R-$20
.byte K_7, K_BSPC, K_0, K_6, K_9, K_5, K_8, K_4
.byte K_W-$20, K_3, K_2, K_E-$20, K_1, K_Q-$20, K_ESC, K_TAB
.byte K_NO, K_Z-$20,   K_D-$20,   K_S-$20, K_X-$20, K_A-$20, K_GRV, K_CAPS, K_SFT

KB_SHIFT_MASK = 1
KB_ALT_MASK = 2
KB_CTL_MASK = 4
kb_pressed_keys: .res 8
kb_pressed_keys_ptr: .res 1
kb_control_keys_mask: .res 1
kb_time: .res 1
kb_prev_char: .res 1
kb_keypressed: .res 1

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
  stz kb_pressed_keys
  stz kb_pressed_keys+1
  stz kb_pressed_keys+2
  stz kb_pressed_keys+3
  stz kb_pressed_keys+4
  stz kb_pressed_keys+5
  stz kb_pressed_keys+6
  stz kb_pressed_keys+7
  stz kb_time
  stz kb_prev_char
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
  ; set pressed keys pointer to zero
  stz kb_pressed_keys_ptr
  inc kb_time               ; increment elasped time
  bpl @repeat_not_expired
  ; if enough time has passed (kb_time > 128), erase prev char
  stz kb_prev_char
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
  beq @row_empty

  ; we have the current column in X and the row data in A
  jsr save_pressed_keys
  inc kb_pressed_keys_ptr
@row_empty:
  inx
  pla

  ror
  bne @scan_col

@exit:

@exit_nokey:
  ply
  plx
@rts:
  rts


;key_number = self.len_cols * row + col

save_pressed_keys:
  ; current col is in X
  ; current row data is in A
  ; multiply X by 8 while ror A carry is unset
  clc
  stx kb_temp_var ; save original column number
  ldx #$FF          ; start with row -1 so that the first time through it gets to 0
@ror_loop:
  inx
  ror
  bcc @ror_loop   ; we don't have a keypress yet, keep looping
; we have a key pressed on col X and row Y
; multiply row by 8
  txa
  clc
  asl
  asl
  asl   ; A now contains row * 8
  clc
  adc kb_temp_var  ; add current column to it
  ldx kb_pressed_keys_ptr
  sta kb_pressed_keys, x  ; save current key position in keymap
  inc kb_pressed_keys_ptr
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
  bne @no_control_key
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
  stz kb_prev_char
  
@exit: 
  pla
  rts

kb_get_char:
  sei     ; prevent interrupts from hitting in the middle of this routine
  phx
  phy


  jsr control_key_mask
  ; set control keys mask
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
  cmp kb_prev_char  ; if it's the same as a previous character
  beq @no_char      ; do not output
  sta kb_prev_char
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

