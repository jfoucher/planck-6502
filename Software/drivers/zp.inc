; Copyright 2020 Jonathan Foucher

; Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
; and associated documentation files (the "Software"), to deal in the Software without restriction, 
; including without limitation the rights to use, copy, modify, merge, publish, distribute, 
; sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
; is furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all copies or 
; substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
; PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
; FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
; OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
; DEALINGS IN THE SOFTWARE.

; next_addr: .res 1




.segment "ZEROPAGE": zeropage

stack_p: .res 2
time: .res 4
last_ps2_time: .res 4

KB_BUF_W_PTR: .res 1
KB_BUF_R_PTR: .res 1
control_keys: .res 1
character: .res 1
debug: .res 1

temp_bits: .res 1
LCD_BUF_W_PTR: .res 1
LCD_BUF_R_PTR: .res 1
sd_buffer_address: .res 2
