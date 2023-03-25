.include "../../macros.s"
ram_end = $8000
TALI_OPTIONAL_ASSEMBLER = 1

.segment "ZEROPAGE": zeropage
stack_p: .res 2
io_current_sector: .res 4
io_buffer_ptr: .res 2
io_read_location: .res 2
io_sector_tmp: .res 2

zp_tmp: .res 2

.segment "BSS"
current_sector: .res 2

IO_BUFFER: .res $400

.import    copydata
.import zerobss
.segment "STARTUP"

v_reset:
    ; printascii welcome_message
    ; jmp v_reset
    JSR     copydata
    jsr zerobss
    
    jmp kernel_init

.segment "CODE"
kernel_putc:
    ; """Print a single character to the console. """
    ;; Send_Char - send character in A out serial port.
    ;; Uses: A (original value restored)
        sta $f001
        rts

.include "../../forth.s"

.ifdef TALI_OPTIONAL_ASSEMBLER
.include "../../assembler.s"
.include "../../disassembler.s"
.endif

.segment "DATA"
.include "../../utils.s"

.include "../../minix.s"


.segment "DATA"
number_string: .asciiz "000000177777"
file_test_string:.asciiz "Data has been written. Did we overwrite the file?"
test_filename: .asciiz "test.txt"
test_filename2: .asciiz "dir"

kernel_init:
v_nmi:
v_irq:                          ; IRQ handler

    printascii welcome_message

    jmp forth

    lda #<dictionary
    sta up
    lda #>dictionary
    sta up + 1

    jsr calculate_free_mem
    lda util_tmp_var + 1
    ldx util_tmp_var
    jsr print16

    printascii free_message


    jsr print_message
    .byte AscCR,AscLF, 0

    ; set up buffer pointer
    lda #<IO_BUFFER
    sta io_buffer_ptr
    lda #>IO_BUFFER
    sta io_buffer_ptr + 1

    lda #>IO_BUFFER
    ldx #<IO_BUFFER
    jsr print16
    jsr print_message
    .byte AscCR,AscLF, 0

    jsr minix_read_superblock
    bcc @ok
    jsr print_message
    .byte "Bad superblock", AscCR,AscLF, 0


    jmp @forth
@ok:
    ; this read the root inode to 
    jsr minix_read_root
    bcc @root_ok
    jsr print_message
    .byte "Bad root dir", AscCR,AscLF, 0
    jmp forth
@root_ok:
    ; jsr minix_ls

    jsr print_message
    .byte AscCR,AscLF, 0


    ; fill search filename with zeroes
    ldx #30
@l1:
    stz MINIX_SEARCH_FILENAME, x
    dex
    bne @l1
    ldx #30                 ; length of data to copy
    ; copy search filename
    memcp test_filename, MINIX_SEARCH_FILENAME
    jsr minix_find_inode_for_filename       ; search filename
    bcc @find_ok
    jmp forth
@find_ok:
    jsr minix_read_file
    bcc @file_ok
    jsr print_message
    .byte "Not a regular file", AscCR,AscLF, 0
    jmp forth
@file_ok:
    jsr print_message
    .byte "file read", AscCR,AscLF, 0

    ; change inode userid
    lda #$55
    sta MINIX_INODE_UID
    lda #$AA
    sta MINIX_INODE_UID + 1
    strlen file_test_string
    stx MINIX_INODE_FILESIZE    ; save new future file size
    jsr minix_write_inode       

    jsr minix_read_file

    ldx #0
@wloop:
    lda file_test_string, x
    beq @wexit
    sta IO_BUFFER, x
    inx
    bra @wloop
@wexit:
    jsr minix_write_data

    jsr print_message
    .byte AscCR,AscLF, 0
    ldx #30
@l2:
    stz MINIX_SEARCH_FILENAME, x
    dex
    bne @l2
    ldx #30                 ; length of data to copy
    ; copy search filename

    memcp test_filename, MINIX_SEARCH_FILENAME

    jsr print_message
    .byte AscCR,AscLF, 0
    jsr minix_find_inode_for_filename       ; search filename
    bcc @file_ok1
    jsr print_message
    .byte "file find fail", AscCR,AscLF, 0
    jmp forth
@file_ok1:
    jsr print_message
    .byte "file find 2", AscCR,AscLF, 0
    jsr minix_read_file
    bcc @file_ok2
    jsr print_message
    .byte "file read fail", AscCR,AscLF, 0
    jmp forth
@file_ok2:
    jsr print_message
    .byte "file read 2", AscCR,AscLF, 0

    bra @forth

@find_fail:
    jsr print_message
    .byte AscCR,AscLF, 0
    jsr print_message
    .byte "Data: ", 0


    lda io_buffer_ptr + 1
    ldx io_buffer_ptr
    jsr print16

    jsr print_message
    .byte AscCR,AscLF,"NF", AscCR,AscLF, 0
    jsr print_message
    .byte AscCR,AscLF, 0

@forth:
    jmp forth


minix_ls:
    phy
    
    ; load first entry
    ldy #0
@loop:
    lda #$0D
    jsr kernel_putc
    lda #$0A
    jsr kernel_putc
    lda (io_buffer_ptr), y
    beq @exit                   ; if this points to the 0 inode, exit now, because this file does not exist
    ; otherwise, the file does exist, print its name
    cp16 io_buffer_ptr, util_tmp
    inc16 util_tmp
    inc16 util_tmp
    phy
    jsr print_zp_index_string
    ply
    ; increase y by 20 to load next entry
    tya
    adc #$20
    bcs @inchigh
    tay
    bra @loop
@inchigh:
    inc io_buffer_ptr + 1
    tay
    bra @loop
@exit:
    ply
    rts



platform_bye:   
    jmp platform_bye


kernel_getc:
    ; """Get a single character from the keyboard. By default, py65mon
    ; is set to $f004, which we just keep. Note that py65mon's getc routine
    ; is non-blocking, so it will return '00' even if no key has been
    ; pressed. We turn this into a blocking version by waiting for a
    ; non-zero character.
    ; """

getc_loop:
    lda $f004
    beq getc_loop
    rts

io_read_sector:
    ; sector to read is in io_current_sector
    phy
    lda #<minix_data                ; load the minix data location
    sta io_read_location            ; and store it temporarly
    lda #>minix_data
    sta io_read_location + 1
    cp16 io_current_sector, io_sector_tmp   ; copy sector requested to temporary
    ;multiply requested sector by 512 to get byte offset
    ldy #9
@mult:
    asl16 io_sector_tmp
    dey
    bne @mult
    add16 io_sector_tmp, io_read_location, io_sector_tmp     ; add minix data address to byte offset
    
    ldy #0
@loop1:
    lda (io_sector_tmp), y
    sta (io_buffer_ptr), y
    iny
    bne @loop1
    inc io_sector_tmp + 1       ; read next page
    inc io_buffer_ptr + 1       ; write to next page
@loop2:
    lda (io_sector_tmp), y
    sta (io_buffer_ptr), y
    iny
    bne @loop2
    dec io_buffer_ptr + 1       ; point back to the beginning of the buffer
    ply
    rts

io_write_sector:
    ; the sector to write to is in io_current_sector
    ; the data to write is in the buffer pointed to by io_buffer_ptr
    phy
    lda #<minix_data                ; load the minix data location
    sta io_read_location            ; and store it temporarly
    lda #>minix_data
    sta io_read_location + 1
    cp16 io_current_sector, io_sector_tmp   ; copy sector requested to temporary
    ;multiply requested sector by 512 to get byte offset
    ldy #9
@mult:
    asl16 io_sector_tmp
    dey
    bne @mult
    add16 io_sector_tmp, io_read_location, io_sector_tmp     ; add minix data address to byte offset
    
    ldy #0
@loop1:
    lda (io_buffer_ptr), y
    sta (io_sector_tmp), y
    iny
    bne @loop1
    inc io_sector_tmp + 1       ; read next page
    inc io_buffer_ptr + 1       ; write to next page
@loop2:
    lda (io_buffer_ptr), y
    sta (io_sector_tmp), y
    iny
    bne @loop2
    dec io_buffer_ptr + 1       ; point back to the beginning of the buffer
    ply
    rts

.segment "RODATA"
minix_data:
.align $100
; .incbin "minix.img"
free_message: .byte " bytes free", $0D, 0
welcome_message: .byte "Welcome to Planck 6502", AscCR, AscLF, AscCR,AscLF, "Type 'words' for available words",AscCR, AscLF,  0

.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq