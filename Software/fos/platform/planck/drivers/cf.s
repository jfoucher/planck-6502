
CF_BUF = FAT_BUFFER
CF_ADDRESS = $FFD0

.segment "ZEROPAGE": zeropage
CF_BUF_PTR: .res 2
; CF_ADDRESS: .res 2


.segment "BSS"

.align  $100
FAT_BUFFER: .res $200
; .align  256
;FILE_BUFFER: .res $1000
FILE_BUFFER_END:
lcd_absent: .res 1
has_acia: .res 1
CF_LBA: .res 4
CF_PART_START: .res 4
CF_SEC_PER_CLUS: .res 1     ; $8
CF_CURRENT_CLUSTER: .res 2
CF_ROOT_ENT_CNT: .res 2     ; $200
CF_ROOT_DIR_SECS: .res 2    ; $02
CF_FAT_SEC_CNT: .res 2      ; $F5
CF_FIRST_DATA_SEC: .res 2   ; $022B
CF_FIRST_ROOT_SEC: .res 2   ; $020B
CF_CURRENT_DIR_SEC: .res 4
CF_CURRENT_DIR: .res 12
FAT_FILE_NAME_TMP: .res 12

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

.macro readsector2
.scope
    
outerloop:
    ldx #0
wait:
    ldy #0
    lda CF_ADDRESS + 7
    and #$80
    bne wait
load:
    lda CF_ADDRESS
    sta (CF_BUF_PTR), y
    iny
    bne load

    inc CF_BUF_PTR + 1
    inx
    cpx #2
    bcc wait

.endscope
.endmacro

cf_read:
    sei
    phy
    phx
    lda #<FAT_BUFFER
    sta CF_BUF_PTR
    lda #>FAT_BUFFER
    sta CF_BUF_PTR + 1

    readsector2
@loop3:
    lda CF_ADDRESS + 7
    and #8
    beq @exit
    lda CF_ADDRESS
    inx
    bne @loop3
@exit:
    plx
    ply
    cli
    rts


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
;     sta FAT_BUFFER + I * 8
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 1
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 2
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 3
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 4
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 5
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 6
;     lda CF_ADDRESS
;     sta FAT_BUFFER + I * 8 + 7
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
;     sta FAT_BUFFER + 16 * I, x
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
;     sta FAT_BUFFER, x
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
;     sta FAT_BUFFER+256, x
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
    ; sei
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
    ; cli
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
    