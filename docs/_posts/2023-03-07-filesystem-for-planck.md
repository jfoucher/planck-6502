---
layout: post
title:  "A filesystem for the Planck computer"
excerpt_separator: <!--more-->
---

Designing a file system for the 6502 MPU is not an easy task. In this post I will explain what I tried, what failed, and maybe what succeeded.

<!--more-->

I started by writing routines to access an SD card via the SPI port of the [IO board](/Hardware/io/). This works fine, and I can read blocks sucessfully. I then started implementing a fat32 filesystem to read it, but this proved to be too much code to add besides TaliForth, which already uses most of the available RAM (Taliforth is copied from ROM to RAM on boot for performance reasons). I tried it again recently and for some reason the SD card reading routines stopped working. I remember spending a good deal of time with a logic analyzer trying to understand what was going on, and I don't really look forward to doing it again for debugging.

I then built a [Compact Flash card adapter](/Hardware/cf/) following [this blog post](http://www.waveguide.se/?article=8-bit-compact-flash-interface) because I had a 256 MB CF card and IDE adapter lying around.However reading data off of it proved troublesome, some bytes would be in the wrong place, and I could not get it to read the boot sector reliably everytime. I also started writing a FAT16 implementation which could sucessfully initialize the FAT and read files. Just reading and listing files however is pretty long and annoying. However because of reliability problems with reading data from the CF card, I also gave up on that approach.

Then I tried using a [tar file as a filesystem](https://wiki.osdev.org/USTAR), and could pretty quickly get it to find and read files, but after thinking about it, I realised that writing to this filesystem would be cumbersome. Since all the data for each file is contiguous, adding data to a file beyond the current last sector of the file would mean rewriting every single file to the disk, which I don't think would be feasible with the limited amount of memory available.

So next I want to try MinixFS, which is a simple, educational filesystem. It should therefore not be too hard to make it work in assembly.

Paradoxically, I have not been able to find quality material documenting the Minix filesystem, mostly some C souce code and course material in PDF format. Nonetheless, let me try and make it work.

The first step is to be able to read 1024 bytes of data at once into a buffer. The routine that does this expects a routine provided by the kernel to read a single 512 bytes sector from the disk. Once that is done, a data structure can be created to store data about the filesystem found in the superblock. On Minix, the superblock is always block 1 (remembering that each block is 2 512 bytes sectors, these are sectors 2 and 3 on disk). Block 0 can be used to put optional boot code.

Once we have this block in memory, the layout of the superblock is very simple and actually only occupies 20 bytes at the start of the block :

<table>
<thead>
<tr>
<th colspan="17" align="center">
MINIX superblock layout
</th>
</tr>
<tr>
<td></td>
<td>$00</td><td>$01</td><td>$02</td><td>$03</td><td>$04</td><td>$05</td><td>$06</td><td>$07</td><td>$08</td><td>$09</td><td>$0A</td><td>$0B</td><td>$0C</td><td>$0D</td><td>$0E</td><td>$0F</td>
</tr>
</thead>
<tbody>
<tr>
<td>$00</td><td colspan=2>No. inodes</td><td colspan=2>No. zones</td><td colspan=2>inode map blocks</td><td colspan=2>zone map blocks</td><td colspan=2>First data zone</td><td colspan=2>Log zone size</td><td colspan=4>Max. file size</td>
</tr>
<tr>
<td>$10</td><td colspan=2>Minix magic</td><td colspan=2>Mount state</td><td colspan=12></td>
</tr>
</tbody>
</table>

- No. inodes is the total number of inodes on the filesystem
- No. zones is the total number of zones on the filesystem, this is the same as the total number of blocks.
- inode map blocks: The total number of inode map blocks
- zone map blocks: the total number of zone map blocks
- first data zone is the block at which the first elements of data can be found. this is usually the contents of the root directory
- log zone size: this represents the size of a zone. the size of a zone in bytes is given by `1024 << log_zone_size`. If this is zero it means one zone = one block = 1024 bytes.
- max file size is a 32 bit number representing the maximum file size on this filesystem
- Minix magic is a magic number, `$138F` on Minix 1 with 30 character file names
- Mount state gives the state of the current filesystem: I think it is 1 for a mounted fs, and 0 for non mounted FS. It is then possible to check if the filesystem was unmounted cleanly.

After the superblock, we have the inode bitmap, which is simple bitmap of free and occupied inodes. There is one bit for each inode, and an unset bit indicates that this inode is free, while a 1 bit indicates that it is used. This bitmap is `inode map blocks` long (see table above)

After the inode map block(s), we have the zone map block(s) which is `zone map blocks` long and is a bitmap of used and unused zones, where each free zone is a zero bit and each busy zone is a 1 bit.

After the zone map block(s) come the inodes themselves.

The first inode we want to get is the inode for the root directory. this is the inode number 0

So we load that inode by adding `inode map blocks` and `zone map blocks` and 1 (superblock number) to get the first inode block, and then we read the first 32 bytes there.

An inode entry is 32 bytes, formatted as follows:


<table>
<thead>
<tr>
<th colspan="17" align="center">
MINIX inode layout
</th>
</tr>
<tr>
<td></td>
<td>$00</td><td>$01</td><td>$02</td><td>$03</td><td>$04</td><td>$05</td><td>$06</td><td>$07</td><td>$08</td><td>$09</td><td>$0A</td><td>$0B</td><td>$0C</td><td>$0D</td><td>$0E</td><td>$0F</td>
</tr>
</thead>
<tbody>
<tr>
<td>$00</td><td colspan=2>MODE</td><td colspan=2>UID</td><td colspan=4>FILESIZE</td><td colspan=4>TIME</td><td>GID</td><td>LINKS</td><td colspan=2>ZONE 0</td>
</tr>
<tr>
<td>$10</td><td colspan=2>ZONE 1</td><td colspan=2>ZONE 2</td><td colspan=2>ZONE 3</td><td colspan=2>ZONE 4</td><td colspan=2>ZONE 5</td><td colspan=2>ZONE 6</td><td colspan=2>ZONE 7</td><td colspan=2>ZONE 8</td>
</tr>
</tbody>
</table>

The MODE is a bit of which type of file the inode is refering to. All we are concerning ourselves with is whether it is a file or directory. All other flags are ignored. A directory will have bit 14 set and a reular file will have bit 15 set, so we can test for these to know what we are dealing with.

Once we have loaded the inode in memory, we can then proceed to read the data from it.

The `ZONE N` fields gives us the location of the file data. `ZONE 0` is the first chunk, `ZONE 1` the second and so on. Expect ZONE 7, which is an indirect zone: it points to a zone containing other zone pointers (which point to actual data). And ZONE 8 is a doubly indirect zone: it points to a zone full of pointers to indirect zones.

With only the direct zones, each file can contain 7kb of data. With the indirect zone added, this number jumps to 7+64 or 71k, and with the double indirect zone, to over 4 Mb.


To read a file, then we need to get it's inode. 