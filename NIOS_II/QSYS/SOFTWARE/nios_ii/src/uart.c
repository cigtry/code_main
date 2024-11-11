/*
 * uart.c

 *
 *  Created on: 2024��7��11��
 *      Author: maccura
 */
#include "../inc/uart.h"

//����1�жϷ������
//ע��,��ȡUSARTx->SR�ܱ���Ī������Ĵ���
u8 USART_RX_BUF[USART_REC_LEN];     //���ջ���,���USART_REC_LEN���ֽ�.
//����״̬
//bit15��	������ɱ�־
//bit14��	���յ�0x0d
//bit13~0��	���յ�����Ч�ֽ���Ŀ
u16 USART_RX_STA=0;       //����״̬���

void uart_init(void){
     char *p;
     alt_ic_isr_register(UART_0_IRQ_INTERRUPT_CONTROLLER_ID,
                         UART_0_IRQ,
						  uart_irq_handler,
                         p,
                         0);

     IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0x0);    //����״̬�Ĵ���
     IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);    //���ս��ռĴ����е�����ֵ
     IOWR_ALTERA_AVALON_UART_DIVISOR(UART_0_BASE, UART_0_FREQ/9600 - 1);//���ò�����Ϊ115200
     IOWR_ALTERA_AVALON_UART_CONTROL(UART_0_BASE, 0x80);    //ʹ�ܽ����ж�
 }

void uart_irq_handler(void){
	u8 res;
	u16 status;
	status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	if(status & ALTERA_AVALON_UART_STATUS_RRDY_MSK){
		res = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		if((USART_RX_STA&0x8000)==0)//����δ���
				{
					if(USART_RX_STA&0x4000)//���յ���0x0d
					{
						if(res!=0x0a)USART_RX_STA=0;//���մ���,���¿�ʼ
						else USART_RX_STA|=0x8000;	//���������
					}else //��û�յ�0X0D
					{
						if(res==0x0d)USART_RX_STA|=0x4000;
						else
						{
							USART_RX_BUF[USART_RX_STA&0X3FFF]=res;
							USART_RX_STA++;
							if(USART_RX_STA>(USART_REC_LEN-1))USART_RX_STA=0;//�������ݴ���,���¿�ʼ����
						}
					}
				}
			}
}





