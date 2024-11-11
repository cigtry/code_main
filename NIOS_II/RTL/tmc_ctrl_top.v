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
// Last modified Date:     2024/06/20 14:20:50 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/20 14:20:50 
// Version:                V1.0 
// TEXT NAME:              tmc_ctrl_top.v 
// PATH:                   C:\Users\maccura\Desktop\h3600\NIOS_II\RTL\tmc_ctrl_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module tmc_ctrl_top(
  input                                          clk             ,
  input                                          rst_n           ,
      //avalon 
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output         [  31:00]                       avs_read_data   ,

  input  wire                                    MISO            ,
  output wire                                    MOSI            ,
  output wire                                    SPI_CLK         ,
  output wire                                    SPI_CS           
);
                                                                   

  wire                                           tmc_start       ;
  wire           [  39:00]                       tmc_mosi_data   ;
  wire           [  39:00]                       tmc_miso_data   ;
  reg                                            tmc_start_d     ;
  wire                                           tmc_pos_start   ;
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        tmc_start_d <= 1'b0;
      end
      else begin
        tmc_start_d <= tmc_start;
      end
    end
  assign                                             tmc_pos_start  = !tmc_start_d & tmc_start;
tmc_reg u_tmc_reg(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .avs_address                                       (avs_address    ),
  .avs_write                                         (avs_write      ),
  .avs_write_data                                    (avs_write_data ),
  .avs_read                                          (avs_read       ),
  .avs_read_data                                     (avs_read_data  ),
  .tmc_start                                         (tmc_start      ),
  .tmc_mosi_data                                     (tmc_mosi_data  ),
  .tmc_miso_data                                     (tmc_miso_data  ) 
);

spi_module_master
        #(
  .SPI_DATA                                          (40             ),
  .DIV_NUM                                           (1999            ) 
        )
        spi_module_fct (
  .sys_clk                                           (clk            ),
  .rst_n                                             (rst_n          ),
  .mosi_data                                         (tmc_mosi_data  ),
  .start_en                                          (tmc_pos_start  ),//receive_en
  .spi_cs_rise                                       (               ),
  .MISO                                              (MISO           ),
  .miso_data                                         (tmc_miso_data  ),
  .spi_cs                                            (SPI_CS         ),
  .spi_sclk                                          (SPI_CLK        ),
  .MOSI                                              (MOSI           ) 
        );
endmodule
