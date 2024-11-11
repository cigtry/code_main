`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-1.8.20240408
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2024/06/18 17:13:24 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/18 17:13:24 
// Version:                V1.0 
// TEXT NAME:              motor_ctrl_top.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\motor\motor_ctrl_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module motor_ctrl_top#(
  parameter                                          S_MODE         = 0     ,
  parameter                                          BIT_A          = 19    ,
  parameter                                          BIT_V          = 19    ,
  parameter                                          BIT_S          = 19    ,
  parameter                                          OPT_LONG       = 2000  ,
  parameter                                          QUIT_LONG      = 200   
)(
  input                                          clk             ,
  input                                          rst_n           ,
  //avalon 
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output         [  31:00]                       avs_read_data   ,
  //
  input                                          limit_signal    ,
  //
  output                                         dirction        ,
  output                                         pulse           ,
  output                                         coe_enable       
);

  wire                                           start           ;
  wire                                           stop            ;
  wire                                           dec             ;
  wire           [BIT_A -1:00]                   acc             ;
  wire           [  15:00]                       start_speed     ;
  wire           [BIT_V-1:00]                    max_speed       ;
  wire           [BIT_V-1:00]                    offset_speed    ;
  wire           [BIT_V-1:00]                    target_speed    ;
  wire           [BIT_S-1:00]                    position_set    ;
  wire           [  10:00]                       zero_position   ;
  wire           [  10:00]                       liquid_position  ;
  wire                                           set_dir         ;
  wire           [  04:00]                       move_mode       ;
  wire     signed[  31:00]                       abs_position    ;
  wire     signed[  31:00]                       abs_set_position  ;
  wire                                           abs_position_set_flag  ;
  wire                                           clear_mt_success  ;
  wire                                           mt_success_int  ;
  wire                                           limit_signal_delay  ;
  wire           [  04:00]                       error_data      ;


motor_arbit#(
  .S_MODE                                            (S_MODE         ),
  .BIT_A                                             (BIT_A          ),
  .BIT_V                                             (BIT_V          ),
  .BIT_S                                             (BIT_S          ),
  .OPT_LONG                                          (OPT_LONG       ),
  .QUIT_LONG                                         (QUIT_LONG      ) 
)
 u_motor_arbit(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  //电机基础参数部分      
  .start                                             (start          ),
  .stop                                              (stop           ),
  .dec                                               (dec            ),
  .acc                                               (acc            ),
  .start_speed                                       (start_speed    ),
  .max_speed                                         (max_speed      ),
  .offset_speed                                      (offset_speed   ),
  .target_speed                                      (target_speed   ),
  .position_set                                      (position_set   ),
  .zero_position                                     (zero_position  ),
  .liquid_position                                   (liquid_position),
  .set_dir                                           (set_dir        ),
  //电机运动控制部分      
  .move_mode                                         (move_mode      ),
  .limit_signal                                      (limit_signal   ),
  //电机反馈部分
  .abs_position                                      (abs_position   ),
  .abs_set_position                                  (abs_set_position),
  .abs_position_set_flag                             (abs_position_set_flag),
  .clear_mt_success                                  (clear_mt_success),
  .mt_success_int                                    (mt_success_int ),
  .limit_signal_delay                                (limit_signal_delay),
  .error_data                                        (error_data     ),
  //电机输出部分  
  .dirction                                          (dirction       ),
  .pulse                                             (pulse          ) 
);



motor_reg u_motor_reg(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .avs_address                                       (avs_address    ),
  .avs_write                                         (avs_write      ),
  .avs_write_data                                    (avs_write_data ),
  .avs_read                                          (avs_read       ),
  .avs_read_data                                     (avs_read_data  ),
  //电机基础参数部分      
  .start                                             (start          ),
  .stop                                              (stop           ),
  .dec                                               (dec            ),
  .acc                                               (acc            ),
  .start_speed                                       (start_speed    ),
  .max_speed                                         (max_speed      ),
  .offset_speed                                      (offset_speed   ),
  .target_speed                                      (target_speed   ),
  .position_set                                      (position_set   ),
  .zero_position                                     (zero_position  ),
  .liquid_position                                   (liquid_position),
  .set_dir                                           (set_dir        ),
  .opt_level                                         (opt_level      ),
  .coe_enable                                        (coe_enable     ),
  //电机运动控制部分      
  .move_mode                                         (move_mode      ),
  //电机反馈部分
  .abs_position                                      (abs_position   ),
  .abs_set_position                                  (abs_set_position),
  .abs_position_set_flag                             (abs_position_set_flag),
  .limit_signal_delay                                (limit_signal_delay),
  .error_data                                        (error_data     ) 
);


                                                                 
                                                                   
endmodule
