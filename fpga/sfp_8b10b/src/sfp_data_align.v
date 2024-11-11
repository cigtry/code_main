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
// Last modified Date:     2024/09/20 16:16:50 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/09/20 16:16:50 
// Version:                V1.0 
// TEXT NAME:              sfp_data_align.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\sfp_8b10b\src\sfp_data_align.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module sfp_data_align(
  input                                          clk             ,//RX端时钟
  input                                          rst_n           ,
  input          [  31:00]                       rx_data_in      ,//rx端未校正的数据
  input          [  03:00]                       rx_charisk_in   ,//rx端k码未校正接收信号
  output  reg    [  31:00]                       rx_data_out     ,//rx端校正后的数据
  output  reg    [  03:00]                       rx_charisk_out   //rx端k码校正后接收信号
);

//parameter define

//reg define
  reg  [31:00] rx_data_in_d0    ;
  reg  [03:00] rx_charisk_in_d0 ;
  reg  [31:00] rx_data_in_d1    ;
  reg  [03:00] rx_charisk_in_d1 ;
  reg  [03:00] byte_ctrl        ;
//wire define	

//*********************************************************************************************
//**                    main code
//**********************************************************************************************

always @(posedge clk ) begin
  rx_data_in_d0    <= rx_data_in   ;
  rx_charisk_in_d0 <= rx_charisk_in;
  rx_data_in_d1    <= rx_data_in_d0   ;
  rx_charisk_in_d1 <= rx_charisk_in_d0;
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    byte_ctrl <= 4'd0;
  end
  else begin
    if (rx_charisk_in_d0 > 0) begin
      byte_ctrl <= rx_charisk_in_d0;
    end
    else begin
      byte_ctrl <= byte_ctrl;
    end
  end
end

always @ (posedge clk or negedge rst_n)begin 
  if(!rst_n)begin  
    rx_data_out    <=  32'd0;
    rx_charisk_out <=  4'd0;
  end  
  else begin  
    if (byte_ctrl == 4'b0100) begin
      rx_data_out   <= {rx_data_in_d0   [15:00],rx_data_in_d1[31:16]   };
      rx_charisk_out<= {rx_charisk_in_d0[01:00],rx_charisk_in_d1[3:2]  };
    end
    else begin
      rx_data_out <= rx_data_in_d0;
      rx_charisk_out <= rx_charisk_in_d0;
    end
  end  
end //always end

                                                                   
                                                                   
endmodule
