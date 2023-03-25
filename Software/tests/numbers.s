
.segment "CODE"
reset:
.repeat 127
.repeat 256, i
    .byte i
.endrepeat
.endrepeat

.segment "ROM_VECTORS"

.word reset
.word reset
.word reset