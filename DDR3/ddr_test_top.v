`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-2.4.20240526
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2024/07/29 19:42:41 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/29 19:42:41 
// Version:                V1.0 
// TEXT NAME:              ddr_test_top.v 
// PATH:                   D:\vivado\DDR3_AXI\DDR_MIG\DDR_MIG.srcs\sources_1\new\ddr_test_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr_test_top(
  input                                            clk             ,
  input                                            rst_n           ,

    // Inouts
  inout            [  31: 0]                       ddr3_dq         ,
  inout            [   3: 0]                       ddr3_dqs_n      ,
  inout            [   3: 0]                       ddr3_dqs_p      ,
   // Outputs
  output           [  14: 0]                       ddr3_addr       ,
  output           [   2: 0]                       ddr3_ba         ,
  output                                           ddr3_ras_n      ,
  output                                           ddr3_cas_n      ,
  output                                           ddr3_we_n       ,
  output                                           ddr3_reset_n    ,
  output           [   0: 0]                       ddr3_ck_p       ,
  output           [   0: 0]                       ddr3_ck_n       ,
  output           [   0: 0]                       ddr3_cke        ,
  output           [   0: 0]                       ddr3_cs_n       ,
  output           [   3: 0]                       ddr3_dm         ,
  output           [   0: 0]                       ddr3_odt         
);
  wire                                             wr_begin        ;
  wire                                             wr_data_valid   ;
  wire             [   7: 0]                       wr_data_in      ;
  wire             [  29:00]                       wr_addr_begin   ;
  wire                                             rd_enable       ;
  wire             [  29:00]                       rd_addr_begin   ;
  wire             [   7: 0]                       rd_data_out     ;
  wire                                             rd_valid_out    ;
  wire                                             tg_compare_error  ;
  wire                                             init_calib_complete  ;


    parameter integer C_M_AXI_ID_WIDTH      = 4 ;
    parameter integer C_M_AXI_ADDR_WIDTH    = 30;
    parameter integer C_M_AXI_DATA_WIDTH    = 128;
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ;
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ;
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ;
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ;
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 ;
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
  wire                                             ddr_clk         ;
  wire                                             wr_clk           ;
  wire                                             rd_clk           ;
  clk_wiz_0 instance_name
   (
    // Clock out ports
  .ddr_clk                                           (ddr_clk        ),// output ddr_clk
  .wrclk                                             (wr_clk          ),// output wrclk
  .rdclk                                             (rd_clk          ),// output rdclk
    // Status and control signals
  .reset                                             (!rst_n         ),// input reset
  .locked                                            (locked         ),// output locked
   // Clock in ports
  .clk_in1                                           (clk)           );// input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------
axi_ddr_test u_axi_ddr_test(
  .rst_n                                             (rst_n          ),
  .init_calib_complete                               (init_calib_complete),
// user
  .wr_clk                                            (wr_clk         ),
  .wr_begin                                          (wr_begin       ),
  .wr_data_valid                                     (wr_data_valid  ),
  .wr_data_in                                        (wr_data_in     ),
  .wr_addr_begin                                     (wr_addr_begin  ),
  .rd_clk                                            (rd_clk         ),
  .rd_begin                                          (rd_begin       ),
  .rd_addr_begin                                     (rd_addr_begin  ),
  .rd_addr_end                                       (rd_addr_end    ),
  .rd_data_busy                                      (rd_data_busy   ),
  .rd_data_out                                       (rd_data_out    ),
  .rd_valid_out                                      (rd_valid_out   ) 
);

axi_ddr_top#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_axi_ddr_top(
  .clk                                               (ddr_clk            ),
  .rst_n                                             (rst_n          ),
  // Inouts
  .ddr3_dq                                           (ddr3_dq        ),
  .ddr3_dqs_n                                        (ddr3_dqs_n     ),
  .ddr3_dqs_p                                        (ddr3_dqs_p     ),
   // Outputs
  .ddr3_addr                                         (ddr3_addr      ),
  .ddr3_ba                                           (ddr3_ba        ),
  .ddr3_ras_n                                        (ddr3_ras_n     ),
  .ddr3_cas_n                                        (ddr3_cas_n     ),
  .ddr3_we_n                                         (ddr3_we_n      ),
  .ddr3_reset_n                                      (ddr3_reset_n   ),
  .ddr3_ck_p                                         (ddr3_ck_p      ),
  .ddr3_ck_n                                         (ddr3_ck_n      ),
  .ddr3_cke                                          (ddr3_cke       ),
  .ddr3_cs_n                                         (ddr3_cs_n      ),
  .ddr3_dm                                           (ddr3_dm        ),
  .ddr3_odt                                          (ddr3_odt       ),
   // Inputs
  .wr_clk                                            (wr_clk         ),
  .rd_clk                                            (rd_clk         ),
  .wr_begin                                          (wr_begin       ),
  .wr_data_valid                                     (wr_data_valid  ),
  .wr_data_in                                        (wr_data_in     ),
  .wr_addr_begin                                     (wr_addr_begin  ),
  .rd_enable                                         (rd_enable      ),
  .rd_addr_begin                                     (rd_addr_begin  ),
  .rd_data_out                                       (rd_data_out    ),
  .rd_valid_out                                      (rd_valid_out   ),
   // Single-ended system clock
  .tg_compare_error                                  (tg_compare_error),
  .init_calib_complete                               (init_calib_complete) 
);
                                                                   
endmodule
