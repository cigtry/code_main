
#ifndef MOTOR_H_
#define MOTOR_H_
#include "alt_types.h"
#include "system.h"
#include <sys/unistd.h>
#include <io.h>
#include <stdio.h>
 struct motor_init{
      alt_u32  acc;
	  alt_u16  start_speed;
	  alt_u32  max_speed;
	  alt_u32  offset_speed;
	  alt_u32  target_speed;
	  alt_u32  position_set;
	  alt_u16  zero_position;
	  alt_u16  liquid_position;
	  alt_u32 abs_set_position;
	  alt_u8  set_dir;
	  alt_u8  opt_level;
	  alt_u8  coe_enable;
	  alt_u8  move_mode;
};

#define  		 move_mode_reg               0
#define          acc_reg                     1
#define          start_speed_reg             2
#define          max_speed_reg               3
#define          offset_speed_reg            4
#define          target_speed_reg            5
#define          position_set_reg            6
#define          zero_position_reg           7
#define          liquid_position_reg         8
#define          abs_set_position_reg        9
#define          abs_position_set_flag_reg   10
#define          opt_level_reg               11
#define          coe_enable_reg              12
#define          set_dir_reg                 13
#define          start_reg                   14
#define          stop_reg                    15
#define          dec_reg                    16
#define motor_wr(reg,data) 	IOWR(MOTOR_CTRL_0_BASE, reg, data)
#define motor_rd(reg) 	    IORD(MOTOR_CTRL_0_BASE, reg)
#define tmc_wr(reg,data) 	IOWR(TMC_CTRL_0_BASE, reg, data)
#define encoder_wr(reg,data) 	IOWR(ENCODER_0_BASE, reg, data)
void motor_init(void);
void motor_start();
void motor_stop();
void motor_dec();
void  motor_reset( );					//电机上电复位
void  motor_normal_reset( );				//电机正常复位
void  motor_step_forward(alt_u32 acc ,alt_u32 speed ,alt_u32 step);			//电机正向运动，（加速度，最大速度，脉冲数）
void  motor_step_backward(alt_u32 acc ,alt_u32 speed ,alt_u32 step);		//电机反向运动，（加速度，最大速度，脉冲数）
void  motor_speed_forward(alt_u32 acc ,alt_u32 speed);			//电机正向速度模式 ，（加速度，最大速度）
void  motor_speed_backward(alt_u32 acc ,alt_u32 speed);			//电机反向速度模式 ，（加速度，最大速度）
void  motor_speed_forward_limit(alt_u32 acc ,alt_u32 speed ,alt_u32 step);		//电机限制正向速度模式 ，（加速度，最大速度，脉冲数）
void  motor_speed_backward_limit(alt_u32 acc ,alt_u32 speed ,alt_u32 step);		//电机反向速度模式 ，（加速度，最大速度，脉冲数）
void  tmc_init();
void  tmc_data_send(alt_u8 addr , alt_u32 data);
#endif /* MOTOR_H_ */
