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
// Last modified Date:     2024/10/15 14:33:25 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/15 14:33:25 
// Version:                V1.0 
// TEXT NAME:              DA_ROM.v 
// PATH:                   D:\fuxin\code_main\fpga\fir\src\DA_ROM.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module DA_ROM#(
  parameter                                          N_taps         = 5     ,
  parameter                                          ROM_WIDTH      = 18    
)(
  input  [N_taps - 1 :00]  addr,
  output reg  [ROM_WIDTH - 14 :00] data
);

always @(addr ) begin
  case(addr)
    5'b0000 : data = 18'b0000_0000_0000_0000_00;
    5'b0001 : data = 18'b0000_1100_0010_1000_00;
    5'b1111 : data = 18'b0110_0111_0101_0100_00;
    default:data = 18 'b011001110101010000;
  endcase
end
                                                                   
                                                                   
endmodule                                                          
