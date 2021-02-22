
; initialize the LCD in A bit mode
lcd_init:
    jsr buf_clr
    lda #0
    sta lcd_absent
    sta LCD_PORT
    sta LCD_BUF_W_PTR
    sta LCD_BUF_R_PTR
    ;set PORTA to output mode
    lda #$FF
    sta LCD_DDR
    
    ldx #3
@l:
    LDA #$30            ;function set
    jsr lcd_inst_single

    ldy #$FF
    jsr delay
    dex 
    bne @l

    ldy #$FF
    jsr delay

    LDA #$28            ;function set: 4 bit
    jsr lcd_inst_no_busy_check
    ldy #$ff            ; wait a while
    jsr delay

    ldy #$FF
    jsr delay

    ;entry mode set
    LDA #$06
    jsr lcd_inst

    LDA #$0F            ;display on, cursor on, blink on
    jsr lcd_inst

    ;clear display
    LDA #$01            
    jsr lcd_inst

    ;set dram address to start of screen
    LDA #$80            
    jsr lcd_inst

    RTS



; waits until the LCD has finished the current operation
lcd_busy:
    PHA
    phx
    phy
    lda #[LCD_RW | LCD_E | LCD_RS]      
    sta LCD_DDR        ; set PORTA as input and Write and enable pins high
    lda #LCD_RW
    sta LCD_PORT
    lda #[LCD_RW | LCD_E]
    sta LCD_PORT
    ldx #$ff
@lcd_busy:
    ldy #$10
    jsr delay_short
    dex
    beq @lcd_absent       ; try it for 255 times max
    bit LCD_PORT       ;check if bit 7 is set, if so, lcd is busy
    bmi @lcd_busy
    bpl @lcd_end
@lcd_absent:
    lda #1
    sta lcd_absent
@lcd_end:
    lda #LCD_RW
    sta LCD_PORT
    lda #[LCD_RW | LCD_E]
    sta LCD_PORT
    lda #0
    sta LCD_PORT
@lcd_exit:
    ply
    plx
    PLA
    RTS

; Sends the character in A to the display
lcd_send:               ; 8 bit data in A
    pha
    phx
    phy
    ldx #[LCD_DATA | LCD_E | LCD_RS | LCD_RW]   ; set DDR to enable all pins as output
    stx LCD_DDR
    tax                     ; save A for later
    and #LCD_DATA           ; keep only 4 high bits
    ora #LCD_RS
    sta LCD_PORT            ; set data on port

    ora #LCD_E          ; enable and RS pins HIGH
    sta LCD_PORT            ; enable and RS high

    and #[$FF ^ LCD_E]
    sta LCD_PORT

    ; send low 4 bits
    txa                 ; recover A
    asl                 ; shift to high bits
    asl
    asl
    asl
    and #$F0
    ora #LCD_RS
    sta LCD_PORT

    ora #LCD_E          ; set enable high
    sta LCD_PORT

    and #[$FF ^ LCD_E] ; set enable pin low
    sta LCD_PORT
    jsr lcd_busy        ; wait for operation to complete
    ply
    plx
    pla
    rts

; gets the current display address and returns it in A
lcd_get_ram_addr:
    lda #[LCD_RW | LCD_E | LCD_RS]
    sta LCD_DDR        ; set PORTA as input and Write and enable pins high
    lda #LCD_RW 
    sta LCD_PORT
    lda #[LCD_RW | LCD_E]
    sta LCD_PORT

    lda LCD_PORT        ; get top 3 bits of address
    and #$70
    sta temp_bits                ; save temp
    lda #LCD_RW
    sta LCD_PORT
    lda #[LCD_RW | LCD_E]
    sta LCD_PORT
    lda LCD_PORT        ; getting bottom 4 bits of address
    and #$F0
    lsr                 ; shift into bottom bits
    lsr
    lsr
    lsr
    ora temp_bits

    jsr lcd_busy

    RTS

; gets the data at the current address and returns it in A
lcd_read_data:
    lda #[LCD_RW | LCD_E | LCD_RS]
    sta LCD_DDR        ; set PORTA as input and Write and enable pins high
    lda #LCD_RW 
    sta LCD_PORT
    lda #[LCD_RS | LCD_E | LCD_RW]
    sta LCD_PORT

    lda LCD_PORT        ; get top 3 bits of data
    and #$70
    sta temp_bits                ; save temp
    lda #LCD_RW
    sta LCD_PORT
    lda #[LCD_RS | LCD_RW | LCD_E]
    sta LCD_PORT
    lda LCD_PORT        ; getting bottom 4 bits of data
    and #$F0
    lsr                 ; shift into bottom bits
    lsr
    lsr
    lsr
    ora temp_bits

    jsr lcd_busy

    RTS



; Send an instruction in 8 bit mode
lcd_inst_single:
    pha
    phy

    ldy #[LCD_DATA | LCD_E | LCD_RS | LCD_RW]   ; set DDR to enable all pins as output
    sty LCD_DDR

    and #LCD_DATA       ; keep only 4 high bits
    sta LCD_PORT

    ora #LCD_E          ; enable pin HIGH
    sta LCD_PORT        ; enable high

    and #[$FF ^ LCD_E] ; set enable pin low
    sta LCD_PORT
    ldy #$FF
    jsr delay
    ply
    pla
    rts

; Sends an instruction in 4 bit mode, waiting for it to complete by polling the ready bit
lcd_inst:               ; 8 bit instruction in A
    jsr lcd_inst_no_busy_check
    jsr lcd_busy        ; wait for operation to complete
    rts

; Sends an instruction in 4 bit mode and uses a delay instead of ready bit polling
lcd_inst_no_busy_check:               ; 8 bit instruction in A
    pha
    phy
    phx
    ldy #[LCD_DATA | LCD_E | LCD_RS | LCD_RW]   ; set DDR to enable all pins as output
    sty LCD_DDR
    tax                 ; save A in X for later
    and #LCD_DATA       ; keep only 4 high bits
    sta LCD_PORT
    ora #LCD_E          ; enable pin HIGH
    sta LCD_PORT        ; enable high

    and #[$FF ^ LCD_E] ; set enable pin low
    sta LCD_PORT
    ; send low 4 bits
    txa                 ; recover A
    asl                 ; shift to high bits
    asl
    asl
    asl
    sta LCD_PORT
    ora #LCD_E          ; set enable high
    sta LCD_PORT
    and #[$FF ^ LCD_E] ; set enable pin low
    sta LCD_PORT

    plx
    ply
    pla
    rts

lcd_clear:
    PHA
    ;clear display
    LDA #$01
    jsr lcd_inst
    ;set dram address
    LDA #$80            
    jsr lcd_inst
    PLA
    RTS

lcd_print:
    pha
    phx
    phy
    ldx lcd_absent
    bne @exit_print
    ldy #0
lcd_wp_done:
    pha
    cmp #$0A
    beq @next_line
    cmp #$0D
    beq @next_line
    cmp #$08            ;backspace
    beq @backspace
    pha
    jsr lcd_get_ram_addr            ;get current DDRAM address
    tax
    pla
    
    jsr lcd_send            ;output the character
    sta LCD_BUF,X           ; store in buffer at current address
    txa
    ; lda temp_bits
    and #$7F
    cmp #$67            ;wrap from pos $54 (line 1 char 20)...
    beq @clr
    cmp #$53            ;wrap from pos $54 (line 1 char 20)...
    beq @line_3
    cmp #$27
    beq @line_4
    CMP #$13            ;wrap from pos $13 (line 1 char 20)...
    beq @line_2
    
@continue:
    pla
    sta LCD_BUF,X           ; store in buffer at current address
    tya
    beq @exit_print
    ora #$80                ; set address to next address
    jsr lcd_inst

@exit_print:
    ply
    plx
    pla
    rts

@backspace:
    lda #$10            ; shift cursor left
    jsr lcd_inst
    lda #$20            ; print a space to erase previous char
    jsr lcd_send
    lda #$10            ; shift cursor left
    jsr lcd_inst
    pla                 ; pull original backspace char from stack
    lda #$20            ; and replace with space
    pha
    bra @continue
@line_2:
    ldy #$C0            ;...to $40 (line 2 char 1)
    bra @continue

@line_3:
    ldy #$94            ;...to $14 (line 3 char 1)
    bra @continue

@line_4:
    ldy #$D4            ;...to $14 (line 3 char 1)
    bra @continue
@clr:
    ;jsr lcd_clear
    jsr lcd_scroll_up
    ldy #0
    bra @continue

@next_line:
    jsr lcd_get_ram_addr            ;get current DDRAM address
    AND #$7F
    CMP #$54            ;wrap from pos $54 (line 1 char 20)...
    bcs @clr
    CMP #$40            ;wrap from pos $54 (line 1 char 20)...
    bcs @line_3
    cmp #$14
    bcs @line_4
    CMP #0            ;wrap from pos $13 (line 1 char 20)...
    bcs @line_2

lcd_scroll_up:
    pha
    phx
    phy
    jsr lcd_clear
    ;ldy #$ff
    ;jsr delay
    ;copy second line to first
    lda #$80                ; set address to start of first line
    jsr lcd_inst
    ldx #$40
@print_loop1:       
    jsr lcd_get_ram_addr    ; get current ram address
    pha                     ; save on stack
    lda LCD_BUF, x          ; load char from buffer
    tay                     ; transfer char to Y for safekeeping
    jsr lcd_send            ; send the character to the LCD
    pla                     ; restore RAM address from stack
    phx                     ; save X on stack
    tax                     ; put current ram address in X
    tya                     ; restore char from Y
    sta LCD_BUF, x          ; store char at correct spot in buffer
    ;ldy #$80                ; delay
    ;jsr delay
    plx                     ; restore X from stack
    inx                     ; increment X
    cpx #$54                ; repeat if not at end of line yet
    bcc @print_loop1

    ; copy third line to the second
    lda #$40
    ora #$80                ; set address to start of second line
    jsr lcd_inst
    ldx #$14                ; get chars from buffer starting at the start of the third line
@print_loop2:
    jsr lcd_get_ram_addr    ; get current ram address
    pha                     ; save on stack
    lda LCD_BUF, x          ; load char from buffer
    tay                     ; transfer char to Y for safekeeping
    jsr lcd_send            ; send the character to the LCD
    pla                     ; restore RAM address from stack
    phx                     ; save X on stack
    tax                     ; put current ram address in X
    tya                     ; restore char from Y
    sta LCD_BUF, x          ; store char at correct spot in buffer
    ;ldy #$C0                ; delay
    ;jsr delay
    plx                     ; restore X from stack
    inx                     ; increment X
    cpx #$27
    bcc @print_loop2

    ;copy fourth line to the third
    lda #$14
    ora #$80                ; set address to start of last line
    jsr lcd_inst
    ldx #$54
@print_loop3:
    jsr lcd_get_ram_addr    ; get current ram address
    pha                     ; save on stack
    lda LCD_BUF, x          ; load char from buffer
    tay                     ; transfer char to Y for safekeeping
    jsr lcd_send            ; send the character to the LCD
    pla                     ; restore RAM address from stack
    phx                     ; save X on stack
    tax                     ; put current ram address in X
    tya                     ; restore char from Y
    sta LCD_BUF, x          ; store char at correct spot in buffer
    ;ldy #$ff                ; delay
    ;jsr delay
    plx                     ; restore X from stack
    inx                     ; increment X
    cpx #$67
    bcc @print_loop3

@last_line:                 ; fill last line with spaces
    lda #$54
    ora #$80                ; set address to start of last line
    jsr lcd_inst
    ldx #$54
    lda #$20
@last_line_loop:
    sta LCD_BUF, x
    jsr lcd_send
    ;ldy #$ff                ; delay
    ;jsr delay
    inx
    cpx #$66
    bcc @last_line_loop

    lda #$54
    ora #$80                ; set address to start of last line
    jsr lcd_inst
    ply
    plx
    pla
    rts

buf_clr:
    pha
    phx
    ldx #$80
    lda #$20
buf_clr_loop:
    sta LCD_BUF,X
    dex
    bne buf_clr_loop
    plx
    pla
    rts