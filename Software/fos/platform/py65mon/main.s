.include "../../macros.s"
ram_end = $8000

.segment "ZEROPAGE": zeropage
stack_p: .res 2
io_current_sector: .res 4
io_buffer_ptr: .res 2
io_read_location: .res 2
io_sector_tmp: .res 2

.segment "BSS"
current_sector: .res 2

IO_BUFFER: .res $400

.import    copydata
.import zerobss
.segment "STARTUP"

v_reset:
    JSR     copydata
    jsr zerobss
    jmp kernel_init



.include "../../forth.s"

.segment "DATA"
.include "../../utils.s"

.include "../../minix.s"


.segment "DATA"
number_string: .asciiz "000000177777"

test_filename: .asciiz "test.txt"

kernel_init:
v_nmi:
v_irq:                          ; IRQ handler


    printascii welcome_message

    lda #<dictionary
    sta up
    lda #>dictionary
    sta up + 1

    jsr calculate_free_mem
    lda tmp_var + 1
    ldx tmp_var
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





    bra @forth
@ok:
    ; this read the root inode to 
    jsr minix_read_root_inode
    bcs @root_fail
    jsr print_message
    .byte "mode:  ", 0

    lda MINIX_INODE_MODE + 1
    ldx MINIX_INODE_MODE
    jsr print16

    jsr minix_read_inode_data

    jsr print_message
    .byte AscCR,AscLF, 0
    jsr print_message
    .byte "Data: ", 0
    lda io_buffer_ptr + 1
    ldx io_buffer_ptr
    jsr print16
    jsr print_message
    .byte AscCR,AscLF, 0


    jsr print_message
    .byte AscCR,AscLF, 0
    bra @forth
@root_fail:
    jsr print_message
    .byte "inode fail", AscCR,AscLF, 0
@forth:
    jmp forth

platform_bye:   
    jmp platform_bye
kernel_putc:
    ; """Print a single character to the console. """
    ;; Send_Char - send character in A out serial port.
    ;; Uses: A (original value restored)
        sta $f001
        rts

kernel_getc:
    ; """Get a single character from the keyboard. By default, py65mon
    ; is set to $f004, which we just keep. Note that py65mon's getc routine
    ; is non-blocking, so it will return '00' even if no key has been
    ; pressed. We turn this into a blocking version by waiting for a
    ; non-zero character.
    ; """

_loop:
    lda $f004
    beq _loop
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
        

.segment "RODATA"
free_message: .byte " bytes free", $0D, 0
welcome_message: .byte "Welcome to Planck 6502", AscCR, AscLF, AscCR,AscLF, "Type 'words' for available words",AscCR, AscLF,  0


.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq