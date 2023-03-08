
.include "../../macros.s"
CLOCK_SPEED = 24000000

ram_end = $8000

; select includes to enable card drivers

.include "drivers/cf.inc"
.include "drivers/acia.inc"
.include "drivers/via.inc"
.include "drivers/sd.inc"
; .include "drivers/ps2.inc"
; .include "drivers/4004.inc"
; .include "drivers/lcd.inc"
; .include "drivers/vga.inc"
; .include "drivers/keyboard.inc"

.segment "ZEROPAGE": zeropage

.include "drivers/zp.s"

.segment "BSS"
.ifdef VIA1_BASE
lcd_absent: .res 1
.endif
.ifdef ACIA_BASE
has_acia: .res 1
.endif

.ifdef CF_ADDRESS

.endif



.segment "STARTUP"
.import    copydata
.import zerobss
zero_ram:
    ldx #$FF
zero_zp:
    stz 0, x
    dex
    bne zero_zp
    stz $00
    lda #0
    sta $01

    ldx #$80
    ldy #0
    lda #0
@loop:
    sta ($0), y
    iny
    bne @loop
    inc $1
    dex
    bne @loop

    jmp ram_zeroed

v_reset:
    jmp zero_ram
ram_zeroed: 
    JSR     copydata
    jsr zerobss
    
    jmp kernel_init



.segment "DATA"

.include "drivers/delayroutines.s"

.ifdef VIA1_BASE
.include "drivers/timer.s"
.include "drivers/spi.s"
.endif

.ifdef ACIA_BASE
.include "drivers/acia.s"
.endif


.ifdef KB_VIA_BASE
.include "drivers/keyboard.s"
.endif
.ifdef KB_INIT_STATE_RESET
.include "drivers/ps2.s"
.endif

.ifdef LCD2_ENABLED
.include "drivers/4004.s"
.endif
.ifdef CF_ADDRESS
.include "drivers/cf.s"
.endif
.ifdef SD

.include "drivers/sd.s"

.endif

.if .def(SD)
.include "../../fat16.s"
.elseif .def(CF_ADDRESS)
.include "../../fat16.s"
.endif

.include "../../utils.s"

; .include "drivers/spi.s"
; .include "drivers/sd.s"
; .include "drivers/vga.s"
; .include "drivers/fat32.s"
; .include "drivers/lcd.s"


.include "../../forth.s"

.segment "DATA"

; .include "../../ed.s"


platform_bye:
kernel_init:
.ifdef VIA1_BASE
    lda #$FF
    sta DDRB
    sta DDRA
    lda #1
    sta PORTB
    stz PORTA
.endif
.ifdef timer_init
    stz time
    stz time+1
    stz time+2
    stz time+3
.endif
jsr acia_init
.ifdef timer_init
    jsr timer_init
.endif
.ifdef video_init
    jsr video_init
.endif
.ifdef ps2_init
    jsr ps2_init
.endif
.ifdef lcd_init
    jsr lcd_init
.endif
.ifdef spi_init
    jsr spi_init
.endif
.ifdef kb_init
    jsr kb_init
.endif
    printascii welcome_message

    lda #<dictionary
    sta up
    lda #>dictionary
    sta up + 1

    jsr calculate_free_mem
    lda tmp_var + 1
    ldx tmp_var
    jsr print16

    printascii free_message

    jmp forth

v_nmi:
    
    jsr calculate_free_mem
    lda tmp_var + 1
    ldx tmp_var
    jsr print16

    printascii free_message
    printascii ready_message

    jmp xt_abort




io_read_sector:
    jmp (io_read_sector_ptr)        ; jump to read sector routine

kernel_putc:
    ; """Print a single character to the console. """
    ;; Send_Char - send character in A out serial port.
    ;; Uses: A (original value restored)
send_char:
    pha
    .ifdef char_out
    jsr char_out
    .endif
    .ifdef acia_out
    jsr acia_out
    .endif
send_char_exit:    
.ifdef lcd_print
    ; jsr lcd_print
.endif
    pla
    rts


        ;; Get_Char - get a character from the serial port into A.
        ;; Set the carry flag if char is valid.
        ;; Return immediately with carry flag clear if no char available.
        ;; Uses: A (return value)
        
Get_Char:
    jsr acia_getc
    bcc get_ps2_char                ; check keyboard buffer if nothing from ACIA
    sec                             ; Set Carry to show we got a character
    rts                             ; Return
    
get_ps2_char:                       ; no ACIA char available, try to get from KB buffer
.ifdef ps2_get_char
    jsr ps2_get_char
.endif
    bcc get_kb_char
    sec

    rts
get_kb_char:
    .ifdef kb_get_char
    
    ; ldy #5
    ; jsr delay_short
    ; ply
        jsr kb_get_char
        
    .endif
exit:                         ; Indicate no char available.
    rts                             ; return

kernel_getc:
    ; """Get a single character from the keyboard (waits for key). 
    ; """
    ;; Get_Char_Wait - same as Get_Char only blocking.
    ;; Uses: A (return value)
Get_Char_Wait:  
    jsr Get_Char
    bcc Get_Char_Wait
    rts


v_irq:                          ; IRQ handler
        pha
        phy
        ; lda #'.'
        ; jsr kernel_putc
        ; check if bit 7 of IFR is set
.ifdef IFR
        lda IFR
        bpl irq_not_from_via  ; Interrupt not from VIA, exit

        and #$08        ; ps2 has priority
        bne v_irq_ps2
        lda IFR
        and #$40
        bne v_irq_timer
irq_not_from_via:
.endif
.ifdef KB_IFR
v_kb_irq:
        lda KB_IFR
        bpl v_irq_exit
        and #$40
        bne v_kb_irq_timer
        bra v_irq_exit
.endif

v_irq_ps2:
    .ifdef ps2_irq
        lda time
        sta last_ps2_time
        lda time+1
        sta last_ps2_time+1
        lda time+2
        sta last_ps2_time+2
        lda time+3
        sta last_ps2_time+3
        
        jsr ps2_irq

    .endif
        bra v_irq_exit
    
.ifdef T1CL
v_irq_timer:
        lda T1CL  
        ; clear timer interrupt
    .ifdef timer_irq
        jsr timer_irq
    .endif
        jsr Get_Char ; Check if a char is waiting to be able to break on CTRL-C
        ; check if there is a char waiting to be printed to the lcd
        ; lda lcd_char
        ; beq v_exit
        ; jsr lcd_print
        ; stz lcd_char


        bcc v_irq_exit      ; no character waiting, exit normally
        cmp #$03            ; check if CTRL-C
        bne v_irq_exit      ; not CTRL-C, exit normally
        printascii abort_message    ; was a CTRL_C
        ply                         ; pull what the ISR pushed
        pla 
        plp                         ; pull status register
        pla                         ; pull return address
        pla
        
        cli                         ; clear interrupt diabled bit
        jmp xt_abort

.endif
v_kb_irq_timer:
.ifdef kb_time
    lda KB_T1CL ; clear timer interrupt
    inc kb_time
    bne v_irq_exit
.endif
    ;jsr kb_scan
v_irq_exit:
    ply
    pla
    rti

free_message: .byte " bytes free", $0D, 0
ready_message: .byte "Ready", $0D, 0
welcome_message: .byte "Welcome to Planck 6502", $0D, "Type 'words' for available words", $0D, 0
abort_message: .byte AscCR, AscLF, 0

.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq