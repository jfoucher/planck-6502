
CF_BUF = FAT_BUFFER
CF_ADDRESS = $FFE0
CF_READ_SECTOR_COMMAND = $20
ACIA_BASE   = $FFE0
ACIA_DATA = ACIA_BASE
ACIA_STATUS = ACIA_BASE + 1
ACIA_CMD = ACIA_BASE + 2
ACIA_CTRL = ACIA_BASE + 3

.include "../fos/macros.s"


.segment "ZEROPAGE": zeropage
CF_POINTER: .res 2
CF_BUF_PTR: .res 2
util_tmp: .res 2



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

LBA_SIZE: .res 4

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
    cld
    cli
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
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out


    jsr cf_init
    jsr cf_wait
    lda #$EC
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_read

    jsr output_fat_buffer

    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out
    jsr output_fat_buffer_raw
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out

    ; print model number
    ldx #0
@loopp:
    lda FAT_BUFFER+55, x
    jsr acia_out
    lda FAT_BUFFER+54, x
    jsr acia_out
    inx
    inx
    cpx #40
    bcc @loopp

@exit_p:
    ; print lba size
    lda FAT_BUFFER + 123
    sta LBA_SIZE + 3
    lda FAT_BUFFER + 122
    sta LBA_SIZE + 2
    lda FAT_BUFFER + 121
    sta LBA_SIZE + 1
    lda FAT_BUFFER + 120
    sta LBA_SIZE

    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE
    asl32 LBA_SIZE

    jsr print_message
    .byte $0D, $0A, 0

    lda LBA_SIZE+3
    jsr output_ascii

    lda LBA_SIZE+2
    jsr output_ascii

    lda LBA_SIZE+1
    jsr output_ascii

    lda LBA_SIZE
    jsr output_ascii

    jsr print_message
    .byte " bytes ",$0D,$0A, 0
    ;jmp end
    
    ldy #$10
    jsr delay_long


    stz CF_LBA
    stz CF_LBA + 1
    stz CF_LBA + 2
    stz CF_LBA + 3

    
    jsr cf_read_sector

    jsr output_fat_buffer

    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out

    
    lda #$3F
    sta CF_LBA

    ldy #$10
    jsr delay_long
    jsr cf_read_sector

    jsr output_fat_buffer

    lda #$0D
    jsr acia_out
    lda #$0A
    jsr acia_out
    lda #$0D
    jsr acia_out

    
    lda #$2A
    sta CF_LBA
    lda #$2
    sta CF_LBA + 1
    
    ldy #$10
    jsr delay_long
    jsr cf_read_sector

    jsr output_fat_buffer

    lda #$03
    sta CF_LBA
    
    ldy #$10
    jsr delay_long
    jsr cf_read_sector

    jsr output_fat_buffer


end:
    jmp end

output_fat_buffer_raw:
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

zero_buffer:
    ldx #0
@loop:
    stz FAT_BUFFER, X
    inx
    bne @loop
@loop2:
    stz FAT_BUFFER+256, X
    inx
    bne @loop2
    rts

output_fat_buffer:
    ldx #0
@loop:
    lda FAT_BUFFER, x
    jsr output_ascii
    lda #' '
    jsr acia_out
    inx
    bne @loop
@loop2:
    lda FAT_BUFFER+256, x
    jsr output_ascii
    lda #' '
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
    lda #<FAT_BUFFER
    sta CF_BUF_PTR
    lda #>FAT_BUFFER
    sta CF_BUF_PTR + 1
    ldy #0
@begin:
    jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #$08
    ; beq @exit
    lda CF_ADDRESS
    sta (CF_BUF_PTR), y
    jsr acia_out
    iny
    bne @begin
    inc CF_BUF_PTR + 1
    ;bra @begin
@loop:
    jsr cf_wait
    ; lda CF_ADDRESS + 7
    ; and #$08
    ; beq @exit
    lda CF_ADDRESS
    sta (CF_BUF_PTR), y
    jsr acia_out
    iny
    bne @loop
    dec CF_BUF_PTR + 1
@loop2:
    jsr cf_wait
    lda CF_ADDRESS + 7
    and #$08
    beq @exit
    lda CF_ADDRESS
    iny
    bne @loop2 
@exit:
    ply
    rts

cf_set_lba:
    ; phy
    lda CF_LBA
    ; ldy #3
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 3
    jsr cf_wait
    lda CF_LBA + 1
    ; ldy #4
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 4
    jsr cf_wait
    lda CF_LBA + 2
    ; ldy #5
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 5
    jsr cf_wait
    lda CF_LBA + 3
    and #$0F
    ora #$E0
    ; ldy #6
    ; sta (CF_ADDRESS), y
    sta CF_ADDRESS + 6
    ; ply
    rts

cf_read_sector:
    jsr zero_buffer
    ; sei
    ; phy
    ; buffer should be set in CF_BUF_PTR
    
    jsr cf_wait
    jsr cf_set_lba
    jsr cf_wait
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

output_ascii:
; """Convert byte in A to two ASCII hex digits and EMIT them"""
    pha
    lsr             ; convert high nibble first
    lsr
    lsr
    lsr
    jsr output_ascii_nibble_to_ascii
    pla

    ; fall through to _nibble_to_ascii

output_ascii_nibble_to_ascii:
; """Private helper function for byte_to_ascii: Print lower nibble
; of A and and EMIT it. This does the actual work.
; """
    and #$0F
    ora #'0'
    cmp #$3A        ; '9+1
    bcc @1
    adc #$06

@1:               
    jsr acia_out
    rts




print_message:
	pla					; get return address from stack
	sta util_tmp
	pla
	sta util_tmp + 1		

	bra @inc
@print:
	jsr acia_out

@inc:
	inc util_tmp
	bne @inced
	inc util_tmp + 1
@inced:
	lda (util_tmp)
	bne @print
	lda util_tmp + 1
	pha
	lda util_tmp
	pha
print_message_end:
	rts


.segment "ROM_VECTORS"

.word reset
.word reset
.word reset