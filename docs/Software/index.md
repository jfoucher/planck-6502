---
layout: page
title: Planck 6502 software
---

## Programmable Logic

The first thing to setup when building your Planck 6502 is to program the PLD chips on the mainboard. This provides address decoding logic for all 6 expansion slots on the board. Basically, when a specific address range is requested by the CPU, this chip pulls one of the SLOT selection lines low. It also pulls the SSEL signal low to let other expansion boards know that an expansion slot is selected. This allows other boards to disable themselves as well if necessary. The second smaller PLD chip is used to choose whther a specific address should be directed to the ROM, RAM, or serial chip on the mainboard.

The source code used to program the chips is in [CUPL](https://en.wikipedia.org/wiki/Programmable_Array_Logic#CUPL) format.

There are two precompiled files : 
  - `Computer.jed` is used for the ATF22V10 chip that handles the extension slots.
  - `Processor-16V8.jed` is used for the ATF16V8 chip.


You will then need to program the ATF16V8 for the CPU board in much the same way.

Once that is done, everyting is setup to run...

## Actual software

The software is currently built around a modified version of [Tali Forth 2](https://github.com/scotws/TaliForth2). A binary is provided in [`Software/fos/fos-planck.bin`](https://gitlab.com/planck-6502/planck-6502/-/tree/main/Software/fos). Just program this binary to a 32K eeprom, insert it in the socket on the main board and you should be good to go.

By default the software expects the boards to be in a certain slot, but this can be changed by changing the hardware definitions in [`platform/planck/drivers`](https://gitlab.com/planck-6502/planck-6502/-/blob/main/Software/fos/platform/planck/drivers) or by reprogramming the backplane PLD chip as detailed above.

### Running the software

By default, the PS/2 keyboard from the I/O card is enabled as an input, as well as the input from the serial chip, which means you can use both to type text into the Planck 6502.

For output you will see that both serial output as well as VGA output is enabled in the software. However the VGA output is only for me to test VGA output at this time since the VGA expansion card is not yet finalized.

You can however use the LCD as an output if you want to use your Planck as a stand alone computer. With a PS/2 keyboard and the LCD screen it is really quite a usable Forth machine.

Some small utilities are present on the provided software, defined as forth words:
- `uptime` gives the time since power up / reset in hours, minutes, seconds and hundredths of a second. The time itself is stored in 4 bytes starting at address `$82`. The number at that address is incremented every 5 milliseconds with a 24 MHz main crystal.



### Customizing the software

Say you just [created a new board](/Hardware/make) for your computer, you will need to write drivers for it. I recommend doing so in assembly as that will give you the best performance, but the drivers can also be written in forth. Below, i will detail how to write drivers in assembly for your custom expansion card.

As you can see, the [Software/drivers](https://gitlab.com/planck-6502/planck-6502/-/tree/main/Software/drivers) folder already contains drivers for expansion cards. You can create a new file named `my_card.s` and write your initialization and usage routines in it.

Then in the [fos/platform/planck/main.s](https://gitlab.com/planck-6502/planck-6502/-/blob/main/Software/fos/platform/planck/main.s) file you will have to include your new driver file or files similarly to how other driver files are included : 

````
.include "drivers/keyboard.s"
````

Then, after the `kernel_init:` label, you can call your initialization routine if any.

To use your driver from Forth, please see the [Tali Forth documentation](https://github.com/scotws/TaliForth2/blob/master/docs/manual.md#adding-new-words) for adding new native words.
