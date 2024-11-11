/*
 * uart.h
 *
 *  Created on: 2024年7月11日
 *      Author: maccura
 */

#ifndef UART_H_
#define UART_H_
#include "alt_types.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"

#define u8 alt_u8
#define u16 alt_u16
#define u32 alt_u32

#define USART_REC_LEN  			200  	//定义最大接收字节数 200

extern u8  USART_RX_BUF[USART_REC_LEN]; //接收缓冲,最大USART_REC_LEN个字节.末字节为换行符
extern u16 USART_RX_STA;         		//接收状态标记

void uart_init(void);
void uart_irq_handler(void);


#endif /* UART_H_ */
