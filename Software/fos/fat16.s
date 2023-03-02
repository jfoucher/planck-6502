; .segment "BSS"
; FAT_FILE_NAME_TMP: .res 12


.segment "CODE"

; fat_convert_filename:
; 	; file name address to transform is in editor3
; 	; file name length is in editor2
; 	phy
; 	phx
; 	ldy #0                  ; Y will be used to index original string
; 	ldx #0                  ; and X to index transformed string
; @transform_name_loop:           ; transform file.txt filename format to FAT16 format
; 	cpy editor2 				; if Y is bigger than the length of the file name
; 	bcs @load20					; load $20 instead
; 	lda (editor3), y			; otherwise, load next character
; 	bra @compare				; and go to compare it
; @load20:
; 	lda #$20					; load $20 instead
; @compare:
; 	cmp #'.'					; if it's a dot
; 	beq @is_dot					; handle the dot
; 	sta FAT_FILE_NAME_TMP, x        ; no dot yet, copy character
; 	iny
; 	inx
; 	cpx #11
; 	bcc @transform_name_loop        ; Do next character
; 	bra @end_trans                  ; We have reached the 11th character for the new string

; @is_dot:                                ; we have a dot in the original string
; 	lda #$20                        ; fill the new string until 8 characters have been done
; 	sta FAT_FILE_NAME_TMP, x
; 	inx
; 	cpx #8
; 	bcc @is_dot                     ; if we have not reached 8 chars yet, keep adding spaces
; 	bra @transform_name_loop        ; once we reached 8 characters, go back to do extension

; @end_trans:							; exit with transformed file name in FAT_FILE_NAME_TMP
; 	plx
; 	ply
; 	rts


; fat_find_file:
; 	; file name to search is in editor3
	
; 	cp16 CF_CURRENT_DIR_SEC, CF_LBA
; 	stz CF_LBA + 2
; 	stz CF_LBA + 3
; 	jsr cf_read_sector

; 	lda #<FAT_BUFFER
; 	sta editor2
; 	lda #>FAT_BUFFER
; 	sta editor2 + 1

	
; @outerloop:
; 	ldy #0
; 	lda (editor2), y                ; load first caracter of file name
; 	beq @exit                       ; if zero, it means we reached the end of the list
; 	cmp #$E5
; 	beq @next_entry                 ; if $E5, it means the entry is deleted, so go to next entry
; @loop:
; 	lda (editor2), y                ; load current filename character
; 	cmp FAT_FILE_NAME_TMP, y        ; compare it we the searched filename
; 	bne @next_entry                 ; as soon as they are not the same, go to the next entry
; 	iny                             ; increase pointer to character
; 	cpy #11                         ; compare with the total filename length
; 	bcc @loop                       ; if y is less than the filename string length, keep going
; 	bra @exit_found                 ; otherwise, it means we compared all characters of the file name and they all match
; @next_entry:
; 	add16 editor2, fat_entry_size, editor2  ; add 32 to the current entry pointer
; 	bra @outerloop                          ; process next entry
; @exit_found:
; 	sec
; 	bra @exit_end
; @exit:
; 	clc
; @exit_end:
; 	plx
; 	ply
; 	rts
; 	rts