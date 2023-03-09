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

.macro asl32 src 
    asl src
    rol src + 1
    rol src + 2
    rol src + 3
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

.macro inc32 src
.local @done
    inc src       ;Increment the LSB
    bne @done       ;If the result was not zero we're done
    inc src+1       ;Increment next byte if LSB wrapped round
    bne @done
    inc src+2       ;Increment the next byte the previous wrapped round
    bne @done
    inc src+3       ;Increment the MSB if previous wrapped round
@done:
.endmacro

.macro dec16 src
.local @skip
.local @end
    lda src             ; load low byte
    bne @skip           ; if it's not zero, just decrement it
    dec src + 1         ; if low byte is zero decrement high byte
@skip:
    dec src
@end:
.endmacro

.macro dec16zero src
.local @skip
.local @end
    lda src             ; load low byte
    bne @skip           ; if it's not zero, just decrement it
    dec src + 1         ; if low byte is zero decrement high byte
    beq @end            ; if high byte is also zero, we reached zero, exit now
@skip:
    dec src
    bne @end            ; if low byte is not zero exit now
    lda src + 1         ; if low byte is zero, load high byte to check if it's also zero
@end:
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

; compare data at two adresses for defined length
; On exit, carry is set if there is a match
; and unset if no match
; length of data to check is in X

.macro memcmp first, second
.local @exit
.local @loop
.local @exit_fail
@loop:
    lda first, x
    cmp second, x
    bne @exit_fail
    dex
    bne @loop
    lda first           ; check 0th element
    cmp second
    bne @exit_fail
    sec
    bra @exit
@exit_fail:
    clc
@exit:
.endmacro

; copy data from one address to another for defined length
; length of data to copy is in X
.macro memcp first, second
.local @exit
.local @loop
@loop:
    lda first, x
    sta second, x
    dex
    bne @loop
    lda first           ; copy zeroth item
    sta second
@exit:
.endmacro


; calculates length of zero terminated string
; result is in x
.macro strlen address
.local @loop
.local @exit
    ldx #0
@loop:
    lda address, x
    beq @exit
    inx
    bra @loop
@exit:
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
