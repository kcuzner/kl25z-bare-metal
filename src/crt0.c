/**
 * Initial runtime for Cortex M0+
 *
 * Kevin Cuzner
 */

#include <stdint.h>
#include "MKL25Z4.h"

int main(void);

extern uint32_t *__DATA_ROM;
extern uint32_t *__DATA_RAM;
extern uint32_t *__DATA_END;

void startup(void)
{
    uint32_t *from = __DATA_ROM;
    uint32_t *to = __DATA_RAM;

    SIM->COPC = 0;

    //volatile uint32_t test = *from;

    /**
     * Load the RAM from the stored data in the flash
     */
    /*while (from < __DATA_END)
    {
        *to++ = *from++;
    }*/
}

