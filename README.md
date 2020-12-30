## Planck computer

This is a hobby computer based on the 6502 processor.

### Contraints and requirements

The constraints for it's design were the following:
 - 100x100mm maximum board size, as that is the size that is often cheapest to have fabricated.
 - Easily extensible
 - Target clock speed of 10 to 12 MHz

### Some details

This resulted in a computer based on a backplane and separate boards that plug into it.
The backplane provides the clock, 4 LEDs, two buttons a micro USB power socket and address decoding for the expansion slots. The expansion bus is described below.

The main board is the CPU board that provides it's own RAM and ROM (32K of each). The CPU board may also in the future include a serial chip so that it can be used as a standalone computer.

The IO board provides a keyboard PS/2 port, a parallel port and a 65SIB port (serial port similar to and compatible with SPI)

Some images of the complete computer will come once the prototype is built.



### Expansion bus signals

Most pins correspond to the pins of the same name on the CPU.

Below are the pins that are specific to the expansion bus:

| Pin | Description |
|-----   |-------------|
| EX0-EX2 | 3 expansion pins that are reserved for future use or can be used for communication betwen two expansion cards.|
| <span style="text-decoration:overline">INH</span>|When low, this signal inhibits the RAM and ROM present on the CPU card and allows an expansion card to take over the whole bus (except expansion region).|
|<span style="text-decoration:overline">SEL1</span>-<span style="text-decoration:overline">SEL5</span>|The expansion card in the slot in which this signal is low should activate.|
|<span style="text-decoration:overline">SSEL</span>| Slot selected. The cpu card and any other card should disable all bus access when this signal is low and their own select signal (<span style="text-decoration:overline">SEL1</span>-<span style="text-decoration:overline">SEL5</span>) is high.|
|LED1-LED4| Debug leds 1 to 4.|
| <span style="text-decoration:overline">IRQ0</span>-<span style="text-decoration:overline">IRQ3</span>|Should be used by expansion cards when they want to signal an IRQ. All 4 lines are ANDed together on the processor board and pull the <span style="text-decoration:overline">IRQ</span> line low when at least one of them is low.|



<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This documentation is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.