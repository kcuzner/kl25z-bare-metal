/**
 * KL25 FRDM HID
 *
 * Kevin Cuzner
 */

#include "MKL25Z4.h"

volatile uint32_t x = 0;

int main(void)
{
    SIM->SCGC5 = SIM_SCGC5_PORTE_MASK | SIM_SCGC5_PORTD_MASK |
        SIM_SCGC5_PORTC_MASK | SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTA_MASK;

    PORTB->PCR[18] = PORT_PCR_MUX(1);
    PORTB->PCR[19] = PORT_PCR_MUX(1);
    FGPIOB->PDDR = 1 << 18 | 1 << 19;

    while(1)
    {
        FGPIOB->PTOR = 1 << 18 | 1 << 19;
        for (uint32_t i = 0; i < 0xFFFF; i++) { } 
    }

    return 0;
}

