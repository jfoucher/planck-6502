CLOCK_SPEED = 24000000

ram_end = $8000

.include "drivers/acia.inc"
.include "drivers/via.inc"
.include "drivers/ps2.inc"
.include "drivers/lcd.inc"
.include "drivers/vga.inc"
.include "drivers/keyboard.inc"

.include "drivers/zp.s"

.segment "BSS"

lcd_absent: .res 1

has_acia: .res 1


.segment "RODATA"

.import    copydata

.segment "STARTUP"

v_reset:
    JSR     copydata
    jmp kernel_init

.segment "DATA"

.include "drivers/acia.s"
.include "drivers/timer.s"
.include "drivers/keyboard.s"
; .include "drivers/ps2.s"
.include "drivers/delayroutines.s"
.include "drivers/lcd.s"
.include "drivers/spi.s"
.include "drivers/sd.s"
; .include "drivers/vga.s"
.include "drivers/fat32.s"

.include "../../forth.s"

kernel_init:
v_nmi:
    lda #$FF
    sta DDRB
    sta DDRA
    stz PORTA
    stz PORTB
.ifdef video_init
    jsr video_init
.endif
.ifdef ps2_init
    jsr ps2_init
.endif
.ifdef timer_init
    jsr timer_init
.endif
    jsr acia_init
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

    jmp forth

platform_bye:   
    jmp platform_bye


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
    jsr lcd_print
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
    jsr check_ctrl_c
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
        jsr kb_get_char_2
        
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
    
check_ctrl_c:
    ;; Check if we have ctrl-C character, if so jump to nmi
    cmp #$03
    bne exit_ctrl_c
    printascii abort_message
    jmp xt_abort

exit_ctrl_c:
    rts



v_irq:                          ; IRQ handler
        pha
        phy
        ; check if bit 7 of IFR is set
        lda IFR
        bpl v_kb_irq  ; Interrupt not from VIA, exit

        and #$08        ; ps2 has priority
        bne v_irq_ps2
        lda IFR
        and #$40
        bne v_irq_timer
v_kb_irq:
        lda KB_IFR
        bpl v_irq_exit
        and #$40
        bne v_kb_irq_timer
        bra v_irq_exit


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
        ; this delay is here to ensure we prevent desynchronization
        ;ldy #$04         ; correct delay seems to be #$20 at 10Mhz
        ; jsr delay_short
        
        
        jsr ps2_irq
        
        ; ldy #$04         ; correct delay seems to be #$20 at 10Mhz
        ; jsr delay_short
    .endif
        bra v_irq_exit
    
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


        bra v_irq_exit
v_kb_irq_timer:
    lda KB_T1CL ; clear timer interrupt
    inc kb_time
    bne v_irq_exit
    ;jsr kb_scan
v_irq_exit:
    ply
    pla
    rti

.segment "RODATA"

welcome_message: .byte "Welcome to Planck 6502", $0D, "Type 'words' for available words", 0
abort_message: .byte AscCR, AscLF, 0

.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq