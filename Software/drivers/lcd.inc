
; HD 44780 driver
; all pins on VIA PORTA, 4 bit mode

; PORTA0 is free
LCD_RS = $2             ; PORTA1
LCD_RW = $4             ; PORTA2
LCD_E = $8              ; PORTA3

LCD_DATA = $F0          ; PORTA4-PORTA7

LCD_PORT = PORTA
LCD_DDR = DDRA