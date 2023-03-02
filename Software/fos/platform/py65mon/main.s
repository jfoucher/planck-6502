
ram_end = $8000

.import    copydata, zerobss
.segment "STARTUP"

v_reset:
    JSR     copydata
    jmp kernel_init

.segment "DATA"

.include "../../forth.s"



kernel_init:
v_nmi:
v_irq:                          ; IRQ handler

printascii welcome_message


jmp forth

platform_bye:   
    jmp platform_bye

kernel_putc:
    ; """Print a single character to the console. """
    ;; Send_Char - send character in A out serial port.
    ;; Uses: A (original value restored)
        sta $f001
        rts

kernel_getc:
        ; """Get a single character from the keyboard. By default, py65mon
        ; is set to $f004, which we just keep. Note that py65mon's getc routine
        ; is non-blocking, so it will return '00' even if no key has been
        ; pressed. We turn this into a blocking version by waiting for a
        ; non-zero character.
        ; """

_loop:
                lda $f004
                beq _loop
                rts



io_read_sector:

    rts
        

.segment "RODATA"

welcome_message: .byte "Welcome to Planck 6502", AscCR, AscLF, AscCR,AscLF, "Type 'words' for available words",AscCR, AscLF,  0

.segment "VECTORS"

.word v_nmi
.word v_reset
.word v_irq