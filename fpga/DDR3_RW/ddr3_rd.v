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
// Last modified Date:     2024/07/29 16:10:10 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/29 16:10:10 
// Version:                V1.0 
// TEXT NAME:              ddr3_rd.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_rd.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_rd#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128    ,//数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 28      //地址位宽
)
(
//时钟与复位-------------------------------------------------       	
  input                                          clk             ,//用户时钟
  input                                          rst_n           ,//复位,高有效	
//用户端信号------------------------------------------------- 	
  input                                          rd_burst_start  ,//一次突发读开始								
  input          [ADDR_WIDTH - 1:0]              rd_burst_len    ,//突发读取的长度								
  input          [ADDR_WIDTH - 1:0]              rd_burst_addr   ,//突发读取的首地址								
  output         [DATA_WIDTH - 1:0]              rd_burst_data   ,//突发读取的数据。存入读FIFO			
  output                                         rd_burst_ack    ,//突发读响应，高电平表示数据有效			
  output reg                                     rd_burst_done   ,//一次突发读完成
  output reg                                     rd_burst_busy   ,//突发读忙状态，高电平有效	
//MIG端控制信号----------------------------------------------	
  output reg                                     app_en          ,//MIG发送命令使能	
  input                                          app_rdy         ,//MIG命令接收准备好标致
  output         [   2: 0]                       app_cmd         ,//MIG操作命令，读或者写
  output reg     [ADDR_WIDTH - 1:0]              app_addr        ,//MIG读取DDR3地址							
  input          [DATA_WIDTH - 1:0]              app_rd_data     ,//MIG读出的数据
  input                                          app_rd_data_end ,//MIG读出的最后一个数据
  input                                          app_rd_data_valid //MIG读出的数据有效
);

//parameter define
  localparam                                         READ           = 3'b001;				//MIG读命令
//reg define
  reg                                            rd_burst_start_d  ;
  reg            [ADDR_WIDTH - 1:0]              rd_burst_len_d  ;
  reg            [ADDR_WIDTH - 1:0]              rd_burst_addr_d  ;
  reg            [ADDR_WIDTH - 1:0]              rd_addr_cnt     ;//地址读取个数计数器
  reg            [ADDR_WIDTH - 1:0]              rd_data_cnt     ;//数据读取个数计数器
//wire define					
  wire                                           rd_addr_last    ;//
  wire                                           rd_data_last    ;//
//*********************************************************************************************
//**                    main code
//**********************************************************************************************

  //固定为读状态 
  assign                                             app_cmd        = READ;
  //将从MIG中读出的数据直接赋值给上级模块
  assign                                             rd_burst_data  = app_rd_data;
  //读出的最后一个地址
  assign                                             rd_addr_last   = app_en && app_rdy && (rd_addr_cnt == rd_burst_len_d - 1);
  //读出的最后一个数据
  assign                                             rd_data_last   = app_rd_data_valid && (rd_data_cnt == rd_burst_len_d - 1);
  //读响应信号，用于将MIG中的数据输出给上级模块（读出）
  assign                                             rd_burst_ack   = app_rd_data_valid;

  //检测突发开始信号延迟
  always @(posedge clk ) begin
    rd_burst_start_d <= rd_burst_start;
  end

  //开始信号到来时锁存突发长度
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_burst_len_d <= {ADDR_WIDTH{1'b0}};
    end
    else if(rd_burst_start)begin
      rd_burst_len_d <= rd_burst_len;
    end
    else begin
      rd_burst_len_d <= rd_burst_len_d;
    end
  end

  //开始信号到来时锁存突发起始地址
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_burst_addr_d <= {ADDR_WIDTH{1'b0}};
    end
    else if(rd_burst_start)begin
      rd_burst_addr_d <= rd_burst_addr;
    end
    else begin
      rd_burst_addr_d <= rd_burst_addr_d;
    end
  end

  //app_en控制：突发开始后一直拉高，直到地址突发结束 
  always @(posedge clk ) begin
    if (!rst_n) begin
      app_en <= 1'b0;
    end
    else if(!app_en && rd_burst_start_d)begin
      app_en <= 1'b1;
    end
    else if(rd_addr_last)begin
      app_en <= 1'b0;
    end
    else begin
      app_en <= app_en;
    end
  end

    //rd_burst_done 
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_burst_done <= 1'b0;
    end
    else if(rd_data_last)begin
      rd_burst_done <= 1'b1;
    end
    else begin
      rd_burst_done <= 1'b0;
    end
  end

  //起始信号拉高忙状态，读完所有数据后拉低该信号
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_burst_busy <= 1'b0;
    end
    else if(!rd_burst_busy && rd_burst_start)begin
      rd_burst_busy <= 1'b1;
    end
    else if(rd_burst_done)begin
      rd_burst_busy <= 1'b0;
    end
    else begin
      rd_burst_busy <= rd_burst_busy;
    end
  end

  //读取地址
  always @(posedge clk ) begin
    if (!rst_n) begin
      app_addr <= {ADDR_WIDTH{1'b0}};
    end
    else if (rd_burst_start_d) begin
      app_addr <= rd_burst_addr_d;
    end
    else if(app_en && app_rdy)begin
      app_addr <= app_addr + 4'd8;
    end
    else begin
      app_addr <= app_addr;
    end
  end

  //地址读取个数计数器
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_addr_cnt <= {ADDR_WIDTH{1'b0}};
    end
    else if (rd_burst_start) begin
      rd_addr_cnt <= {ADDR_WIDTH{1'b0}};
    end
    else if(app_en && app_rdy)begin
      rd_addr_cnt <= rd_addr_cnt + 1'b1;
    end
    else begin
      rd_addr_cnt <= rd_addr_cnt;
    end
  end

  //数据读取个数计数器
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_data_cnt <= {ADDR_WIDTH{1'b0}};
    end
    else if (rd_burst_start) begin
      rd_data_cnt <= {ADDR_WIDTH{1'b0}};
    end
    else if(rd_burst_busy && app_rd_data_valid)begin
      rd_data_cnt <= rd_data_cnt + 1'b1;
    end
    else begin
      rd_data_cnt <= rd_data_cnt;
    end
  end

endmodule
