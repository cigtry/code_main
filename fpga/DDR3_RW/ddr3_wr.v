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
// Last modified Date:     2024/07/29 11:25:23 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/29 11:25:23 
// Version:                V1.0 
// TEXT NAME:              ddr3_wr.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_wr.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_wr#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128    ,//数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 28      //地址位宽
)(
  input                                          clk             ,
  input                                          rst_n           ,
//用户端信号------------------------------------------------- 	
  input                                          wr_burst_start  ,//一次突发写开始	由外部写请求产生						
  input          [ADDR_WIDTH - 1:0]              wr_burst_len    ,//突发写入的长度							
  input          [ADDR_WIDTH - 1:0]              wr_burst_addr   ,//突发写入的首地址							
  input          [DATA_WIDTH - 1:0]              wr_burst_data   ,//需要突发写入的数据。来源写FIFO							
  output                                         wr_burst_ack    ,//突发写响应，为高时代表正在写入数据为低时可以请求下次数据							
  output reg                                     wr_burst_done   ,//一次突发写完成
  output reg                                     wr_burst_busy   ,//突发写忙状态，高电平有效  
//MIG端控制信号----------------------------------------------	
  output reg                                     app_en          ,//MIG IP发送命令使能	
  input                                          app_rdy         ,//MIG IP命令接收准备好标致 空闲
  output         [   2: 0]                       app_cmd         ,//MIG IP操作命令，读或者写
  output reg     [ADDR_WIDTH - 1:0]              app_addr        ,//MIG IP操作地址	
  input                                          app_wdf_rdy     ,//MIG IP数据接收准备好 写数据空闲
  output                                         app_wdf_wren    ,//MIG IP写数据使能
  output                                         app_wdf_end     ,//MIG IP突发写当前时钟最后一个数据
  output         [(DATA_WIDTH/8) - 1:0]          app_wdf_mask    ,//MIG IP数据掩码
  output         [DATA_WIDTH - 1:0]              app_wdf_data     //MIG IP写数据
);
//parameter define
  localparam                                         WRITE          = 3'b000;				//MIG写命令
//reg define
  reg                                            wr_burst_start_d  ;
  reg            [ADDR_WIDTH - 1:0]              wr_burst_addr_lock  ;//开始地址锁存
  reg            [ADDR_WIDTH - 1:0]              wr_burst_len_lock  ;//突发写入长度锁存
  reg            [ADDR_WIDTH - 1:0]              wr_brust_cnt    ;//突发长度计数
//wire defien
  wire                                           wr_data_last    ;//一次突发完成
//*********************************************************************************************
//**                    main code
//**********************************************************************************************

  //写命令
  assign                                             app_cmd        = WRITE;
  //数据掩码为0
  assign                                             app_wdf_mask   = {(DATA_WIDTH/8){1'b0}};
  //写响应信号，用于从前级获取数据
  assign                                             wr_burst_ack   = app_en && app_rdy && app_wdf_rdy;
  //app_en app_rdy app_wdf_rdy 都准备好此时拉高写使能
  assign                                             app_wdf_wren   = wr_burst_ack;
  //处于写使能且是最后一个数据
  assign                                             wr_data_last   = (app_wdf_wren && (wr_brust_cnt == (wr_burst_len_lock - 1'b1))) ? 1'b1 : 1'b0;
  //由于DDR3芯片时钟和用户时钟的分频选择4:1，突发长度为8，故两个信号相同
  assign                                             app_wdf_end    = app_wdf_wren;
  assign                                             app_wdf_data   = wr_burst_data;

  //检测开始信号的上升沿
  always @(posedge clk ) begin
    wr_burst_start_d <= wr_burst_start;
  end
  //app_en控制：突发开始后一直拉高，直到地址突发结束 
  always @(posedge clk ) begin
    if (!rst_n) begin
      app_en <= 1'b0;
    end
    else if(!app_en && wr_burst_start_d)begin
      app_en <= 1'b1;
    end
    else if(wr_data_last)begin
      app_en <= 1'b0;
    end
    else begin
      app_en <= app_en;
    end
  end
  //开始信号的上升沿锁存地址信号
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_burst_addr_lock <= {ADDR_WIDTH{1'b0}};
    end
    else if(!wr_burst_busy && wr_burst_start)begin
      wr_burst_addr_lock <= wr_burst_addr;
    end
    else begin
      wr_burst_addr_lock <= wr_burst_addr_lock;
    end
  end

  //开始信号的上升沿锁存突发长度
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_burst_len_lock <= {ADDR_WIDTH{1'b0}};
    end
    else if (!wr_burst_busy && wr_burst_start) begin
      wr_burst_len_lock <= wr_burst_len;
    end
    else begin
      wr_burst_len_lock <= wr_burst_len_lock;
    end
  end

  //突发写状态，上升沿拉高，突发完成后拉低
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_burst_busy <= 1'b0;
    end
    else if(wr_burst_done)begin
      wr_burst_busy <= 1'b0;
    end
    else if(wr_burst_start && (!wr_burst_busy))begin
      wr_burst_busy <= 1'b1;
    end
    else begin
      wr_burst_busy <= wr_burst_busy;
    end
  end

  //突发长度计数
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_brust_cnt <= {ADDR_WIDTH{1'b0}};
    end
    else if(wr_burst_busy)begin
      if (wr_burst_ack) begin
        wr_brust_cnt <= wr_brust_cnt + 1'b1;
      end
      else begin
        wr_brust_cnt <= wr_brust_cnt;
      end
    end
    else begin
      wr_brust_cnt <= {ADDR_WIDTH{1'b0}};
    end
  end

  //写入地址
  always @(posedge clk ) begin
    if (!rst_n) begin
      app_addr <= {ADDR_WIDTH{1'b0}};
    end
    else if(wr_burst_start_d)begin
      app_addr <= wr_burst_addr_lock;
    end
    else if(app_wdf_wren)begin
      app_addr <= app_addr + 5'd16;
    end
    else begin
      app_addr <= app_addr;
    end
  end
  //wr_burst_done
  always @(posedge clk) begin
      if(!rst_n)
          wr_burst_done <= 0;
  	else if(wr_data_last)
  		wr_burst_done <= 1;				
  	else 
  		wr_burst_done <= 0;		
  end

endmodule
