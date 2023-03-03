.macro  printascii   addr
.local @loop
.local @done
    phx
    ldx #0
@loop:
    lda addr,x
    beq @done
    jsr kernel_putc
    inx
    bra @loop
@done:
    plx
.endmacro

.macro  cp16   src, dest
    lda src
    sta dest
    lda src + 1
    sta dest + 1
.endmacro

.macro printstr addr, len
.repeat len, I
lda addr + I
jsr kernel_putc
.endrepeat
.endmacro

.macro asl16 src 
    asl src
    rol src + 1
.endmacro

.macro lsr16 src 
    lsr src + 1
    ror src
.endmacro

.macro inc16 src
.local @done
    inc src       ;Increment the LSB
    bne @done       ;If the result was not zero we're done
    inc src+1       ;Increment the MSB if LSB wrapped round
@done:
.endmacro

.macro dec16 src
    lda src
    bne @skip
    dec src + 1
@skip:
    dec src
.endmacro

.macro add16 first, second, result
    CLC             ;Ensure carry is clear
    LDA first+0       ;Add the two least significant bytes
    ADC second+0
    STA result+0       ;... and store the result
    LDA first+1       ;Add the two most significant bytes
    ADC second+1       ;... and any propagated carry bit
    STA result+1       ;... and store the result
.endmacro



.macro push_axy
	pha		; push accumulator to stack
	phx
    phy
.endmacro

.macro pull_axy
	ply		; pull y from stack
	plx		; pull x from stack
	pla		; pull a from stack
.endmacro


.macro push_ax
	pha
	phx
.endmacro


.macro pull_ax
	pla
	plx
.endmacro

.macro push_ay
	pha
	phy
.endmacro


.macro pull_ay
	pla
	ply
.endmacro


.macro mov16 SRC, DEST
	lda SRC
	sta DEST
	lda SRC+1
	sta DEST+1
.endmacro

.macro mov32 SRC, DEST
	lda SRC
	sta DEST
	lda SRC+1
	sta DEST+1
	lda SRC+2
	sta DEST+2
	lda SRC+3
	sta DEST+3
.endmacro
