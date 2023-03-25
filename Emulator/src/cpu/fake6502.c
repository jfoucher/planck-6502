/* Fake6502 CPU emulator core v1.1 *******************
 * (c)2011 Mike Chambers (miker00lz@gmail.com)       *
 *****************************************************
 * v1.1 - Small bugfix in BIT opcode, but it was the *
 *        difference between a few games in my NES   *
 *        emulator working and being broken!         *
 *        I went through the rest carefully again    *
 *        after fixing it just to make sure I didn't *
 *        have any other typos! (Dec. 17, 2011)      *
 *                                                   *
 * v1.0 - First release (Nov. 24, 2011)              *
 *****************************************************
 * LICENSE: This source code is released into the    *
 * public domain, but if you use it please do give   *
 * credit. I put a lot of effort into writing this!  *
 *                                                   *
 *****************************************************
 * Fake6502 is a MOS Technology 6502 CPU emulation   *
 * engine in C. It was written as part of a Nintendo *
 * Entertainment System emulator I've been writing.  *
 *                                                   *
 * A couple important things to know about are two   *
 * defines in the code. One is "UNDOCUMENTED" which, *
 * when defined, allows Fake6502 to compile with     *
 * full support for the more predictable             *
 * undocumented instructions of the 6502. If it is   *
 * undefined, undocumented opcodes just act as NOPs. *
 *                                                   *
 * The other define is "NES_CPU", which causes the   *
 * code to compile without support for binary-coded  *
 * decimal (BCD) support for the ADC and SBC         *
 * opcodes. The Ricoh 2A03 CPU in the NES does not   *
 * support BCD, but is otherwise identical to the    *
 * standard MOS 6502. (Note that this define is      *
 * enabled in this file if you haven't changed it    *
 * yourself. If you're not emulating a NES, you      *
 * should comment it out.)                           *
 *                                                   *
 * If you do discover an error in timing accuracy,   *
 * or operation in general please e-mail me at the   *
 * address above so that I can fix it. Thank you!    *
 *                                                   *
 *****************************************************
 * Usage:                                            *
 *                                                   *
 * Fake6502 requires you to provide two external     *
 * functions:                                        *
 *                                                   *
 * uint8_t read6502(uint16_t address)                *
 * void write6502(uint16_t address, uint8_t value)   *
 *                                                   *
 * You may optionally pass Fake6502 the pointer to a *
 * function which you want to be called after every  *
 * emulated instruction. This function should be a   *
 * void with no parameters expected to be passed to  *
 * it.                                               *
 *                                                   *
 * This can be very useful. For example, in a NES    *
 * emulator, you check the number of clock ticks     *
 * that have passed so you can know when to handle   *
 * APU events.                                       *
 *                                                   *
 * To pass Fake6502 this pointer, use the            *
 * hookexternal(void *funcptr) function provided.    *
 *                                                   *
 * To disable the hook later, pass NULL to it.       *
 *****************************************************
 * Useful functions in this emulator:                *
 *                                                   *
 * void reset6502()                                  *
 *   - Call this once before you begin execution.    *
 *                                                   *
 * void exec6502(uint32_t tickcount)                 *
 *   - Execute 6502 code up to the next specified    *
 *     count of clock ticks.                         *
 *                                                   *
 * void step6502()                                   *
 *   - Execute a single instrution.                  *
 *                                                   *
 * void irq6502()                                    *
 *   - Trigger a hardware IRQ in the 6502 core.      *
 *                                                   *
 * void nmi6502()                                    *
 *   - Trigger an NMI in the 6502 core.              *
 *                                                   *
 * void hookexternal(void *funcptr)                  *
 *   - Pass a pointer to a void function taking no   *
 *     parameters. This will cause Fake6502 to call  *
 *     that function once after each emulated        *
 *     instruction.                                  *
 *                                                   *
 *****************************************************
 * Useful variables in this emulator:                *
 *                                                   *
 * uint32_t clockticks6502                           *
 *   - A running total of the emulated cycle count.  *
 *                                                   *
 * uint32_t instructions                             *
 *   - A running total of the total emulated         *
 *     instruction count. This is not related to     *
 *     clock cycle timing.                           *
 *                                                   *
 *****************************************************/

#include <stdio.h>
#include <stdint.h>

//6502 defines
#define UNDOCUMENTED //when this is defined, undocumented opcodes are handled.
                     //otherwise, they're simply treated as NOPs.

//#define NES_CPU      //when this is defined, the binary-coded decimal (BCD)
                     //status flag is not honored by ADC and SBC. the 2A03
                     //CPU in the Nintendo Entertainment System does not
                     //support BCD operation.

#define FLAG_CARRY     0x01
#define FLAG_ZERO      0x02
#define FLAG_INTERRUPT 0x04
#define FLAG_DECIMAL   0x08
#define FLAG_BREAK     0x10
#define FLAG_CONSTANT  0x20
#define FLAG_OVERFLOW  0x40
#define FLAG_SIGN      0x80

#define BASE_STACK     0x100


//6502 CPU registers
uint16_t pc;
uint8_t sp, a, x, y, status;


//helper variables
uint32_t instructions = 0; //keep track of total instructions executed
uint32_t clockticks6502 = 0, clockgoal6502 = 0;
uint16_t oldpc, ea, reladdr, value, result;
uint8_t opcode, oldstatus;

uint8_t penaltyop, penaltyaddr;
uint8_t waiting = 0;

//externally supplied functions
extern uint8_t read6502(uint16_t address);
extern void write6502(uint16_t address, uint8_t value);
extern void stop6502(uint16_t address);
#define saveaccum(n) a = (uint8_t)((n) & 0x00FF)


//flag modifier macros
#define setcarry() status |= FLAG_CARRY
#define clearcarry() status &= (~FLAG_CARRY)
#define setzero() status |= FLAG_ZERO
#define clearzero() status &= (~FLAG_ZERO)
#define setinterrupt() status |= FLAG_INTERRUPT
#define clearinterrupt() status &= (~FLAG_INTERRUPT)
#define setdecimal() status |= FLAG_DECIMAL
#define cleardecimal() status &= (~FLAG_DECIMAL)
#define setoverflow() status |= FLAG_OVERFLOW
#define clearoverflow() status &= (~FLAG_OVERFLOW)
#define setsign() status |= FLAG_SIGN
#define clearsign() status &= (~FLAG_SIGN)


//flag calculation macros
#define zerocalc(n) {\
    if ((n) & 0x00FF) clearzero();\
        else setzero();\
}

#define signcalc(n) {\
    if ((n) & 0x0080) setsign();\
        else clearsign();\
}

#define carrycalc(n) {\
    if ((n) & 0xFF00) setcarry();\
        else clearcarry();\
}

#define overflowcalc(n, m, o) { /* n = result, m = accumulator, o = memory */ \
    if (((n) ^ (uint16_t)(m)) & ((n) ^ (o)) & 0x0080) setoverflow();\
        else clearoverflow();\
}

//a few general functions used by various other functions
void push16(uint16_t pushval) {
    write6502(BASE_STACK + sp, (pushval >> 8) & 0xFF);
    write6502(BASE_STACK + ((sp - 1) & 0xFF), pushval & 0xFF);
    sp -= 2;
}

void push8(uint8_t pushval) {
    write6502(BASE_STACK + sp--, pushval);
}

uint16_t pull16() {
    uint16_t temp16;
    temp16 = read6502(BASE_STACK + ((sp + 1) & 0xFF)) | ((uint16_t)read6502(BASE_STACK + ((sp + 2) & 0xFF)) << 8);
    sp += 2;
    return(temp16);
}

uint8_t pull8() {
    return (read6502(BASE_STACK + ++sp));
}

void reset6502() {
    pc = (uint16_t)read6502(0xFFFC) | ((uint16_t)read6502(0xFFFD) << 8);
    a = 0;
    x = 0;
    y = 0;
    sp = 0xFD;
    status |= FLAG_CONSTANT | FLAG_BREAK;
    setinterrupt();
    cleardecimal();
    waiting = 0;
}
static void imp() { //implied
}

static void acc() { //accumulator
}

static void imm() { //immediate
    ea = pc++;
}

static void zp() { //zero-page
    ea = (uint16_t)read6502((uint16_t)pc++);
}

static void zpx() { //zero-page,X
    ea = ((uint16_t)read6502((uint16_t)pc++) + (uint16_t)x) & 0xFF; //zero-page wraparound
}

static void zpy() { //zero-page,Y
    ea = ((uint16_t)read6502((uint16_t)pc++) + (uint16_t)y) & 0xFF; //zero-page wraparound
}

static void rel() { //relative for branch ops (8-bit immediate value, sign-extended)
    reladdr = (uint16_t)read6502(pc++);
    if (reladdr & 0x80) reladdr |= 0xFF00;
}

static void abso() { //absolute
    ea = (uint16_t)read6502(pc) | ((uint16_t)read6502(pc+1) << 8);
    pc += 2;
}

static void absx() { //absolute,X
    uint16_t startpage;
    ea = ((uint16_t)read6502(pc) | ((uint16_t)read6502(pc+1) << 8));
    startpage = ea & 0xFF00;
    ea += (uint16_t)x;

    if (startpage != (ea & 0xFF00)) { //one cycle penlty for page-crossing on some opcodes
        penaltyaddr = 1;
    }

    pc += 2;
}

static void absy() { //absolute,Y
    uint16_t startpage;
    ea = ((uint16_t)read6502(pc) | ((uint16_t)read6502(pc+1) << 8));
    startpage = ea & 0xFF00;
    ea += (uint16_t)y;

    if (startpage != (ea & 0xFF00)) { //one cycle penlty for page-crossing on some opcodes
        penaltyaddr = 1;
    }

    pc += 2;
}

static void ind() { //indirect
    uint16_t eahelp, eahelp2;
    eahelp = (uint16_t)read6502(pc) | (uint16_t)((uint16_t)read6502(pc+1) << 8);
    //
    //      The 6502 page boundary wraparound bug does not occur on a 65C02.
    //
    //eahelp2 = (eahelp & 0xFF00) | ((eahelp + 1) & 0x00FF); //replicate 6502 page-boundary wraparound bug
    eahelp2 = (eahelp+1) & 0xFFFF;
    ea = (uint16_t)read6502(eahelp) | ((uint16_t)read6502(eahelp2) << 8);
    pc += 2;
}

static void indx() { // (indirect,X)
    uint16_t eahelp;
    eahelp = (uint16_t)(((uint16_t)read6502(pc++) + (uint16_t)x) & 0xFF); //zero-page wraparound for table pointer
    ea = (uint16_t)read6502(eahelp & 0x00FF) | ((uint16_t)read6502((eahelp+1) & 0x00FF) << 8);
}

static void indy() { // (indirect),Y
    uint16_t eahelp, eahelp2, startpage;
    eahelp = (uint16_t)read6502(pc++);
    eahelp2 = (eahelp & 0xFF00) | ((eahelp + 1) & 0x00FF); //zero-page wraparound
    ea = (uint16_t)read6502(eahelp) | ((uint16_t)read6502(eahelp2) << 8);
    startpage = ea & 0xFF00;
    ea += (uint16_t)y;

    if (startpage != (ea & 0xFF00)) { //one cycle penlty for page-crossing on some opcodes
        penaltyaddr = 1;
    }
}

static void zprel() { // zero-page, relative for branch ops (8-bit immediatel value, sign-extended)
	ea = (uint16_t)read6502(pc);
	reladdr = (uint16_t)read6502(pc+1);
	if (reladdr & 0x80) reladdr |= 0xFF00;

	pc += 2;
}

static void (*addrtable[256])();
static void (*optable[256])();

static uint16_t getvalue() {
    if (addrtable[opcode] == acc) return((uint16_t)a);
        else return((uint16_t)read6502(ea));
}

__attribute__((unused)) static uint16_t getvalue16() {
    return((uint16_t)read6502(ea) | ((uint16_t)read6502(ea+1) << 8));
}

static void putvalue(uint16_t saveval) {
    if (addrtable[opcode] == acc) a = (uint8_t)(saveval & 0x00FF);
        else write6502(ea, (saveval & 0x00FF));
}


static void adc() {
    penaltyop = 1;
    #ifndef NES_CPU
    if (status & FLAG_DECIMAL) {
        uint16_t tmp, tmp2;
        value = getvalue();
        tmp = ((uint16_t)a & 0x0F) + (value & 0x0F) + (uint16_t)(status & FLAG_CARRY);
        tmp2 = ((uint16_t)a & 0xF0) + (value & 0xF0);
        if (tmp > 0x09) {
            tmp2 += 0x10;
            tmp += 0x06;
        }
        if (tmp2 > 0x90) {
            tmp2 += 0x60;
        }
        if (tmp2 & 0xFF00) {
            setcarry();
        } else {
            clearcarry();
        }
        result = (tmp & 0x0F) | (tmp2 & 0xF0);

        zerocalc(result);                /* 65C02 change, Decimal Arithmetic sets NZV */
        signcalc(result);

        clockticks6502++;
    } else {
    #endif
        value = getvalue();
        result = (uint16_t)a + value + (uint16_t)(status & FLAG_CARRY);

        carrycalc(result);
        zerocalc(result);
        overflowcalc(result, a, value);
        signcalc(result);
    #ifndef NES_CPU
    }
    #endif

    saveaccum(result);
}

static void and() {
    penaltyop = 1;
    value = getvalue();
    result = (uint16_t)a & value;

    zerocalc(result);
    signcalc(result);

    saveaccum(result);
}

static void asl() {
    value = getvalue();
    result = value << 1;

    carrycalc(result);
    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void bcc() {
    if ((status & FLAG_CARRY) == 0) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void bcs() {
    if ((status & FLAG_CARRY) == FLAG_CARRY) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void beq() {
    if ((status & FLAG_ZERO) == FLAG_ZERO) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void bit() {
    value = getvalue();
    result = (uint16_t)a & value;

    zerocalc(result);
    status = (status & 0x3F) | (uint8_t)(value & 0xC0);
}

static void bmi() {
    if ((status & FLAG_SIGN) == FLAG_SIGN) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void bne() {
    if ((status & FLAG_ZERO) == 0) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void bpl() {
    if ((status & FLAG_SIGN) == 0) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void brk() {
    pc++;


    push16(pc); //push next instruction address onto stack
    push8(status | FLAG_BREAK); //push CPU status to stack
    setinterrupt(); //set interrupt flag
    cleardecimal();       // clear decimal flag (65C02 change)
    pc = (uint16_t)read6502(0xFFFE) | ((uint16_t)read6502(0xFFFF) << 8);
}

static void bvc() {
    if ((status & FLAG_OVERFLOW) == 0) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void bvs() {
    if ((status & FLAG_OVERFLOW) == FLAG_OVERFLOW) {
        oldpc = pc;
        pc += reladdr;
        if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
            else clockticks6502++;
    }
}

static void clc() {
    clearcarry();
}

static void cld() {
    cleardecimal();
}

static void cli() {
    clearinterrupt();
}

static void clv() {
    clearoverflow();
}

static void cmp() {
    penaltyop = 1;
    value = getvalue();
    result = (uint16_t)a - value;

    if (a >= (uint8_t)(value & 0x00FF)) setcarry();
        else clearcarry();
    if (a == (uint8_t)(value & 0x00FF)) setzero();
        else clearzero();
    signcalc(result);
}

static void cpx() {
    value = getvalue();
    result = (uint16_t)x - value;

    if (x >= (uint8_t)(value & 0x00FF)) setcarry();
        else clearcarry();
    if (x == (uint8_t)(value & 0x00FF)) setzero();
        else clearzero();
    signcalc(result);
}

static void cpy() {
    value = getvalue();
    result = (uint16_t)y - value;

    if (y >= (uint8_t)(value & 0x00FF)) setcarry();
        else clearcarry();
    if (y == (uint8_t)(value & 0x00FF)) setzero();
        else clearzero();
    signcalc(result);
}

static void dec() {
    value = getvalue();
    result = value - 1;

    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void dex() {
    x--;

    zerocalc(x);
    signcalc(x);
}

static void dey() {
    y--;

    zerocalc(y);
    signcalc(y);
}

static void eor() {
    penaltyop = 1;
    value = getvalue();
    result = (uint16_t)a ^ value;

    zerocalc(result);
    signcalc(result);

    saveaccum(result);
}

static void inc() {
    value = getvalue();
    result = value + 1;

    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void inx() {
    x++;

    zerocalc(x);
    signcalc(x);
}

static void iny() {
    y++;

    zerocalc(y);
    signcalc(y);
}

static void jmp() {
    pc = ea;
}

static void jsr() {
    push16(pc - 1);
    pc = ea;
}

static void lda() {
    penaltyop = 1;
    value = getvalue();
    a = (uint8_t)(value & 0x00FF);

    zerocalc(a);
    signcalc(a);
}

static void ldx() {
    penaltyop = 1;
    value = getvalue();
    x = (uint8_t)(value & 0x00FF);

    zerocalc(x);
    signcalc(x);
}

static void ldy() {
    penaltyop = 1;
    value = getvalue();
    y = (uint8_t)(value & 0x00FF);

    zerocalc(y);
    signcalc(y);
}

static void lsr() {
    value = getvalue();
    result = value >> 1;

    if (value & 1) setcarry();
        else clearcarry();
    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void nop() {
    switch (opcode) {
        case 0x1C:
        case 0x3C:
        case 0x5C:
        case 0x7C:
        case 0xDC:
        case 0xFC:
            penaltyop = 1;
            break;
    }
}

static void ora() {
    penaltyop = 1;
    value = getvalue();
    result = (uint16_t)a | value;

    zerocalc(result);
    signcalc(result);

    saveaccum(result);
}

static void pha() {
    push8(a);
}

static void php() {
    push8(status | FLAG_BREAK);
}

static void pla() {
    a = pull8();

    zerocalc(a);
    signcalc(a);
}

static void plp() {
    status = pull8() | FLAG_CONSTANT;
}

static void rol() {
    value = getvalue();
    result = (value << 1) | (status & FLAG_CARRY);

    carrycalc(result);
    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void ror() {
    value = getvalue();
    result = (value >> 1) | ((status & FLAG_CARRY) << 7);

    if (value & 1) setcarry();
        else clearcarry();
    zerocalc(result);
    signcalc(result);

    putvalue(result);
}

static void rti() {
    status = pull8();
    value = pull16();
    pc = value;
}

static void rts() {
    value = pull16();
    pc = value + 1;
}

static void sbc() {
    penaltyop = 1;

    #ifndef NES_CPU
    if (status & FLAG_DECIMAL) {
        value = getvalue();
        result = (uint16_t)a - (value & 0x0f) + (status & FLAG_CARRY) - 1;
        if ((result & 0x0f) > (a & 0x0f)) {
            result -= 6;
        }
        result -= (value & 0xf0);
        if ((result & 0xfff0) > ((uint16_t)a & 0xf0)) {
            result -= 0x60;
        }
        if (result <= (uint16_t)a) {
            setcarry();
        } else {
            clearcarry();
        }

        zerocalc(result);                /* 65C02 change, Decimal Arithmetic sets NZV */
        signcalc(result);

        clockticks6502++;
    } else {
    #endif
        value = getvalue() ^ 0x00FF;
        result = (uint16_t)a + value + (uint16_t)(status & FLAG_CARRY);

        carrycalc(result);
        zerocalc(result);
        overflowcalc(result, a, value);
        signcalc(result);
    #ifndef NES_CPU
    }
    #endif

    saveaccum(result);
}

static void sec() {
    setcarry();
}

static void sed() {
    setdecimal();
}

static void sei() {
    setinterrupt();
}

static void sta() {
    putvalue(a);
}

static void stx() {
    putvalue(x);
}

static void sty() {
    putvalue(y);
}

static void tax() {
    x = a;

    zerocalc(x);
    signcalc(x);
}

static void tay() {
    y = a;

    zerocalc(y);
    signcalc(y);
}

static void tsx() {
    x = sp;

    zerocalc(x);
    signcalc(x);
}

static void txa() {
    a = x;

    zerocalc(a);
    signcalc(a);
}

static void txs() {
    sp = x;
}

static void tya() {
    a = y;

    zerocalc(a);
    signcalc(a);
}


// *******************************************************************************************
//
//					Indirect without indexation.  (copied from indy)
//
// *******************************************************************************************

static void ind0() {
    uint16_t eahelp, eahelp2;
    eahelp = (uint16_t)read6502(pc++);
    eahelp2 = (eahelp & 0xFF00) | ((eahelp + 1) & 0x00FF); //zero-page wraparound
    ea = (uint16_t)read6502(eahelp) | ((uint16_t)read6502(eahelp2) << 8);
}


// *******************************************************************************************
//
//						(Absolute,Indexed) address mode for JMP
//
// *******************************************************************************************

static void ainx() { 		// absolute indexed branch
    uint16_t eahelp, eahelp2;
    eahelp = (uint16_t)read6502(pc) | (uint16_t)((uint16_t)read6502(pc+1) << 8);
    eahelp = (eahelp + (uint16_t)x) & 0xFFFF;
#if 0
    eahelp2 = (eahelp & 0xFF00) | ((eahelp + 1) & 0x00FF); //replicate 6502 page-boundary wraparound bug
#else
    eahelp2 = eahelp + 1; // the 65c02 doesn't have the bug
#endif
    ea = (uint16_t)read6502(eahelp) | ((uint16_t)read6502(eahelp2) << 8);
    pc += 2;
}

// *******************************************************************************************
//
//								Store zero to memory.
//
// *******************************************************************************************

static void stz() {
    putvalue(0);
}

// *******************************************************************************************
//
//								Unconditional Branch
//
// *******************************************************************************************

static void bra() {
    oldpc = pc;
    pc += reladdr;
    if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502++; //check if jump crossed a page boundary
}

// *******************************************************************************************
//
//									Push/Pull X and Y
//
// *******************************************************************************************

static void phx() {
    push8(x);
}

static void plx() {
    x = pull8();
   
    zerocalc(x);
    signcalc(x);
}

static void phy() {
    push8(y);
}

static void ply() {
    y = pull8();
  
    zerocalc(y);
    signcalc(y);
}

// *******************************************************************************************
//
//								TRB & TSB - Test and Change bits 
//
// *******************************************************************************************

static void tsb() {
    value = getvalue(); 							// Read memory
    result = (uint16_t)a & value;  					// calculate A & memory
    zerocalc(result); 								// Set Z flag from this.
    result = value | a; 							// Write back value read, A bits are set.
    putvalue(result);
}

static void trb() {
    value = getvalue(); 							// Read memory
    result = (uint16_t)a & value;  					// calculate A & memory
    zerocalc(result); 								// Set Z flag from this.
    result = value & (a ^ 0xFF); 					// Write back value read, A bits are clear.
    putvalue(result);
}

// *******************************************************************************************
//
//                                   Stop (Invoke Debugger)
//
// *******************************************************************************************

static void stp() {
    stop6502(pc - 1);
}

// *******************************************************************************************
//
//                                     Wait for interrupt
//
// *******************************************************************************************

static void wai() {
	waiting = 1;
}

// *******************************************************************************************
//
//                                     BBR and BBS
//
// *******************************************************************************************
static void bbr(uint16_t bitmask)
{
	if ((getvalue() & bitmask) == 0) {
		oldpc = pc;
		pc += reladdr;
		if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
		else clockticks6502++;
	}
}

static void bbr0() { bbr(0x01); }
static void bbr1() { bbr(0x02); }
static void bbr2() { bbr(0x04); }
static void bbr3() { bbr(0x08); }
static void bbr4() { bbr(0x10); }
static void bbr5() { bbr(0x20); }
static void bbr6() { bbr(0x40); }
static void bbr7() { bbr(0x80); }

static void bbs(uint16_t bitmask)
{
	if ((getvalue() & bitmask) != 0) {
		oldpc = pc;
		pc += reladdr;
		if ((oldpc & 0xFF00) != (pc & 0xFF00)) clockticks6502 += 2; //check if jump crossed a page boundary
		else clockticks6502++;
	}
}

static void bbs0() { bbs(0x01); }
static void bbs1() { bbs(0x02); }
static void bbs2() { bbs(0x04); }
static void bbs3() { bbs(0x08); }
static void bbs4() { bbs(0x10); }
static void bbs5() { bbs(0x20); }
static void bbs6() { bbs(0x40); }
static void bbs7() { bbs(0x80); }

// *******************************************************************************************
//
//                                     SMB and RMB
//
// *******************************************************************************************

static void smb0() { putvalue(getvalue() | 0x01); }
static void smb1() { putvalue(getvalue() | 0x02); }
static void smb2() { putvalue(getvalue() | 0x04); }
static void smb3() { putvalue(getvalue() | 0x08); }
static void smb4() { putvalue(getvalue() | 0x10); }
static void smb5() { putvalue(getvalue() | 0x20); }
static void smb6() { putvalue(getvalue() | 0x40); }
static void smb7() { putvalue(getvalue() | 0x80); }

static void rmb0() { putvalue(getvalue() & ~0x01); }
static void rmb1() { putvalue(getvalue() & ~0x02); }
static void rmb2() { putvalue(getvalue() & ~0x04); }
static void rmb3() { putvalue(getvalue() & ~0x08); }
static void rmb4() { putvalue(getvalue() & ~0x10); }
static void rmb5() { putvalue(getvalue() & ~0x20); }
static void rmb6() { putvalue(getvalue() & ~0x40); }
static void rmb7() { putvalue(getvalue() & ~0x80); }

/* Generated by buildtables.py */

static void (*addrtable[256])() = {
/*        |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  A  |  B  |  C  |  D  |  E  |  F  |     */
/* 0 */     imp, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  acc,  imp, abso, abso, abso,zprel, /* 0 */
/* 1 */     rel, indy, ind0,  imp,   zp,  zpx,  zpx,   zp,  imp, absy,  acc,  imp, abso, absx, absx,zprel, /* 1 */
/* 2 */    abso, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  acc,  imp, abso, abso, abso,zprel, /* 2 */
/* 3 */     rel, indy, ind0,  imp,  zpx,  zpx,  zpx,   zp,  imp, absy,  acc,  imp, absx, absx, absx,zprel, /* 3 */
/* 4 */     imp, indx,  imp,  imp,  imp,   zp,   zp,   zp,  imp,  imm,  acc,  imp, abso, abso, abso,zprel, /* 4 */
/* 5 */     rel, indy, ind0,  imp,  imp,  zpx,  zpx,   zp,  imp, absy,  imp,  imp,  imp, absx, absx,zprel, /* 5 */
/* 6 */     imp, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  acc,  imp,  ind, abso, abso,zprel, /* 6 */
/* 7 */     rel, indy, ind0,  imp,  zpx,  zpx,  zpx,   zp,  imp, absy,  imp,  imp, ainx, absx, absx,zprel, /* 7 */
/* 8 */     rel, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  imp,  imp, abso, abso, abso,zprel, /* 8 */
/* 9 */     rel, indy, ind0,  imp,  zpx,  zpx,  zpy,   zp,  imp, absy,  imp,  imp, abso, absx, absx,zprel, /* 9 */
/* A */     imm, indx,  imm,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  imp,  imp, abso, abso, abso,zprel, /* A */
/* B */     rel, indy, ind0,  imp,  zpx,  zpx,  zpy,   zp,  imp, absy,  imp,  imp, absx, absx, absy,zprel, /* B */
/* C */     imm, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  imp,  imp, abso, abso, abso,zprel, /* C */
/* D */     rel, indy, ind0,  imp,  imp,  zpx,  zpx,   zp,  imp, absy,  imp,  imp,  imp, absx, absx,zprel, /* D */
/* E */     imm, indx,  imp,  imp,   zp,   zp,   zp,   zp,  imp,  imm,  imp,  imp, abso, abso, abso,zprel, /* E */
/* F */     rel, indy, ind0,  imp,  imp,  zpx,  zpx,   zp,  imp, absy,  imp,  imp,  imp, absx, absx,zprel  /* F */
};

static void (*optable[256])() = {
/*        |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  A  |  B  |  C  |  D  |  E  |  F  |     */
/* 0 */      brk,  ora,  nop,  nop,  tsb,  ora,  asl, rmb0,  php,  ora,  asl,  nop,  tsb,  ora,  asl, bbr0, /* 0 */
/* 1 */      bpl,  ora,  ora,  nop,  trb,  ora,  asl, rmb1,  clc,  ora,  inc,  nop,  trb,  ora,  asl, bbr1, /* 1 */
/* 2 */      jsr,  and,  nop,  nop,  bit,  and,  rol, rmb2,  plp,  and,  rol,  nop,  bit,  and,  rol, bbr2, /* 2 */
/* 3 */      bmi,  and,  and,  nop,  bit,  and,  rol, rmb3,  sec,  and,  dec,  nop,  bit,  and,  rol, bbr3, /* 3 */
/* 4 */      rti,  eor,  nop,  nop,  nop,  eor,  lsr, rmb4,  pha,  eor,  lsr,  nop,  jmp,  eor,  lsr, bbr4, /* 4 */
/* 5 */      bvc,  eor,  eor,  nop,  nop,  eor,  lsr, rmb5,  cli,  eor,  phy,  nop,  nop,  eor,  lsr, bbr5, /* 5 */
/* 6 */      rts,  adc,  nop,  nop,  stz,  adc,  ror, rmb6,  pla,  adc,  ror,  nop,  jmp,  adc,  ror, bbr6, /* 6 */
/* 7 */      bvs,  adc,  adc,  nop,  stz,  adc,  ror, rmb7,  sei,  adc,  ply,  nop,  jmp,  adc,  ror, bbr7, /* 7 */
/* 8 */      bra,  sta,  nop,  nop,  sty,  sta,  stx, smb0,  dey,  bit,  txa,  nop,  sty,  sta,  stx, bbs0, /* 8 */
/* 9 */      bcc,  sta,  sta,  nop,  sty,  sta,  stx, smb1,  tya,  sta,  txs,  nop,  stz,  sta,  stz, bbs1, /* 9 */
/* A */      ldy,  lda,  ldx,  nop,  ldy,  lda,  ldx, smb2,  tay,  lda,  tax,  nop,  ldy,  lda,  ldx, bbs2, /* A */
/* B */      bcs,  lda,  lda,  nop,  ldy,  lda,  ldx, smb3,  clv,  lda,  tsx,  nop,  ldy,  lda,  ldx, bbs3, /* B */
/* C */      cpy,  cmp,  nop,  nop,  cpy,  cmp,  dec, smb4,  iny,  cmp,  dex,  wai,  cpy,  cmp,  dec, bbs4, /* C */
/* D */      bne,  cmp,  cmp,  nop,  nop,  cmp,  dec, smb5,  cld,  cmp,  phx,  stp,  nop,  cmp,  dec, bbs5, /* D */
/* E */      cpx,  sbc,  nop,  nop,  cpx,  sbc,  inc, smb6,  inx,  sbc,  nop,  nop,  cpx,  sbc,  inc, bbs6, /* E */
/* F */      beq,  sbc,  sbc,  nop,  nop,  sbc,  inc, smb7,  sed,  sbc,  plx,  nop,  nop,  sbc,  inc, bbs7  /* F */
};

static const uint32_t ticktable[256] = {
/*        |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  A  |  B  |  C  |  D  |  E  |  F  |     */
/* 0 */       7,    6,    2,    2,    5,    3,    5,    5,    3,    2,    2,    2,    6,    4,    6,    5, /* 0 */
/* 1 */       2,    5,    5,    2,    5,    4,    6,    5,    2,    4,    2,    2,    6,    4,    7,    5, /* 1 */
/* 2 */       6,    6,    2,    2,    3,    3,    5,    5,    4,    2,    2,    2,    4,    4,    6,    5, /* 2 */
/* 3 */       2,    5,    5,    2,    4,    4,    6,    5,    2,    4,    2,    2,    4,    4,    7,    5, /* 3 */
/* 4 */       6,    6,    2,    2,    2,    3,    5,    5,    3,    2,    2,    2,    3,    4,    6,    5, /* 4 */
/* 5 */       2,    5,    5,    2,    2,    4,    6,    5,    2,    4,    3,    2,    2,    4,    7,    5, /* 5 */
/* 6 */       6,    6,    2,    2,    3,    3,    5,    5,    4,    2,    2,    2,    5,    4,    6,    5, /* 6 */
/* 7 */       2,    5,    5,    2,    4,    4,    6,    5,    2,    4,    4,    2,    6,    4,    7,    5, /* 7 */
/* 8 */       3,    6,    2,    2,    3,    3,    3,    5,    2,    2,    2,    2,    4,    4,    4,    5, /* 8 */
/* 9 */       2,    6,    5,    2,    4,    4,    4,    5,    2,    5,    2,    2,    4,    5,    5,    5, /* 9 */
/* A */       2,    6,    2,    2,    3,    3,    3,    5,    2,    2,    2,    2,    4,    4,    4,    5, /* A */
/* B */       2,    5,    5,    2,    4,    4,    4,    5,    2,    4,    2,    2,    4,    4,    4,    5, /* B */
/* C */       2,    6,    2,    2,    3,    3,    5,    5,    2,    2,    2,    3,    4,    4,    6,    5, /* C */
/* D */       2,    5,    5,    2,    2,    4,    6,    5,    2,    4,    3,    1,    2,    4,    7,    5, /* D */
/* E */       2,    6,    2,    2,    3,    3,    5,    5,    2,    2,    2,    2,    4,    4,    6,    5, /* E */
/* F */       2,    5,    5,    2,    2,    4,    6,    5,    2,    4,    4,    2,    2,    4,    7,    5  /* F */
};


void nmi6502() {
    push16(pc);
    push8(status & ~FLAG_BREAK);
    setinterrupt();
    cleardecimal();
    pc = (uint16_t)read6502(0xFFFA) | ((uint16_t)read6502(0xFFFB) << 8);
    waiting = 0;
}

void irq6502() {
    if (!(status & FLAG_INTERRUPT)) {
        push16(pc);
        push8(status & ~FLAG_BREAK);
        setinterrupt();
        cleardecimal();
        pc = (uint16_t)read6502(0xFFFE) | ((uint16_t)read6502(0xFFFF) << 8);
    }
    waiting = 0;
}

uint8_t callexternal = 0;
void (*loopexternal)();

void exec6502(uint32_t tickcount) {
	if (waiting) {
		clockticks6502 += tickcount;
		clockgoal6502 = clockticks6502;
		return;
    }

    clockgoal6502 += tickcount;
   
    while (clockticks6502 < clockgoal6502) {
        opcode = read6502(pc++);
        status |= FLAG_CONSTANT;

        penaltyop = 0;
        penaltyaddr = 0;

        (*addrtable[opcode])();
        (*optable[opcode])();
        clockticks6502 += ticktable[opcode];
        if (penaltyop && penaltyaddr) clockticks6502++;

        instructions++;

        if (callexternal) (*loopexternal)();
    }
}

void step6502() {
	if (waiting) {
		++clockticks6502;
		clockgoal6502 = clockticks6502;
		return;
	}

    opcode = read6502(pc++);
    status |= FLAG_CONSTANT;

    penaltyop = 0;
    penaltyaddr = 0;

    (*addrtable[opcode])();
    (*optable[opcode])();
    clockticks6502 += ticktable[opcode];
    if (penaltyop && penaltyaddr) clockticks6502++;
    clockgoal6502 = clockticks6502;

    instructions++;

    if (callexternal) (*loopexternal)();
}

void hookexternal(void *funcptr) {
    if (funcptr != (void *)NULL) {
        loopexternal = funcptr;
        callexternal = 1;
    } else callexternal = 0;
}

//  Fixes from http://6502.org/tutorials/65c02opcodes.html
//
//  65C02 Cycle Count differences.
//        ADC/SBC work differently in decimal mode.
//        The wraparound fixes may not be required.
