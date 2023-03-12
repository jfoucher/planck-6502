.segment "ZEROPAGE": zeropage
CF_POINTER: .res 2

.segment "BSS"
LBA_SIZE: .res 4
.segment "DATA"



cf_init:
    ; phy
    lda #$4
    ; ldy #7
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 7
    jsr cf_wait
    lda #$E0
    ; ldy #6
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 6
    lda #$1
    ; ldy #1
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 1
    lda #$EF
    ; ldy #7
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_err
    ; ply
    rts




cf_read:
    phy
    ldy #0
@loop:
    jsr cf_wait
    lda CF_ADDRESS
    ; jsr kernel_putc
    sta (io_buffer_ptr), y
    iny
    bne @loop
    inc io_buffer_ptr + 1
@loop2:
    jsr cf_wait
    lda CF_ADDRESS
    ; jsr kernel_putc
    sta (io_buffer_ptr), y
    iny
    bne @loop2
    dec io_buffer_ptr + 1
@loop3:
    lda CF_ADDRESS + 7
    and #$08
    beq @exit
    lda CF_ADDRESS
    iny
    bne @loop3
@exit:
    ply
    rts


; number of sectors to read is in X
cf_read_sector:
    ; sei
    jsr cf_set_lba
    ; ldy #2
    ; sta (CF_ADDRESS), y
    lda #1
    sta CF_ADDRESS + 2
    jsr cf_wait
    lda #CF_READ_SECTOR_COMMAND
    ; ldy #7
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_read
    jsr cf_err
    ; cli
    rts

; number of sectors to write is in X
cf_write_sector:
    ; sei
    jsr cf_set_lba
    lda #1
    ; ldy #2
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 2
    jsr cf_wait
    lda #CF_WRITE_SECTOR_COMMAND
    ; ldy #7
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_write
    jsr cf_err
    ; cli
    rts


cf_write:
    phy
    ldy #0
@loop:
    jsr cf_wait
    
    lda (io_buffer_ptr), y
    sta CF_ADDRESS
    iny
    bne @loop
    inc io_buffer_ptr + 1
@loop2:
    jsr cf_wait
    lda (io_buffer_ptr), y
    sta CF_ADDRESS
    iny
    bne @loop2
    dec io_buffer_ptr + 1
@loop3:
    lda CF_ADDRESS + 7
    and #$08
    beq @exit
    sta CF_ADDRESS
    iny
    bne @loop3
@exit:
    ply
    rts






cf_wait: 
    ; phy
    ; ldy #7
@wait_loop:
    ; lda (CF_ADDRESS), y
    lda CF_ADDRESS + 7
    and #$80
    bne @wait_loop
    ; ply
    rts
    
cf_set_lba:
    ; phy
    lda IO_SECTOR
    ; ldy #3
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 3
    lda IO_SECTOR + 1
    ; ldy #4
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 4
    lda IO_SECTOR + 2
    ; ldy #5
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 5
    lda IO_SECTOR + 3
    and #$0F
    ora #$E0
    ; ldy #6
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 6
    ; ply
    rts

cf_err:
    ; phy
    jsr cf_wait
    ; ldy #7
    ; lda (CF_ADDRESS), y
    lda CF_ADDRESS + 7
    and #$01
    beq @exit
@exit_fail:
    lda #'!'
    jsr kernel_putc
@exit:
    ; ply
    rts

cf_info:
    jsr cf_init
    jsr cf_wait
    lda #$EC
    sta CF_ADDRESS + 7
    jsr cf_read
    rts

cf_print_id:
    ; print model number
    phy
    ldy #55
@loop:
    lda (io_buffer_ptr), y
    jsr kernel_putc
    dey
    lda (io_buffer_ptr), y
    jsr kernel_putc
    iny
    iny
    iny
    cpy #(40+55)
    bcc @loop
    ply
    rts

cf_print_capacity:
    phy

    jsr xt_cr

    ldy #120
    ; print lba size
    lda (io_buffer_ptr), y
    sta LBA_SIZE
    iny
    lda (io_buffer_ptr), y
    sta LBA_SIZE + 1

    iny
    lda (io_buffer_ptr), y
    sta LBA_SIZE + 2

    iny
    lda (io_buffer_ptr), y
    sta LBA_SIZE + 3

    ldy #9
@loop:
    asl32 LBA_SIZE
    dey
    bne @loop

    dex
    dex
    dex
    dex

    lda LBA_SIZE
    sta 2, x
    lda LBA_SIZE + 1
    sta 3, x
    lda LBA_SIZE + 2
    sta 0, x
    lda LBA_SIZE + 3
    sta 1, x

    jsr xt_ud_dot

    dex
    dex
    dex
    dex
    lda #6
    sta 0, x
    stz 1, x
    lda #<bytes_msg
    sta 2, x
    lda #>bytes_msg
    sta 3, x
    jsr xt_type
    jsr xt_cr
    ply
    rts
bytes_msg: .byte " bytes"
cf_end:
    