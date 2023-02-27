


.segment "ZEROPAGE"
CF_BUF_PTR: .res 2

.segment "DATA"
CF_BUF: .res $200

CF_LBA: .res 4
CF_PART_START: .res 4

cf_wait: 
    ; phy
@wait_loop:
    ; ldy #$10
    ; jsr delay_short
    ; lda #'.'
    ; jsr kernel_putc
    lda CF_REG_7
    and #$80
    bne @wait_loop
    ; ply
    rts

cf_init:
    lda #$4
    sta CF_REG_7
    jsr cf_wait
    lda #$E0
    sta CF_REG_6
    lda #$1
    sta CF_REG_1
    lda #$EF
    sta CF_REG_7
    jsr cf_wait
    jsr cf_err
    rts

cf_read:
    phy
    ldy #0
@readloop1:
    jsr cf_wait
    lda CF_REG_7
    and #$08
    beq @exit

    lda CF_REG_0
    sta (CF_BUF_PTR), y
    inc CF_BUF_PTR
    beq @incptr
    bra @readloop1
@exit:
    ply
    rts
@incptr: 
    inc CF_BUF_PTR+1
    bra @readloop1
 
cf_set_lba:
    lda CF_LBA
    sta CF_REG_3
    lda CF_LBA + 1
    sta CF_REG_4
    lda CF_LBA + 2
    sta CF_REG_5
    lda CF_LBA + 3
    and #$0F
    ora #$E0
    sta CF_REG_6
    rts

cf_read_sector:
    lda #<CF_BUF
    sta CF_BUF_PTR
    lda #>CF_BUF
    sta CF_BUF_PTR+1
    jsr cf_set_lba
    lda #1
    sta CF_REG_2
    jsr cf_wait
    lda #CF_READ_SECTOR_COMMAND
    sta CF_REG_7
    jsr cf_read
    jsr cf_err
    rts

cf_err:
    jsr cf_wait
    lda CF_REG_7
    and #$01
    beq @exit
@exit_fail:
    lda #'!'
    jsr kernel_putc
@exit:
    rts

cf_end:
    