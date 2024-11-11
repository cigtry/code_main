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
// Last modified Date:     2024/06/20 14:22:14 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/20 14:22:14 
// Version:                V1.0 
// TEXT NAME:              tmc_reg.v 
// PATH:                   C:\Users\maccura\Desktop\h3600\NIOS_II\RTL\tmc_reg.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module tmc_reg(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output  reg    [  31:00]                       avs_read_data   ,

  output reg                                     tmc_start       ,
  output reg     [  39:00]                       tmc_mosi_data   ,
  input          [  39:00]                       tmc_miso_data    

);

  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      tmc_start <= 1'b0;
      tmc_mosi_data <= 40'b0;
    end  
    else if(avs_write)begin  
      case (avs_address)
        8'h00: begin
          tmc_mosi_data[39:32] <= avs_write_data[7:0];
        end 
        8'h01:begin
          tmc_mosi_data[31:00] <= avs_write_data;
        end
        8'h02:begin
          tmc_start <= avs_write_data[0];
        end
        default: tmc_mosi_data <= tmc_mosi_data;
      endcase
    end  
    else begin  
      tmc_start <= 1'b0;
      tmc_mosi_data <= tmc_mosi_data;
    end  
  end //always end
  
  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      avs_read_data <= 32'b0;
    end  
    else if(avs_read)begin  
      case(avs_address)
        8'h00: avs_read_data <= {24'b0 , tmc_miso_data[39:32]};
         8'h01: avs_read_data <= tmc_miso_data[31:00];
        default:avs_read_data <= 32'h00;
      endcase
    end  
    else begin  
      avs_read_data <= 32'b0;
    end  
  end //always end
  

                                                                   
                                                                   
endmodule
