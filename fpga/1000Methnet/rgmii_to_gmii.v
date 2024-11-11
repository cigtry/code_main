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
// Last modified Date:     2024/08/01 14:13:42 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/01 14:13:42 
// Version:                V1.0 
// TEXT NAME:              rgmii_to_gmii.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\rgmii_to_gmii.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module rgmii_to_gmii(
  input                                          rst_n           ,

  input                                          rgmii_rx_clk    ,
  input          [   3: 0]                       rgmii_rxd       ,
  input                                          rgmii_rxdv      ,

  output                                         gmii_rx_clk     ,
  output         [   7: 0]                       gmii_rxd        ,
  output                                         gmii_rxdv       ,
  output                                         gmii_rxerr       
);

  wire                                           gmii_rxer       ;
  assign                                             gmii_rx_clk    = rgmii_rx_clk;
  assign                                             gmii_rxerr     = gmii_rxer^gmii_rxdv;

  genvar i;
  generate
    for (i = 0; i<4; i=i+1) begin :rgmii_rxd_i
        IDDR #(
  .DDR_CLK_EDGE                                      ("SAME_EDGE_PIPELINED"),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                              //    or "SAME_EDGE_PIPELINED" 
  .INIT_Q1                                           (1'b0           ),// Initial value of Q1: 1'b0 or 1'b1
  .INIT_Q2                                           (1'b0           ),// Initial value of Q2: 1'b0 or 1'b1
  .SRTYPE                                            ("SYNC"         ) // Set/Reset type: "SYNC" or "ASYNC" 
        ) IDDR_inst (
  .Q1                                                (gmii_rxd[i]    ),// 1-bit output for positive edge of clock
  .Q2                                                (gmii_rxd[i+4]  ),// 1-bit output for negative edge of clock
  .C                                                 (rgmii_rx_clkC  ),// 1-bit clock input
  .CE                                                (1'b1           ),// 1-bit clock enable input
  .D                                                 (rgmii_rxd[i]   ),// 1-bit DDR data input
  .R                                                 (!rst_n         ),// 1-bit reset
  .S                                                 (1'b0           ) // 1-bit set
        );
    end
  endgenerate

  IDDR #(
  .DDR_CLK_EDGE                                      ("SAME_EDGE_PIPELINED"),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                              //    or "SAME_EDGE_PIPELINED" 
  .INIT_Q1                                           (1'b0           ),// Initial value of Q1: 1'b0 or 1'b1
  .INIT_Q2                                           (1'b0           ),// Initial value of Q2: 1'b0 or 1'b1
  .SRTYPE                                            ("SYNC"         ) // Set/Reset type: "SYNC" or "ASYNC" 
        ) IDDR_inst (
  .Q1                                                (gmii_rxdv      ),// 1-bit output for positive edge of clock
  .Q2                                                (gmii_rxer      ),// 1-bit output for negative edge of clock
  .C                                                 (rgmii_rx_clkC  ),// 1-bit clock input
  .CE                                                (1'b1           ),// 1-bit clock enable input
  .D                                                 (rgmii_rxdv     ),// 1-bit DDR data input
  .R                                                 (!rst_n         ),// 1-bit reset
  .S                                                 (1'b0           ) // 1-bit set
        );
                                                                   
                                                                   
endmodule
