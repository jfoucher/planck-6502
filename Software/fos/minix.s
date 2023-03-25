

; This is a library to use a minix file system on the 65C02 CMOS processor.
; it requires 2 bytes in zeropage, 100 bytes for variables in RAM
; and a buffer of 1024 bytes provided by the user of this library.
; It also requires the caller to provide two subroutines:
; - an io_read_sector subroutine
; - an io_write_sector subroutine
; both with the same two parameters : 
; io_current_sector: a 4 byte variable in RAM to indicate which sector to read/write like LBA addressing
; io_buffer_ptr: a zeropage pointer to a buffer in RAM where the sector data will be stored
; or where it will be found to be written to disk
; The buffer will be overwriten by many routines.
; The only time it is safe to write to it is just before calling file_write_data
; This library is designed to be assembled with ca65 but it should be 
; fairly easy to adapt to another assembler.
; Compatible only with MINIX 1 filesystem with 30 character filenames

; References : 
; http://minix1.woodhull.com/faq/filesize.html
; https://github.com/osxfuse/filesystems/blob/aee39765ffe32b426a1089f617d21bff387f5c91/filesystems-c/unixfs/minixfs/minixfs.c
; http://ohm.hgesser.de/sp-ss2012/Intro-MinixFS.pdf
; https://lass.cs.umass.edu/~shenoy/courses/spring20/lectures/Lec18.pdf
; https://github.com/gdevic/minix1
; Operating systems - Design and implementation by Andrew S. Tanenbaum

; PUBLIC DOMAIN
; This library for the 65c02 is provided on an "as is" basis without any warranty
; of any kind, including, without limitation, the implied warranties of
; merchantability and fitness for a particular purpose and their equivalents
; under the laws of any jurisdiction. Put briefly, use this at your own risk.

; Constants
MINIX_MAGIC_NUMBER = $138F		; minix fs, 30 char names 

; These are the only two mode flags we care about
MINIX_REGULAR_FILE = $8000
MINIX_DIRECTORY = $4000

MINIX_ROOT_INODE = 1            ; inodes are 1 indexed, so inode 1 is the first one

; zeropage variables, 2 bytes required
.segment "ZEROPAGE": zeropage
MINIX_PTR: .res 2

.segment "BSS"
; RAM storage, 100 bytes required

MINIX_CURRENT_BLOCK: .res 2 ; block to read
MINIX_SECTOR: .res 4
MINIX_CURRENT_INODE: .res 2
MINIX_CURRENT_DIR_INODE: .res 2
MINIX_CURRENT_FILE_INODE: .res 2

MINIX_TMP: .res 2
MINIX_FILESIZE_COMPARE: .res 2
MINIX_ZONE_TO_READ: .res 1
MINIX_ZONE_TO_WRITE: .res 1
MINIX_SEARCH_INODE: .res 2
MINIX_SEARCH_FILENAME: .res 30

MINIX_SUPERBLOCK:
MINIX_N_INODES: .res 2
MINIX_N_ZONES: .res 2
MINIX_N_INODE_MAP_BLOCKS: .res 2
MINIX_N_ZONE_MAP_BLOCKS: .res 2
MINIX_FIRST_DATA_ZONE: .res 2       ; 
MINIX_LOG_ZONE_SIZE: .res 2         ; size of a data zone = 1024 << MINIX_LOG_ZONE_SIZE
MINIX_MAX_FILE_SIZE: .res 4
MINIX_MAGIC: .res 2
MINIX_STATE: .res 2

MINIX_DIRENT:
MINIX_INODE_NUMBER: .res 2
MINIX_FILENAME: .res 30

MINIX_INODE:
MINIX_INODE_MODE: .res 2
MINIX_INODE_UID: .res 2
MINIX_INODE_FILESIZE: .res 4
MINIX_INODE_TIME: .res 4
MINIX_INODE_GID: .res 1
MINIX_INODE_LINKS: .res 1
MINIX_INODE_ZONE0: .res 2
MINIX_INODE_ZONE1: .res 2
MINIX_INODE_ZONE2: .res 2
MINIX_INODE_ZONE3: .res 2
MINIX_INODE_ZONE4: .res 2
MINIX_INODE_ZONE5: .res 2
MINIX_INODE_ZONE6: .res 2
MINIX_INODE_INDIRECT: .res 2
MINIX_INODE_DOUBLE_INDIRECT: .res 2

.segment "DATA"

MINIX_DIRENT_JUMP: .byte $20, $0        ; size of a directory entry

; setup MINIX_CURRENT_BLOCK to indicate which block to read
; the resulting block data will be in the buffer pointed to by io_buffer_ptr
; he caller is reponsible for setting up io_buffer_ptr
; returns with carry set on error
minix_read_block:
    stz io_current_sector                   ; zero current sector to read
    stz io_current_sector + 1
    stz io_current_sector + 2
    stz io_current_sector + 3
    stz MINIX_SECTOR + 2                    ; zero top bytes of sector to read
    stz MINIX_SECTOR + 3
    cp16 MINIX_CURRENT_BLOCK, MINIX_SECTOR  ; copy current block number
    asl16 MINIX_SECTOR                      ; multiply by two to get first block sector number
    bcc minix_read_block_noinc
    inc io_current_sector + 2               ; increase higher byte if previous asl set the carry
minix_read_block_noinc:
    cp16  MINIX_SECTOR, io_current_sector  ; copy result to the sector to read

    jsr io_read_sector          ; read first sector
    inc io_buffer_ptr + 1
    inc io_buffer_ptr + 1       ; write to next buffer 512 block to get full 1024 block
    inc io_current_sector       ; setup to read next sector
    jsr io_read_sector          ; Read next sector
    dec io_buffer_ptr + 1       ; put buffer pointer back
    dec io_buffer_ptr + 1
    ; one full block is now in the buffer pointed to by io_buffer_ptr
    rts

minix_write_block:
    stz io_current_sector                   ; zero current sector to read
    stz io_current_sector + 1
    stz io_current_sector + 2
    stz io_current_sector + 3
    stz MINIX_SECTOR + 2                    ; zero top bytes of sector to read
    stz MINIX_SECTOR + 3
    cp16 MINIX_CURRENT_BLOCK, MINIX_SECTOR  ; copy current block number
    asl16 MINIX_SECTOR                      ; multiply by two to get first block sector number
    bcc minix_write_block_noinc
    inc io_current_sector + 2               ; increase higher byte if previous asl set the carry
minix_write_block_noinc:
    cp16  MINIX_SECTOR, io_current_sector  ; copy result to the sector to read
    jsr io_write_sector          ; read first sector
    inc io_buffer_ptr + 1
    inc io_buffer_ptr + 1       ; read from next buffer 512 block to get full 1024 block
    inc32 io_current_sector       ; setup to write to next sector
    jsr io_write_sector          ; Write next sector
    dec io_buffer_ptr + 1       ; put buffer pointer back
    dec io_buffer_ptr + 1
    ; one full block has now been written to disk
    rts

; read the root inode
minix_read_root_inode:
    lda #MINIX_ROOT_INODE               ; set inode to root inode
    sta MINIX_CURRENT_INODE
    stz MINIX_CURRENT_INODE + 1

    jsr minix_read_inode                ; read the inode

    ; check that it is a directory
    lda MINIX_INODE_MODE+1
    and #>MINIX_DIRECTORY
    beq minix_read_root_inode_fail
    ; we have read root inode successfully
    lda #MINIX_ROOT_INODE               ; save the root inode number to MINIX_CURRENT_DIR_INODE
    sta MINIX_CURRENT_DIR_INODE         ; because this is the current directory
    stz MINIX_CURRENT_DIR_INODE + 1
    clc
    rts
minix_read_root_inode_fail:
    sec
    rts

; We read the root directory data into the memory buffer
minix_read_root:
    jsr minix_read_root_inode
    bcs @exit_fail
    jsr minix_read_inode_data
    clc
    rts
@exit_fail:
    sec
    rts

minix_read_file:
    cp16 MINIX_CURRENT_FILE_INODE, MINIX_CURRENT_INODE
    jsr minix_read_inode                ; read the inode

    ; check that it is a file
    lda MINIX_INODE_MODE+1
    and #>MINIX_REGULAR_FILE
    beq @exit_fail

    jsr minix_read_inode_data           ; the first block of data for the file is now in the buffer
    clc
    rts
@exit_fail:
    sec
    rts

; Find the inode corresponding to the given filename
minix_find_inode_for_filename:
    ; get the data for the current dir inode
    ; to do that, we first set MINIX_CURRENT_INODE to MINIX_CURRENT_DIR_INODE, 
    ; which contains the inode for the current directory
    ; then we read the inode data
    ; and loop through it until we find the right filename
    ; and then we set MINIX_CURRENT_INODE to the found inode
    ; and set the carry to indicate success
    ; otherwise, clear the carry to indicate failure
    ; the filename to look for is in MINIX_SEARCH_FILENAME
    ; the caller has to zero these 30 bytes before setting the filename to search
    ; at the beginning of this buffer

    cp16 MINIX_CURRENT_DIR_INODE, MINIX_CURRENT_INODE
    jsr minix_read_inode                ; read the inode for the directory
    jsr minix_read_inode_data           ; the data for the directory is now in the buffer
    ; loop through the buffer to check the filename
    phy
    cp16 io_buffer_ptr, MINIX_PTR       ; copy the current io buffer pointer to our ZP pointer
    ; load first entry
    ldy #0
@loop:
    lda (MINIX_PTR), y                    ; check low byte of inode number
    bne @inode_not_zero                   ; if it's not 0 it means we have a file here
    iny                                   ; check high byte of inode number
    lda (MINIX_PTR), y                    ; if it's not 0 it means we have a file here
    bne @inode_not_zero2
    
    bra @exit_fail                        ; otherwise, there is nothing here nor beyond, exit now
    
@inode_not_zero:
    iny             ; we get here without having incremented y, so do it twice
@inode_not_zero2:   ; if we get here directly, y has already been incremented once
    iny             ; increment y again to point to start of file
    
    ; and then check if the name corresponds
@inner:
    lda (MINIX_PTR), y
    beq @exit_success                   ; we reached the end of the filename, success
    cmp MINIX_SEARCH_FILENAME-2, y
    bne @next
    iny                                 ; increase y by one to check next character
    cpy #32                             ; check if we reached the end of the filename
    bcc @inner                          ; if not, keep checking
    bra @exit_success                   ; file found
@next:
    ; increase MINIX_PTR by $20 to point to start of next entry
    add16 MINIX_PTR, MINIX_DIRENT_JUMP, MINIX_PTR
    ldy #0
    bra @loop
@exit_success:
    ldy #0
    lda (MINIX_PTR), y
    sta MINIX_CURRENT_FILE_INODE          ; save low byte of inode number to MINIX_CURRENT_FILE_INODE   
    iny
    lda (MINIX_PTR), y
    sta MINIX_CURRENT_FILE_INODE + 1          ; save high byte of inode number to MINIX_CURRENT_FILE_INODE 
    ply
    clc
    rts
@exit_fail:
    ply
    sec
    rts



; once an inode is loaded, read the file data
; if the carry is set on exit, it means there is data left to read, so we should call this routine again
; if the carry is unset, we reached the end of the data and should stop reading
minix_read_inode_data:
    phy
    ; check if zone to read is zero.
    lda MINIX_ZONE_TO_READ
    bne @getzone
    ; if it is, copy the two high bytes of file size to a temporary space
    cp16 MINIX_INODE_FILESIZE, MINIX_FILESIZE_COMPARE
    ; to be decremented each time we come here
@getzone:
    lda MINIX_ZONE_TO_READ
    cmp #7                                      ; we only handle the direct zones for now
    bcs @exit_end                                   ; so we exit if we are trying to read zone 7 or higher
    sta MINIX_TMP                               ; copy current zone to temporary
    stz MINIX_TMP + 1
    asl MINIX_TMP                               ; multiply by two because we want the byte offset
    clc                                         ; add the zone offset to the address where zone 0 is stored
    lda #<MINIX_INODE_ZONE0
    adc MINIX_TMP
    sta MINIX_PTR
    lda #>MINIX_INODE_ZONE0
    adc MINIX_TMP + 1
    sta MINIX_PTR + 1
    ; we now have the address where we will find the zone to read in MINIX_PTR
    ldy #0
    lda (MINIX_PTR),y                 ; we copy that data to the block to read
    sta MINIX_CURRENT_BLOCK
    iny
    lda (MINIX_PTR), y
    sta MINIX_CURRENT_BLOCK+1

    jsr minix_read_block                    ; and we read it
    ; add a check for file length
    ; we should reduce it by 1024 each time this function is called
    ldy #4
@dec_loop:
    dec16zero MINIX_FILESIZE_COMPARE    ; decrement the two high bytes of the filesize 4 times: this reduces the file size left by 1024
    beq @end_loop                       ; if we reach zero on the high bytes, we have only one block left to read for the remainder of the file so exit now
    dey
    bne @dec_loop
    
@end_loop:
    ; TODO check Y here to see if we whould read another block or not
    ; if y is > 0 then we should read another block
    ; otherwise, the end of the data is in the block we just read
    cpy #1
    bcs @exit_end
    inc16 MINIX_ZONE_TO_READ            ; we increment MINIX_ZONE_TO_READ for the next time we get called
    bra @exit_continue
@exit_end:
    ply
    clc
    rts
@exit_continue:
    ply
    sec
    rts

; Node name to create is in MINIX_FILENAME
; the directory in which to create it is in MINIX_CURRENT_DIR_INODE
; some data can already be set in MINIX_INODE
; Node mode should be set in MINIX_INODE_MODE
; this will indicate if the node is a file or directory
minix_mknod:
    phy
    phx
    ; find a free inode by looking at the bitmap
    stz MINIX_CURRENT_BLOCK + 1
    lda #2                          ; the first block of the inode map is block 2
    sta MINIX_CURRENT_BLOCK         ; so read that block now
    cp16 MINIX_N_INODE_MAP_BLOCKS, MINIX_TMP    ;save the number of inode map blocks temporarily
@new_block:
    cp16 io_buffer_ptr, MINIX_PTR               ; copy the io buffer pointer to our own
    jsr minix_read_block
    ldx #4                          ; set X to 4 (number of pages to read) 
@outer:
    phx                             ; and save to stack
    ; find the first free inode slot
    ldy #0
@loop:
    ldx #0
    lda (MINIX_PTR), y              ; load current byte
    beq @found                      ; if it is zero, at least the first bit is free
    ; otherwise, rotate A until the carry get unset
@inner:
    ror                             ; rotate right
    bcc @found                      ; if the carry is clear, it means X is now the number of the free bit
    inx                             ; increase X to keep track of which bit we are looking at
    cpx #8                          ; if X reaches 8, we went around the byte and found no free slot
    bcc @inner                      ; try again with next bit
    iny                             ; increase Y to get next byte
    bne @loop                       ; if Y did not wrap around, do next byte
    inc MINIX_PTR + 1               ; if it did wraparound, do next page
    plx                             ; get X from stack
    dex                             ; decrement X to check number of pages read
    bne @outer                      ; X is not zero yet, read another page

    ; we are at the end of the block, read another one if necessary
    dec16zero MINIX_TMP             ; decrement the number of blocks in inode map by one
    beq @not_found                  ; if we reached zero, we have not found a free inode
    inc16 MINIX_CURRENT_BLOCK       ; otherwise, increment block to read
    bra @new_block                  ; and do the whole circus again

@found:                             ; we found a free inode
    ; now we need to multiply Y by 8 and add X to find the free inode number
    ; we don't need MINIX_TMP anymore, so use it to pultiply Y by 8
    stz MINIX_TMP + 1           ; set high byte to zero
    sty MINIX_TMP               ; set low byte to Y
    phx                         ; save X on stack
    ldx #3
@mult_loop:
    asl16 MINIX_TMP             ; shift left 3 times
    dex
    bne @mult_loop
    pla                         ; pull X in A
    adc MINIX_TMP               ; add low byte of inode number
    sta MINIX_TMP               ; store to low byte
    bcc @carry_unset            ; skip next addition if carry was unset
    lda MINIX_TMP + 1           ; load high byte
    adc #0                      ; add carry if there is one
    sta MINIX_TMP + 1           ; store result in high byte
@carry_unset:
    ; we now have the inode number in MINIX_TMP
    cp16 MINIX_TMP, MINIX_CURRENT_INODE         ; copy it to MINIX_CURRENT_INODE to prepare for write
    ; we have to generate the inode data

    ; find a free data zone by looking at the zone bitmap

    ; create the inode data structure for the new file
    ; with a size of zero
    ; write the inode to disk
    ; get the data for the directory
    ; add a line with the inode number for the new file
    ; and it's filename
    clc
@exit:
    plx
    ply
    rts
@not_found:
    sec
    bra @exit


; Once an inode has been written, we can write the file data
; This routine only writes one block of data at a time, from the buffer pointed to by io_buffer_ptr
; and in the data zone number MINIX_ZONE_TO_WRITE
; this is a reference to the number of the zone in the inode data structure, which itself contains
; the number of the block to write to.
; there is no check for file length, it is up to  the user to manage that.
; This is to allow read / modify / write per block
; the zone to write is incremented at the end of this routine, though
; so if the file data does not exceed one block it will cause a problem
; if the file data ecxeeds one block, this routine expects 
; the zones to be set in the inode data in RAM before being called
minix_write_data:
    phy
    ; check if zone to read is zero.
    lda MINIX_ZONE_TO_WRITE
    cmp #7                                      ; we only handle the direct zones for now
    bcs @exit_end                               ; so we exit if we are trying to write to zone 7 or higher
    sta MINIX_TMP                               ; copy current zone to temporary
    stz MINIX_TMP + 1
    asl MINIX_TMP                               ; multiply by two because we want the byte offset into the inode
    clc                                         ; add the zone byte offset to the address where zone 0 is stored
    lda #<MINIX_INODE_ZONE0
    adc MINIX_TMP
    sta MINIX_PTR
    lda #>MINIX_INODE_ZONE0
    adc MINIX_TMP + 1
    sta MINIX_PTR + 1
    ; we now have the address where we will find the zone to read in MINIX_TMP
    ldy #0
    lda (MINIX_PTR),y                 ; we copy that data to the block to read
    sta MINIX_CURRENT_BLOCK
    iny
    lda (MINIX_PTR), y
    sta MINIX_CURRENT_BLOCK+1

    jsr minix_write_block                    ; and we write it

    inc16 MINIX_ZONE_TO_WRITE            ; we increment MINIX_ZONE_TO_WRITE for the next time we get called
@exit_end:
    ply
    rts



; read one inode entry into RAM data structure
; the number of the inode to read is in MINIX_CURRENT_INODE
minix_read_inode:
    phy
    ; MINIX_CURRENT_INODE contains the number of the inode we have to read to find the data zone
    ; the blocks with inodes start at block 1 + MINIX_N_INODE_MAP_BLOCKS + MINIX_N_ZONE_MAP_BLOCKS
    cp16 MINIX_N_INODE_MAP_BLOCKS, MINIX_CURRENT_BLOCK    ; copy number of inode map blocks to temporary
    inc16 MINIX_CURRENT_BLOCK                             ; add 1 to account for superblock
    inc16 MINIX_CURRENT_BLOCK                             ; add 1 to account for blank root block
    add16 MINIX_CURRENT_BLOCK, MINIX_N_ZONE_MAP_BLOCKS, MINIX_CURRENT_BLOCK ; add the number of zone map blocks

    dec16 MINIX_CURRENT_INODE       ; since inodes are 1 indexed, we need to decrement it by one

    ; we have the first block with inodes in MINIX_CURRENT_BLOCK
    ; now we have to add the number of blocks necessary to reach the MINIX_CURRENT_INODEth block
    ; each inode is 32 bytes, which means there are 32 in each block
    ; so let's divide MINIX_CURRENT_INODE by 32 and add it to the current block to get the real block where that inode is located
    
    cp16 MINIX_CURRENT_INODE, MINIX_TMP
    ldy #5
minix_read_inode_loop1:
    lsr16 MINIX_TMP
    dey
    bne minix_read_inode_loop1

    add16 MINIX_CURRENT_BLOCK, MINIX_TMP, MINIX_CURRENT_BLOCK

    ; MINIX_CURRENT_BLOCK is set up, read data
    jsr minix_read_block            ; read block to buffer

    ; the offset into the block is calculated by taking MINIX_CURRENT_INODE, 
    ; dividing by 32 and taking the remainder
    ; (which is done by doing and $1F) and then 
    ; multiplying by 32 again to get the byte ofset into the block
    stz MINIX_TMP + 1
    lda MINIX_CURRENT_INODE
    and #$1F
    sta MINIX_TMP
    ldy #5
minix_read_inode_loop2:
    asl16 MINIX_TMP         ; multiply inode remainder by 32 bytes to get byte offset
    dey
    bne minix_read_inode_loop2

    ; the byte ofset into the block is now in MINIX_TMP
    ; add it to the buffer pointer
    ; and save it to our own pointer
    add16 MINIX_TMP, io_buffer_ptr, MINIX_PTR

minix_read_inode_loop3:
    ; copy from buffer to data structure
    lda (MINIX_PTR), y
    sta MINIX_INODE, y
    dey
    bne minix_read_inode_loop3
    ; the inode is now stored in MINIX_INODE for future reference
    ; we set the zone to read to zero
    ; so that when we read the data we start with zone 0
    stz MINIX_ZONE_TO_READ
    stz MINIX_ZONE_TO_READ + 1
    inc16 MINIX_CURRENT_INODE       ; put current inode number back to what it was, in case we need ot again
    ply
    rts

; write an inode
; inode data is in MINIX_INODE
; inode number is in MINIX_CURRENT_INODE, 1 indexed

minix_write_inode:
    phy
    ; MINIX_CURRENT_INODE contains the number of the inode we want to write to
    ; the blocks with inodes start at block 1 + MINIX_N_INODE_MAP_BLOCKS + MINIX_N_ZONE_MAP_BLOCKS
    cp16 MINIX_N_INODE_MAP_BLOCKS, MINIX_CURRENT_BLOCK    ; copy number of inode map blocks to temporary
    inc16 MINIX_CURRENT_BLOCK                             ; add 1 to account for superblock
    inc16 MINIX_CURRENT_BLOCK                             ; add 1 to account for blank root block
    add16 MINIX_CURRENT_BLOCK, MINIX_N_ZONE_MAP_BLOCKS, MINIX_CURRENT_BLOCK ; add the number of zone map blocks

    dec16 MINIX_CURRENT_INODE       ; since inodes are 1 indexed, we need to decrement it by one

    ; we have the first block with inodes in MINIX_CURRENT_BLOCK
    ; now we have to add the number of blocks necessary to reach the MINIX_CURRENT_INODEth block
    ; each inode is 32 bytes, which means there are 32 in each block
    ; so let's divide MINIX_CURRENT_INODE by 32 and add it to the current block to get the real block where that inode is located
    
    cp16 MINIX_CURRENT_INODE, MINIX_TMP
    ldy #5
minix_write_inode_loop1:            ; divide inode number by 32
    lsr16 MINIX_TMP
    dey
    bne minix_write_inode_loop1

    add16 MINIX_CURRENT_BLOCK, MINIX_TMP, MINIX_CURRENT_BLOCK   ; MINIX_CURRENT_BLOCK contains the number of the block where our inode is located

    ; copy data from inode in memory data structure to our buffer
    
    ; the offset into the block is calculated by taking MINIX_CURRENT_INODE, 
    ; dividing by 32 and taking the remainder
    ; (which is done by doing and $1F) and then 
    ; multiplying by 32 again to get the byte ofset into the block
    stz MINIX_TMP + 1
    lda MINIX_CURRENT_INODE
    and #$1F
    sta MINIX_TMP
    ldy #5
minix_write_inode_loop2:
    asl16 MINIX_TMP         ; multiply inode remainder by 32 bytes to get byte offset
    dey
    bne minix_write_inode_loop2

    ; the byte ofset into the block is now in MINIX_TMP
    ; add it to the buffer pointer
    ; and save it to our own pointer
    add16 MINIX_TMP, io_buffer_ptr, MINIX_PTR
    jsr minix_read_block            ; read block to make sure we have latest inode from disk in the buffer, ready to be modified
minix_write_inode_loop3:
    ; copy from data structure to buffer
    lda MINIX_INODE, y
    sta (MINIX_PTR), y
    
    dey
    bne minix_write_inode_loop3
    ; MINIX_CURRENT_BLOCK was set up above, 
    ; so we can now write data to disk
    jsr minix_write_block            ; write block from buffer
    ; we set the zone to write to zero
    ; so that when we want to write some data we start with zone 0
    stz MINIX_ZONE_TO_WRITE
    stz MINIX_ZONE_TO_WRITE + 1
    inc16 MINIX_CURRENT_INODE       ; put current inode number back to what it was, in case we need it again
    ply
    rts


; read the superblock
; carry clear on success
; carry set on error
minix_read_superblock:
    phy                             ; save y register just in case
    lda #1                          ; setup to read block 1
    sta MINIX_CURRENT_BLOCK         ; this is the second block on the disk
    stz MINIX_CURRENT_BLOCK + 1
    jsr minix_read_block            ; read block to buffer
    ldy #20                         ; copy data to RAM
    
minix_read_superblock_loop:
    lda (io_buffer_ptr), y
    sta MINIX_SUPERBLOCK, y
    dey
    bne minix_read_superblock_loop

    ; set current inode to root inode
    stz MINIX_CURRENT_INODE + 1
    lda #MINIX_ROOT_INODE
    sta MINIX_CURRENT_INODE

    ; check for magic number
    lda MINIX_MAGIC
    cmp #<MINIX_MAGIC_NUMBER
    bne minix_read_superblock_fail
    lda MINIX_MAGIC + 1
    cmp #>MINIX_MAGIC_NUMBER
    bne minix_read_superblock_fail
    ; we only support zones of 1024 bytes, so exit with error if different
    lda MINIX_LOG_ZONE_SIZE
    bne minix_read_superblock_fail
    lda MINIX_LOG_ZONE_SIZE + 1
    bne minix_read_superblock_fail
    
    ply
    clc
    rts
minix_read_superblock_fail:
    ply
    sec
    rts



.segment "RODATA"
minix_data:
.align $100
.incbin "minix.img"