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
.byte K_NO, $5C, $3D,   $20, K_GUI,  K_CTL, K_NO, K_ALT
.byte K_N, K_SFT, K_DOT, K_B, K_COM, K_V, K_M  , K_C
.byte K_J, K_ENT, K_SCLN, K_H, K_L, K_G, K_K, K_F
.byte K_U, K_ENT, K_P, K_Y, K_O, K_T, K_I, K_R
.byte K_7, K_BSPC, K_0, K_6, K_9, K_5, K_8, K_4
.byte K_W, K_3, K_2, K_E, K_1, K_Q, K_ESC, K_TAB
.byte K_Z,   K_D,   K_S, K_X, K_A, K_GRV, K_CAPS, K_SFT

kb_pressed_keys: .res 8
kb_pressed_keys_ptr: .res 1
kb_control_keys: .res 1
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
  sta kb_keypressed
  ; we have the current column in X and the row data in A
  jsr save_pressed_keys
@row_empty:
  inx
  pla

  ror
  bne @scan_col

@exit:
  ; is no pressed key, reset prev key
  lda kb_keypressed
  bne @exit_nokey
  stz kb_prev_char
  stz PORTA
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

kb_get_char:
  phx
  ; for each position in kb_pressed_keys
  ; check if it is a control character
  
  ; TEST
  ; if we have something in the first element of the buffer, set carry and put it in A
  ldx kb_pressed_keys
  beq @no_key
  lda keymap, x
  cmp kb_prev_char  ; if it's the same as a previous character
  beq @no_char      ; do not output
  sta kb_prev_char
  sta PORTA
  stz kb_pressed_keys
  stz kb_time
  plx
  sec
  rts
@no_key:        ; no key is pressed, unset kb_prev_char
@no_char:
  stz kb_pressed_keys
  plx
  clc
  rts