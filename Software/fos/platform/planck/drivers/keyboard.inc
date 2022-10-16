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


KB_VIA_BASE   = $FF90
KB_PORTB = KB_VIA_BASE
KB_PORTA  = KB_VIA_BASE+1
KB_DDRB = KB_VIA_BASE+2
KB_DDRA = KB_VIA_BASE+3


KB_T1CL = KB_VIA_BASE + 4
KB_T1CH = KB_VIA_BASE + 5
KB_T1LL = KB_VIA_BASE + 6
KB_T1LH = KB_VIA_BASE + 7
KB_ACR = KB_VIA_BASE + 11
KB_PCR = KB_VIA_BASE + 12
KB_IFR = KB_VIA_BASE + 13
KB_IER = KB_VIA_BASE + 14