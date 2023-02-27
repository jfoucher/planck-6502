---
layout: board
title: Banked RAM board
short_title: RAM board
status: dev
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/main/Hardware/ram_board
order: 60
gerbers: https://planck6502.com/fabrication/ram_board-zip.zip
schematic: https://planck6502.com/fabrication/ram_board-schematic.pdf
html_bom: https://planck6502.com/fabrication/ram_board-bom.html
csv_bom: https://planck6502.com/fabrication/ram_board-bom.csv
---

This is a banked RAM board for the Planck 6502 computer.


When active, it gives access to a bank or RAM in the $8000-$BFFF address space.

To activate, store a byte with it's high bit set to the first register of the slot where it is placed.

For example 
lda #$80
sta $FFD0
will activate bank 0

There are 32 banks. You can choose which one is active by setting the first 5 bits of the data when storing to the first register. There is no way to get the currently active bank.

When the RAM card is active, it will respond to requests in the $8000 to $BFFF range instead of the ROM

lda #$8E
sta $FFD0
will activate the 14th bank

Setting the high bit to 0 will deactivate the banked RAM

For example the following code will deactivate the banked RAM and restore the ROM :

lda #0
sta $FFD0

## Slot placement

There is no driver for this board, you will have to develop custom code for it, so you can place it anywhere you like as long as your code looks for it in the right place.

