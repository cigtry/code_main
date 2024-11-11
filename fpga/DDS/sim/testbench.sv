`timescale 1ps / 1ps
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
  reg                                            clk_14          ;


    initial
        begin
                    rst_n = 0   ;
                    clk = 0     ;
                    clk_14 = 0 ;
                  
            #10
                    rst_n = 1   ;
        end
                                                           
  parameter                                          CLK_FREQ       = 100   ;//Mhz                       
    always # ( 1000000/CLK_FREQ/2 ) clk = ~clk ;

  parameter                                          CLK_FREQ_14    = 1500  ;//Mhz                       
    always # ( 1000000/CLK_FREQ_14/2 ) clk_14 = ~clk_14 ;
  reg                                            en              ;

  reg            [  31: 0]                       fword           ;
  reg            [  11: 0]                       pword           ;
  wire     signed[   7: 0]                       rom_data        ;

  reg            [  31: 0]                       fword1          ;
  reg            [  11: 0]                       pword1          ;
  wire     signed[   7: 0]                       rom_data1       ;


    wire    signed             [   15: 0]        rom_data3                 =  rom_data *  rom_data1   ;
dds u_dds(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .en                                                (en             ),
  .fword                                             (fword          ),
  .pword                                             (pword          ),
  .rom_data                                          (rom_data       ) 
);
dds u_dds2(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .en                                                (en             ),
  .fword                                             (fword1         ),
  .pword                                             (pword1         ),
  .rom_data                                          (rom_data1      ) 
);

  wire     signed[  15:00]                       test_wrapper_dds_out  ;

  wire           [  39: 0]                       M_AXIS_DATA_0_tdata  ;
  wire                                           M_AXIS_DATA_0_tvalid  ;
  wire           [  31: 0]                       S_0             ;
  wire                                           m_axis_data_tvalid_0  ;
test_wrapper u_test_wrapper
   (.M_AXIS_DATA_0_tdata      (M_AXIS_DATA_0_tdata),
  .M_AXIS_DATA_0_tvalid                              (M_AXIS_DATA_0_tvalid),
  .S_0                                               (S_0            ),
  .m_axis_data_tvalid_0                              (m_axis_data_tvalid_0),
  .aclk_0                                            (clk)           );



/*    wire   signed                   [15  : 00]filter_out                 ;
 ser_filter u_ser_filter(
  .clk                                               (clk_14         ),
  .rst_n                                             (rst_n          ),
  .filter_in                                         (rom_data3      ),
  .filter_out                                        (filter_out     ) 
); */

  wire     signed[  15:00]                       filter_out_per  ;
per_filter u_per_filter(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .filter_in                                         (rom_data3      ),
  .filter_out                                        (filter_out_per ) 
);

  wire     signed[  15:00]                       filter_out_per1  ;
per_filter u_per_filter1(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .filter_in                                         (test_wrapper_dds_out),
  .filter_out                                        (filter_out_per1) 
);

initial begin
  en= 0;
  fword = 0;
  pword = 0;
  fword1 = 0;
  pword1 = 0;
  wait(rst_n);
  repeat(50)@(posedge clk);
  fword = 42949672;
  fword1 = 429496729;
  en= 1;
  repeat(5000)@(posedge clk);
  $stop;
end



endmodule





   




