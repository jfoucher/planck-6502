---
layout: page
---

# Input / output board

[Design files](https://gitlab.com/planck-6502/planck-6502/-/tree/master/Hardware/io_board)

This board is based on a WDC65C22 chip and provides a keyboard PS/2 port, a parallel port and a 65SIB port (serial port similar to and compatible with SPI)


## Slot placement

The I/O board should be inserted in SLOT 2 on the backplane, otherwise you will have to change the hardware definitions in [`platform-planck.asm`](https://gitlab.com/planck-6502/planck-6502/-/blob/master/Software/forth/platform/platform-planck.asm#L109)