---
layout: post
title:  "A filesystem for the Planck computer"
excerpt_separator: <!--more-->
---

Designing a file system for the 6502 MPU is not an easy task. In this post I will explain what I tried, what failed, and maybe what succeeded.

<!--more-->

## Failed attempts

I started by writing routines to access an SD card via the SPI port of the [IO board](/Hardware/io/). This works fine, and I can read blocks sucessfully. I then started implementing a fat32 filesystem to read it, but this proved to be too much code to add besides TaliForth, which already uses most of the available RAM (Taliforth is copied from ROM to RAM on boot for performance reasons). I tried it again recently and for some reason the SD card reading routines stopped working. I remember spending a good deal of time with a logic analyzer trying to understand what was going on, and I don't really look forward to doing it again for debugging.

I then built a [Compact Flash card adapter](/Hardware/cf/) following [this blog post](http://www.waveguide.se/?article=8-bit-compact-flash-interface) because I had a 256 MB CF card and IDE adapter lying around.However reading data off of it proved troublesome, some bytes would be in the wrong place, and I could not get it to read the boot sector reliably everytime. I also started writing a FAT16 implementation which could sucessfully initialize the FAT and read files. Just reading and listing files however is pretty long and annoying. However because of reliability problems with reading data from the CF card, I also gave up on that approach.

Actually, I gave up on trying to read data off of real media for now, and started experimenting with filesystems in a 65C02 emulator ([py65mon](https://py65.readthedocs.io/en/latest/))

## Filesystems

### FAT16

FAT16 was okay, I managed to read files pretty quickly, but the code was getting pretty big and I was worried that writing files was going to be much harder, so I stopped work on it, and next tried USTAR

### USTAR

[tar file as a filesystem (USTAR)](https://wiki.osdev.org/USTAR) is quite simple, and I could pretty quickly get it to find and read files, but after thinking about it, I realised that writing to this filesystem would be cumbersome: since all the data for each file is contiguous, adding data to a file beyond the current last sector of the file would mean rewriting every single file to the disk, which I don't think would be feasible with the limited amount of memory available. It makes sense for TAR to work this way, since it is an archive format the data will only be written once and then only read.

### MINIX FS

So next I wanted to try MinixFS, which is a simple, educational filesystem. It should therefore not be too hard to make it work in assembly.

Paradoxically, I have not been able to find quality material documenting the Minix filesystem, mostly some C souce code and course material in PDF format. Nonetheless, let me try and make it work.

#### Basic data read

The first step is to be able to read 1024 bytes of data at once into a buffer. The routine that does this expects a routine provided by the kernel to read a single 512 bytes sector from the disk. It just basically calls the IO routine twice while setting the sector to read each time.

Nothing complex here, the routine basically just does this:

```asm
minix_read_block_noinc:
    mov16  MINIX_SECTOR, io_current_sector  ; copy sector to read to IO variable
    ; mov16 is a macro that copies 2 bytes at once

    jsr io_read_sector          ; read first sector

    inc io_buffer_ptr + 1       ; write to next buffer 512 block to get full 1024 block
    inc io_current_sector       ; setup to read next sector
    jsr io_read_sector          ; Read next sector
    dec io_buffer_ptr + 1       ; put buffer pointer back
    ; one full block is now in the buffer pointed to by io_buffer_ptr
    rts
```

#### Superblock

Once that is implemented, a data structure can be created to store data about the filesystem found in the superblock. On Minix, the superblock is always block 1 (remembering that each block is 2 512 bytes sectors, these are sectors 2 and 3 on disk). Block 0 (sectors 0 and 1) can be used to put optional boot code.

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
<td>$00</td><td colspan="2">No. inodes</td><td colspan="2">No. zones</td><td colspan="2">inode map blocks</td><td colspan="2">zone map blocks</td><td colspan="2">First data zone</td><td colspan="2">Log zone size</td><td colspan="4">Max. file size</td>
</tr>
<tr>
<td>$10</td><td colspan="2">Minix magic</td><td colspan=2>Mount state</td><td colspan="12"></td>
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

#### Bitmaps

After the superblock, we have the inode bitmap, which is simple bitmap of free and occupied inodes. There is one bit for each inode, and an unset bit indicates that this inode is free, while a 1 bit indicates that it is used. This bitmap is `inode map blocks` long (see table above)

After the inode map block(s), we have the zone map block(s) which is `zone map blocks` long and is a bitmap of used and unused zones, where each free zone is a zero bit and each busy zone is a 1 bit.

These two series of blocks are only important for writing data, we need not concern ourselves with them for now.

#### inodes

After the zone map block(s) come the inodes themselves.

The first inode we want to get is the inode for the root directory. This is the inode number 1. Do note that inodes are 1 indexed, because if a file has no inode, the inode field will be 0 in its directory entry

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

The MODE is a bit of which type of file the inode is refering to. All we are concerning ourselves with is whether it is a file or directory. All other flags are ignored. A directory will have bit 14 set and a regular file will have bit 15 set, so we can test for these to know what we are dealing with.

Once we have loaded the inode in memory, we can then proceed to read the data from it.

The `ZONE N` fields gives us the location of the file data. `ZONE 0` is the first chunk, `ZONE 1` the second and so on. Except ZONE 7, which is an indirect zone: it points to a zone containing other zone pointers (which point to actual data). And ZONE 8 is a doubly indirect zone: it points to a zone full of pointers to indirect zones.

With only the direct zones, each file can contain 7kb of data. With the indirect zone added, this number jumps to 7+64 or 71k, and with the double indirect zone, to over 4 Mb.

#### Root directory

The first to getting data from the filesystem is to read the root directory. The root directory has it's own inode, which is the very first inode at the start of the first inode block.

Once we have read this inode, we can read its data by following the zones links, as explained below.

#### Reading data

Reading data works in exactly the same way for all types of files. Once we have the inode for the file or directory, we can read the zone pointers to get the data at the correct block, which would look someting like this in assembly:

```asm
lda #>(INODE + $0E)    ; get the zone 0 low byte
sta ZP_POINTER     ; store it in a zeropage pointer low byte
lda #>(INODE + $0F)    ; get the zone 0 high byte
sta ZP_POINTER + 1    ; store it in a zeropage pointer high byte
; we now have the address where we will find the zone to read in ZP_POINTER
ldy #0
lda (MINIX_PTR),y         ; we copy that data to the block to read
sta MINIX_CURRENT_BLOCK
iny
lda (MINIX_PTR), y
sta MINIX_CURRENT_BLOCK+1
jsr minix_read_block   ; and trigger a read of the corresponding minix block
```

The actual code is more complex than that, because it allows for reading from any of the 7 direct zones. (indirect zones are not handled for now).

Like all other directories, the root directory data consists entirely of "directory entries"

#### Directory entries

The data for a directory is a succession of directory entries, which occupy 32 bytes each and look like this :

<table>
<thead>
<tr>
<th colspan="17" align="center">
MINIX Directory entry layout
</th>
</tr>
<tr>
<td></td>
<td>$00</td><td>$01</td><td>$02</td><td>$03</td><td>$04</td><td>$05</td><td>$06</td><td>$07</td><td>$08</td><td>$09</td><td>$0A</td><td>$0B</td><td>$0C</td><td>$0D</td><td>$0E</td><td>$0F</td>
</tr>
</thead>
<tbody>
<tr>
<td>$00</td><td colspan=2>INODE</td><td colspan=14>FILENAME</td>
</tr>
<tr>
<td>$10</td><td colspan=16>FILENAME (cont.)</td>
</tr>
</tbody>
</table>

As you can see, the inode is a 16 bit number, and the filename has a maximum of 30 characters.

The first two entries in a directory are always `.` and `..` which represent the current directory and the parent directory respectively. For the root directory, these two entries point to the same inode.

#### Reading a file

Reading a file follows the same process as reading the root directory, expect we first need to get the inode for the file we are interested in.

To do this, we will walk all directory entries of the directory until we find the one we are searching for, or until we get to an entry where the inode is 0, in which case it signals the end of the directory.

Once we have the inode number for the file we are interested in, we can read it and get the data from the zones defined within it as discussed earlier.

#### Conclusion

This blog post stops here where we can sucessfully read data from a MINIX 1 filesystem, but I will probably keep working on it to add write access to the filesystem as well.

You can get the full source to allow you to read data from a MINIX filesystem on a 65C02 in [minix.txt](/img/minix.txt)
