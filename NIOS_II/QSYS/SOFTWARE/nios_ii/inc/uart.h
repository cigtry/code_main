/*
 * uart.h
 *
 *  Created on: 2024��7��11��
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

#define USART_REC_LEN  			200  	//�����������ֽ��� 200

extern u8  USART_RX_BUF[USART_REC_LEN]; //���ջ���,���USART_REC_LEN���ֽ�.ĩ�ֽ�Ϊ���з�
extern u16 USART_RX_STA;         		//����״̬���

void uart_init(void);
void uart_irq_handler(void);


#endif /* UART_H_ */
