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
    reg                                        clk                       ;
    reg                                        rst_n                    ;




    initial
        begin
            #2                                             
                    rst_n = 0   ;                          
                    clk = 0     ;                          
            #10                                            
                    rst_n = 1   ;                          
        end                                                
                                                           
    parameter   CLK_FREQ = 100;//Mhz                       
    always # ( 1000/CLK_FREQ/2 ) clk = ~clk ;              

    reg                                        en                         ;
    reg                       [  31: 0]        fword                      ;
    reg                       [  31: 0]        fword1                      ;
    reg                       [  11: 0]        pword                      ;
    reg                       [  11: 0]        pword1                      ;
    wire                      [   7: 0]        rom_data                   ;
    wire                      [   7: 0]        rom_data1                   ;

dds u_dds(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .en                                 (en                        ),
    .fword                              (fword                     ),
    .pword                              (pword                     ),
    .rom_data                           (rom_data                  )
);
dds u_dds2(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .en                                 (en                        ),
    .fword                              (fword1                     ),
    .pword                              (pword1                     ),
    .rom_data                           (rom_data1                  )
);
initial begin
  en= 0;
  fword = 0;
  pword = 0;
  fword1 = 0;
  pword1 = 0;
  wait(rst_n);
  repeat(50)@(posedge clk);
  fword = 4295;
  fword1 = 429;
  en= 1;
  repeat(5000000)@(posedge clk);
  $stop;
end



endmodule                                                  