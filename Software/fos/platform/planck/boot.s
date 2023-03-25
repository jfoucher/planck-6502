
.include "../../macros.s"
CLOCK_SPEED = 12000000

RAM_END = $8000
CODE_START= $200

; select includes to enable card drivers

.include "drivers/cf.inc"


.segment "ZEROPAGE": zeropage
IRQ_VEC: .res 2
NMI_VEC: .res 2
io_buffer_ptr: .res 2

.segment "BSS"
has_acia: .res 1
.ifdef CF_ADDRESS
IO_SECTOR: .res 4
.endif


.segment "CODE"

.include "drivers/acia.inc"
.include "drivers/acia.s"
.include "drivers/delayroutines.s"

.ifdef CF_ADDRESS
io_read_sector_address = cf_read_sector
.endif



reset:
    jsr acia_init

    lda #'1'
    jsr acia_out
    jsr cf_init

    ; copy data from CF card to RAM

    stz IO_SECTOR
    stz IO_SECTOR + 1
    stz IO_SECTOR + 2
    stz IO_SECTOR + 3
    ; stz NMI_VEC
    ; stz NMI_VEC + 1
    ; stz IRQ_VEC
    ; stz IRQ_VEC + 1

    lda #<CODE_START
    sta io_buffer_ptr
    lda #>CODE_START
    sta io_buffer_ptr + 1

    ldx #(((RAM_END-CODE_START)/$200)-1)                 ; number of sectors to read
@loop:
    jsr io_read_sector
    inc io_buffer_ptr + 1
    inc io_buffer_ptr + 1
    inc IO_SECTOR
    dex
    bne @loop

    lda #'2'
    jsr acia_out

    lda CODE_START
    jsr acia_out
    lda CODE_START + 1
    jsr acia_out
    lda CODE_START + 2
    jsr acia_out

    jmp CODE_START          ; jump to start of code

nmi:
    pha		; save affected register

	lda NMI_VEC	; check if NMI vector is zero
	ora NMI_VEC+1
	beq nmi_end		; if so, skip


	pla		; restore register
	jmp (NMI_VEC)

nmi_end:    ; should not be called
	pla		; restore register
	rti		; return from interrupt

irq: 
	pha		; save affected register

	lda IRQ_VEC	; check if IRQ vector is zero
	ora IRQ_VEC+1
	beq end		; if so, skip

	; there is no indirect jsr so push return address to stack
	; so the actual IRQ handler code can rts later on
	pla		; restore register
	jmp (IRQ_VEC)

end:
	pla		; restore register
	rti		; return from interrupt

io_read_sector:
    jmp io_read_sector_address        ; jump to read sector routine


kernel_putc:
    rts

cf_init:
    ; phy
    lda #$4
    ; ldy #7
    ; sta (CF_ADDRESS),y
    sta CF_ADDRESS + 7
    jsr cf_wait
    lda #$E0
    sta CF_ADDRESS + 6
    jsr cf_wait
    lda #$1
    sta CF_ADDRESS + 1
    jsr cf_wait
    lda #$EF
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_err
    ; ply
    rts


cf_read:
    ; jsr cf_wait
    jsr cf_wait
    lda CF_ADDRESS + 7
    and #$08
    beq @exit
    lda CF_ADDRESS
    sta (io_buffer_ptr)
    inc io_buffer_ptr
    bne cf_read
    inc io_buffer_ptr + 1
    bra cf_read
@exit:
    rts


; number of sectors to read is in X
cf_read_sector:
    sei
    jsr cf_set_lba
    lda #1
    sta CF_ADDRESS + 2
    jsr cf_wait
    lda #CF_READ_SECTOR_COMMAND
    sta CF_ADDRESS + 7
    jsr cf_wait
    jsr cf_read
    jsr cf_err
    cli
    rts



cf_wait: 
    lda CF_ADDRESS + 7
    bmi cf_wait             ; wait FOR RDY to become unset
    and #$10
    beq cf_wait             ; wait for DSC to become set
    rts
    
cf_set_lba:
    lda IO_SECTOR
    sta CF_ADDRESS + 3
    jsr cf_wait
    lda IO_SECTOR + 1
    sta CF_ADDRESS + 4
    jsr cf_wait
    lda IO_SECTOR + 2
    sta CF_ADDRESS + 5
    jsr cf_wait
    lda IO_SECTOR + 3
    and #$0F
    ora #$E0
    sta CF_ADDRESS + 6
    jsr cf_wait
    rts

cf_err:
    jsr cf_wait
    lda CF_ADDRESS + 7
    and #$01
    beq @exit
@exit_fail:
    lda #'!'
    jsr kernel_putc
@exit:
    rts

.segment "VECTORS"
.word nmi
.word reset
.word irq