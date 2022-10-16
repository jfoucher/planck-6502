; SD card driver

; SD card initialization routine
; http://elm-chan.org/docs/mmc/mmc_e.html#spiinit

sd_init:                    ; slave address in A
    sta SD_SLAVE             ; save slave address for later use
    phx
    jsr spi_init                ; init SPI system
    lda #0
    jsr spi_select          ; DEselect slave
    sta SD_ARG
    sta SD_ARG+1            ; clear command argument
    sta SD_ARG+2
    sta SD_ARG+3
    lda #$95
    sta SD_CRC              ; set CRC for CMD0
    ; clear SD buffer
    ldx #$FF
clear_sd_buf_loop1:
    stz SD_BUF, X
    dex
    bne clear_sd_buf_loop1

    dex
clear_sd_buf_loop2:
    stz SD_BUF+256, x
    dex
    bne clear_sd_buf_loop2

    ; send 10 bytes of $FF With SD card deselected
    
    ldx #10
init_loop:
    lda #$FF
    jsr spi_transceive
    dex
    bne init_loop

    jsr sd_cmd_0            ; set SD card idle state
    cmp #$01                ; Check for idle state
    bne sd_error
    jsr sd_cmd_8            ; SEND_IF_COND	For only SDC V2. Check voltage range.
    cmp #$01                ; Check for idle state
    bne sd_error
    ; TODO check if long response is $01AA

    ; wait for card to be initialized
    ldx #$ff    ; Max times to loop
    stz SD_ARG
    stz SD_ARG+1
    stz SD_ARG+2
    stz SD_ARG+3
sd_init_loop2:
    dex
    beq sd_error
    stz SD_ARG+3
    lda #55
    jsr sd_command
    lda #$40
    sta SD_ARG+3
    lda #41
    jsr sd_command
    
    bne sd_init_loop2

    lda #58
    jsr sd_command
    lda SD_BUF
    and #$40
    beq force_block_size    ; CCS bit is unset, force block addressing
sd_init_exit_success:
    plx
    stz SD_CRC              ; reset CRC to zero
    lda #0
    
    rts

force_block_size:
    stz SD_ARG
    stz SD_ARG+1
    lda #$2
    sta SD_ARG+2
    stz SD_ARG+3    ; set block size to $200 (512 bytes)
    lda #$10
    jsr sd_command
    jmp sd_init_exit_success

sd_error:
    plx
    lda #1
    rts

sd_command:         ; command index is in A
    and #$3F        ; only keep low 6 bits
    sta SD_TMP
    ora #$40        ; 0 and 1 to most significant bits

    ; Select chip
    jsr sd_command_start

    jsr spi_transceive  ; send command index
    ; command argument is in SD_ARG
    ; SPI is big endian, so reverse argument order
    lda SD_ARG + 3
    jsr spi_transceive
    lda SD_ARG+2
    jsr spi_transceive
    lda SD_ARG+1
    jsr spi_transceive
    lda SD_ARG
    jsr spi_transceive
    lda SD_CRC          ; send hardcoded CRC if available
    jsr spi_transceive

    ; wait for a zero to be received in the top bit of the response
sd_response_wait_loop:
    lda #$FF
    jsr spi_transceive
    bmi sd_response_wait_loop           ; if high bit of response is 1, keep going

    pha

    ; Maybe we should handle the case where the response is an R1b, i.e. "It is an R1 response followed by busy flag (DO is driven to low as long as internal process is in progress). The host controller should wait for end of the process until DO goes high (a 0xFF is received)." (only for CMD12)

    ; get 32 bits of response for CMD 8 and CMD 58
    lda SD_TMP
    cmp #8
    beq long_response
    cmp #58
    beq long_response
    cmp #$11
    beq sd_command_exit_no_end

sd_command_exit:
    jsr sd_command_end
sd_command_exit_no_end:
    pla
    ; return the response
    rts

long_response:
    lda #$FF
    jsr spi_transceive
    sta SD_BUF
    lda #$FF
    jsr spi_transceive
    sta SD_BUF+1
    lda #$FF
    jsr spi_transceive
    sta SD_BUF+2
    lda #$FF
    jsr spi_transceive
    sta SD_BUF+3
    jmp sd_command_exit

; send SD card CMD0
sd_cmd_0:
    lda #$95
    sta SD_CRC
    stz SD_ARG
    stz SD_ARG+1
    stz SD_ARG+2
    stz SD_ARG+3
    lda #0
    jsr sd_command
    rts

; send SD card CMD8
sd_cmd_8:
    lda #$87
    sta SD_CRC
    ; store in little endian
    ; will be converted to big endian when sending command
    stz SD_ARG+3
    stz SD_ARG+2
    lda #1
    sta SD_ARG+1
    lda #$AA
    sta SD_ARG
    lda #$48
    jsr sd_command

    rts

sd_command_start:
    pha                         ; Save A
    lda SD_SLAVE
    jsr spi_select
    pla                         ; Restore A
    rts

sd_command_end:
    pha
    lda #0
    jsr spi_select
    lda #$FF
    jsr spi_transceive      ; Send $FF without SD selected
    pla
    rts


sd_readsector:
    ; Read a sector from the SD card.  A sector is 512 bytes.
    ;
    ; Parameters:
    ;    sd_sector   32-bit sector number
    ;    sd_buffer_address     address of buffer to receive data
    phx
    jsr sd_command_start
    ; Command 17, arg is sector number, crc not checked
    lda #$11                    ; CMD17 - READ_SINGLE_BLOCK
    jsr sd_command

    cmp #0              ; Check if command accepted by card
    bne @fail
    ldx #$FF
@feloop:
    dex
    beq @fail           ; the card took too long to get ready
    lda #$FF
    jsr spi_transceive
    cmp #$FE            ; are we about to receive data ?
    bne @feloop

    ; Read page by page
    jsr readpage
    inc sd_buffer_address+1
    jsr readpage
    dec sd_buffer_address+1

    lda #$FF
    jsr spi_transceive      ; read and discard CRC
    lda #$FF
    jsr spi_transceive      
    jsr sd_command_end
    plx
    lda #0
    rts

@fail:
    ; return 1 means fail
    jsr sd_command_end
    plx
    lda #1
    rts

readpage:
    ; Read 256 bytes to the address at zp_sd_address
    phy
    ldy #0
@readloop:
    lda #$FF
    jsr spi_transceive
    sta (sd_buffer_address),y
    iny
    bne @readloop
    ply
    rts

sd_init_success_message:
    .byte $0D,"SD init OK", $0D, 0

sd_init_error_message:
    .byte $0D,"SD init FAIL", $0D, 7, 0

sd_read_error_message:
    .byte $0D,"SD read FAIL", $0D, 7, 0