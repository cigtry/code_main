`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE plug-in 
// VSCODE plug-in version: Verilog-Hdl-Format-2.3.20240512
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              dds_tb.v
// Last modified Date:     2024/10/10 11:33:10
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             
// Created date:           2024/10/10 11:33:10
// Version:                V1.0
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module    testbench();
  reg                                            clk             ;
  reg                                            rst_n           ;




    initial
        begin
            #2
                    rst_n = 0   ;
                    clk = 0     ;
            #10
                    rst_n = 1   ;
        end
                                                           
  parameter                                          CLK_FREQ       = 100   ;//Mhz                       
    always # ( 1000/CLK_FREQ/2 ) clk = ~clk ;
  parameter                                          N_POINT        = 32    ;
  parameter                                          DATA_IN_WIDTH  = 16    ;
  parameter                                          DATA_OUT_WIDTH = 32    ;

  reg            [DATA_IN_WIDTH - 1:00]          data_in         ;
  reg                                            data_in_valid   ;
  wire     signed[DATA_OUT_WIDTH - 1:00]         data_out        ;
  wire                                           data_out_valid  ;
  localparam                                         N_NUM_BIT      = $clog2(N_POINT);
  localparam                                         LAYER_BIT      = $clog2(N_NUM_BIT);
fft#(
  .N_POINT                                           (N_POINT        ),
  .DATA_IN_WIDTH                                     (DATA_IN_WIDTH  ),
  .DATA_OUT_WIDTH                                    (DATA_OUT_WIDTH ) 
)
 u_fft(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .data_in                                           (data_in        ),
  .data_in_valid                                     (data_in_valid  ),
  .data_out                                          (data_out       ),
  .data_out_valid                                    (data_out_valid ) 
);

initial begin
  data_in = 0;
  data_in_valid = 0;
  wait(rst_n);
    repeat(N_POINT + 5) @(posedge clk);
  repeat(N_POINT)begin
    @(posedge clk);
      data_in =data_in+  1;
      data_in_valid = 1;
  end
repeat(1)@(posedge clk);
    data_in = 0;
  data_in_valid = 0;
  repeat(N_POINT*($clog2(N_POINT)) + N_POINT+10)@(posedge clk);

  $stop;
end



endmodule



