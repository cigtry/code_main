`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-2.4.20240526
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2024/07/29 19:52:51 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/29 19:52:51 
// Version:                V1.0 
// TEXT NAME:              axi_ddr_test.v 
// PATH:                   D:\DESKTOP\git\code\DDR3\axi_ddr_test.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module axi_ddr_test#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input                                            rst_n           ,
  input                                            init_calib_complete,
// user
  input                                            wr_clk          ,
  output reg                                       wr_begin        ,
  output reg                                       wr_data_valid   ,
  output reg       [  07:00]                       wr_data_in      ,
  output reg       [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr_begin   ,

  input                                            rd_clk          ,
  output reg                                       rd_begin        ,
  output reg       [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_begin   ,
  output reg       [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_end     ,
  input                                            rd_data_busy    ,
  input            [  07:00]                       rd_data_out     ,
  input                                            rd_valid_out     
);
  reg                                              wr_busy         ;
  reg              [   9:00]                       cnt             ;
  reg                                              wr_done         ;
  reg              [   9:00]                       rd_cnt          ;
        
  reg                                              rd_busy         ;
  reg              [   9:00]                       delay_cnt       ;
  reg                           rd_data_busy_d;
    wire   neg_rd_data_busy;
  always @(posedge rd_clk ) begin
    rd_data_busy_d <= rd_data_busy;
  end
  assign  neg_rd_data_busy= !rd_data_busy && rd_data_busy_d;

    always @(posedge wr_clk ) begin
        if (!rst_n) begin
            cnt <= 10'b0;
        end
        else if (init_calib_complete && ((!wr_busy)& (!wr_done) & (!rd_busy))) begin
            cnt <= cnt +1'b1;
        end
        else begin
            cnt <= 10'b0;
        end
    end
    always @(posedge wr_clk ) begin
        if (!rst_n) begin
            wr_addr_begin <= 0;
            wr_begin <= 0;
        end
        else if (cnt == 999) begin
            wr_begin <= 1;
            wr_addr_begin <= 30'h0100_0000;
        end
        else begin
            wr_begin <= 0;
            wr_addr_begin <= wr_addr_begin;
        end
    end

    always @(posedge wr_clk ) begin
        if (!rst_n) begin
            wr_busy <= 1'b0;
        end
        else if (cnt == 999) begin
            wr_busy <= 1'b1;
        end
        else if(wr_data_in == 8'hff)begin
            wr_busy <= 1'b0;
        end
        else begin
            wr_busy <= wr_busy;
        end
    end

    always @(posedge wr_clk ) begin
        if (!rst_n) begin
            wr_data_in <= 0;
            wr_data_valid<=0;
        end
        else if (wr_busy) begin
            wr_data_in <= wr_data_in + 1'b1;
            wr_data_valid <= 1'b1;
        end
        else begin
            wr_data_in <= 0;
            wr_data_valid <=0;
        end
    end

    always @(posedge wr_clk ) begin
        if (!rst_n) begin
            wr_done <= 0;
        end
        else if (delay_cnt == 999) begin
            wr_done <= 0;
        end
        else if (wr_data_in == 8'hff) begin
            wr_done <= 1;
        end
        else begin
            wr_done <=wr_done;
        end
    end

    always @(posedge rd_clk ) begin
        if (!rst_n) begin
            delay_cnt <= 0;
        end
        else if (wr_done) begin
            delay_cnt <= delay_cnt + 1;
        end
        else begin
            delay_cnt <= 0;
        end
    end

    always @(posedge rd_clk ) begin
        if (!rst_n) begin
            rd_cnt <= 0;
        end
        else if (rd_busy) begin
            rd_cnt <= rd_cnt + 1;
        end
        else begin
            rd_cnt <= 0;
        end
    end

    always @(posedge rd_clk ) begin
        if (!rst_n) begin
            rd_busy <= 0;
        end
        else if (delay_cnt ==999) begin
            rd_busy <= 1;
        end
        else if (rd_busy && neg_rd_data_busy ) begin
            rd_busy <= 0;
        end
    end
    always @(posedge rd_clk ) begin
        if (!rst_n) begin
            rd_begin      <=0;
            rd_addr_begin <=0;
            rd_addr_end   <=0;
        end
        else if (delay_cnt==999) begin
             rd_begin      <=1;
             rd_addr_begin <=wr_addr_begin;
             rd_addr_end   <=wr_addr_begin+ (((256/8)-1 )* 16);
        end
        else begin
            rd_begin      <=0;
             rd_addr_begin <=rd_addr_begin;
             rd_addr_end   <=rd_addr_end;
        end
    end

                                                 
endmodule
