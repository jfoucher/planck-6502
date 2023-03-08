.segment "BSS"

FAT_LBA: .res 4
FAT_PART_START: .res 4
FAT_CURRENT_DIR_SEC: .res 4
FAT_CURRENT_FILE_SIZE: .res 4
FAT_TMP: .res 4
FAT_CURRENT_CLUSTER: .res 2
FAT_ROOT_ENT_CNT: .res 2     ; $200
FAT_ROOT_DIR_SECS: .res 2    ; $02
FAT_SEC_CNT: .res 2      ; $F5
FAT_FIRST_DATA_SEC: .res 2   ; $022B
FAT_FIRST_ROOT_SEC: .res 2   ; $020B
FAT_SEC_PER_CLUS: .res 1     ; $8
FAT_CURRENT_DIR: .res 12
FAT_FILE_NAME_TMP: .res 12

DISK_BUFFER: .res $200
FAT_BUFFER2: .res $200

.segment "DATA"
.if .def(SD)
io_read_sector_ptr: .word sd_readsector
.elseif .def(CF_ADDRESS)
io_read_sector_ptr: .word cf_read_sector
.endif
fat_entry_size: .byte $20, 0

fat_mounted_error1:
        .asciiz "Error reading boot sector"
fat_mounted_error2:
        .asciiz "Error reading FAT sector"


fat_init:
check_fat_sector_signature:
		stz FAT_LBA
        stz FAT_LBA + 1
        stz FAT_LBA + 2
        stz FAT_LBA + 3
        stz FAT_CURRENT_CLUSTER                  ; reset variables
        stz FAT_CURRENT_CLUSTER + 1
        stz FAT_CURRENT_DIR_SEC
        stz FAT_CURRENT_DIR_SEC + 1
        stz FAT_CURRENT_DIR_SEC + 2
        stz FAT_CURRENT_DIR_SEC + 3

        ; LBA is set, now read sector
        jsr io_read_sector

		; we now have the first sector in DISK_BUFFER
.ifdef check_fat_sector_signature
        ; check signature
        lda DISK_BUFFER + $1FE
        cmp #$55
        bne @sigerr
        lda DISK_BUFFER + $1FF
        cmp #$AA
        beq @sigok
@sigerr:
        jmp fat_init_error
@sigok:
.endif

        ; check if this is MBR or FAT start sector
        lda DISK_BUFFER + 54
        cmp #'F'
        bne @read_fat_sector
        lda DISK_BUFFER + 55
        cmp #'A'
        bne @read_fat_sector
        lda DISK_BUFFER + 56
        cmp #'T'
        bne @read_fat_sector

        bra @is_fat_sector

@read_fat_sector:
        ; read FAT start sector
        ; and save to sector address to read
        lda DISK_BUFFER + 454
        sta FAT_LBA
        sta FAT_PART_START
        lda DISK_BUFFER + 455
        sta FAT_LBA + 1
        sta FAT_PART_START + 1
        lda DISK_BUFFER + 456
        sta FAT_LBA + 2
        sta FAT_PART_START + 2
        lda DISK_BUFFER + 457
        sta FAT_LBA + 3
        sta FAT_PART_START + 3

        ; LBA is set, now read sector
        jsr io_read_sector
        ; We now have the FAT start sector in the buffer
.ifdef check_fat_sector_signature
        ; check signature
        lda DISK_BUFFER + $1FE
        cmp #$55
        bne @sigerr2
        lda DISK_BUFFER + $1FF
        cmp #$AA
        beq @is_fat_sector
@sigerr2:
        jmp fat_init_error2
@is_fat_sector:
.endif
        ; Check if its partition first sector
        lda DISK_BUFFER + 54
        cmp #'F'
        bne @sigerr2
        lda DISK_BUFFER + 55
        cmp #'A'
        bne @sigerr2
        lda DISK_BUFFER + 56
        cmp #'T'
        bne @sigerr2
        ; Save FAT sectors count
        cp16 DISK_BUFFER + 22, FAT_SEC_CNT
        ; Get the sectors per cluster
        lda DISK_BUFFER + 13
        sta FAT_SEC_PER_CLUS
        ; get the number of directory entries in the root directory
        cp16 DISK_BUFFER + 17, FAT_ROOT_ENT_CNT

        ;($600 * 32 + 511) / 512
        ; RootDirSectors = ((BPB_RootEntCnt * 32) + (BPB_BytsPerSec – 1)) / BPB_BytsPerSec;
        cp16 FAT_ROOT_ENT_CNT, FAT_ROOT_DIR_SECS
        ; multiply by 32
        asl16 FAT_ROOT_DIR_SECS
        asl16 FAT_ROOT_DIR_SECS
        asl16 FAT_ROOT_DIR_SECS
        asl16 FAT_ROOT_DIR_SECS
        asl16 FAT_ROOT_DIR_SECS
        ; add 512
        inc FAT_ROOT_DIR_SECS+1
        inc FAT_ROOT_DIR_SECS+1
        ; subtract 1
        dec16 FAT_ROOT_DIR_SECS
        ; divide by 512
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS
        lsr16 FAT_ROOT_DIR_SECS

        ; FirstRootDirSecNum = BPB_ResvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + FAT_PART_START;
        ; CF_FIRST_ROOT_SEC = 1 + 2*CF_FAT_SEC_CNT + FAT_PART_START


        cp16 FAT_SEC_CNT, FAT_FIRST_ROOT_SEC
        asl16 FAT_FIRST_ROOT_SEC
        inc16 FAT_FIRST_ROOT_SEC
        add16 FAT_FIRST_ROOT_SEC, FAT_PART_START, FAT_FIRST_ROOT_SEC

        cp16 FAT_FIRST_ROOT_SEC, FAT_CURRENT_DIR_SEC

        ; FirstDataSector = BPB_ResvdSecCnt + (BPB_NumFATs * FATSz) + RootDirSectors;
        ; CF_FIRST_DATA_SEC = 1 + 2*CF_FAT_SEC_CNT + CF_ROOT_DIR_SECS
        add16 FAT_FIRST_ROOT_SEC, FAT_ROOT_DIR_SECS, FAT_FIRST_DATA_SEC

        stz FAT_CURRENT_CLUSTER
        stz FAT_CURRENT_CLUSTER + 1
        ; print volume label
        printstr DISK_BUFFER + 43, 11
        ; printascii cf_fat_mounted_message
        ; jsr xt_cr

		rts

fat_init_error:
        printascii fat_mounted_error1
        jsr xt_cr
        jmp xt_abort
fat_init_error2:
        printascii fat_mounted_error2
        jsr xt_cr
        jmp xt_abort


fat_convert_filename:
	; file name address to transform is in FAT_PTR2
	; file name length is in FAT_PTR1
	phy
	phx
	ldy #0                  ; Y will be used to index original string
	ldx #0                  ; and X to index transformed string
@transform_name_loop:           ; transform file.txt filename format to FAT16 format
	cpy FAT_PTR1 				; if Y is bigger than the length of the file name
	bcs @load20					; load $20 instead
	lda (FAT_PTR2), y			; otherwise, load next character
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
	inx
@avoid_dot:
	iny
	cpx #11
	bcc @transform_name_loop        ; Do next character
	bra @end_trans                  ; We have reached the 11th character for the new string

@is_dot:                            ; we have a dot in the original string
	cpx #2							; do not replace first 2 dots
	bcc @save_char
	cpx #7						; if the dot is in 8th place, remove it completely
	bcs @avoid_dot
@add_space:
	lda #$20                        ; fill the new string until 8 characters have been done
@dont_replace:
	sta FAT_FILE_NAME_TMP, x
	inx
	cpx #8
	bcc @add_space                     ; if we have not reached 8 chars yet, keep adding spaces
	iny
	bra @transform_name_loop        ; once we reached 8 characters, go back to do extension

@end_trans:							; exit with transformed file name in FAT_FILE_NAME_TMP
	plx
	ply
	rts


fat_find_file:
	; file name to search should be in FAT_FILE_NAME_TMP
	phy

	cp16 FAT_CURRENT_DIR_SEC, FAT_LBA
	cp16 FAT_CURRENT_DIR_SEC + 2, FAT_LBA + 2
	jsr io_read_sector

	lda #<DISK_BUFFER
	sta FAT_PTR1
	lda #>DISK_BUFFER
	sta FAT_PTR1 + 1

	
@outerloop:
	ldy #0
	lda (FAT_PTR1), y                ; load first caracter of file name
	beq @exit                       ; if zero, it means we reached the end of the list
	cmp #$E5
	beq @next_entry                 ; if $E5, it means the entry is deleted, so go to next entry
@loop:
	lda (FAT_PTR1), y                ; load current filename character
	cmp FAT_FILE_NAME_TMP, y        ; compare it we the searched filename
	bne @next_entry                 ; as soon as they are not the same, go to the next entry
	iny                             ; increase pointer to character
	cpy #11                         ; compare with the total filename length
	bcc @loop                       ; if y is less than the filename string length, keep going
	bra @exit_found                 ; otherwise, it means we compared all characters of the file name and they all match
@next_entry:
	add16 FAT_PTR1, fat_entry_size, FAT_PTR1  ; add 32 to the current entry pointer
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
	stz FAT_CURRENT_DIR_SEC
	stz FAT_CURRENT_DIR_SEC + 1
	stz FAT_CURRENT_DIR_SEC + 2
	stz FAT_CURRENT_DIR_SEC + 3
	; cluster number is in CF_CURRENT_CLUSTER
	; Given any valid data cluster number N, the sector number of the first sector of that cluster (again relative to sector 0 of the FAT volume) is computed as follows:
	; FirstSectorofCluster = ((N – 2) * BPB_SecPerClus) + FirstDataSector;
	; (CF_CURRENT_CLUSTER - 2) * CF_SEC_PER_CLUS + CF_FIRST_DATA_SEC
	cp16 FAT_CURRENT_CLUSTER, FAT_CURRENT_DIR_SEC
	lda FAT_CURRENT_DIR_SEC
	bne @notzero
	lda FAT_CURRENT_DIR_SEC + 1
	bne @notzero
	lda FAT_CURRENT_DIR_SEC + 2
	bne @notzero
	lda FAT_CURRENT_DIR_SEC + 3
	bne @notzero

	; current cluster is zero, which means the root directory
	cp16 FAT_FIRST_ROOT_SEC, FAT_CURRENT_DIR_SEC
	rts
@notzero:
	dec16 FAT_CURRENT_DIR_SEC
	dec16 FAT_CURRENT_DIR_SEC
	lda FAT_SEC_PER_CLUS			; load sectors per cluster
@shiftleft:
	lsr							; rotate right
	beq @shifted				; if we haven't shifted far enough, do it again

	asl FAT_CURRENT_DIR_SEC
    rol FAT_CURRENT_DIR_SEC + 1
	rol FAT_CURRENT_DIR_SEC + 2
	rol FAT_CURRENT_DIR_SEC + 3
	bra @shiftleft
@shifted:
	clc
	lda FAT_CURRENT_DIR_SEC		; finally, add first data sector
	adc FAT_FIRST_DATA_SEC
	sta FAT_CURRENT_DIR_SEC
	lda FAT_CURRENT_DIR_SEC + 1
	adc FAT_FIRST_DATA_SEC + 1
	sta FAT_CURRENT_DIR_SEC + 1
	lda FAT_CURRENT_DIR_SEC + 2
	adc #0
	sta FAT_CURRENT_DIR_SEC + 2
	lda FAT_CURRENT_DIR_SEC + 3
	adc #0
	sta FAT_CURRENT_DIR_SEC + 3

@end:
	rts

reduce_filesize_by_one_sector:
	lda FAT_CURRENT_FILE_SIZE + 1
    bne @skip1
	lda FAT_CURRENT_FILE_SIZE + 2
    bne @skip2
    dec FAT_CURRENT_FILE_SIZE + 3
@skip2:
    dec FAT_CURRENT_FILE_SIZE + 2
@skip1:
    dec FAT_CURRENT_FILE_SIZE + 1

	lda FAT_CURRENT_FILE_SIZE + 1
    bne @skip3
	lda FAT_CURRENT_FILE_SIZE + 2
    bne @skip4
    dec FAT_CURRENT_FILE_SIZE + 3
@skip4:
    dec FAT_CURRENT_FILE_SIZE + 2
@skip3:
    dec FAT_CURRENT_FILE_SIZE + 1

	rts

output_sector:
	phx
	ldx #0
@loop:
	lda FAT_CURRENT_FILE_SIZE + 3
	bne @not_end
	lda FAT_CURRENT_FILE_SIZE + 2
	bne @not_end
	lda FAT_CURRENT_FILE_SIZE + 1
	bne @not_end
	lda FAT_CURRENT_FILE_SIZE
	bne @not_end
@not_end:
	lda DISK_BUFFER, x
	jsr kernel_putc
	
	dec FAT_CURRENT_FILE_SIZE
	bne @n
	lda FAT_CURRENT_FILE_SIZE + 1
	beq @end
	dec FAT_CURRENT_FILE_SIZE + 1
@n:
	inx
	bne @loop
	ldx #0
@loop2:
	lda FAT_CURRENT_FILE_SIZE + 3
	bne @not_end2
	lda FAT_CURRENT_FILE_SIZE + 2
	bne @not_end2
	lda FAT_CURRENT_FILE_SIZE + 1
	bne @not_end2
	lda FAT_CURRENT_FILE_SIZE
	bne @not_end2
@not_end2:
	lda DISK_BUFFER+256, x
	jsr kernel_putc

	dec FAT_CURRENT_FILE_SIZE
	bne @n2
	lda FAT_CURRENT_FILE_SIZE + 1
	beq @end
	dec FAT_CURRENT_FILE_SIZE + 1
@n2:
	inx
	bne @loop2
@end:
	plx
	rts