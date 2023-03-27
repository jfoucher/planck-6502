---
layout: board
title: Compact Flash board
short_title: CF board

order: 80

status: dev
design_files: https://gitlab.com/planck-6502/planck-6502/-/tree/main/Hardware/cf_board
order: 40
gerbers: https://planck6502.com/fabrication/cf_board-zip.zip
schematic: https://planck6502.com/fabrication/cf_board-schematic.pdf
html_bom: https://planck6502.com/fabrication/cf_board-bom.html
csv_bom: https://planck6502.com/fabrication/cf_board-bom.csv
---

## Compact Flash interface card

This is a compact flash memory interface card to allow the Planck 6502 to save and restore data to mass storage.

![Top view of the CompactFlash board](/img/compactflash.jpg)

TaliForth works with raw block storage on the CompactFlash card. A block is 1024 bytes.
To read the contents of a block, type `{numblock} list` where `{numblock}` is the number of the block to read, so for example `0 list` to show the contents of block 0, or `1000 list` to show the contents of block 1000.

Read the [Taliforth documentation](https://github.com/SamCoVT/TaliForth2/blob/master-64tass/docs/manual.md#working-with-blocks) to know more.

## Warning

Building this card is a difficult endeavour due to the fine pitch of the CompactFlash socket.

![3D View](https://planck6502.com/fabrication/cf_board-3D_top.png)


## Slot placement

SLOT 5 (`$FFD0`)