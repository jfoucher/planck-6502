---
layout: page
title: CPU board
status: prod
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/master/Hardware/proc_board
order: 20
---

The CPU board contains the 65C02 cpu itself, but also 32K of ROM and 32K of RAM as well as the address decoding to handle these.

The address decoding is provided by a PLD, more specifically an ATF16V8. This chip also handles the incoming interrupt requests from the expansion card before passing them on to the CPU such that each extension card can send it's own IRQ signal without risking contention with other cards.

The RAM can be either a wide or a narrow DIP chip, like the narrow IDT71256 or a more "classic" wide 62256 chip.
The ROM placement on the board can accomodate a ZIF socket to allow the user to more easily update the software on the chip.

## Slot placement

The CPU board **MUST** be inserted in SLOT 0, marked `CPU BOARD` on the backplane.