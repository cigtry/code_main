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
// Last modified Date:     2024/06/18 17:11:12 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/18 17:11:12 
// Version:                V1.0 
// TEXT NAME:              motor_reg.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\motor\motor_reg.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module motor_reg(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  07:00]                       avs_address     ,
  input                                          avs_write       ,
  input          [  31:00]                       avs_write_data  ,
  input                                          avs_read        ,
  output reg     [  31:00]                       avs_read_data   ,
  //电机基础参数部分      
  output reg                                     start           ,//电机启动信号
  output reg                                     stop            ,//电机停止信号
  output reg                                     dec             ,//电机减速信号
  output reg     [  31:00]                       acc             ,//加速度
  output reg     [  15:00]                       start_speed     ,//初速度
  output reg     [  31:00]                       max_speed       ,//最大速度
  output reg     [  31:00]                       offset_speed    ,//是复位速度
  output reg     [  31:00]                       target_speed    ,//速度模式目标速度
  output reg     [  31:00]                       position_set    ,//运动距离
  output reg     [  10:00]                       zero_position   ,//电机复位原点位置，离光电边沿的距离
  output reg     [  10:00]                       liquid_position ,//电机正常复位，需要先匀速提出液面的距离
  output reg                                     set_dir         ,//初始方向（正向以此为准）
  output reg                                     opt_level       ,
  output reg                                     coe_enable      ,
  //电机运动控制部分      
  output reg     [  04:00]                       move_mode       ,//电机运动模式
  //电机反馈部分
  input  wire signed[  31:00]                       abs_position    ,//电机绝对位置反馈（虚拟编码器）
  output reg  signed[  31:00]                       abs_set_position,//电机初始位置设置
  output reg                                     abs_position_set_flag,//电机初始位置使能信号
  input  wire                                    limit_signal_delay,//存储电机完成时的光电状态
  input  wire    [  04:00]                       error_data       

);
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      start                 <= 1'b0;
      stop                  <= 1'b0;
      dec                   <= 1'b0;
      acc                   <= 32'b0;
      start_speed           <= 16'b0;
      max_speed             <= 32'b0;
      offset_speed          <= 32'b0;
      target_speed          <= 32'b0;
      position_set          <= 32'b0;
      zero_position         <= {11   {1'b0}};
      liquid_position       <= {11   {1'b0}};
      set_dir               <= 1'b0;
      move_mode             <= 5'd0;
      abs_set_position      <= 32'b0;
      abs_position_set_flag <= 1'b0;
    end
    else if(avs_write)begin
      case (avs_address)
        8'h00:begin
          move_mode <=  avs_write_data[15:00];
        end
        8'h01:begin
          acc <= avs_write_data;
        end
        8'h02:begin
          start_speed <= avs_write_data[15:00];
        end
        8'h03:begin
          max_speed   <= avs_write_data;
        end
        8'h04:begin
          offset_speed   <= avs_write_data;
        end
        8'h05:begin
          target_speed   <= avs_write_data;
        end
        8'h06:begin
          position_set   <= avs_write_data;
        end
        8'h07:begin
          zero_position   <= avs_write_data[11:00];
        end
        8'h08:begin
          liquid_position   <= avs_write_data[11:00];
        end
        8'h09:begin
          abs_set_position   <= avs_write_data;
        end
        8'h0a:begin
          abs_position_set_flag   <= avs_write_data[0];
        end
        8'h0b:begin
          opt_level   <= avs_write_data[0];
        end
        8'h0c:begin
          coe_enable  <=  avs_write_data[0] ;
        end
        8'h0d:begin
          set_dir  <=  avs_write_data[0] ;
        end
        8'h0e:begin
          start  <=  avs_write_data[0] ;
        end
        8'h0f:begin
          stop  <=  avs_write_data[0] ;
        end
        8'h10:begin
          dec <= avs_write_data[0];
        end
        default:;
      endcase
    end
    else begin
      start                 <= 1'b0;
      stop                  <= 1'b0;
      dec                   <= 1'b0;
      abs_position_set_flag <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      avs_read_data <= 32'h0;
    end
    else if(avs_read  )begin
      case (avs_address)
        8'h00:begin
          avs_read_data <= {move_mode,abs_position_set_flag,opt_level,coe_enable,set_dir,start,stop};
        end
        8'h01:begin
          avs_read_data <= acc ;
        end
        8'h02:begin
          avs_read_data <= start_speed ;
        end
        8'h03:begin
          avs_read_data <= max_speed  ;
        end
        8'h04:begin
          avs_read_data <= offset_speed  ;
        end
        8'h05:begin
          avs_read_data <= target_speed   ;
        end
        8'h06:begin
         avs_read_data <= position_set  ;
        end
        8'h07:begin
          avs_read_data <= zero_position  ;
        end
        8'h08:begin
          avs_read_data <= liquid_position  ;
        end
        8'h09:begin
          avs_read_data <=  abs_set_position ;
        end
        8'h0a:begin
          avs_read_data <=  {29'b0,error_data} ;
        end
        8'h0b:begin
          avs_read_data <=  abs_position ;
        end
        default: ;
      endcase
    end
    else begin
      
    end
  end                                                               //always end
                                                                   
                                                                   
endmodule
