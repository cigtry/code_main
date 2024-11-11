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
// Last modified Date:     2024/07/11 09:01:32 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/11 09:01:32 
// Version:                V1.0 
// TEXT NAME:              encoder.v 
// PATH:                   D:\git\h3600\RTL\encoder\encoder.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module encoder#(
  parameter                                          CIRCLE_STEP    = 3200  ,
  parameter                                          RESOLUTION     = 20    
)(
  input                                          clk             ,//100m时钟
  input                                          rst_n           ,
  input                                          encoder_sginal  ,//光电信号
  input                                          clear           ,
  output reg     [  31:00]                       speed           ,//采集到的速度
  output reg     [  31:00]                       step             //采集到的步长
);
  reg                                            encoder_sginal_d  ;
  wire                                           pos_encoder_signal  ;
  wire                                           neg_encoder_siganl  ;

    always @(posedge clk ) begin
       encoder_sginal_d <= encoder_sginal;
    end
  assign                                             pos_encoder_signal= encoder_sginal & (!encoder_sginal_d);// 光电信号上升沿
  assign                                             neg_encoder_siganl= (!encoder_sginal) & (encoder_sginal_d);// 光电信号下降沿
  localparam                                         time_unit      = 17'd100000;
  reg            [  16:00]                       cnt_ns          ;
  reg            [  09:00]                       cnt_ms          ;
  reg            [  07:00]                       cnt_s           ;
  reg            [  07:00]                       cnt_over_time   ;//超时结束
  reg                                            busy            ;
  reg            [  31:00]                       step_record     ;//每100ms记录一次步长值
  reg            [  31:00]                       step_record_d   ;//延迟一拍来计算速度
  reg            [  31:00]                       speed_d         ;//每100ms记录步长值之间的差得到速度 也就是 步长 * 100 每秒 

    always @(posedge clk or negedge rst_n ) begin
      if (!rst_n) begin
        busy <= 1'b0;
      end
      else if((busy && (cnt_over_time == 10)) || clear)begin        //10s内未检测到光电上升沿后代表电机已经停止转动
        busy <= 1'b0;
      end
      else if((~busy) && (pos_encoder_signal || neg_encoder_siganl))begin
        busy <= 1'b1;
      end
      else begin
        busy <= busy;
      end
    end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        cnt_ns <= 17'd0;
      end
      else if(busy)begin
        if(cnt_ns ==time_unit - 1'b1 )begin
          cnt_ns <= 17'd0;
        end
        else begin
          cnt_ns <= cnt_ns + 1'b1;
        end
      end
      else begin
        cnt_ns <= 17'd0;
      end
    end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        cnt_ms <= 10'd0;
      end
      else if(busy)begin
        if(cnt_ns ==time_unit - 1'b1 )begin
          cnt_ms <= cnt_ms + 1'b1;
        end
        else begin
          cnt_ms <= cnt_ms;
        end
      end
      else begin
        cnt_ms <= 10'd0;
      end
    end

        always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        cnt_over_time <= 8'd0;
      end
      else if(busy)begin
        if (pos_encoder_signal || neg_encoder_siganl) begin
          cnt_over_time <= 8'd0;
        end
        else if(cnt_ms ==10'd999 && (cnt_ns ==time_unit - 1'b1 ))begin
          cnt_over_time <= cnt_over_time + 1'b1;
        end
        else begin
          cnt_over_time <= cnt_over_time;
        end
      end
      else begin
        cnt_over_time <= 8'd0;
      end
    end



    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        step <= 32'd0;
      end
      else if( clear)begin
        step <= 32'd0;
      end
      else if(pos_encoder_signal || neg_encoder_siganl)begin
        step <= step + 32'd80;                                      //(CIRCLE_STEP / RESOLUTION/2);
      end
      else begin
        step <= step;
      end
    end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        step_record <= 31'd0;
        step_record_d <= 31'd0;
      end
      else if(busy)begin
        if (cnt_ms == 10'd9&&(cnt_ns ==time_unit - 1'b1 )) begin
          step_record <= step;
          step_record_d <= step_record;
        end
        else begin
          step_record <= step_record;
          step_record_d <= step_record_d;
        end
      end
      else begin
        step_record <= 31'd0;
        step_record_d <= 31'd0;
      end
    end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        speed <= 32'd0;
      end
      else begin
        speed <= step_record - step_record_d ;
      end
    end
                                                                   
endmodule
