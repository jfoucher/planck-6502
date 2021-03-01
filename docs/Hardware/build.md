---
layout: page
---

# Building the computer

Building the computer from PCBs is fairly easy, but please note that the design uses surface mount components for most passives (resistors and capacitors mostly) and that there is a technique to be acquired if you want to solder them without getting frustrated.

## Surface mount components

I limited myself to the smallest sizes that I thought could be compfortably soldered by hand, so if you're having trouble, watch a few Youtube videos on the subject and practice on some scrap pieces of PCB or prototype boards until you get the hang of it.

There are also a limited number of surface mount active components, such as the binary counter for the clock circuit on the backplane. However these are relatively big SMD components and again with a bit of practice can be soldered by hand. Please see this video if you want to see the basic technique: https://www.youtube.com/watch?v=hoLf8gvvXXU. There are many more to choose frome.

## Soldering order

My recommendation for building each board is to start by soldering all SMD components on both sides of the board first. You will need to reference the schematic to know which value component to place where. Once that is done, most of the difficult part of the job will be behind you.

Now, you can solder on the necessary headers such as the expansion bus right angle header and any other headers or sockets that may be present on the board. If you are building the backplane, this step is where most of your soldering will take place.

Next I recommend you solder sockets for all the dip chips. Sockets are great because they are (generally) cheaper than the components that will be mounted into them, which causes less of a problem if you happen to mess up something. They  also allow for easy replacement of defective parts. Make sure you put the sockets in the right orientation (notch on socket with notch on board silkscreen as well as the notch on the chip itself) as that varies chip by chip even on the same board.

## Finishing up and testing

Now that everything is soldered up, all that's left to do is to plug the chips in their respective sockets and give the board a test.

First check that with a multimeter that you do not have a short between ground and VCC. Give a thourough visual inspection to the board to make sure that all solder joint are ok and that no bridging between pins occurs. Touch up where necessary.

Then if everything looks ok, you are ready to power up the board and test it's functionality. The source code [Software](https://gitlab.com/planck-6502/planck-6502/-/tree/master/Software) folder should provide everything you need to test the whole computer as well as individual parts.

