; .segment "BSS"
; FAT_FILE_NAME_TMP: .res 12


.segment "CODE"

fat_convert_filename:
	; file name address to transform is in editor3
	; file name length is in editor2
	phy
	phx
	ldy #0                  ; Y will be used to index original string
	ldx #0                  ; and X to index transformed string
@transform_name_loop:           ; transform file.txt filename format to FAT16 format
	cpy editor2 				; if Y is bigger than the length of the file name
	bcs @load20					; load $20 instead
	lda (editor3), y			; otherwise, load next character
	bra @compare				; and go to compare it
@load20:
	lda #$20					; load $20 instead
@compare:
	cmp #'.'					; if it's a dot
	beq @is_dot					; handle the dot
	cmp #'A'					; if it is a lowercase character
	bcc @save_char				; convert to uppercase
	and #$DF

@save_char:
	sta FAT_FILE_NAME_TMP, x        ; no dot yet, copy character
	iny
	inx
	cpx #11
	bcc @transform_name_loop        ; Do next character
	bra @end_trans                  ; We have reached the 11th character for the new string

@is_dot:                            ; we have a dot in the original string
	cpx #2							; do not replace first 2 dots
	bcc @save_char
	lda #$20                        ; fill the new string until 8 characters have been done
@dont_replace:
	sta FAT_FILE_NAME_TMP, x
	inx
	cpx #8
	bcc @is_dot                     ; if we have not reached 8 chars yet, keep adding spaces
	iny
	bra @transform_name_loop        ; once we reached 8 characters, go back to do extension

@end_trans:							; exit with transformed file name in FAT_FILE_NAME_TMP
	plx
	ply
	rts


fat_find_file:
	; file name to search should be in FAT_FILE_NAME_TMP
	phy

	cp16 CF_CURRENT_DIR_SEC, CF_LBA
	cp16 CF_CURRENT_DIR_SEC + 2, CF_LBA + 2
	jsr cf_read_sector

	lda #<FAT_BUFFER
	sta editor2
	lda #>FAT_BUFFER
	sta editor2 + 1

	
@outerloop:
	ldy #0
	lda (editor2), y                ; load first caracter of file name
	beq @exit                       ; if zero, it means we reached the end of the list
	cmp #$E5
	beq @next_entry                 ; if $E5, it means the entry is deleted, so go to next entry
@loop:
	lda (editor2), y                ; load current filename character
	cmp FAT_FILE_NAME_TMP, y        ; compare it we the searched filename
	bne @next_entry                 ; as soon as they are not the same, go to the next entry
	iny                             ; increase pointer to character
	cpy #11                         ; compare with the total filename length
	bcc @loop                       ; if y is less than the filename string length, keep going
	bra @exit_found                 ; otherwise, it means we compared all characters of the file name and they all match
@next_entry:
	add16 editor2, fat_entry_size, editor2  ; add 32 to the current entry pointer
	bra @outerloop                          ; process next entry
@exit_found:
	sec
	bra @exit_end
@exit:
	clc
@exit_end:

	ply

	rts

fat_get_sector_for_cluster:
	stz CF_CURRENT_DIR_SEC
	stz CF_CURRENT_DIR_SEC + 1
	stz CF_CURRENT_DIR_SEC + 2
	stz CF_CURRENT_DIR_SEC + 3
	; cluster number is in CF_CURRENT_CLUSTER
	; Given any valid data cluster number N, the sector number of the first sector of that cluster (again relative to sector 0 of the FAT volume) is computed as follows:
	; FirstSectorofCluster = ((N – 2) * BPB_SecPerClus) + FirstDataSector;
	; (CF_CURRENT_CLUSTER - 2) * CF_SEC_PER_CLUS + CF_FIRST_DATA_SEC
	cp16 CF_CURRENT_CLUSTER, CF_CURRENT_DIR_SEC
	lda CF_CURRENT_DIR_SEC
	bne @notzero
	lda CF_CURRENT_DIR_SEC + 1
	bne @notzero
	lda CF_CURRENT_DIR_SEC + 2
	bne @notzero
	lda CF_CURRENT_DIR_SEC + 3
	bne @notzero

	; current cluster is zero, which means the root directory
	cp16 CF_FIRST_ROOT_SEC, CF_CURRENT_DIR_SEC
	rts
@notzero:
	dec16 CF_CURRENT_DIR_SEC
	dec16 CF_CURRENT_DIR_SEC
	lda CF_SEC_PER_CLUS			; load sectors per cluster
@shiftleft:
	lsr							; rotate right
	beq @shifted				; if we haven't shifted far enough, do it again

	asl CF_CURRENT_DIR_SEC
    rol CF_CURRENT_DIR_SEC + 1
	rol CF_CURRENT_DIR_SEC + 2
	rol CF_CURRENT_DIR_SEC + 3
	bra @shiftleft
@shifted:
	clc
	lda CF_CURRENT_DIR_SEC		; finally, add first data sector
	adc CF_FIRST_DATA_SEC
	sta CF_CURRENT_DIR_SEC
	lda CF_CURRENT_DIR_SEC + 1
	adc CF_FIRST_DATA_SEC + 1
	sta CF_CURRENT_DIR_SEC + 1
	lda CF_CURRENT_DIR_SEC + 2
	adc #0
	sta CF_CURRENT_DIR_SEC + 2
	lda CF_CURRENT_DIR_SEC + 3
	adc #0
	sta CF_CURRENT_DIR_SEC + 3

@end:

	rts