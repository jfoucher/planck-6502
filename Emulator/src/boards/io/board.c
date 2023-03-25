
#include "board.h"
#include "via.h"

typedef struct {
    uint8_t leds;
    m6522_t via;
} io_board_t;