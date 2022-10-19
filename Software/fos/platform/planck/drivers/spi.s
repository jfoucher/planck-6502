; SPI defines

SS = $07   ; Slave Select with lowest 3 bits
SCK = $08   ; Clock on bit 3
MISO = $10  ; MISO on bit 4
MOSI = $20  ; MOSI on bit 5
CONF = $40  ; CONF on bit 6

.segment "BSS"
spi_tmp: .res 1
spi_tmp2: .res 1
spi_slave: .res 1

.segment "DATA"

spi_init: 
    lda PORTB               ; load current port B
    and #(DATA | MISO)      ; set everything to zero except for PS2 DATA and MISO
    ora #CONF               ; set CONF high
    sta PORTB               ; save to PORTB
    lda DDRB                ; get current direction register
    ora #(MOSI | CONF | SCK | SS) ; set MOSI, CONF, SCK and SS as outputs
    and #($FF^MISO)                 ; set MISO as input        
    sta DDRB
    lda #$FF
    sta DDRA
    sta PORTA

    rts

spi_select:
    ; selected slave in A
    and #SS                 ; mask slave select bits
    sta PORTB               ; set everything low except for SS bits
    sta PORTA
    sta spi_slave
    phy
    ldy #$1
    jsr delay_short         ; slight delay
    ora #CONF               ; set CONF high to latch address
    sta PORTB               ; save to PORTB
    ply                     ; CONF MUST stay high for the duration of the transfer
    rts

spi_clk_toggle:
    rts

spi_transceive:
    ; send data in A, received data will be in A
    phy
    ; save data in RAM
    sta spi_tmp
    ; reset X
    phx
    ldx #8
    ; reset result
    stz spi_tmp2
spi_send_loop: 
    asl spi_tmp
    bcc bit_unset
bit_set: 
    lda PORTB
    ora #(MOSI | CONF)
    jmp clock_on
bit_unset:
    lda PORTB
    and #(($FF^MOSI) | CONF)
clock_on:
    ; set data bit
    ora spi_slave
    sta PORTB

    ; set clock on
    ora #(SCK | CONF)
    ora spi_slave
    sta PORTB

    ; read bit from slave, maybe add slight delay here ?
    lda PORTB
    and #MISO           ; mask miso bit
    bne spi_bit_set      ; bit is set
    ; bit is unset
    clc
    rol spi_tmp2
    jmp clock_off

spi_bit_set: 
    sec
    rol spi_tmp2


clock_off:
    lda PORTB
    and #(($FF^SCK) | CONF)
    ora spi_slave
    sta PORTB
end_loop: 
    dex
    bne spi_send_loop
    ; set data low
    ldy #$1
    jsr delay_short
    lda PORTB
    ora spi_slave
    and #(($FF^MOSI) | CONF)
    sta PORTB
    plx
    ply
    lda spi_tmp2
    rts