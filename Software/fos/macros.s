.macro  printascii   addr
    ldx #0
@loop:
    lda addr,x
    beq @done
    jsr kernel_putc
    inx
    bra @loop
@done:
.endmacro

