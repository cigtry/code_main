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
// Last modified Date:     2024/07/30 15:41:37 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/30 15:41:37 
// Version:                V1.0 
// TEXT NAME:              ddr3_test_top.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_test_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_test_top#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128   , //数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 29      //地址位宽
)(
  input                                            clk             ,
  input                                            rst_n           ,
  output           [  14: 0]                       ddr3_addr       ,
  output           [   2: 0]                       ddr3_ba         ,
  output                                           ddr3_cas_n      ,
  output           [   0: 0]                       ddr3_ck_n       ,
  output           [   0: 0]                       ddr3_ck_p       ,
  output           [   0: 0]                       ddr3_cke        ,
  output                                           ddr3_ras_n       ,
  output                                           ddr3_reset_n    ,
  output                                           ddr3_we_n       ,
  inout            [  15: 0]                       ddr3_dq         ,
  inout            [   1: 0]                       ddr3_dqs_n      ,
  inout            [   1: 0]                       ddr3_dqs_p      ,
  output           [   0: 0]                       ddr3_cs_n       ,
  output           [   1: 0]                       ddr3_dm         ,
  output           [   0: 0]                       ddr3_odt        ,
  
  //
  input                                            uart_rx         ,
  //
  output                                           tmds_clk_p      ,
  output                                           tmds_clk_n      ,
  output           [  02:00]                       tmds_data_p     ,
  output           [  02:00]                       tmds_data_n      

);
  wire                                             init_calib_complete  ;
  wire                                             DDR_CLK         ;
  wire                                             wr_clk          ;
  wire                                             rd_clk          ;
  wire                                             locked          ;

  wire                                             wr_req          ;
  wire             [ADDR_WIDTH - 1 : 0]            wr_address_beign  ;
  wire             [ADDR_WIDTH - 1 : 0]            wr_address_end  ;
  wire             [DATA_IN_WIDTH - 1 : 0]         wr_din          ;
  wire                                             wr_din_vld      ;
  wire                                             rd_req          ;
  wire             [ADDR_WIDTH - 1 : 0]            rd_address_beign  ;
  wire             [ADDR_WIDTH - 1 : 0]            rd_address_end  ;
  wire             [DATA_IN_WIDTH - 1 : 0]         rd_dout         ;
  wire                                             rd_dout_vld     ;



  wire             [   7: 0]                       rx_din          ;
  wire                                             rx_vld          ;

  wire                                             post_img_vsync  ;
  wire                                             post_img_hsync  ;
  wire                                             post_img_valid  ;
  wire             [  23:00]                       post_img_data   ;


  clk_wiz_ddr clk_wiz_ddr
   (
    // Clock out ports
  .DDR_CLK                                           (DDR_CLK        ),// output DDR_CLK
  .wr_clk                                            (wr_clk         ),// output wr_clk
  .rd_clk                                            (rd_clk         ),// output rd_clk
    // Status and control signals
  .reset                                             (!rst_n         ),// input reset
  .locked                                            (locked         ),// output locked
   // Clock in ports
  .clk_in1                                           (clk)           );// input clk_in1



vga2hdmi u_vga2hdmi(
  .clk_1x                                            (rd_clk         ),// system clock 74.25MHz
  .clk_5x                                            (DDR_CLK        ),
  .rst_n                                             (init_calib_complete),// reset, low valid
  .hsync                                             (post_img_vsync ),
  .vsync                                             (post_img_hsync ),
  .rgb_vlaid                                         (post_img_valid ),
  .rgb_data                                          (post_img_data  ),
  .tmds_clk_p                                        (tmds_clk_p     ),
  .tmds_clk_n                                        (tmds_clk_n     ),
  .tmds_data_p                                       (tmds_data_p    ),
  .tmds_data_n                                       (tmds_data_n    ) 
);

uart_rx u_uart_rx(
  .clk                                               (wr_clk         ),
  .rst_n                                             (init_calib_complete),
  .uart_rx                                           (uart_rx        ),
  .baud_sel                                          (4              ),
  .rx_din                                            (rx_din         ),
  .rx_vld                                            (rx_vld         ) 
);



ddr3_test#
( .DATA_IN_WIDTH                                     ( DATA_IN_WIDTH )  ,//写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (DATA_WIDTH     ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (ADDR_WIDTH     ) //地址位宽
) u_ddr3_test(
  .init_calib_complete                               (init_calib_complete),
  .rst_n                                             (locked         ),
  //串口图片输入
  .bit16_out                                         ({8'b0,rx_din}      ),
  .bit16_out_vld                                     (rx_vld  ),
  //video_driver信号
  .post_img_vsync                                    (post_img_vsync ),
  .post_img_hsync                                    (post_img_hsync ),
  .post_img_valid                                    (post_img_valid ),
  .post_img_data                                     (post_img_data  ),
  //ddr3 native fifo 接口
    //写fifo
  .wr_clk                                            (wr_clk         ),
  .wr_req                                            (wr_req         ),
  .wr_address_beign                                  (wr_address_beign),
  .wr_address_end                                    (wr_address_end ),
  .wr_din                                            (wr_din         ),
  .wr_din_vld                                        (wr_din_vld     ),
    //读fifo
  .rd_clk                                            (rd_clk         ),
  .rd_req                                            (rd_req         ),
  .rd_address_beign                                  (rd_address_beign),
  .rd_address_end                                    (rd_address_end ),
  .rd_dout                                           (rd_dout        ),
  .rd_dout_vld                                       (rd_dout_vld    ) 
);


ddr3_native#
( .DATA_IN_WIDTH                                     ( DATA_IN_WIDTH )  ,//写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (DATA_WIDTH     ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (ADDR_WIDTH     ) //地址位宽
) u_ddr3_native(
  .clk                                               (DDR_CLK        ),
  .rst_n                                             (locked         ),
  // Memory interface ports
  .ddr3_addr                                         (ddr3_addr      ),// output [14:0]		ddr3_addr
  .ddr3_ba                                           (ddr3_ba        ),// output [2:0]		ddr3_ba
  .ddr3_cas_n                                        (ddr3_cas_n     ),// output			ddr3_cas_n
  .ddr3_ck_n                                         (ddr3_ck_n      ),// output [0:0]		ddr3_ck_n
  .ddr3_ck_p                                         (ddr3_ck_p      ),// output [0:0]		ddr3_ck_p
  .ddr3_cke                                          (ddr3_cke       ),// output [0:0]		ddr3_cke
  .ddr3_ras_n                                        (ddr3_ras_n     ),// output			ddr3_ras_n
  .ddr3_reset_n                                      (ddr3_reset_n   ),// output			ddr3_reset_n
  .ddr3_we_n                                         (ddr3_we_n      ),// output			ddr3_we_n
  .ddr3_dq                                           (ddr3_dq        ),// inout [31:0]		ddr3_dq
  .ddr3_dqs_n                                        (ddr3_dqs_n     ),// inout [3:0]		ddr3_dqs_n
  .ddr3_dqs_p                                        (ddr3_dqs_p     ),// inout [3:0]		ddr3_dqs_p
  .init_calib_complete                               (init_calib_complete),// output			init_calib_complete
  .ddr3_cs_n                                         (ddr3_cs_n      ),// output [0:0]		ddr3_cs_n
  .ddr3_dm                                           (ddr3_dm        ),// output [3:0]		ddr3_dm
  .ddr3_odt                                          (ddr3_odt       ),// output [0:0]		ddr3_odt
    // USERS PORT
  .wr_clk                                            (wr_clk         ),
  .wr_req                                            (wr_req         ),
  .wr_address_beign                                  (wr_address_beign),
  .wr_address_end                                    (wr_address_end ),
  .wr_din                                            (wr_din         ),
  .wr_din_vld                                        (wr_din_vld     ),
  .rd_clk                                            (rd_clk         ),
  .rd_req                                            (rd_req         ),
  .rd_address_beign                                  (rd_address_beign),
  .rd_address_end                                    (rd_address_end ),
  .rd_dout                                           (rd_dout        ),
  .rd_dout_vld                                       (rd_dout_vld    ) 

);

                                                                   
                                                                   
endmodule
