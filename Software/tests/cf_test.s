
CF_BUF = FAT_BUFFER
CF_ADDRESS = $FFA0
CF_READ_SECTOR_COMMAND = $20
ACIA_BASE   = $FFE0
ACIA_DATA = ACIA_BASE
ACIA_STATUS = ACIA_BASE + 1
ACIA_CMD = ACIA_BASE + 2
ACIA_CTRL = ACIA_BASE + 3

.segment "ZEROPAGE": zeropage
CF_POINTER: .res 2
CF_BUF_PTR: .res 2




.segment "BSS"
has_acia: .res 1
CF_LBA: .res 4
CF_PART_START: .res 4
CF_CURRENT_DIR_SEC: .res 4
CF_CURRENT_FILE_SIZE: .res 4
CF_TMP: .res 4
CF_CURRENT_CLUSTER: .res 2
CF_ROOT_ENT_CNT: .res 2     ; $200
CF_ROOT_DIR_SECS: .res 2    ; $02
CF_FAT_SEC_CNT: .res 2      ; $F5
CF_FIRST_DATA_SEC: .res 2   ; $022B
CF_FIRST_ROOT_SEC: .res 2   ; $020B


CF_SEC_PER_CLUS: .res 1     ; $8

CF_CURRENT_DIR: .res 12
FAT_FILE_NAME_TMP: .res 12

FAT_BUFFER: .res $200

.segment "CODE"
reset:
    .import    copydata
    .import zerobss
    JSR     copydata
    jsr zerobss
    jmp start
test_str: .asciiz "Starting"

.segment "DATA"



start:
    jsr acia_init
    ldx #0
@loop:
    lda test_str,x
    beq @done
    jsr acia_out
    inx
    bra @loop
@done:
    lda #$0d
    jsr acia_out
    
    jsr cf_init
    stz CF_LBA
    stz CF_LBA + 1
    stz CF_LBA + 2
    stz CF_LBA + 3

    jsr cf_read_sector

    jsr output_fat_buffer

    lda #$20
    sta CF_LBA
    
    jsr cf_read_sector

    jsr output_fat_buffer


end:
    jmp end

output_fat_buffer:
    ldx #0
@loop:
    lda FAT_BUFFER, x
    jsr acia_out
    inx
    bne @loop
@loop2:
    lda FAT_BUFFER+256, x
    jsr acia_out
    inx
    bne @loop2

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
    phx
    ldx #2
    ldy #0
    lda #<FAT_BUFFER
    sta CF_BUF_PTR
    lda #>FAT_BUFFER
    sta CF_BUF_PTR + 1
@begin:
    jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #$08
    ; beq @exit
    lda CF_ADDRESS
    sta (CF_BUF_PTR), y
    iny
    bne @begin
    inc CF_BUF_PTR + 1
    dex
    bne @begin

@exit:
    plx
    ply
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
    sei
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
    cli
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
    jsr acia_out
@exit:
    ; ply
    rts


cf_end:
    
acia_init:
    sta ACIA_STATUS        ; soft reset (value not important)
                            ; set specific modes and functions
    stz has_acia
    lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
    ;lda #$09               ; no parity, no echo, no Tx interrupt, Rx interrupt, enable Tx/Rx
    sta ACIA_CMD        ; store to the command register
    lda ACIA_CMD        ; load command register again
    cmp #$0B                ; if not the same
    bne acia_absent         ; then it means the ACIA is not connected
    lda ACIA_STATUS         ; Read the ACAI status to
    and #$60                ; check if present or absent
    bne acia_absent
    lda #1
    sta has_acia           ; remember that ACIA is here
    lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 115.200k baud rate
    ;lda #$10               ; 1 stop bits, 8 bit word length, internal clock, 1200 baud rate
    sta ACIA_CTRL          ; program the ctl register

acia_absent:
    ldy #$20
aa_loop:
    jsr delay_short
    lda ACIA_STATUS         ; Read ACIA data a few times
    lda ACIA_DATA           ; to try and prevent spurious characters
    dey
    bne aa_loop
aa_end:
    rts

acia_out:
    pha
    phy
    sta ACIA_DATA
    ldy #$40            ;minimal delay is $02
    jsr delay_short
    ply
    pla
    rts

acia_getc:
    lda ACIA_STATUS                 ; Read the ACIA status to   
    and #$08                        ; Check if there is character in the receiver
    beq @no_char      ; Exit now if we don't get one.
    lda ACIA_DATA
    sec
    rts
@no_char:
    clc
    rts

; this routine delays by 2304 * y + 23 cycles
delay:
  phx       ; 3 cycles
  phy       ; 3 cycles
two:
  ldx #$ff  ; 2 cycles
one:
  nop       ; 2 cycles
  nop       ; 2 cycles
  dex       ; 2 cycles
  bne one   ; 3 for all cycles, 2 for last
  dey       ; 2 cycles
  bne two   ; 3 for all cycles, 2 for last
  ply       ; 4 cycles
  plx       ; 4 cycles
  rts       ; 6 cycles

; delay is in Y register
delay_long:
  pha
  phy
  phx
  tya
  tax
delay_long_loop:
  ldy #$ff
  jsr delay
  dex
  bne delay_long_loop
  plx
  ply
  pla
  rts

delay_short:        ; delay Y * 19 cycles
  phy
delay_short_loop:
  nop               ; 2 cycles
  nop               ; 2 cycles
  nop               ; 2 cycles
  nop               ; 2 cycles
  nop               ; 2 cycles
  nop               ; 2 cycles
  nop               ; 2 cycles
  
  dey               ; 2 cycles
  bne delay_short_loop   ; 2 or 3 cycles
  ply
  rts


.segment "ROM_VECTORS"

.word reset
.word reset
.word reset