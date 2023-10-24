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

At boot time, Forth is copied from the ROM to the RAM for faster execution, leaving little space for anything else. The Forth dictionary is a minimum of `$1000` bytes. Depending on your configuration, it runs from the end of the BSS segment to the top of RAM.

### Running the software

By default, the PS/2 keyboard from the I/O card is enabled as an input, as well as the input from the serial chip, which means you can use both to type text into the Planck 6502.

For output you will see that both serial output as well as LCD output is enabled. However if you do not use the LCD, you may want to disable it and reflash the ROM since the delays required to wait for the LCD to respond make the serial output unnecessarily slow.

You can however use the LCD as an output if you want to use your Planck as a stand alone computer. With a PS/2 keyboard and the LCD screen it is really quite a usable Forth machine.

Some small utilities are present on the provided software, defined as forth words:

- `uptime` gives the time since power up / reset in hours, minutes, seconds and hundredths of a second. The time itself is stored in 4 bytes starting at address `$82`. The number at that address is incremented every 5 milliseconds with a 24 MHz main crystal. (requires the [IO board](/Hardware/io))
- `dumpzp` is a shortcut to dump the zero page
- `lights` will blink the IO board's led very fast
- `slights` will blink the IO board's led slower
- `vslights` will blink the IO board's led very slowly

There are drivers for most of the cards to be able to use them from forth as well as from assembly.

### Customizing the software

Say you just [created a new board](/Hardware/make) for your computer, you will need to write drivers for it. I recommend doing so in assembly as that will give you the best performance, but the drivers can also be written in forth. Below, i will detail how to write drivers in assembly for your custom expansion card.

As you can see, the [Software/drivers](https://gitlab.com/planck-6502/planck-6502/-/tree/main/Software/drivers) folder already contains drivers for expansion cards. You can create a new file named `my_card.s` and write your initialization and usage routines in it.

Then in the [fos/platform/planck/main.s](https://gitlab.com/planck-6502/planck-6502/-/blob/main/Software/fos/platform/planck/main.s) file you will have to include your new driver file or files similarly to how other driver files are included : 

``` nesasm
.include "drivers/keyboard.s"
```

Then, after the `kernel_init:` label, you can call your initialization routine if any.

To use your driver from Forth, please see the [Tali Forth documentation](https://github.com/scotws/TaliForth2/blob/master/docs/manual.md#adding-new-words) for adding new native words.

## Uploading software

Forth now includes words to load binary data in [intel HEX format](https://en.wikipedia.org/wiki/Intel_HEX) from the serial port.

Use the `ihex` word to start loading data, then paste the contents in your terminal emulator window.

The data will be placed at the addresses specified in the intel HEX file. Be careful not to clobber the `ihex` routine nor its variables. The ihex routine is `$CF` bytes long, so do not touch anything for at least `$D0` bytes after `' ihex` (the address or the word in RAM).

Once your binary data is in place, you can jump to it with the word `go`, so for example if your executable code is loaded at `$7E80`, doing `hex 7e80 go` will jump to the start of your program.

## Forth

For general information about the Forth programming language, [Starting Forth](https://www.forth.com/starting-forth/) is a great resource. 

The [Taliforth documentation](https://github.com/scotws/TaliForth2/blob/master/docs/manual.md) is worth a read as well, since the Forth used by the Planck 6502 is based on it. The [6502.org forum](http://forum.6502.org/) has a [forth section](http://forum.6502.org/viewforum.php?f=9&sid=f950c7259167a625796c614111543ead) as well, to talk about forth on the 6502 in general.

If you want to discuss Forth on the Planck 6502 in particular, or other software options for the Planck, you can head over to [our forum's Software section](https://forum.planck6502.com/c/software/6)

Finally, since the assembler used in ca65, you may want to familiarize yourself with [cc65's documentation](https://cc65.github.io/doc/)