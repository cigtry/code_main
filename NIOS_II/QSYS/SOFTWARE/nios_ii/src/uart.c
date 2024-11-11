/*
 * uart.c

 *
 *  Created on: 2024年7月11日
 *      Author: maccura
 */
#include "../inc/uart.h"

//串口1中断服务程序
//注意,读取USARTx->SR能避免莫名其妙的错误
u8 USART_RX_BUF[USART_REC_LEN];     //接收缓冲,最大USART_REC_LEN个字节.
//接收状态
//bit15，	接收完成标志
//bit14，	接收到0x0d
//bit13~0，	接收到的有效字节数目
u16 USART_RX_STA=0;       //接收状态标记

void uart_init(void){
     char *p;
     alt_ic_isr_register(UART_0_IRQ_INTERRUPT_CONTROLLER_ID,
                         UART_0_IRQ,
						  uart_irq_handler,
                         p,
                         0);

     IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0x0);    //清零状态寄存器
     IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);    //读空接收寄存器中的无用值
     IOWR_ALTERA_AVALON_UART_DIVISOR(UART_0_BASE, UART_0_FREQ/9600 - 1);//设置波特率为115200
     IOWR_ALTERA_AVALON_UART_CONTROL(UART_0_BASE, 0x80);    //使能接收中断
 }

void uart_irq_handler(void){
	u8 res;
	u16 status;
	status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	if(status & ALTERA_AVALON_UART_STATUS_RRDY_MSK){
		res = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		if((USART_RX_STA&0x8000)==0)//接收未完成
				{
					if(USART_RX_STA&0x4000)//接收到了0x0d
					{
						if(res!=0x0a)USART_RX_STA=0;//接收错误,重新开始
						else USART_RX_STA|=0x8000;	//接收完成了
					}else //还没收到0X0D
					{
						if(res==0x0d)USART_RX_STA|=0x4000;
						else
						{
							USART_RX_BUF[USART_RX_STA&0X3FFF]=res;
							USART_RX_STA++;
							if(USART_RX_STA>(USART_REC_LEN-1))USART_RX_STA=0;//接收数据错误,重新开始接收
						}
					}
				}
			}
}





