#include "../inc/usmart.h"
#include "../inc/usmart_str.h"
#include "../inc/motor.h"
#include "alt_types.h"
////////////////////////////�û�������///////////////////////////////////////////////
//������Ҫ�������õ��ĺ�����������ͷ�ļ�(�û��Լ����)
												 
//�������б��ʼ��(�û��Լ����)
//�û�ֱ������������Ҫִ�еĺ�����������Ҵ�
struct _m_usmart_nametab usmart_nametab[]=
{
#if USMART_USE_WRFUNS==1 	//���ʹ���˶�д����
	(void*)read_addr,"u32 read_addr(u32 addr)",
	(void*)write_addr,"void write_addr(u32 addr,u32 val)",
	(void*)motor_stop,"void motor_stop( )",
	(void*)motor_reset,"void motor_reset( )",					//����ϵ縴λ
	(void*)motor_normal_reset,"void motor_normal_reset( )",				//���������λ
	(void*)motor_step_forward,"void  motor_step_forward(alt_u32 acc ,alt_u32 speed ,alt_u32 step)",			//��������˶��������ٶȣ�����ٶȣ���������
	(void*)motor_step_backward,"motor_step_backward(alt_u32 acc ,alt_u32 speed ,alt_u32 step)",		//��������˶��������ٶȣ�����ٶȣ���������
	(void*)motor_speed_forward,"void motor_speed_forward(alt_u32 acc ,alt_u32 speed)",			//��������ٶ�ģʽ �������ٶȣ�����ٶȣ�
	(void*)motor_speed_backward,"void motor_speed_backward(alt_u32 acc ,alt_u32 speed)",			//��������ٶ�ģʽ �������ٶȣ�����ٶȣ�
	(void*)motor_speed_forward_limit,"motor_speed_forward_limit(alt_u32 acc ,alt_u32 speed ,alt_u32 step)",		//������������ٶ�ģʽ �������ٶȣ�����ٶȣ���������
	(void*)motor_speed_backward_limit,"void motor_reset( )",		//��������ٶ�ģʽ �������ٶȣ�����ٶȣ���������
	(void*)motor_init,"void motor_init( )",
#endif		   

};						  
///////////////////////////////////END///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//�������ƹ�������ʼ��
//�õ������ܿغ���������
//�õ�����������
struct _m_usmart_dev usmart_dev=
{
	usmart_nametab,
	usmart_init,
	usmart_cmd_rec,
	usmart_exe,
	usmart_scan,
	sizeof(usmart_nametab)/sizeof(struct _m_usmart_nametab),//��������
	0,	  	//��������
	0,	 	//����ID
	1,		//������ʾ����,0,10����;1,16����
	0,		//��������.bitx:,0,����;1,�ַ���
	0,	  	//ÿ�������ĳ����ݴ��,��ҪMAX_PARM��0��ʼ��
	0,		//�����Ĳ���,��ҪPARM_LEN��0��ʼ��
};   



















