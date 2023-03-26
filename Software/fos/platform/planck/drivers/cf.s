.segment "BSS"
cf_present: .res 1
LBA_SIZE: .res 4

.segment "CODE"

cf_init:
    ; phy
    lda CF_ADDRESS + 7  ; wait for RDY flag to become set
    and #$40
    beq cf_init
    lda #$4
    ; lda #$6         ; try disabling interrupts from card
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

    lda #$55
    sta CF_ADDRESS + 3
    lda CF_ADDRESS + 3
    cmp #$55
    beq @exit
    stz cf_present
    rts
@exit:
    sta cf_present
    rts




cf_read:
    phy
    ldy #0
@loop:
    lda CF_ADDRESS
    sta (io_buffer_ptr), y
    iny
    bne @loop
    inc io_buffer_ptr + 1
    jsr cf_wait
@loop2:
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
    sei
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
    cli
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
@wait_loop:
    lda CF_ADDRESS + 7
    bmi @wait_loop
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
    