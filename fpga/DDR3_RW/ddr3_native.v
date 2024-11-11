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
// Last modified Date:     2024/07/29 10:48:00 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/29 10:48:00 
// Version:                V1.0 
// TEXT NAME:              ddr3_ctrl_top.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_ctrl_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_ctrl_top#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128    ,//数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 28      //地址位宽
)(
  input                                          clk             ,//ddr3 系统时钟
  input                                          rst_n           ,
  // Inouts
  inout          [  31: 0]                       ddr3_dq         ,
  inout          [   3: 0]                       ddr3_dqs_n      ,
  inout          [   3: 0]                       ddr3_dqs_p      ,
   // Outputs
  output         [  14: 0]                       ddr3_addr       ,
  output         [   2: 0]                       ddr3_ba         ,
  output                                         ddr3_ras_n      ,
  output                                         ddr3_cas_n      ,
  output                                         ddr3_we_n       ,
  output                                         ddr3_reset_n    ,
  output         [   0: 0]                       ddr3_ck_p       ,
  output         [   0: 0]                       ddr3_ck_n       ,
  output         [   0: 0]                       ddr3_cke        ,
  output         [   0: 0]                       ddr3_cs_n       ,
  output         [   3: 0]                       ddr3_dm         ,
  output         [   0: 0]                       ddr3_odt        ,
  // USERS PORT
  input                                          wr_clk          ,
  input                                          wr_req          ,
  input          [ADDR_WIDTH - 1 : 0]            wr_address_beign,
  input          [ADDR_WIDTH - 1 : 0]            wr_address_end  ,//写结束地址
  input          [DATA_IN_WIDTH - 1 : 0]         wr_din          ,
  input                                          wr_din_vld      ,
  input                                          rd_clk          ,
  input                                          rd_req          ,
  input          [ADDR_WIDTH - 1 : 0]            rd_address_beign,
  input          [ADDR_WIDTH - 1 : 0]            rd_address_end  ,//读结束地址
  output         [DATA_IN_WIDTH - 1 : 0]         rd_dout         ,
  output                                         rd_dout_vld     ,

  output                                         init_calib_complete 
);

  wire                                           ui_clk          ;
  wire                                           ui_clk_sync_rst  ;
  wire                                           app_en          ;
  wire                                           app_rdy         ;
  wire           [   2: 0]                       app_cmd         ;
  wire           [ADDR_WIDTH - 1:0]              app_addr        ;
  wire                                           app_wdf_rdy     ;
  wire                                           app_wdf_wren    ;
  wire                                           app_wdf_end     ;
  wire           [(DATA_WIDTH/8) - 1:0]          app_wdf_mask    ;
  wire           [DATA_WIDTH - 1:0]              app_wdf_data    ;
  wire           [DATA_WIDTH - 1:0]              app_rd_data     ;
  wire                                           app_rd_data_end  ;
  wire                                           app_rd_data_valid  ;



ddr3_arbit#
( .DATA_IN_WIDTH                                     ( DATA_IN_WIDTH )  ,//写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (DATA_WIDTH     ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (ADDR_WIDTH     ) //地址位宽
)  u_ddr3_arbit(
  //时钟和复位
  .clk                                               (ui_clk         ),
  .rst_n                                             (~ui_clk_sync_rst),
  .init_calib_complete                               (init_calib_complete),
  //用户信号
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
  .rd_dout_vld                                       (rd_dout_vld    ),
//MIG端控制信号----------------------------------------------	
  .app_en                                            (app_en         ),
  .app_rdy                                           (app_rdy        ),
  .app_cmd                                           (app_cmd        ),
  .app_addr                                          (app_addr       ),
  .app_wdf_rdy                                       (app_wdf_rdy    ),
  .app_wdf_wren                                      (app_wdf_wren   ),
  .app_wdf_end                                       (app_wdf_end    ),
  .app_wdf_mask                                      (app_wdf_mask   ),
  .app_wdf_data                                      (app_wdf_data   ),
  .app_rd_data                                       (app_rd_data    ),
  .app_rd_data_end                                   (app_rd_data_end),
  .app_rd_data_valid                                 (app_rd_data_valid) 
);



  //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
  mig_7series_0 u_mig_7series_0 (
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
    // Application interface ports
  .app_addr                                          (app_addr       ),// input [28:0]		app_addr
  .app_cmd                                           (app_cmd        ),// input [2:0]		app_cmd
  .app_en                                            (app_en         ),// input				app_en
  .app_wdf_data                                      (app_wdf_data   ),// input [127:0]		app_wdf_data
  .app_wdf_end                                       (app_wdf_end    ),// input				app_wdf_end
  .app_wdf_wren                                      (app_wdf_wren   ),// input				app_wdf_wren
  .app_rd_data                                       (app_rd_data    ),// output [127:0]		app_rd_data
  .app_rd_data_end                                   (app_rd_data_end),// output			app_rd_data_end
  .app_rd_data_valid                                 (app_rd_data_valid),// output			app_rd_data_valid
  .app_rdy                                           (app_rdy        ),// output			app_rdy
  .app_wdf_rdy                                       (app_wdf_rdy    ),// output			app_wdf_rdy
  .app_sr_req                                        (1'b0           ),// input			app_sr_req
  .app_ref_req                                       (1'b0           ),// input			app_ref_req
  .app_zq_req                                        (1'b0           ),// input			app_zq_req
  .app_sr_active                                     (               ),// output			app_sr_active
  .app_ref_ack                                       (               ),// output			app_ref_ack
  .app_zq_ack                                        (               ),// output			app_zq_ack
  .ui_clk                                            (ui_clk         ),// output			ui_clk
  .ui_clk_sync_rst                                   (ui_clk_sync_rst),// output			ui_clk_sync_rst
  .app_wdf_mask                                      (app_wdf_mask   ),// input [15:0]		app_wdf_mask
    // System Clock Ports
  .sys_clk_i                                         (clk            ),
  .sys_rst                                           (rst_n          ) // input sys_rst
    );




// INST_TAG_END ------ End INSTANTIATION Template ---------                                                                 
endmodule
