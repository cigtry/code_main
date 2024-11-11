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
// Last modified Date:     2024/07/31 15:13:15 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/31 15:13:15 
// Version:                V1.0 
// TEXT NAME:              video_driver.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\hdmi\video_driver.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 
module video_driver(
  input                                          pixel_clk       ,
  input                                          sys_rst_n       ,
  input                                          show_en         ,
    //RGB接口
  output                                         img_hsync       ,//行同步信号
  output                                         img_vsync       ,//场同步信号
  output                                         img_valid       ,//数据使能
  output         [  15: 0]                       img_data        ,//RGB888颜色数据
    
  input          [  15: 0]                       pixel_data       //像素点数据
);

//parameter define

//1280*720 分辨率时序参数
  parameter                                          H_SYNC         = 11'd40;   //行同步
  parameter                                          H_BACK         = 11'd220;  //行显示后沿
  parameter                                          H_DISP         = 11'd1280; //行有效数据
  parameter                                          H_FRONT        = 11'd110;  //行显示前沿
  parameter                                          H_TOTAL        = 11'd1650; //行扫描周期

  parameter                                          V_SYNC         = 11'd5 ;    //场同步
  parameter                                          V_BACK         = 11'd20;   //场显示后沿
  parameter                                          V_DISP         = 11'd720;  //场有效数据
  parameter                                          V_FRONT        = 11'd5 ;    //场显示前沿
  parameter                                          V_TOTAL        = 11'd750;  //场扫描周期
  
  reg            [  10:00]                       h_cnt           ;
  reg            [  09:00]                       v_cnt           ;
always @ (posedge pixel_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
      h_cnt <= 11'd0;
    end
    else if(h_cnt == H_TOTAL - 1'b1)begin
      h_cnt <= 11'd0;
    end
    else if(show_en)begin
      h_cnt <= h_cnt + 1'b1;
    end
    else begin
      h_cnt <= h_cnt;
    end
  end                                                               //always end

  always @ (posedge pixel_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
      v_cnt <= 10'd0;
    end
    else if((v_cnt == V_TOTAL- 1'b1 && h_cnt == H_TOTAL - 1'b1))begin
      v_cnt <= 10'd0;
    end
    else if(h_cnt == H_TOTAL- 1'b1)begin
      v_cnt <= v_cnt + 1'b1;
    end
    else begin
      v_cnt <= v_cnt ;
    end
  end                                                               //always end
  assign                                             img_vsync      = (show_en && v_cnt < V_SYNC) ?  1'b1 : 1'b0;

  assign                                             img_hsync      = (show_en && h_cnt < H_SYNC) ? 1'b1 : 1'b0;

  assign   img_valid =((((h_cnt >= H_SYNC+H_BACK) && (h_cnt < H_SYNC+H_BACK+H_DISP))
                 &&((v_cnt >= V_SYNC+V_BACK) && (v_cnt < V_SYNC+V_BACK+V_DISP)))) ?  1'b1 : 1'b0;
  assign                                             img_data       = pixel_data;

endmodule