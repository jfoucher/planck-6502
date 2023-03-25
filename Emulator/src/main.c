#include <stdio.h>
#include <stdint.h>
#include <termios.h>            //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
void *emulator_loop(void *param);
void emscripten_main_loop(void);
#endif
int main(int argc, char **argv);
#include "cpu/fake6502.h"


unsigned char ram[0x8000];
unsigned char rom[0x8000];
unsigned char io[0x70];

typedef struct {
    char* slot0[0x10];
    char* slot1[0x10];
    char* slot2[0x10];
    char* slot3[0x10];
    char* slot4[0x10];
    char* slot5[0x10];
    char* slot6[0x10];
} iobus_t;

uint8_t read6502(uint16_t address) {
    
    if (address < 0x8000) {
        // printf("R %0000X : %00X\n", address, ram[address]);
        return ram[address];
    }
    if (address >= 0xFF80 && address < 0xFFF0) {
        return io[address - 0xFF80];
    }
    if (address == 0xf004) {
// #ifdef __EMSCRIPTEN__
//     if (rom[0x7004]) {
//         char c = rom[0x7004];
//         rom[0x7004] = 0;
//         return c;
//     }
// #else
    char c;
    scanf("%c", &c);
    if (c > 0) {
        return c;
    }

    return 0;
    
    // return getchar();
// #endif
    }
    // printf("R %0000X : %00X\n", address, rom[address-0x8000]);
    return rom[address-0x8000];
}

void write6502(uint16_t address, uint8_t val) {
    // printf("W %0000X : %00X\n", address, val);
    if (address < 0x8000) {
        ram[address] = val;
    }
    
    if (address == 0xf001) {
        char str[2];
        str[0]=val;
        str[1]=0;
        printf("%s", str);
    }
}
uint8_t running = 1;
uint8_t do_reset = 0;
void stop6502(uint16_t address) {
    running = 0;
}


void reset_6502(void) {
    reset6502();
}

void run_6502(int cycles) {
    running = 1;
}

void receive_char(int c) {
    printf("%d", c);
    rom[0x7004] = (char) c;
}

void set_rom(uint8_t data[0x8000]) {
    for (int i = 0; i < 0x8000; i++) {
        rom[i] = data[i];
    }
}

void * emulator_loop(void *param)
{
    int n = 0;
    for (;;) {
        if(running) {
            if ((clockticks6502 >> 8) > 0 && (clockticks6502 >> 8) % 2 == 0) {
                //printf("%d %0000X\n", clockticks6502, pc);
            }
            //printf("%d %0000X\n", clockticks6502, pc);
            step6502();
        }
        n++;
#ifdef __EMSCRIPTEN__
        // After completing a frame we yield back control to the browser to stay responsive
        if (n > 1000) {
            return 0;
        }
        
#endif
    }
}

void emscripten_main_loop(void) {
	emulator_loop(NULL);
}



int main(int argc, char **argv) {
#ifndef __EMSCRIPTEN__
    static struct termios oldt, newt;
    tcgetattr( STDIN_FILENO, &oldt);
    /*now the settings will be copied*/
    newt = oldt;

    /*ICANON normally takes care that one line at a time will be processed
    that means it will return if it sees a "\n" or an EOF or an EOL*/
    newt.c_lflag &= ~(ICANON|ECHO);          

    /*Those new settings will be set to STDIN
    TCSANOW tells tcsetattr to change attributes immediately. */
    tcsetattr( STDIN_FILENO, TCSANOW, &newt);
#endif


    
    if (argc > 1) {
        FILE *ptr;

        ptr = fopen(argv[1],"rb");  // r for read, b for binary

        if (!ptr)
        {
            printf("Could not open file. Aborting.\n");
            return -2;
        }

        fread(rom, sizeof(rom), 1, ptr); 

        printf("%00X %00X\n", rom[0x7FFC], rom[0x7FFD]);
    }

    reset6502();

#ifdef __EMSCRIPTEN__
    running = 0;
	emscripten_set_main_loop(emscripten_main_loop, 2400000, 1);
#else
	emulator_loop(NULL);
    tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
#endif



}