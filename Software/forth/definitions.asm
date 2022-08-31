; Definitions for Tali Forth 2
; Scot W. Stevenson <scot.stevenson@gmail.com>
; First version: 01. Apr 2016 (Liara Forth)
; This version: 29. Jan 2020

; This file is included by taliforth.asm. These are the general
; definitions; platform-specific definitions such as the
; memory map are kept in the platform folder.


; ZERO PAGE ADDRESSES/VARIABLES

; These are kept at the top of Zero Page, with the most important variables at
; the top because the Data Stack grows towards this area from dsp0: If there is
; an overflow, the lower, less important variables will be clobbered first,
; giving the system a chance to recover. In other words, they are part of the
; floodplain.

; The four variables insrc, cib, ciblen, and toin must stay together in this
; sequence for the words INPUT>R and R>INPUT to work correctly.

cp =        user0+0   ; Compiler Pointer
dp =        user0+2   ; Dictionary Pointer
workword =  user0+4   ; nt (not xt!) of word being compiled, except in
                           ; a :NONAME declared word (see status)
insrc =     user0+6   ; input Source for SOURCE-ID
cib =       user0+8   ; address of current input buffer
ciblen =    user0+10  ; length of current input buffer
toin =      user0+12  ; pointer to CIB (>IN in Forth)
ip =        user0+14  ; Instruction Pointer (current xt)
output =    user0+16  ; vector for EMIT
input =     user0+18  ; vector for KEY
havekey =   user0+20  ; vector for KEY?
state =     user0+22  ; STATE: -1 compile, 0 interpret
base =      user0+24  ; number radix, default decimal
nc_limit =   user0+26  ; limit for Native Compile size
uf_strip =   user0+28  ; flag to strip underflow detection code
up =        user0+30  ; User Pointer (Address of user variables)
status =    user0+32  ; internal status information
                           ; (used by : :NONAME ; ACCEPT)
                           ; Bit 7 = Redefined word message postpone
                           ;         When set before calling CREATE, it will
                           ;         not print the "redefined xxxx" message if
                           ;         the word exists. Instead, this bit will
                           ;         be reused and after CREATE has run, it will
                           ;         be set if the word was redefined and 0 if
                           ;         not. This bit should be 0 when not in use.
                           ; Bit 6 = 1 for normal ":" definitions
                           ;         WORKWORD contains nt of word being compiled
                           ;       = 0 for :NONAME definitions
                           ;         WORKWORD contains xt of word being compiled
                           ; Bit 5 = 1 for NUMBER returning a double word
                           ;       = 0 for NUMBER returning a single word
                           ; Bit 3 = 1 makes CTRL-n recall current history
                           ;       = 0 CTRL-n recalls previous history
                           ; Bit 2 = Current history buffer msb
                           ; Bit 1 = Current history buffer (0-7, wraps)
                           ; Bit 0 = Current history buffer lsb
                           ; status+1 is used by ACCEPT to hold history lengths.
tmpbranch = user0+34  ; temporary storage for 0BRANCH, BRANCH only
tmp1 =      user0+36  ; temporary storage
tmp2 =      user0+38  ; temporary storage
tmp3 =      user0+40  ; temporary storage (especially for print)
tmpdsp =    user0+42  ; temporary DSP (X) storage (two bytes)
tmptos =    user0+44  ; temporary TOS storage
editor1 =   user0+46  ; temporary for editors
editor2 =   user0+48  ; temporary for editors
editor3 =   user0+50  ; temporary for editors
tohold =    user0+52  ; pointer for formatted output
scratch =   user0+54  ; 8 byte scratchpad (see UM/MOD)

; Zero Page:
; Bytes used for variables: 62 ($0000-$003D)
; First usable Data Stack location: $003E (decimal 62)
; Bytes avaible for Data Stack: 128-62 = 66 --> 33 16-bit cells

dsp0 =      zpage_end-7    ; initial Data Stack Pointer

; User Variables:
; Block variables
blk_offset =  0        ; BLK : UP + 0
scr_offset =  2        ; SCR : UP + 2

; Wordlists
current_offset =  4    ; CURRENT (byte) : UP + 4 (Compilation wordlist)
num_wordlists_offset =  5
                           ; #WORDLISTS (byte) : UP + 5
wordlists_offset =  6  ; WORDLISTS (cells) : UP + 6 to UP + 29
                           ;          (FORTH, EDITOR, ASSEMBLER, ROOT, +8 more)
num_order_offset =  30 ; #ORDER (byte) : UP + 30
                           ;          (Number of wordlists in search order)
search_order_offset =  31
                           ; SEARCH-ORDER (bytes) : UP + 31 to UP + 39
                           ; Allowing for 9 to keep offsets even.
max_wordlists =  12    ; Maximum number of wordlists supported
                           ; 4 Tali built-ins + 8 user wordlists

; Buffer variables
blkbuffer_offset =     40   ; Address of buffer
buffblocknum_offset =  42   ; Block number current in buffer
buffstatus_offset =    44   ; Status of buffer (bit 0 = used, bit 1 = dirty)

; Block I/O vectors
blockread_offset =     46   ; Vector to block reading routine
blockwrite_offset =    48   ; Vector to block writing routine


; ASCII CHARACTERS
AscCC =   $03  ; break (CTRL-c)
AscBELL = $07  ; bell sound
AscBS =   $08  ; backspace
AscLF =   $0a  ; line feed
AscCR =   $0d  ; carriage return
AscESC =  $1b  ; escape
AscSP =   $20  ; space
AscDEL =  $7f  ; delete (CTRL-h)
AscCP =   $10  ; CTRL-p (used to recall previous input history)
AscCN =   $0e  ; CTRL-n (used to recall next input history)

; DICTIONARY FLAGS
; The first three bits are currently unused
CO = 1  ; Compile Only
AN = 2  ; Always Native Compile
IM = 4  ; Immediate Word
NN = 8  ; Never Native Compile
UF = 16 ; Includes Underflow Check (RESERVED)
HC = 32 ; Word has Code Field Area (CFA)


; VARIOUS
MAX_LINE_LENGTH =   79      ; assumes 80 character lines

; END
