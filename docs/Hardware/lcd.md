---
layout: board
title: LCD board
status: prod
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/main/Hardware/lcd_board
gerbers: https://planck6502.com/fabrication/lcd_board-zip.zip
schematic: https://planck6502.com/fabrication/lcd_board-schematic.pdf
html_bom: https://planck6502.com/fabrication/lcd_board-bom.html
csv_bom: https://planck6502.com/fabrication/lcd_board-bom.csv
order: 50
---


This board allows a HD44780 based LCD such as [this one](https://www.ebay.fr/itm/2004-20x4-Character-LCD-Display-Module-2004-LCD-Blue-Yellow-Blacklight-HD44780/264032858433?hash=item3d7995b141:g:7oAAAOSwTztb5q6k&mkcid=1&mkrid=709-53476-19255-0&siteid=71&campid=5338598798&toolid=11800&mkevt=1) to display data from the computer.

The LCD is enabled by default in the ROM file. Due to the delays it requires, it significantly slows the output. If you are only using the computer over serial, you can disable printing to the LCD by setting a zero in the location pointed to by the `haslcd` word, for example like this:

```
0 haslcd c!
```

![Planck prototype board for LCD](/img/lcd_board.jpg)

![3D View](https://planck6502.com/fabrication/lcd_board-3D_top.csv)

## Slot placement

The LCD board should be inserted in SLOT 4 on the backplane, otherwise you will have to change the hardware definitions in [`lcd.inc`](https://gitlab.com/planck-6502/planck-6502/-/blob/main/Software/fos/platform/planck/drivers/lcd.inc)