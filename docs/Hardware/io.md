---
layout: board
title: I/O board
status: prod
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/main/Hardware/io_board
order: 40
gerbers: https://planck6502.com/fabrication/io_board-zip.zip
schematic: https://planck6502.com/fabrication/io_board-schematic.pdf
html_bom: https://planck6502.com/fabrication/io_board-bom.html
csv_bom: https://planck6502.com/fabrication/io_board-bom.csv
---


This board is based on a WDC65C22 chip and provides a keyboard PS/2 port, a parallel port and a 65SIB port (serial port similar to and compatible with SPI)

![IO board](/img/io_board.jpg)

In this image you can see the PS/2 port at the top right, and just to he left of it a parallel port connected to the VIA's PORTA pins. Then to the right again 8 LEDs also connected to the PORTA pins.

Below the LEDs is the 65C22 VIA itself. To its right is located a 74HC137 chip that selects the SPI slave device to be used. And finally, to the right of that, at the back of the card is located the modified 65SIB port, which is basically an SPI port that can allow addressing up to 7 different devices.


## Slot placement

The I/O board should be inserted in SLOT 0 on the backplane, otherwise you will have to change the hardware definitions in [`platform-planck.asm`](https://gitlab.com/planck-6502/planck-6502/-/blob/main/Software/forth/platform/platform-planck.asm#L109)