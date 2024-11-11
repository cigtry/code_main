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
// Last modified Date:     2024/07/11 10:52:23 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/11 10:52:23 
// Version:                V1.0 
// TEXT NAME:              encoder_reg.v 
// PATH:                   D:\git\h3600\RTL\encoder\encoder_reg.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module encoder_reg(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output reg     [  31:00]                       avs_read_data   ,
  output reg                                     clear           ,
  input          [  31:00]                       speed           ,//采集到的速度
  input          [  31:00]                       step             //采集到的步长

);
  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      clear <= 1'b0;
    end  
    else if(avs_write)begin  
      case (avs_address)
        8'h00: begin
          clear <= avs_write_data[0];
        end 
        default: clear <= 1'b0;
      endcase
    end  
    else begin  
    clear <= 1'b0;
    end  
  end //always end  

  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      avs_read_data <= 32'b0;
    end  
    else if(avs_read)begin  
      case(avs_address)
        8'h01: avs_read_data <= step;
        8'h02: avs_read_data <= speed;
        default:avs_read_data <= 32'h00;
      endcase
    end  
    else begin  
      avs_read_data <= 32'b0;
    end  
  end //always end                                                               
                                                                   
endmodule
