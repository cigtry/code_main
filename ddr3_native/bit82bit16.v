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
// Last modified Date:     2024/07/31 11:49:32 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/31 11:49:32 
// Version:                V1.0 
// TEXT NAME:              bit82bit16.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\bit82bit16.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module bit82bit16(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  07:00]                       bit8_in         ,
  input                                          bit8_in_vld    ,

  output reg     [  15:00]                       bit16_out       ,
  output reg                                     bit16_out_vld    
);
reg bit_cnt;
always @(posedge clk ) begin
  if (!rst_n) begin
    bit_cnt <= 1'b0;
  end
  else if(bit8_in_vld)begin
    bit_cnt <= bit_cnt + 1'b1;
  end
  else begin
    bit_cnt <= bit_cnt;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    bit16_out<= 16'b0;
  end
  else if(bit8_in_vld)begin
    bit16_out <= {bit16_out[7:0],bit8_in};
  end
  else begin
    bit16_out <= bit16_out;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    bit16_out_vld <= 1'b0;
  end
  else if(bit_cnt && bit8_in_vld)begin
    bit16_out_vld <= 1'b1;
  end
  else begin
    bit16_out_vld <= 1'b0;
  end
end
                                                                   
                                                                   
endmodule
