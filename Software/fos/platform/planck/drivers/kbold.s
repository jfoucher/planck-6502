
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
