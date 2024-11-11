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
// Last modified Date:     2024/10/14 15:35:12 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/14 15:35:12 
// Version:                V1.0 
// TEXT NAME:              filter_serial.v 
// PATH:                   D:\fuxin\code_main\fpga\fir\src\filter_serial.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module filter_serial(
  input                                          clk             ,
  input                                          rst_n           ,
  input                                          clk_enable      ,
  input       signed[  15:00]                       filter_in       ,
  output      signed[  15:00]                       filter_out       
);

  localparam signed [15:00] coeff1= 16'b1110111010111001;
  localparam signed [15:00] coeff2= 16'b0100100010111111;
  localparam signed [15:00] coeff3= 16'b0111000110111010;
  localparam signed [15:00] coeff4= 16'b0111000110111010;
  localparam signed [15:00] coeff5= 16'b0100100010111111;
  localparam signed [15:00] coeff6= 16'b1110111010111001;

  reg  [02:00]  cur_count;

  always @(posedge clk ) begin
    if (!rst_n) begin
      cur_count <= 3'b101;
    end
    else if (clk_enable == 1'b1) begin
      if (cur_count == 3'b101) begin
        cur_count <= 3'b000;
      end
      else begin
        cur_count <= cur_count + 1'b1;
      end
    end
    else begin
      cur_count <= cur_count;
    end
  end

  wire  FIRSET_SUM_STAGE = (cur_count == 3'b101 && clk_enable == 1'b1 ) ? 1'b1 : 1'b0;
  wire  OUTPUT_STAGE = (cur_count == 3'b000 && clk_enable) ? 1'b1 : 1'b0;

  reg  signed [15:00]  delay_pipeline [0:5];
  always @(posedge clk ) begin
    if (!rst_n) begin
      delay_pipeline[0] <= 16'b0;
      delay_pipeline[1] <= 16'b0;
      delay_pipeline[2] <= 16'b0;
      delay_pipeline[3] <= 16'b0;
      delay_pipeline[4] <= 16'b0;
      delay_pipeline[5] <= 16'b0;
    end
    else begin
      delay_pipeline[0] <= filter_in;
      delay_pipeline[1] <= delay_pipeline[0];
      delay_pipeline[2] <= delay_pipeline[1];
      delay_pipeline[3] <= delay_pipeline[2];
      delay_pipeline[4] <= delay_pipeline[3];
      delay_pipeline[5] <= delay_pipeline[4];
    end
  end

  reg  [15:00]  inputmux_1;

  always @(*)begin
    case(cur_count)
      3'b000 : inputmux_1 =delay_pipeline[0];
      3'b001 : inputmux_1 =delay_pipeline[1];
      3'b010 : inputmux_1 =delay_pipeline[2];
      3'b011 : inputmux_1 =delay_pipeline[3];
      3'b100 : inputmux_1 =delay_pipeline[4];
      3'b101 : inputmux_1 =delay_pipeline[5];
      default: inputmux_1 = 16'b0;
    endcase
  end

  reg [15:00]  product_1_mux;
    always @(*)begin
    case(cur_count)
      3'b000 : product_1_mux =coeff1;
      3'b001 : product_1_mux =coeff2;
      3'b010 : product_1_mux =coeff3;
      3'b011 : product_1_mux =coeff4;
      3'b100 : product_1_mux =coeff5;
      3'b101 : product_1_mux =coeff6;
      default: product_1_mux = 16'b0;
    endcase
  end

  wire signed [31:00] mul_temp = inputmux_1 * product_1_mux;

  wire signed [32:00] acc_sum_1;
  wire signed [32:00] acc_in_1;
  reg  signed [32:00] acc_out_1;
  assign acc_sum_1 = {mul_temp[31],mul_temp} + acc_out_1;
  assign acc_in_1 = (OUTPUT_STAGE == 1'b1) ? {mul_temp[31],mul_temp} : acc_sum_1;

  always @(posedge clk ) begin
    if (!rst_n) begin
      acc_out_1 <= 33'd0;
    end
    else if(clk_enable == 1'b1)begin
      acc_out_1 <= acc_in_1;
    end
    else begin
      acc_out_1 <= acc_out_1;
    end
  end

  reg  signed [32:00] acc_fianal;
  always @(posedge clk ) begin
    if (!rst_n) begin
      acc_fianal <= 33'd0;
    end
    else if(OUTPUT_STAGE == 1'b1)begin
      acc_fianal <= acc_out_1;
    end
    else begin
      acc_fianal <= acc_fianal;
    end
  end

  //四舍五入
  assign filter_out = (acc_fianal[31:00] + {acc_fianal[16],{15{~acc_fianal[16]}}})>>>16;
                                                                   
                                                                   
endmodule
