
; PARTITION TYPE
; 00h 	Unknown or Nothing
; 01h 	12-bit FAT
; 04h 	16-bit FAT (Partition Smallerthan 32MB)
; 05h 	Extended MS-DOS Partition
; 06h 	16-bit FAT (Partition Largerthan 32MB)
; 0Bh 	32-bit FAT (Partition Up to2048GB)
; 0Ch 	Same as 0BH, but uses LBA1 13h Extensions
; 0Eh 	Same as 06H, but uses LBA1 13h Extensions
; 0Fh 	Same as 05H, but uses LBA1 13h Extensions
FSTYPE_FAT32 = $0B
FSTYPE_FAT32_1 = $0C
fat32_readbuffer = SD_BUF

fat32_fatstart          = FAT_VARS + $00  ; 4 bytes
fat32_datastart         = FAT_VARS + $04  ; 4 bytes
fat32_rootcluster       = FAT_VARS + $08  ; 4 bytes
fat32_sectorspercluster = FAT_VARS + $0c  ; 1 byte
fat32_pendingsectors    = FAT_VARS + $0d  ; 1 byte
fat32_address           = FAT_VARS + $0e  ; 2 bytes
fat32_nextcluster       = FAT_VARS + $10  ; 4 bytes
fat32_bytesremaining    = line; FAT_VARS + $14  ; 4 bytes 



fat32_init:
    ; Initialize the module - read the MBR etc, find the partition,
    ; and set up the variables ready for navigating the filesystem

    ; Read the MBR and extract pertinent information
    phx

    ; Sector 0
    lda #0
    sta SD_ARG
    sta SD_ARG+1
    sta SD_ARG+2
    sta SD_ARG+3

    ; Target buffer
    lda #<fat32_readbuffer
    sta sd_buffer_address
    lda #>fat32_readbuffer
    sta sd_buffer_address+1

    ; Do the read
    jsr sd_readsector

    ; Check some things
    lda fat32_readbuffer+510 ; Boot sector signature 55
    cmp #$55
    bne @fail
    lda fat32_readbuffer+511 ; Boot sector signature aa
    cmp #$aa
    bne @fail

    ; Find a FAT32 partition
    ldx #0
    lda fat32_readbuffer+$1C2, x
    cmp #FSTYPE_FAT32
    beq @foundpart
    cmp #FSTYPE_FAT32_1
    beq @foundpart
    ldx #$10
    lda fat32_readbuffer+$1C2, x
    cmp #FSTYPE_FAT32
    beq @foundpart
    cmp #FSTYPE_FAT32_1
    beq @foundpart

    ldx #$20
    lda fat32_readbuffer+$1C2, x
    cmp #FSTYPE_FAT32
    beq @foundpart
    cmp #FSTYPE_FAT32_1
    beq @foundpart

    ldx #$30
    lda fat32_readbuffer+$1C2, x
    cmp #FSTYPE_FAT32
    beq @foundpart
    cmp #FSTYPE_FAT32_1
    beq @foundpart


@fail:
    jmp @error

@foundpart:
    ; Read the FAT32 LBA BEGIN

    lda fat32_readbuffer + $1C6,x
    sta SD_ARG
    lda fat32_readbuffer+$1C7,x
    sta SD_ARG+1
    lda fat32_readbuffer+$1C8,x
    sta SD_ARG+2
    lda fat32_readbuffer+$1C9,x
    sta SD_ARG+3

    jsr sd_readsector   ; read FAT32 Volume ID block
    cmp #1              ; readsector returns 1 on failure
    beq @fail

    ; Check some things
    lda fat32_readbuffer+510 ; FAT32 Volume ID sector signature 55
    cmp #$55
    bne @fail
    lda fat32_readbuffer+511 ; FAT32 Volume ID sector signature aa
    cmp #$aa
    bne @fail

    lda fat32_readbuffer+$11 ; RootEntCnt should be 0 for FAT32
    ora fat32_readbuffer+$12
    bne @fail

    lda fat32_readbuffer+$13 ; TotSec16 should be 0 for FAT32
    ora fat32_readbuffer+$14
    bne @fail

    ; Check bytes per filesystem sector, it should be 512 for any SD card that supports FAT32
    lda fat32_readbuffer+$0B ; low byte should be zero
    bne @fail
    lda fat32_readbuffer+$0C ; high byte is 2 (512), 4, 8, or 16
    cmp #2
    bne @fail

    ; Calculate the starting sector of the FAT
    clc
    lda SD_ARG
    adc fat32_readbuffer+$0E    ; reserved sectors lo
    sta fat32_fatstart
    sta fat32_datastart
    lda SD_ARG+1
    adc fat32_readbuffer+$0F    ; reserved sectors hi
    sta fat32_fatstart+1
    sta fat32_datastart+1
    lda SD_ARG+2
    adc #0
    sta fat32_fatstart+2
    sta fat32_datastart+2
    lda SD_ARG+3
    adc #0
    sta fat32_fatstart+3
    sta fat32_datastart+3

    ; Calculate the starting sector of the data area
    ldx fat32_readbuffer+16   ; number of FATs
@skipfatsloop:
    clc
    lda fat32_datastart
    adc fat32_readbuffer+36 ; fatsize 0
    sta fat32_datastart
    lda fat32_datastart+1
    adc fat32_readbuffer+37 ; fatsize 1
    sta fat32_datastart+1
    lda fat32_datastart+2
    adc fat32_readbuffer+38 ; fatsize 2
    sta fat32_datastart+2
    lda fat32_datastart+3
    adc fat32_readbuffer+39 ; fatsize 3
    sta fat32_datastart+3
    dex
    bne @skipfatsloop

    ; Sectors-per-cluster is a power of two from 1 to 128
    lda fat32_readbuffer+13
    sta fat32_sectorspercluster

    ; Remember the root cluster
    lda fat32_readbuffer+44
    sta fat32_rootcluster
    lda fat32_readbuffer+45
    sta fat32_rootcluster+1
    lda fat32_readbuffer+46
    sta fat32_rootcluster+2
    lda fat32_readbuffer+47
    sta fat32_rootcluster+3

    plx
    lda #0
    rts

@error:
    plx
    lda #1
    rts


fat32_seekcluster:
    phy
    ; Gets ready to read fat32_nextcluster, and advances it according to the FAT
    
    ; FAT sector = (cluster*4) / 512 = (cluster*2) / 256
    lda fat32_nextcluster
    asl
    lda fat32_nextcluster+1
    rol
    sta SD_ARG
    lda fat32_nextcluster+2
    rol
    sta SD_ARG+1
    lda fat32_nextcluster+3
    rol
    sta SD_ARG+2
    ; note: cluster numbers never have the top bit set, so no carry can occur
    ; Add FAT starting sector
    lda SD_ARG
    adc fat32_fatstart
    sta SD_ARG
    lda SD_ARG+1
    adc fat32_fatstart+1
    sta SD_ARG+1
    lda SD_ARG+2
    adc fat32_fatstart+2
    sta SD_ARG+2
    lda #0
    adc fat32_fatstart+3
    sta SD_ARG+3
    ; Target buffer
    lda #<fat32_readbuffer
    sta sd_buffer_address
    lda #>fat32_readbuffer
    sta sd_buffer_address+1
    ; Read the sector from the FAT
    jsr sd_readsector

    ; Before using this FAT data, set currentsector ready to read the cluster itself
    ; We need to multiply the cluster number minus two by the number of sectors per 
    ; cluster, then add the data region start sector

    ; Subtract two from cluster number
    sec
    lda fat32_nextcluster
    sbc #2
    sta SD_ARG
    lda fat32_nextcluster+1
    sbc #0
    sta SD_ARG+1
    lda fat32_nextcluster+2
    sbc #0
    sta SD_ARG+2
    lda fat32_nextcluster+3
    sbc #0
    sta SD_ARG+3
    
    ; Multiply by sectors-per-cluster which is a power of two between 1 and 128
    lda fat32_sectorspercluster
@spcshiftloop:
    lsr
    bcs @spcshiftloopdone
    asl SD_ARG
    rol SD_ARG+1
    rol SD_ARG+2
    rol SD_ARG+3
    jmp @spcshiftloop
@spcshiftloopdone:

    ; Add the data region start sector
    clc
    lda SD_ARG
    adc fat32_datastart
    sta SD_ARG
    lda SD_ARG+1
    adc fat32_datastart+1
    sta SD_ARG+1
    lda SD_ARG+2
    adc fat32_datastart+2
    sta SD_ARG+2
    lda SD_ARG+3
    adc fat32_datastart+3
    sta SD_ARG+3

    ; That's now ready for later code to read this sector in - tell it how many consecutive
    ; sectors it can now read
    lda fat32_sectorspercluster
    sta fat32_pendingsectors

    ; Now go back to looking up the next cluster in the chain
    ; Find the offset to this cluster's entry in the FAT sector we loaded earlier

    ; Offset = (cluster*4) & 511 = (cluster & 127) * 4
    lda fat32_nextcluster
    and #$7f
    asl
    asl
    tay ; Y = low byte of offset
    ; Add the potentially carried bit to the high byte of the address
    lda sd_buffer_address+1
    adc #0
    sta sd_buffer_address+1

    ; Copy out the next cluster in the chain for later use
    lda (sd_buffer_address),y
    sta fat32_nextcluster
    iny
    lda (sd_buffer_address),y
    sta fat32_nextcluster+1
    iny
    lda (sd_buffer_address),y
    sta fat32_nextcluster+2
    iny
    lda (sd_buffer_address),y
    and #$0f
    sta fat32_nextcluster+3

    ; See if it's the end of the chain
    ora #$f0
    and fat32_nextcluster+2
    and fat32_nextcluster+1
    cmp #$ff
    bne @notendofchain
    lda fat32_nextcluster
    cmp #$f8
    bcc @notendofchain

    ; It's the end of the chain, set the top bits so that we can tell this later on
    sta fat32_nextcluster+3
@notendofchain:
    ply
    rts


fat32_readnextsector:
    ; Reads the next sector from a cluster chain into the buffer at fat32_address.
    ;
    ; Advances the current sector ready for the next read and looks up the next cluster
    ; in the chain when necessary.
    ;
    ; On return, carry is clear if data was read, or set if the cluster chain has ended.

    ; Maybe there are pending sectors in the current cluster
    lda fat32_pendingsectors
    bne @readsector

    ; No pending sectors, check for end of cluster chain
    lda fat32_nextcluster+3
    bmi @endofchain

    ; Prepare to read the next cluster
    jsr fat32_seekcluster

@readsector:
    dec fat32_pendingsectors

    ; Set up target address  
    lda fat32_address
    sta sd_buffer_address
    lda fat32_address+1
    sta sd_buffer_address+1

    ; Read the sector
    jsr sd_readsector

    ; Advance to next sector
    inc SD_ARG
    bne @sectorincrementdone
    inc SD_ARG+1
    bne @sectorincrementdone
    inc SD_ARG+2
    bne @sectorincrementdone
    inc SD_ARG+3
@sectorincrementdone:

    ; Success - clear carry and return
    clc
    rts

@endofchain:
    ; End of chain - set carry and return
    sec
    rts


fat32_openroot:
    ; Prepare to read the root directory

    lda fat32_rootcluster
    sta fat32_nextcluster
    lda fat32_rootcluster+1
    sta fat32_nextcluster+1
    lda fat32_rootcluster+2
    sta fat32_nextcluster+2
    lda fat32_rootcluster+3
    sta fat32_nextcluster+3

    jsr fat32_seekcluster

    ; Set the pointer to a large value so we always read a sector the first time through
    ; lda #$ff
    ; sta sd_buffer_address+1
    lda #0   ; return success
    rts


fat32_opendirent:
    phy
    ; Prepare to read from a file or directory based on a dirent
    ;
    ; Point sd_buffer_address at the dirent

    ; Remember file size in bytes remaining
    ldy #28
    lda (sd_buffer_address),y
    sta fat32_bytesremaining
    iny
    lda (sd_buffer_address),y
    sta fat32_bytesremaining+1
    iny
    lda (sd_buffer_address),y
    sta fat32_bytesremaining+2
    iny
    lda (sd_buffer_address),y
    sta fat32_bytesremaining+3

    ; Seek to first cluster
    ldy #26
    lda (sd_buffer_address),y
    sta fat32_nextcluster
    iny
    lda (sd_buffer_address),y
    sta fat32_nextcluster+1
    ldy #20
    lda (sd_buffer_address),y
    sta fat32_nextcluster+2
    iny
    lda (sd_buffer_address),y
    sta fat32_nextcluster+3

    jsr fat32_seekcluster

    ; Set the pointer to a large value so we always read a sector the first time through
    ; lda #$ff
    ; sta sd_buffer_address+1
    ply
    rts


fat32_readdirent:
    ; Read a directory entry from the open directory
    ;
    ; On exit the carry is set if there were no more directory entries.
    ;
    ; Otherwise, A is set to the file's attribute byte and
    ; zp_sd_address points at the returned directory entry.
    ; LFNs and empty entries are ignored automatically.

    ; Increment pointer by 32 to point to next entry
    lda #'1'
    jsr kernel_putc
    phy
    clc
    lda sd_buffer_address
    adc #32
    sta sd_buffer_address
    lda sd_buffer_address+1
    adc #0
    sta sd_buffer_address+1
    sta PORTA

    ; If it's not at the end of the buffer, we have data already
    cmp #>(fat32_readbuffer+$200)
    bcc @gotdata

    ; Read another sector
    lda #<fat32_readbuffer
    sta fat32_address
    lda #>fat32_readbuffer
    sta fat32_address+1
    jsr fat32_readnextsector
    bcc @gotdata

@endofdirectory:
    ply
    sec
    rts

@gotdata:
    ; Check first character
    ldy #0
    lda (sd_buffer_address),y

    ; End of directory => abort
    beq @endofdirectory

    ; Empty entry => start again
    cmp #$e5
    beq fat32_readdirent

    lda #'5'
    jsr kernel_putc

    ; Check attributes
    ldy #11
    lda (sd_buffer_address),y
    and #$3f
    cmp #$0f ; LFN => start again
    beq fat32_readdirent

    lda #'6'
    jsr kernel_putc
    ; Yield this result
    ply
    clc
    rts


fat32_finddirent:
    ; The directory should already be open for iteration.
    ; Pointer to filename is in fat32_filenamepointer and fat32_filenamepointer + 1
    
    ; Iterate until name is found or end of directory
    phy
@direntloop:
    jsr fat32_readdirent
    ldy #10
    bcc @comparenameloop
    ply
    lda #1
    rts ; return not found

@comparenameloop:
    lda (sd_buffer_address),y
    cmp (fat32_filenamepointer),y
    bne @direntloop ; no match
    dey
    bpl @comparenameloop

    ; Found it
    ply
    lda #0
    rts


fat32_file_readbyte:
    ; Read a byte from an open file
    ;
    ; The byte is returned in A with C clear; or if end-of-file was reached, C is set instead

    sec

    ; Is there any data to read at all?
    lda fat32_bytesremaining
    ora fat32_bytesremaining+1
    ora fat32_bytesremaining+2
    ora fat32_bytesremaining+3
    beq @rts

    ; Decrement the remaining byte count
    lda fat32_bytesremaining
    sbc #1
    sta fat32_bytesremaining
    lda fat32_bytesremaining+1
    sbc #0
    sta fat32_bytesremaining+1
    lda fat32_bytesremaining+2
    sbc #0
    sta fat32_bytesremaining+2
    lda fat32_bytesremaining+3
    sbc #0
    sta fat32_bytesremaining+3
    
    ; Need to read a new sector?
    lda sd_buffer_address+1
    cmp #>(fat32_readbuffer+$200)
    bcc @gotdata

    ; Read another sector
    lda #<fat32_readbuffer
    sta fat32_address
    lda #>fat32_readbuffer
    sta fat32_address+1

    jsr fat32_readnextsector
    bcs @rts                    ; this shouldn't happen

@gotdata:
    phy
    ldy #0
    lda (sd_buffer_address),y
    ply
    inc sd_buffer_address
    bne @rts
    inc sd_buffer_address+1
    bne @rts
    inc sd_buffer_address+2
    bne @rts
    inc sd_buffer_address+3

@rts:
    rts


fat32_file_read:
    ; Read a whole file into memory.  It's assumed the file has just been opened 
    ; and no data has been read yet.
    ;
    ; Also we read whole sectors, so data in the target region beyond the end of the 
    ; file may get overwritten, up to the next 512-byte boundary.
    ;
    ; And we don't properly support 64k+ files, as it's unnecessary complication given
    ; the 6502's small address space

    ; Round the size up to the next whole sector
    lda fat32_bytesremaining
    cmp #1                      ; set carry if bottom 8 bits not zero
    lda fat32_bytesremaining+1
    adc #0                      ; add carry, if any
    lsr                         ; divide by 2
    adc #0                      ; round up

    ; No data?
    beq @done

    ; Store sector count - not a byte count any more
    sta fat32_bytesremaining

    ; Read entire sectors to the user-supplied buffer
@wholesectorreadloop:
    ; Read a sector to fat32_address
    jsr fat32_readnextsector

    ; Advance fat32_address by 512 bytes
    lda fat32_address+1
    adc #2                      ; carry already clear
    sta fat32_address+1

    ldx fat32_bytesremaining    ; note - actually loads sectors remaining
    dex
    stx fat32_bytesremaining    ; note - actually stores sectors remaining

    bne @wholesectorreadloop

@done:
    rts

