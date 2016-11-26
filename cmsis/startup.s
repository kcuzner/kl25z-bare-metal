/* Startup code
 * ARM Cortex-M0+
 * With CMSIS naming conventions
 *
 * Does not support ISR table remapping
 *
 * Kevin Cuzner
 */

    .syntax unified
    .thumb


    .section ".isr_vector","a",%progbits
    .global __isr_vector

__isr_vector:
    .long __StackTop
    .long Reset_Handler
    .long NMI_Handler
    .long HardFault_Handler
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long SVC_Handler
    .long 0
    .long 0
    .long PendSV_Handler
    .long SysTick_Handler

    .long DMA0_Handler
    .long DMA1_Handler
    .long DMA2_Handler
    .long DMA3_Handler
    .long 0
    .long FTFA_Handler
    .long LVD_LVW_Handler
    .long LLWU_Handler
    .long I2C0_Handler
    .long I2C1_Handler
    .long SPI0_Handler
    .long SPI1_Handler
    .long UART0_Handler
    .long UART1_Handler
    .long UART2_Handler
    .long ADC0_Handler
    .long CMP0_Handler
    .long TPM0_Handler
    .long TPM1_Handler
    .long TPM2_Handler
    .long RTC_Handler
    .long RTC_Seconds_Handler
    .long PIT_Handler
    .long 0
    .long USB0_Handler
    .long DAC0_Handler
    .long TSI0_Handler
    .long MCG_Handler
    .long LPTMR0_Handler
    .long 0
    .long PORTA_Handler
    .long PORTD_Handler


    .section ".FlashConfig","a",%progbits
__flash_config:
    .long 0xFFFFFFFF
    .long 0xFFFFFFFF
    .long 0xFFFFFFFF
    .long 0xFFFFFFFE

    .thumb

    .section ".text"
    .thumb_func
    .global _startup
    .global Reset_Handler

/**
 * Reset handler
 *
 * Loads .data from flash to RAM using the following linker-defined variables:
 * __DATA_ROM : Beginning of .data stored in flash (source)
 * __DATA_RAM : Beginning of .data in RAM (destination)
 * __DATA_END : End of .data stored in flash
 *
 * Clears .bss using the following linker defined variables:
 * __START_BSS : Beginning of .bss in RAM
 *  __END_BSS : End of .bss in RAM
 */

Reset_Handler:
    ldr r0, =__DATA_ROM
    ldr r1, =__DATA_RAM
    ldr r2, =__DATA_END
data_load_loop:
    cmp r0, r2
    bge data_load_end
    ldmia r0!,{r3}
    stmia r1!,{r3}
    b   data_load_loop
data_load_end:
    ldr r0, =__START_BSS
    ldr r1, =__END_BSS
    eors r2, r2
bss_clear_loop:
    cmp r0, r1
    bge bss_clear_end
    stmia r0!,{r2}
    b   bss_clear_loop
bss_clear_end:
    ldr r0, =SystemInit
    blx r0
    ldr r0, =main
    bx  r0

/**
 * Default handlers
 *
 * Implemented as infinite looping weak references. Perhaps a more debuggable
 * option would be to make them separate? Or load a register with some magic
 * value?
 */

    .weak NMI_Handler
    .weak HardFault_Handler
    .weak SVC_Handler
    .weak PendSV_Handler
    .weak SysTick_Handler

    .weak DMA0_Handler
    .weak DMA1_Handler
    .weak DMA2_Handler
    .weak DMA3_Handler
    .weak FTFA_Handler
    .weak LVD_LVW_Handler
    .weak LLWU_Handler
    .weak I2C0_Handler
    .weak I2C1_Handler
    .weak SPI0_Handler
    .weak SPI1_Handler
    .weak UART0_Handler
    .weak UART1_Handler
    .weak UART2_Handler
    .weak ADC0_Handler
    .weak CMP0_Handler
    .weak TPM0_Handler
    .weak TPM1_Handler
    .weak TPM2_Handler
    .weak RTC_Handler
    .weak RTC_Seconds_Handler
    .weak PIT_Handler
    .weak USB0_Handler
    .weak DAC0_Handler
    .weak TSI0_Handler
    .weak MCG_Handler
    .weak LPTMR0_Handler
    .weak PORTA_Handler
    .weak PORTD_Handler

NMI_Handler:
HardFault_Handler:
SVC_Handler:
PendSV_Handler:
SysTick_Handler:
DMA0_Handler:
DMA1_Handler:
DMA2_Handler:
DMA3_Handler:
FTFA_Handler:
LVD_LVW_Handler:
LLWU_Handler:
I2C0_Handler:
I2C1_Handler:
SPI0_Handler:
SPI1_Handler:
UART0_Handler:
UART1_Handler:
UART2_Handler:
ADC0_Handler:
CMP0_Handler:
TPM0_Handler:
TPM1_Handler:
TPM2_Handler:
RTC_Handler:
RTC_Seconds_Handler:
PIT_Handler:
USB0_Handler:
DAC0_Handler:
TSI0_Handler:
MCG_Handler:
LPTMR0_Handler:
PORTA_Handler:
PORTD_Handler:
    b   .



    .end

