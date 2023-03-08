.macro max first, second
.local @end
	lda first
	cmp second
	bcs @end
	lda second
@end:
.endmacro

.macro min first, second
.local @end
	lda first
	cmp second
	bcc @end
	lda second
@end:
.endmacro

BLOCKSIZE = 512
BLOCKING_FACTOR = 20
RECORD_SIZE = 10240

; file types
REGULAR = 0
NORMAL = '0'
HARDLINK = '1'
SYMLINK = '2'
CHAR = '3'
BLOCK = '4'
DIRECTORY = '5'
FIFO = '6'
CONTIGUOUS = '7'


.segment "ZEROPAGE": zeropage

tar_zp_tmp: .res 2			; temporary pointer used to hold pointer to number string to convert

.segment "BSS"
.align $100
tar_buffer: .res $200
tar_sector: .res 4
tar_tmp: .res 2				; temporary
tar_number: .res 2			; used to convert octal ascii string to binary number
tar_filename: .res 32		; contains a zero terminated string of the filename to read

.segment "DATA"

; from https://wiki.osdev.org/USTAR
; /* returns file size and pointer to file data in out */
; int tar_lookup(unsigned char *archive, char *filename, char **out) {
;     unsigned char *ptr = archive;
 
;     while (!memcmp(ptr + 257, "ustar", 5)) {
;         int filesize = oct2bin(ptr + 0x7c, 11);
;         if (!memcmp(ptr, filename, strlen(filename) + 1)) {
;             *out = ptr + 512;
;             return filesize;
;         }
;         ptr += (((filesize + 511) / 512) + 1) * 512;
;     }
;     return 0;
; }

tar_ustar: .asciiz "ustar"

; get the starting sector for a given filename
; name is in tar_filename
; if carry is set on exit, it means the file was found
; if carry is unset, file was not found
tar_get_file:
	phx
	stz tar_sector
	stz tar_sector + 1
	stz tar_sector + 2
	stz tar_sector + 3
@loop:
	jsr io_read_sector			; read first sector
	ldx #5
	memcmp tar_buffer + 257, tar_ustar	; check for ustar header
	bcc @next_sector				; carry is clear which means this sector is not a file header
@is_file:
	strlen tar_filename			; filename string length is in x
	memcmp tar_filename, tar_buffer ; compare requested filename with this header file name
	bcc @next_sector			; file does not match, try next sector
	; or better jump by the number of sectors that we get from the file size
	lda #<(tar_buffer+$7C)			; load start of filesize octal string low byte
	sta tar_zp_tmp				; store in zp pointer
	lda #>(tar_buffer+$7C)			; load high byte
	sta tar_zp_tmp + 1			; save in pointer high byte
	lda #11
	sta tar_tmp					; how many chars to convert
	jsr tar_oct2bin				; convert to binary
	; now the file size is in tar_number
	; and the filename at the start of tar_buffer
	; to get the file data, we have to read the next sectors
	; for filesize bytes
	sec
@exit:
	plx
	rts
@next_sector:
	inc32 tar_sector		; prepare to get next sector
	lda tar_sector + 1		; if we tried 256 sectors
	clc						; clear carry in case we exit
	bne @exit				; give up
	bra @loop				; otherwise try again

; read file data
; call tar_get_file beforehand to set required variables
; tar_number which contains the filesize
; and tar_sector which contains the file header
; with tar, the file data is contained in the sectors following the header, up to the specified file size
; On exit, tar_buffer contains the file fragment
; call this while the carry is not set to get the whole file
; once the carry is set, tar_number + 1 will be 0
; read the bytes left in tar_number
tar_read_file:
	; check if file is a regular file
	lda tar_buffer+156
	beq @regular_file		; if zero, is a normal file
	cmp #REGULAR			; if ascii zero, is a normal file
	beq @regular_file
	bra @not_a_file_error	; otherwise, not a regular file, cannot read it
@regular_file:
	inc32 tar_sector		; prepare to get next sector, which contains the file data
	jsr io_read_sector		; read first data sector
	dec tar_number+1		; decrement tar_number by 512
	bmi @end_of_file		; if the high byte of the number is negative or zero
	beq @end_of_file		; we have reached the end of the file
	
	dec tar_number+1
	beq @end_of_file
	bmi @end_of_file

	clc						; we have to read more sectors
	rts						; but we give that responsibility to the caller

@end_of_file:
	sec
	rts
@not_a_file_error:
	jsr print_message
	.byte "Not a file", AscCR, AscLF, 0
	bit @not_file_exit ; set overflow flag
@not_file_exit:
	rts

tar_error: 

	rts

; from https://github.com/calccrypto/tar
; unsigned int oct2uint(char * oct, unsigned int size){
;     unsigned int out = 0;
;     int i = 0;
;     while ((i < size) && oct[i]){
;         out = (out << 3) | (unsigned int) (oct[i++] - '0');
;     }
;     return out;
; }

tar_oct2bin:
	; pointer to data in tar_zp_tmp
	; size in tar_tmp
	; 16 bit result only, max octal number handled is 0000000177777
	phy
	ldy #0
	stz tar_number
	stz tar_number + 1

@loop:
	lda (tar_zp_tmp), y			; read current character
	beq @exit					; if item read is null exit now
	sec
	sbc #'0'					; subtract ascii 0 to get real number
	asl16 tar_number			; multiply by 8
	asl16 tar_number
	asl16 tar_number
	adc tar_number				; add current number to result
	sta tar_number				; save to result
	bcc @no_carry
	inc tar_number+1			; if there was a carry, increment high byte
@no_carry:
	iny
	cpy tar_tmp
	bcc @loop

@exit:

	ply
	rts