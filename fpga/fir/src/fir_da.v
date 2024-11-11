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
// Last modified Date:     2024/10/15 11:15:56 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/15 11:15:56 
// Version:                V1.0 
// TEXT NAME:              fir_da.v 
// PATH:                   D:\fuxin\code_main\fpga\fir\src\fir_da.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module fir_da#(
  parameter                                          N_taps         = 30     ,
  parameter                                          BIT_WIDTH      = 16    
)(
  input                                          clk             ,
  input                                          rst_n           ,
  input                                          clk_enable      ,
  input       signed[BIT_WIDTH - 1 :00]             filter_in       ,
  output reg  signed[BIT_WIDTH - 1 : 00]            filter_out       
);

  localparam                                         DA_WIDTH       = BIT_WIDTH + $clog2(N_taps);
  localparam                                         SUM_WIDTH      = BIT_WIDTH + $clog2(N_taps) + $clog2(BIT_WIDTH);

  reg      signed[N_taps - 1 :00]                delay_pipeline      [ BIT_WIDTH - 1 :00]  ;
  wire     signed[DA_WIDTH - 1 : 00]             DA_data             [BIT_WIDTH - 1 : 00]  ;
  wire     signed[SUM_WIDTH - 1 : 00]            sum                 [BIT_WIDTH : 00]  ;

  assign sum[0] = 0;

  integer j;
  generate
    genvar i;
    for ( i= 0;i<BIT_WIDTH ;i=i+1 ) begin : BIT_WIDTH_1bit_LUT

      always @(posedge clk ) begin
        if (!rst_n) begin
          for(j = 0 ; j < N_taps; j = j+1)begin : bit_matrix_initial
            delay_pipeline[i][j] <= 1'b0;
          end
        end
        else if(clk_enable)begin
          delay_pipeline[i][0] <= filter_in[i];
          for(j = 1 ; j < N_taps; j = j+1)begin : bit_matrix
            delay_pipeline[i][j] <= delay_pipeline[i][j - 1];
          end
        end
        else begin
          for(j = 0 ; j < N_taps; j = j+1)begin : bit_matrix_initial_else
            delay_pipeline[i][j] <= delay_pipeline[i][j];
          end
        end
      end

    DA_ROM #(N_taps,DA_WIDTH)u_bit(.addr (delay_pipeline[i]),.data (DA_data[i]));

    assign sum[i+1] = sum[i]+(DA_data[i]<<<i);
    end
  endgenerate

                                                                   
                                                                   
endmodule
