#include "../inc/motor.h"

struct motor_init  pmotor = {
		  .acc              =   100000,
		  .start_speed      =   1000,
		  .max_speed        =   65535,
		  .offset_speed     =   1000,
		  .target_speed     =   65535,
		  .position_set     =   60000,
		  .zero_position    =   50,
		  .liquid_position  =   0,
		  .abs_set_position =   0,
		  .set_dir           =   0,
		  .opt_level         =   0,
		  .coe_enable        =   0,
		  .move_mode         =   0,
};

void motor_init(void)
{


	motor_wr(move_mode_reg, pmotor.move_mode);
	usleep(100);
	motor_wr(acc_reg, pmotor.acc);
	usleep(100);
	motor_wr(start_speed_reg, pmotor.start_speed);
	usleep(100);
	motor_wr(max_speed_reg, pmotor.max_speed);
	usleep(100);
	motor_wr(offset_speed_reg, pmotor.offset_speed);
	usleep(100);
	motor_wr(target_speed_reg, pmotor.target_speed);
	usleep(100);
	motor_wr(position_set_reg, pmotor.position_set);
	usleep(100);
	motor_wr(zero_position_reg, pmotor.zero_position);
	usleep(100);
	motor_wr(liquid_position_reg, pmotor.liquid_position);
	usleep(100);
	motor_wr(abs_set_position_reg, pmotor.abs_set_position);
	usleep(100);
	motor_wr(opt_level_reg, pmotor.opt_level);
	usleep(100);
	motor_wr(coe_enable_reg, pmotor.coe_enable);
	usleep(100);
	motor_wr(set_dir_reg, pmotor.set_dir);
	usleep(100);
	tmc_init();
}

void motor_start()
{
	encoder_wr(0,0x00);
	encoder_wr(0,0x01);
	encoder_wr(0,0x00);
	motor_wr(start_reg,0x0000);
	motor_rd(0);
	motor_wr(start_reg,0x0001);
	motor_rd(0);
	motor_wr(start_reg,0x0000);
}

void motor_stop()
{
	motor_wr(stop_reg,0x0000);
	motor_rd(0);
	motor_wr(stop_reg,0x0001);
	motor_rd(0);
	motor_wr(stop_reg,0x0000);
}

void motor_dec()
{
	motor_wr(dec_reg,0x0000);
	motor_rd(0);
	motor_wr(dec_reg,0x0001);
	motor_rd(0);
	motor_wr(dec_reg,0x0000);
}

void  motor_reset( ){
	motor_wr(move_mode_reg , 0x00);
	usleep(100);
	motor_start();
}

motor_normal_reset( ){
	alt_u32 abs_position_return;
	abs_position_return = motor_rd(0x0b);
	motor_wr(position_set_reg , abs_position_return);
	motor_wr(move_mode_reg , 0x01);
	usleep(100);
	motor_start();
}

void  motor_step_forward(alt_u32 acc ,alt_u32 speed ,alt_u32 step){
	motor_wr(position_set_reg , step);
	usleep(100);
	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x02);
    usleep(100);
	motor_start();
}

void  motor_step_backward(alt_u32 acc ,alt_u32 speed ,alt_u32 step)
{
	motor_wr(position_set_reg , step);
	usleep(100);
	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x03);
    usleep(100);
	motor_start();
}

void  motor_speed_forward(alt_u32 acc ,alt_u32 speed)
{

	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x04);
    usleep(100);
	motor_start();
}
void  motor_speed_backward(alt_u32 acc ,alt_u32 speed)
{
	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x05);
    usleep(100);
	motor_start();
}
void  motor_speed_forward_limit(alt_u32 acc ,alt_u32 speed ,alt_u32 step)
{
	motor_wr(position_set_reg , step);
	usleep(100);
	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x06);
    usleep(100);
	motor_start();
}
void  motor_speed_backward_limit(alt_u32 acc ,alt_u32 speed ,alt_u32 step)
{
	motor_wr(position_set_reg , step);
	usleep(100);
	motor_wr(acc_reg , acc);
	usleep(100);
	motor_wr(max_speed_reg , speed);
	usleep(100);
	motor_wr(move_mode_reg , 0x07);
    usleep(100);
	motor_start();
}
void  tmc_data_send(alt_u8 addr , alt_u32 data)
{
	tmc_wr(0x00,addr);
	usleep(100);
	tmc_wr(0x01,data);
	usleep(100);
	tmc_wr(0x02,0x00);
	tmc_wr(0x02,0x01);
	tmc_wr(0x02,0x00);

}

void  tmc_init()
{
	tmc_data_send(0xec , 0x040100c3);
	usleep(1000);
	tmc_data_send(0x90 , 0x00061a03);
	usleep(1000);
	tmc_data_send(0x91 , 0x0000000a);
	usleep(1000);
	tmc_data_send(0x80 , 0x0000006a);
	usleep(1000);
	tmc_data_send(0x93 , 0x000001f4);
	usleep(1000);
	tmc_data_send(0x8a , 0x00000030);
	usleep(1000);
	tmc_data_send(0x89 , 0x00010608);
	usleep(1000);
}
