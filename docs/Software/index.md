---
layout: page
title: Planck 6502 software
---


The software is currently built around [Tali Forth 2](https://github.com/scotws/TaliForth2). A binary is provided in [`Software/forth/taliforth-planck.bin`](https://gitlab.com/planck-6502/planck-6502/-/tree/master/Software/forth). Just program this binary to a 32K eeprom, insert it in the ZIF socket on the CPU board and you should be good to go.

By default the software expects the I/O board to be in SLOT 2 and the Serial board to be in SLOT 3, but this can be changed by changing the hardware definitions in [`platform-planck.asm`](https://gitlab.com/planck-6502/planck-6502/-/blob/master/Software/forth/platform/platform-planck.asm#L109)