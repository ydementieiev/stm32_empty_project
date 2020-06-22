#include "stm32f30x_gpio.h"
#include "stm32f30x_rcc.h"
#include "stm32f30x.h"
#include "stm32f30x_it.h"
#include "stm32f3_discovery.h"

void Delay()
{
    int i;
    for (i = 0; i < 1000000; i++)
    asm("nop");
}

int main()
{
    GPIO_InitTypeDef GPIO_InitStructure;
    
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOE, ENABLE);
    
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
    
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOE, &GPIO_InitStructure);
    
    for (;;)
    {
        GPIO_WriteBit(GPIOE, GPIO_Pin_9, Bit_SET);
        Delay();
        GPIO_WriteBit(GPIOE, GPIO_Pin_9, Bit_RESET);
        Delay();
    }

    return 0;
}
