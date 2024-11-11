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
// Last modified Date:     2024/10/18 16:36:33 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/18 16:36:33 
// Version:                V1.0 
// TEXT NAME:              pipe.v 
// PATH:                   D:\fuxin\code_main\fpga\paixu\src\pipe.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module pipe(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  07:00]                       data_in         ,
  output         [  07:00]                       data_out        ,
  output                                         data_out_valid   
);

  reg            [  07:00]                       pipe1_max,pipe1_min  ;
  reg            [  07:00]                       pipe2_max,pipe2_min  ;
  reg            [  07:00]                       pipe3_max,pipe3_min  ;

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      pipe1_max <= 0;
      pipe1_min <= 0;
    end
    else if(data_in >= pipe1_max)begin
      pipe1_max <= data_in;
      pipe1_min <= pipe1_max;
    end
    else if(data_in < pipe1_max && data_in >= pipe1_min)begin
      pipe1_max <= pipe1_max;
      pipe1_min <= data_in;
    end
    else begin
      pipe1_max <= pipe1_min;
      pipe1_min <= pipe1_min;
    end
  end                                                               //always end

    always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      pipe2_max <= 0;
      pipe2_min <= 0;
    end
    else if(pipe1_max >= pipe2_max)begin
      pipe2_max <= pipe2_min;
      pipe2_min <= pipe1_max;
    end
    else begin
      pipe2_max <= pipe2_max;
      pipe2_min <= pipe2_max;
    end
  end                                                               //always end


  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      pipe3_max <= 0;
      pipe3_min <= 0;
    end
    else if(pipe2_max >= pipe3_max)begin
      pipe3_max <= pipe3_min;
      pipe3_min <= pipe2_max;
    end
    else begin
       pipe3_max <= pipe3_max;
      pipe3_min <= pipe3_max;
    end
  end                                                               //always end
  
  assign  data_out= pipe3_max;
                                                                   
                                                                   
endmodule
