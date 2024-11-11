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
// Last modified Date:     2024/06/17 10:04:13 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/17 10:04:13 
// Version:                V1.0 
// TEXT NAME:              Verilog1.v 
// PATH:                   C:\Users\maccura\Desktop\h3600\NIOS_II\PRJ\Verilog1.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module NIOS_II_top(
  input                                          clk             ,
  //UART port
  input                                          rxd             ,
  output                                         txd             ,
  //tmc
  output                                         tmc_mosi        ,
  output                                         tmc_clk         ,
  output                                         tmc_cs          ,
  input                                          tmc_miso        ,
  //motor
  input                                          limit_signal    ,
  output                                         step            ,
  output                                         dirction        ,
  output                                         coe_enable       
);
  wire                                           clk_100M        ;
  wire                                           clk_1M          ;
  wire                                           rst_n           ;
  reset_sig  u_reset_sig
(
  .clk_sys                                           (clk            ),
  .rst_n                                             (rst_n          ) 
    );
  pll inst_pll(
  .refclk                                            (clk            ),//  refclk.clk
  .rst                                               (!rst_n         ),//   reset.reset
  .outclk_0                                          (clk_100M       ),// outclk0.clk
  .outclk_1                                          (clk_1M         ) 
    );


  wire                                           clk_10k         ;

  wire                                           filt_data       ;
clk_generate u_clk_generate(
  .clk_1m                                            (clk_1M         ),
  .rst_n                                             (rst_n          ),
  .clk_10k                                           (clk_10k        ) 
);
      cb_filter_app #(
  .OPT_NUM                                           (1              ),
  .FILTER_CNT                                        (5             ) 
    )
    u_cb_filter_opt(
    //-----------------------------------------------------------------------------------
    // Filter & System Clock & Reset
    //-----------------------------------------------------------------------------------
  .filter_clk                                        (clk_10k        ),
  .sys_clk                                           (clk_100M       ),
  .rst_n                                             (rst_n          ),
    //-----------------------------------------------------------------------------------
    // Orign IO Photoelectric Signal input
    //-----------------------------------------------------------------------------------
  .orign_opt_i                                       (limit_signal   ),
    //-----------------------------------------------------------------------------------
    // IO Photoelectric Signal output After filter
    //-----------------------------------------------------------------------------------
  .filter_opt_o                                      (filt_data      ) 
    );

       nios_ii u_nios_ii (
  .clk_clk                                           (clk_100M       ),//   clk.clk
  .reset_reset_n                                     (rst_n          ),// reset.reset_n
  .motor_ctrl_0_coe_enable                           (coe_enable     ),// motor_ctrl_0.coe_enable
  .motor_ctrl_0_dirction                             (dirction       ),//             .dirction
  .motor_ctrl_0_limit_signal                         (filt_data      ),//             .limit_signal
  .motor_ctrl_0_pulse                                (step           ),//             .pulse
  .uart_rxd                                          (rxd            ),//  uart.rxd
  .uart_txd                                          (txd            ),//      .txd
  .tmc_ctrl_0_miso                                   (tmc_miso       ),//   tmc_ctrl_0.miso
  .tmc_ctrl_0_mosi                                   (tmc_mosi       ),//             .mosi
  .tmc_ctrl_0_spi_clk                                (tmc_clk        ),//             .spi_clk
  .tmc_ctrl_0_spi_cs                                 (tmc_cs         ),//             .spi_cs
  .encoder_0_encoder_sginal                          (~filt_data   ) 
    );
                                                                
endmodule


