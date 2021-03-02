---
layout: page
title: Planck 6502 software
---

## Programmable Logic

The first thing to setup when building your Planck 6502 is to program the PLD chip on the backplane. This provides address decoding logic for all 5 expansion slots on the backplane. Basically, when a specific address range is request by the CPU, this chip pulls one of the SLOT selection lines low. It also pulls the SSEL signal low to let other expansion boards as well the the CPU board know that an expansion slot is selected. This disables the memory on the CPU board and allows other boards to disable themselves as well if necessary.

The source code used to program the chip is in [CUPL](https://en.wikipedia.org/wiki/Programmable_Array_Logic#CUPL) format and provided as `backplane.PLD` files in the [`Software/PAL/`](https://gitlab.com/planck-6502/planck-6502/-/tree/master/Software/PAL) directory. 

Also provided is the precompiled binay (`BACKPLANE.jed`) in the same folder. This file can be used to program your ATF22V10 chip immediately with the defaulta address values for each slot. Please see [Expansion slot activation](/Hardware/#expansion-slot-activation) for the default slot addresses.

You will then need to program the ATF16V8 for the CPU board in much the same way.

Once that is done, everytinh is setup to run...


## Actual software


The software is currently built around [Tali Forth 2](https://github.com/scotws/TaliForth2). A binary is provided in [`Software/forth/taliforth-planck.bin`](https://gitlab.com/planck-6502/planck-6502/-/tree/master/Software/forth). Just program this binary to a 32K eeprom, insert it in the ZIF socket on the CPU board and you should be good to go.

By default the software expects the I/O board to be in SLOT 2 and the Serial board to be in SLOT 3, but this can be changed by changing the hardware definitions in [`platform-planck.asm`](https://gitlab.com/planck-6502/planck-6502/-/blob/master/Software/forth/platform/platform-planck.asm#L109) or by reprogramming the backplane PLD chip as detailed above.