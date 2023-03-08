

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
    phy
    phx
    ldx #2
    ldy #0
    lda #<DISK_BUFFER
    sta CF_BUF_PTR
    lda #>DISK_BUFFER
    sta CF_BUF_PTR + 1
@begin:
    ; jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #$08
    ; beq @exit
    lda CF_ADDRESS
    sta (CF_BUF_PTR), y
    iny
    bne @begin
    inc CF_BUF_PTR + 1
    jsr cf_wait
    dex
    bne @begin
@exit:
    plx
    ply
    rts

; .macro readsector2
; .scope
    
; outerloop:
;     ldx #0
; wait:
;     ldy #0
;     lda CF_ADDRESS + 7
;     and #$80
;     bne wait
; load:
;     lda CF_ADDRESS
;     sta (CF_BUF_PTR), y
;     iny
;     bne load

;     inc CF_BUF_PTR + 1
;     inx
;     cpx #2
;     bcc wait

; .endscope
; .endmacro

; cf_read:
;     sei
;     phy
;     phx
;     lda #<DISK_BUFFER
;     sta CF_BUF_PTR
;     lda #>DISK_BUFFER
;     sta CF_BUF_PTR + 1

;     readsector2
; @loop3:
;     lda CF_ADDRESS + 7
;     and #8
;     beq @exit
;     lda CF_ADDRESS
;     inx
;     bne @loop3
; @exit:
;     plx
;     ply
;     cli
;     rts


; .macro  readsector
;     .repeat 64, I
;         .scope
;     ; ldx #0
; wait:
;     lda CF_ADDRESS + 7
;     and #$80
;     bne wait
; load:
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 1
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 2
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 3
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 4
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 5
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 6
;     lda CF_ADDRESS
;     sta DISK_BUFFER + I * 8 + 7
;     ; inx
;     ; cpx #4
;     ; bcc load
;         .endscope
;     .endrep
; .endmacro

; cf_read:
;     sei
;     phx
;     readsector
; @loop3:
;     lda CF_ADDRESS + 7
;     and #8
;     beq @exit
;     lda CF_ADDRESS
;     inx
;     bne @loop3
; @exit:
;     plx
;     cli
;     rts

; cf_read:
;     sei
;     phx
;     ldx #0
; @loop1:
; .repeat 16
;     lda CF_ADDRESS + 7
;     and #$80
;     bne @loop1
;     lda CF_ADDRESS
;     sta DISK_BUFFER + 16 * I, x
;     inx
;     bne @loop1
; .endrepeat
;     ; lda CF_ADDRESS + 7
;     ; and #$80
;     ; bne @loop1
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop

;     ; txa
;     ; and #32
;     ; bne @getbyte1

;     ; lda (CF_ADDRESS), y
;     ; lda CF_ADDRESS + 7
;     ; and #8
;     ; beq @exit
;     ; jsr cf_wait
; @getbyte1:
;     lda CF_ADDRESS
;     sta DISK_BUFFER, x
;     inx
;     bne @loop1
; @wait:
;     lda CF_ADDRESS + 7
;     and #$80
;     bne @wait
; @loop2:
;     ; lda CF_ADDRESS + 7
;     ; and #$80
;     ; bne @loop2
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop
;     ; nop

;     ; txa
;     ; and #32
;     ; bne @getbyte2
;     ; lda CF_ADDRESS + 7
;     ; and #$80
;     ; bne @loop2
;     ; lda CF_ADDRESS + 7
;     ; and #$80
;     ; bne @loop2
;     ; lda CF_ADDRESS + 7
;     ; and #8
;     ; beq @exit
;     ; jsr cf_wait
; @getbyte2:
;     lda CF_ADDRESS
;     sta DISK_BUFFER+256, x
;     inx
;     bne @loop2
; @loop3:
;     lda CF_ADDRESS + 7
;     and #8
;     beq @exit
;     lda CF_ADDRESS
;     inx
;     bne @loop3
; @exit:
;     plx
;     cli
;     rts

cf_set_lba:
    ; phy
    lda FAT_LBA
    ; ldy #3
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 3
    lda FAT_LBA + 1
    ; ldy #4
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 4
    lda FAT_LBA + 2
    ; ldy #5
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 5
    lda FAT_LBA + 3
    and #$0F
    ora #$E0
    ; ldy #6
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 6
    ; ply
    rts

cf_do_read:
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
    rts

cf_read_sector:
    sei
    phx
    jsr cf_do_read
    ldx #8
; verify:
;     ; ply
;     ; copy to other buffer
;     jsr cf_copy_buffer

;     ; read sector again
;     jsr cf_do_read

;     ; compare buffers
;     jsr cf_compare_buffers
;     bcc @exit                   ; both buffers are the same, exit
;     dex
;     bne verify            ; buffers are not the same, read again
@exit:
    cli
    plx
    rts

cf_compare_buffers:
    phx
    ldx #0
@loop:
    lda DISK_BUFFER, x
    cmp FAT_BUFFER2, x
    bne @exit_fail
    inx
    bne @loop
@loop2:
    lda DISK_BUFFER+256, x
    cmp FAT_BUFFER2+256, x
    bne @exit_fail
    inx
    bne @loop2
    bra @exit_ok
@exit_fail:
    sec
    plx
    rts
@exit_ok:
    clc
    plx
    rts

cf_copy_buffer:
    phx
    ldx #0
@loop:
    lda DISK_BUFFER, x
    sta FAT_BUFFER2, x
    inx
    bne @loop
@loop2:
    lda DISK_BUFFER+256, x
    sta FAT_BUFFER2+256, x
    inx
    bne @loop2

    plx
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
    