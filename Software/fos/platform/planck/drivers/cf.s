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
    sta CF_ADDRESS + 6
    jsr cf_wait
    lda #$1
    sta CF_ADDRESS + 1
    jsr cf_wait
    lda #$EF
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
    sta (io_buffer_ptr), y
    iny
    bne @loop
    inc io_buffer_ptr + 1
    ; jsr cf_wait
@loop2:
    jsr cf_wait
    lda CF_ADDRESS
    sta (io_buffer_ptr), y
    iny
    bne @loop2
    dec io_buffer_ptr + 1
@loop3:
    jsr cf_wait
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
    jsr cf_wait
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
    lda IO_SECTOR
    sta CF_ADDRESS + 3
    jsr cf_wait
    lda IO_SECTOR + 1
    sta CF_ADDRESS + 4
    jsr cf_wait
    lda IO_SECTOR + 2
    sta CF_ADDRESS + 5
    jsr cf_wait
    lda IO_SECTOR + 3
    and #$0F
    ora #$E0
    sta CF_ADDRESS + 6
    jsr cf_wait
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


bytes_msg: .byte " bytes"
cf_end:
    