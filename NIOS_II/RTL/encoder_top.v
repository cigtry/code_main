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
// Last modified Date:     2024/07/11 10:55:20 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/11 10:55:20 
// Version:                V1.0 
// TEXT NAME:              encoder_top.v 
// PATH:                   D:\git\h3600\RTL\encoder\encoder_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module encoder_top(
    input                               clk                        ,
    input                               rst_n                      ,
          //avalon 
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output         [  31:00]                       avs_read_data   ,

  input                                          encoder_sginal
);

    wire                                        clear                      ;
    wire                      [31:00]          speed                      ;
    wire                      [31:00]          step                       ;

encoder#(
   .CIRCLE_STEP    (3200           ),
   .RESOLUTION     (1000           )
)
 u_encoder(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .encoder_sginal                     (encoder_sginal            ),
    .clear                              (clear                     ),
    .speed                              (speed                     ),
    .step                               (step                      )
);


encoder_reg u_encoder_reg(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .avs_address                        (avs_address               ),
    .avs_write                          (avs_write                 ),
    .avs_write_data                     (avs_write_data            ),
    .avs_read                           (avs_read                  ),
    .avs_read_data                      (avs_read_data             ),
    .clear                              (clear                     ),
    .speed                              (speed                     ),
    .step                               (step                      )
);

                                                                 
                                                                   
endmodule                                                          
