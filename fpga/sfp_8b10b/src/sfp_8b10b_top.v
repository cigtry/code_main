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
// Last modified Date:     2024/09/20 14:11:33 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/09/20 14:11:33 
// Version:                V1.0 
// TEXT NAME:              sfp_8b10b_top.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\sfp_8b10b\src\sfp_8b10b_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module sfp_8b10b_top(
  //光口接口
  input                                          q0_ck1_n_in     ,//差分参考时钟
  input                                          q0_ck1_p_in     ,
  input          [  01:00]                       rxn_in          ,//差分接收数据
  input          [  01:00]                       rxp_in          ,
  output         [  01:00]                       txn_out         ,//差分发送数据
  output         [  01:00]                       txp_out         ,
  output         [  01:00]                       tx_disable      ,//tx端发送禁止使能
  //用户接口
  input                                          drp_clk         ,//光口输入时钟
  input                                          clk_in          ,//数据输入时钟
  input                                          rst_n           ,//输入复位信号
  input                                          vs_in           ,//输入场信号
  input                                          data_valid_in   ,//输入数据有效信号
  input          [  15:00]                       data_in         ,//输入数据

  output                                         vs_out          ,//输出场信号
  output                                         data_valid_out  ,//输出数据有效信号
  output         [  15:00]                       data_out         //输出数据
);
//parameter define
  localparam                                         VS_POSE_DATA1  = 32'h55a101bc;
  localparam                                         VS_POSE_DATA2  = 32'h55a102bc;
  localparam                                         DATA_START1    = 32'h55a105bc;
  localparam                                         DATA_START2    = 32'h55a106bc;
  localparam                                         DATA_END1      = 32'h55a107bc;
  localparam                                         DATA_END2      = 32'h55a108bc;
  localparam                                         UNUSE_DATA     = 32'h55a109bc;
//reg define

//wire define	
  wire                                           tx0_user_clk    ;
  wire                                           tx0_rst_n       ;
  wire           [  03:00]                       tx0_gt_charisk  ;
  wire           [  31:00]                       tx0_gt_txdata   ;
  wire                                           rx1_user_clk    ;
  wire                                           rx1_rst_n       ;
  wire           [   3: 0]                       rx1_gt_rx_charisk  ;
  wire           [  31:00]                       rx1_gt_rx_data  ;
  wire           [   3: 0]                       rx1_rx_charisk_align  ;
  wire           [  31:00]                       rx1_rx_data_align  ;
//*********************************************************************************************
//**                    main code
//**********************************************************************************************

//光口编码模块


sfp_encoder#(
  .VS_POSE_DATA1                                     (VS_POSE_DATA1  ),
  .VS_POSE_DATA2                                     (VS_POSE_DATA2  ),
  .DATA_START1                                       (DATA_START1    ),
  .DATA_START2                                       (DATA_START2    ),
  .DATA_END1                                         (DATA_END1      ),
  .DATA_END2                                         (DATA_END2      ),
  .UNUSE_DATA                                        (UNUSE_DATA     ) 
)
 u_sfp_encoder(
  .clk_in                                            (clk_in         ),
  .rst_n                                             (rst_n          ),
  .vs_in                                             (vs_in          ),
  .data_valid_in                                     (data_valid_in  ),
  .data_in                                           (data_in        ),
  .tx_clk                                            (tx0_user_clk   ),
  .tx_rst_n                                          (tx0_rst_n      ),
  .gt_txcharisk                                      (tx0_gt_charisk ),
  .gt_txdata                                         (tx0_gt_txdata  ) 
);

//光口字对齐模块


sfp_data_align u_sfp_data_align(
  .clk                                               (rx1_user_clk   ),
  .rst_n                                             (rx1_rst_n      ),
  .rx_data_in                                        (rx1_gt_rx_data ),
  .rx_charisk_in                                     (rx1_gt_rx_charisk),
  .rx_data_out                                       (rx1_rx_data_align),
  .rx_charisk_out                                    (rx1_rx_charisk_align) 
);


//光口解码模块
sfp_decode#(
  .VS_POSE_DATA1                                     (VS_POSE_DATA1  ),
  .VS_POSE_DATA2                                     (VS_POSE_DATA2  ),
  .DATA_START1                                       (DATA_START1    ),
  .DATA_START2                                       (DATA_START2    ),
  .DATA_END1                                         (DATA_END1      ),
  .DATA_END2                                         (DATA_END2      ),
  .UNUSE_DATA                                        (UNUSE_DATA     ) 
)
 u_sfp_decode(
  .clk_in                                            (clk_in         ),
  .rst_n                                             (rst_n          ),
  .rx_clk                                            (rx1_user_clk   ),
  .rx_rst_n                                          (rx1_rst_n      ),
  .rx_data_align                                     (rx1_rx_data_align),
  .rx_charisk_align                                  (rx1_rx_charisk_align),
  .vs_out                                            (vs_out         ),
  .data_out                                          (data_out       ),
  .data_valid_out                                    (data_valid_out ) 
);



aurora_8b10b_exdes u_aurora_8b10b_exdes(
  .Q0_CLK1_GTREFCLK_PAD_N_IN                         (q0_ck1_n_in    ),
  .Q0_CLK1_GTREFCLK_PAD_P_IN                         (q0_ck1_p_in    ),
  .RXN_IN                                            (rxn_in         ),
  .RXP_IN                                            (rxp_in         ),
  .TXN_OUT                                           (txn_out        ),
  .TXP_OUT                                           (txp_out        ),
  .drp_clk                                           (drp_clk        ),
  .tx_disable                                        (tx_disable     ),
  .rx0_user_clk                                      (               ),
  .rx0_rst_n                                         (               ),
  .tx0_user_clk                                      (tx0_user_clk   ),
  .tx0_rst_n                                         (tx0_rst_n      ),
  .rx0_gt_rxdata                                     (               ),
  .rx0_gt_rxcharisk                                  (               ),
  .tx0_gt_txdata                                     (tx0_gt_txdata  ),
  .tx0_gt_txcharisk                                  (tx0_gt_charisk ),
  .rx1_user_clk                                      (rx1_user_clk   ),
  .rx1_rst_n                                         (rx1_rst_n      ),
  .tx1_user_clk                                      (               ),
  .tx1_rst_n                                         (               ),
  .rx1_gt_rxdata                                     (rx1_gt_rx_data  ),
  .rx1_gt_rxcharisk                                  (rx1_gt_rx_charisk),
  .tx1_gt_txdata                                     (32'd0          ),
  .tx1_gt_txcharisk                                  (4'd0           ) 
);

                                                                   
endmodule
