This folder contains CUPL code for the programmable logic chips on the backplane and on the processor board.

To build it, use [Wincupl](https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources). Hopefully this link still works when you access it. It works fine in [wine](http://www.winehq.org/) if you use Linux or MacOs.

Load the pld file, then click on run -> device dependent compile.

You can then program the .jed file to your chip. A TL866II works fine with both 22V10 and 16V8.

