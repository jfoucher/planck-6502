.segment "CODE"

; I/O facilities are handled in the separate kernel files because of their
; hardware dependencies. See docs/memorymap.txt for a discussion of Tali's
; memory layout.


; MEMORY MAP OF RAM


; Drawing is not only very ugly, but also not to scale. See the manual for 
; details on the memory map. Note that some of the values are hard-coded in
; the testing routines, especially the size of the input history buffer, the
; offset for PAD, and the total RAM size. If these are changed, the tests will
; have to be changed as well


;    $0000  +-------------------+  ram_start, zpage, user0
;           |  User variables  |
;           +-------------------+  
;           |                   |
;           |                   |
;           +~~~~~~~~~~~~~~~~~~~+  <-- dsp
;           |                   |
;           |  ^  Data Stack    |  
;           |  |                |
;    $0078  +-------------------+  dsp0, stack
;           |                   |
;           |   (Reserved for   |
;           |      kernel)      |
;           |                   |
;    $0100  +-------------------+  
;           |                   |
;           |  ^  Return Stack  |  <-- rsp 
;           |  |                |
;    $0200  +-------------------+  rsp0, buffer, buffer0
;           |  |                |
;           |  v  Input Buffer  |
;           |                   |
;    $0300  +-------------------+  cp0
;           |  |                |
;           |  v  Dictionary    |
;           |       (RAM)       |
;           |                   |
;   (...)   ~~~~~~~~~~~~~~~~~~~~~  <-- cp
;           |                   |
;           |                   |
;           |                   |
;           |                   |
;           |                   |
;           |                   |
;    $7C00  +-------------------+  hist_buff, cp_end
;           |   Input History   |
;           |    for ACCEPT     |
;           |  8x128B buffers   |
;    $7fff  +-------------------+  ram_end


; HARD PHYSICAL ADDRESSES

; Some of these are somewhat silly for the 65c02, where for example
; the location of the Zero Page is fixed by hardware. However, we keep
; these for easier comparisons with Liara Forth's structure and to 
; help people new to these things.

ram_start = $0000          ; start of installed 32 KiB of RAM
ram_end =   $8000-1        ; end of installed RAM
zpage =     ram_start      ; begin of Zero Page ($0000-$00ff)
zpage_end = $7F            ; end of Zero Page used ($0000-$007f)	
stack0 =    $0100          ; begin of Return Stack ($0100-$01ff)
hist_buff = ram_end-$03ff  ; begin of history buffers
            



; SOFT PHYSICAL ADDRESSES

; Tali currently doesn't have separate user variables for multitasking. To
; prepare for this, though, we've already named the location of the user
; variables user0. 





KB_BUF =    hist_buff - $ff
LCD_BUF =   KB_BUF - $7f
LINE_BUF =  LCD_BUF - $7f
SD_CRC =    LINE_BUF - $1
SD_SLAVE =  SD_CRC - $1
SD_TMP =  SD_SLAVE - $1
SD_ARG =    SD_TMP - $4
SD_BUF =    SD_ARG - $1ff
user0 =     zpage          ; user and system variables

rsp0 =      $ff            ; initial Return Stack Pointer (65c02 stack)
bsize =     $ff            ; size of input/output buffers
buffer0 =   stack0+$100    ; input buffer ($0200-$027f)
cp0 =       buffer0+bsize  ; Dictionary starts after last buffer
cp_end =    SD_BUF         ; Last RAM byte available for code
padoffset = $ff            ; offset from CP to PAD (holds number strings)




;PLANCK DEFINITIONS

; clock speed of main oscillator in hertz
; used by drivers/timer.s to set proper via timing interval
CLOCK_SPEED = 24000000      
; I/O board in slot 0
VIA1_BASE =        $FF80
; Serial chip at this address
ACIA_BASE =        $FFE0

; VIDEO board in slot 3
VIDEO_BASE =       $FFB0

; LCD board in slot 2
LCD_BASE =         $FFD0

ACIA_DATA =    ACIA_BASE
ACIA_STATUS =  ACIA_BASE+1
ACIA_COMMAND = ACIA_BASE+2
ACIA_CTRL =    ACIA_BASE+3

LCD_ADDR_DISABLED = LCD_BASE
LCD_ADDR_ENABLED = LCD_BASE + 1
LCD_DATA_DISABLED = LCD_BASE + 2
LCD_DATA_ENABLED = LCD_BASE + 3

PORTB =  VIA1_BASE
PORTA =   VIA1_BASE+1
DDRB =  VIA1_BASE+2
DDRA =  VIA1_BASE+3

T1CL =  VIA1_BASE + 4
T1CH =  VIA1_BASE + 5
T1LL =  VIA1_BASE + 6
T1LH =  VIA1_BASE + 7
ACR =  VIA1_BASE + 11
PCR =  VIA1_BASE + 12
IFR =  VIA1_BASE + 13
IER =  VIA1_BASE + 14


VIDEO_CTRL = VIDEO_BASE       ;// Formatted as follows |INCR_5|INCR_4|INCR_3|INCR_2|INCR_1|INCR_0|MODE_1|MODE_0|  default to LORES
VIDEO_ADDR_LOW = VIDEO_BASE + 1   ;//  ||||ADDR4|ADDR_3|ADDR_2|ADDR_1|ADDR_0|
VIDEO_ADDR_HIGH = VIDEO_BASE + 2
VIDEO_DATA = VIDEO_BASE + 3
VIDEO_IEN = VIDEO_BASE + 4    ;// formatted as follows |VSYNC| | | | | | |HSYNC|
VIDEO_INTR = VIDEO_BASE + 5   ;// formatted as follows |VSYNC| | | | | | |HSYNC|
VIDEO_HSCROLL = VIDEO_BASE + 6
VIDEO_VSCROLL = VIDEO_BASE + 7
VIDEO_HIRES_HCHARS = 100
VIDEO_HIRES_VCHARS = 75

; ps2 defines

DATA = $80   ; Data is in bit 7 of PORTB
; clock is on CB2
SHIFT = $1
ALT = $2

KB_STATE_START = $0
KB_STATE_DATA = $1
KB_STATE_PARITY = $2
KB_STATE_STOP = $3

KB_INIT_STATE_RESET = $0
KB_INIT_STATE_RESET_ACK = $1
KB_INIT_STATE_LEDS = $2
KB_INIT_STATE_LEDS_ACK = $3
KB_INIT_STATE_LEDS_DATA = $4
KB_INIT_STATE_LEDS_DATA_ACK = $5

LSHIFT_KEY = $12
RSHIFT_KEY = $59

TIMER_DELAY = $C4

; Zero page variables

stack_p =          dsp0
time =             dsp0+2
last_ps2_time =    dsp0+6

to_send =          dsp0+10
KB_STATE =         dsp0+11
KB_TEMP =          dsp0+11

KB_BUF_W_PTR =     dsp0+12
KB_BUF_R_PTR =     dsp0+13
KB_PARITY =        dsp0+14
KB_BIT =           dsp0+15
KB_INIT_STATE =    dsp0+16
KB_INIT_WAIT =     dsp0+17

ready =            dsp0+18

ignore_next =      dsp0+19
control_keys =     dsp0+20

character =        dsp0+21
debug =            dsp0+22

temp_bits =        dsp0+23
LCD_BUF_W_PTR =    dsp0+24
LCD_BUF_R_PTR =    dsp0+25
line =             dsp0+26
char =             dsp0+27
lcd_absent =       dsp0+28
lcd_pos =          dsp0+29
has_acia =         dsp0+30
spi_tmp =          dsp0+31
spi_tmp2 =         dsp0+32
spi_slave =        dsp0+33





.include "../../drivers/spi.s"
.include "../../drivers/delayroutines.s"
.include "../../drivers/ps2.s"

.include "../../drivers/timer.s"
.include "../../drivers/lcd.s"
.include "../../drivers/vga.s"

.include "../../drivers/sd.s"
.include "../taliforth.asm" ; Top-level definitions, memory map

; =====================================================================
; FINALLY

; Of the 32 KiB we use, 24 KiB are reserved for Tali (from $8000 to $DFFF)
; and the last eight (from $E000 to $FFFF) are left for whatever the user
; wants to use them for.


; ******************************************************************
; *  Hardware definitions for Planck 6502 computer                 *
; *  Change these depending on the slot in which                   *
; *  you want to put each card                                     *
; *  As a reminder here are the addresses for each slot:           *
; *                                                                *
; * START ADDRESS    |   END ADDRESS       |     DESCRIPTION       *
; * 0xFF80           |   0xFF8F            | SLOT1 Selected        *
; * 0xFF90           |   0xFF9F            | SLOT2 Selected        *
; * 0xFFA0           |   0xFFAF            | SLOT3 Selected        *
; * 0xFFB0           |   0xFFBF            | SLOT4 Selected        *
; * 0xFFC0           |   0xFFCF            | SLOT5 Selected        *
; ******************************************************************
;
;

.segment "KERNEL"

; Default kernel file for Tali Forth 2 
; Scot W. Stevenson <scot.stevenson@gmail.com>
; First version: 19. Jan 2014
; This version: 18. Feb 2018
;
; This section attempts to isolate the hardware-dependent parts of Tali
; Forth 2 to make it easier for people to port it to their own machines.
; Ideally, you shouldn't have to touch any other files. There are three
; routines and one string that must be present for Tali to run:
;
;       kernel_init - Initialize the low-level hardware
;       kernel_getc - Get single character in A from the keyboard (blocks)
;       kernel_putc - Prints the character in A to the screen
;       s_kernel_id - The zero-terminated string printed at boot
;


v_reset:
kernel_init:
        ; """Initialize the hardware. This is called with a JMP and not
        ; a JSR because we don't have anything set up for that yet. With
        ; py65mon, of course, this is really easy. -- At the end, we JMP
        ; back to the label forth to start the Forth system.
        ; """

        lda #1
        sta PORTA
        lda #$FF
        sta DDRA
        sta DDRB
        
        ldy #04
        jsr delay_long

        jsr video_init

        
        jsr ps2_init
        jsr timer_init
        jsr Init_ACIA

        jsr lcd_init

v_nmi:
        cli
        ; lda #$55
        ; sta PORTA
        ; We've successfully set everything up, so print the kernel
        ; string
        ldx #0
@loop:
        lda s_kernel_id,x
        beq @done
        jsr kernel_putc
        inx
        bra @loop
@done:
        lda #1
        sta PORTB
        jmp forth



; The Planck computer runs Tali Forth 2 as the OS, to there is nowhere to go back to.
; Just restart TALI.
platform_bye:   
        jmp kernel_init


    ;; Init ACIA to 115200 8,N,1
    ;; Uses: A (not restored)
Init_ACIA:  
        sta ACIA_STATUS        ; soft reset (value not important)
                                ; set specific modes and functions
        stz has_acia
        lda #$0B                ; no parity, no echo, no Tx interrupt, NO Rx interrupt, enable Tx/Rx
        ;lda #$09               ; no parity, no echo, no Tx interrupt, Rx interrupt, enable Tx/Rx
        sta ACIA_COMMAND        ; store to the command register
        lda ACIA_COMMAND        ; load command register again
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
        ldy #20
aa_loop:
        lda ACIA_STATUS         ; Read ACIA data a few times
        lda ACIA_DATA           ; to try and prevent spurious characters
        dey
        bne aa_loop
aa_end:
        rts


        ;; Get_Char - get a character from the serial port into A.
        ;; Set the carry flag if char is valid.
        ;; Return immediately with carry flag clear if no char available.
        ;; Uses: A (return value)
Get_Char:
        lda has_acia                    ; if no ACIA
        beq no_acia_char_available      ; exit now
        lda ACIA_STATUS                 ; Read the ACAI status to
        and #$08                        ; Check if there is character in the receiver
        beq no_acia_char_available      ; Exit now if we don't get one.
        lda ACIA_DATA                   ; Load it into the accumulator
        sec                             ; Set Carry to show we got a character
        jsr check_ctrl_c
        rts                             ; Return
      
no_acia_char_available:                 ; no ACIA char available
        phx                             ; save X
        ldx KB_BUF_R_PTR                ; check the keyboard buffer
        lda KB_BUF, x                   
        beq no_ps2_char_available       ; exit if nothing found
        stz KB_BUF, x                   ; if there was a character, reset this buffer cell
        inc KB_BUF_R_PTR                ; and increment the read pointer

        sec                             ; mark character present
        plx                             ; restore X
        jsr check_ctrl_c
        rts                             ; return
no_ps2_char_available:                  ; no keyboard char
        inc KB_BUF_R_PTR                ; increment read pointer for next time
        plx                             ; restore X
no_char_available:
        clc                             ; Indicate no char available.
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


        jmp xt_abort

exit_ctrl_c:
        sec
        rts

kernel_putc:
        ; """Print a single character to the console. """
        ;; Send_Char - send character in A out serial port.
        ;; Uses: A (original value restored)
Send_Char:
        jsr char_out
        phy
        ldy has_acia
        beq send_char_exit
        sta ACIA_DATA
        
        ; nedd to provide additional delay for ACIA
        ldy #$20
        jsr delay_short
        ; Delay is provided by writing to the LCD screen
        ;ldy #$32            ;minimal delay; The min delay increased when added diode on SLOW. Why?
        ;jsr delay_short
        ;ldy #$30
        ;jsr delay

        ;jsr char_out
send_char_exit:    
        ;jsr lcd_print
        ply
        rts


v_irq:                          ; IRQ handler
        pha
        phy
        ; check if bit 7 of IFR is set
        lda IFR
        bpl v_exit  ; Interrupt not from VIA, exit

        and #$08        ; ps2 has priority
        bne v_ps2
        lda IFR
        and #$40
        bne v_timer
        bra v_exit


v_ps2:
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
        bra v_exit
v_timer:
        lda T1CL
        jsr timer_irq
        jsr Get_Char ; Check if a char is waiting to be able to break on CTRL-C
        ; check if there is a char waiting to be printed to the lcd
        ; lda lcd_char
        ; beq v_exit
        ; jsr lcd_print
        ; stz lcd_char

v_exit:
        ply
        pla
        rti

; Leave the following string as the last entry in the kernel routine so it
; is easier to see where the kernel ends in hex dumps. This string is
; displayed after a successful boot
s_kernel_id: 
        .byte "Tali Forth 2.1 for Planck 6502", 0



; Add the interrupt vectors 
.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq

; END
	
