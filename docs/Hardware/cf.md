---
layout: board
title: Compact Flash board
short_title: CF board

order: 80

status: prod
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/main/Hardware/cf_board
order: 40
gerbers: https://planck6502.com/fabrication/cf_board-zip.zip
schematic: https://planck6502.com/fabrication/cf_board-schematic.pdf
html_bom: https://planck6502.com/fabrication/cf_board-bom.html
csv_bom: https://planck6502.com/fabrication/cf_board-bom.csv
---


## Compact Flash interface card

This is a compact flash memory interface card to allow the Planck 6502 to save and restore data to mass storage.

A FAT16 file system should be created on the card before use.

Initialize the card by calling the following word : 

```
hex FFD0 cf_fat_init decimal
```

where FFDO is the address of the slot the card is placed in.

We then have access to the CF card a fat volume. To list files and directories in the disk, type

```
ls
```

This should display a list of files and directories at the root of the drive

To output the contents of a file, type

```
s" file.txt" cat
```

To load the contents of a file at a memory address $2000 and jump to it, run

```
hex 2000 s" code.bin" load
```






![3D View](https://planck6502.com/fabrication/cf_board-3D_top.png)



## Slot placement

TBD