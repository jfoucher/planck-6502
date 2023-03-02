
CF_BUF = FAT_BUFFER
CF_ADDRESS = $FFD0

; .segment "ZEROPAGE": zeropage
; CF_BUF_PTR: .res 2
; CF_ADDRESS: .res 2




.segment "DATA"


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


; cf_read:
;     phy
;     ldy #0
; @readloop:
;     ; phy
;     ; ldy #7
;     ; lda (CF_ADDRESS), y
;     lda CF_ADDRESS + 7
;     and #8
;     beq @exit
;     ; jsr cf_wait
;     ; ldy #0
;     ; lda (CF_ADDRESS), y
;     lda CF_ADDRESS
;     ; ply
;     sta (CF_BUF_PTR), y
;     ; jsr cf_wait
;     iny
;     bne @readloop
;     ; if y wraps around to zero, increment buffer page
;     inc CF_BUF_PTR+1
;     bra @readloop
; @exit:
;     ; we only come here because we read an & 8 from REG 7
;     ; ply
;     dec CF_BUF_PTR+1
;     ply
;     rts
 
; : cfread 0 buffptr ! begin cfwait cfreg7 c@ 8 and while cfreg0 c@ cfbuffer buffptr @ + c! buffptr @ 1 + buffptr ! repeat ;

cf_read:
    phx
    ldx #0
@loop1:
    ;jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #8
    ; beq @exit
    ; jsr cf_wait
    lda CF_ADDRESS
    sta FAT_BUFFER, x
    inx
    bne @loop1
@loop2:
    ;jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #8
    ; beq @exit
    ; jsr cf_wait
    lda CF_ADDRESS
    sta FAT_BUFFER+256, x
    inx
    bne @loop2
@loop3:
    lda CF_ADDRESS + 7
    and #8
    beq @exit
    lda CF_ADDRESS
    inx
    bne @loop3
@exit:
    plx
    rts

cf_set_lba:
    ; phy
    lda CF_LBA
    ; ldy #3
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 3
    lda CF_LBA + 1
    ; ldy #4
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 4
    lda CF_LBA + 2
    ; ldy #5
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 5
    lda CF_LBA + 3
    and #$0F
    ora #$E0
    ; ldy #6
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 6
    ; ply
    rts

cf_read_sector:
    ; phy
    ; buffer should be set in CF_BUF_PTR
    jsr cf_set_lba
    lda #1
    ; ldy #2
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 2
    jsr cf_wait
    lda #CF_READ_SECTOR_COMMAND
    ; ldy #7
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_read
    jsr cf_err
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


cf_end:
    