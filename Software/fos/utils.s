;  print a 16-bit integer
; lsb in x, msb in a

.segment "ZEROPAGE": zeropage
util_tmp: .res 2

.segment "BSS"
tmp_var: .res 2

.segment "DATA"

print16:
    sta acc+1
    stx acc

    ldx #4
nextdig:
    jsr div
    lda ext
    sta num,x
    dex
    bpl nextdig

firstdig:
    inx
    cpx #5
    beq print0
    lda num,x
    beq firstdig

ptnxtdig:
    clc
    adc #'0'
    jsr kernel_putc
    inx
    cpx #5
    beq pt16done
    lda num,x
    jmp ptnxtdig

pt16done: 
    rts

print0:
    lda #'0'
    jsr kernel_putc
    rts

num: .byte 0,0,0,0,0

; 16/16-bit division, from the fridge
; acc/aux -> acc, remainder in ext
div:
    lda #0
    sta ext+1
    ldy #$10
dloop:
    asl acc
    rol acc+1
    rol
    rol ext+1
    pha
    cmp aux
    lda ext+1
    sbc aux+1
    bcc div2
    sta ext+1
    pla
    sbc aux
    pha
    inc acc
div2:
    pla
    dey
    bne dloop
    sta ext
    rts

acc: .word 0
aux: .word 10 ; constant
ext: .word 0



calculate_free_mem:
    ; load dictionary address
    ; fill with $55 until ram_end
    ; read and check same
    ; fill again with zeroes

    lda up
    sta util_tmp
    lda up + 1
    sta util_tmp + 1

    stz tmp_var
    stz tmp_var + 1

    ldy #0
@loop:
    lda #$55
    sta (util_tmp), y        ; store to mem address
    cmp (util_tmp), y        ; compare to what is now there
    bne @exit               ; no equal, stop couting and exit
    lda #0                  ; zero the memory again
    sta (util_tmp), y
    inc tmp_var
    bne @incok
    inc tmp_var + 1
@incok:
    iny
    bne @loop
    lda util_tmp + 1
    cmp #>ram_end
    bcs @exit
    inc util_tmp + 1
    bra @loop
@exit:
    rts
    


print_message:
	pla					; get return address from stack
	sta util_tmp
	pla
	sta util_tmp + 1		

	bra @inc
@print:
	jsr kernel_putc

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