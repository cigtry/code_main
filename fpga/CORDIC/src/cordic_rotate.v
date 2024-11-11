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
// Last modified Date:     2024/10/08 14:33:20 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/08 14:33:20 
// Version:                V1.0 
// TEXT NAME:              cordic.v 
// PATH:                   D:\fuxin\code_main\fpga\CORDIC\src\cordic.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module cordic_rotate(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [  15:00]                       angle           ,
  output reg                                     out_valid       ,
  output reg     [  31:00]                       cos_out         ,
  output reg     [  31:00]                       sin_out          
);



  //旋转角度查找表
  wire           [  31:00]                       rotate_table        [15:00]  ;
  assign                                             rotate_table[0]= 32'd2949120;//45.0000度*2^16
  assign                                             rotate_table[1]= 32'd1740992;//26.5651度*2^16
  assign                                             rotate_table[2]= 32'd919872;//14.0362度*2^16
  assign                                             rotate_table[3]= 32'd466944;//7.1250度*2^16
  assign                                             rotate_table[4]= 32'd234368;//3.5763度*2^16
  assign                                             rotate_table[5]= 32'd117312;//1.7899度*2^16
  assign                                             rotate_table[6]= 32'd58688;//0.8952度*2^16
  assign                                             rotate_table[7]= 32'd29312;//0.4476度*2^16
  assign                                             rotate_table[8]= 32'd14656;//0.2238度*2^16
  assign                                             rotate_table[9]= 32'd7360;//0.1119度*2^16
  assign                                             rotate_table[10]= 32'd3648;//0.0560度*2^16
  assign                                             rotate_table[11]= 32'd1856;//0.0280度*2^16
  assign                                             rotate_table[12]= 32'd896;//0.0140度*2^16
  assign                                             rotate_table[13]= 32'd448;//0.0070度*2^16
  assign                                             rotate_table[14]= 32'd256;//0.0035度*2^16
  assign                                             rotate_table[15]= 32'd128;//0.0018度*2^16

  //状态机
  localparam                                         IDLE           = 3'B001;
  localparam                                         WORK           = 3'b010;
  localparam                                         DONE           = 3'B100;
  reg            [   2: 0]                       state_c,state_n  ;
  reg            [   3: 0]                       cnt             ;
  reg                                            pos_start       ;
  reg           [  31:00]                       angle_d         ;
  reg           [  31:00]                       angle_pre       ;
  reg           [ 01:00]   quadrant;//相位
  //角度值缓存一拍
  always @(posedge clk ) begin
    angle_d <= angle;
  end
  //角度预处理
  always @(posedge clk ) begin
    if (angle_d >= 0 && angle_d < 360) begin
      if (angle_d>=0 && angle_d < 90) begin
        angle_pre <= angle_d;
        quadrant <= 2'b00;
      end
      else if(angle_d>=90 && angle_d < 180)begin
        angle_pre <= angle_d - 90;
        quadrant <= 2'b01;
      end
      else if(angle_d>=180 && angle_d < 270)begin
        angle_pre <= angle_d - 180;
        quadrant <= 2'b10;
      end
      else begin
        angle_pre <= angle_d - 270;
        quadrant <= 2'b11;
      end
    end
    else begin
      angle_pre <= 0;
    end
  end

  //新输入角度值不同开始运算
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pos_start <= 1'b0;
    end
    else if(angle_d != angle_pre)begin
      pos_start <= 1'b1;
    end
    else begin
      pos_start <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state_c <= IDLE;
    end
    else begin
      state_c <= state_n;
    end
  end

  always @(*) begin
    case(state_c)
      IDLE:begin
        if (pos_start) begin
          state_n = WORK;
        end
        else begin
          state_n = state_c;
        end
      end
      WORK:begin
        if (cnt == 4'd15) begin
          state_n = DONE;
        end
        else begin
          state_n = state_c;
        end
      end
      DONE:begin
        state_n = IDLE;
      end
      default:state_n = IDLE;
    endcase
  end

  reg      signed[  31:00]                       x_shift         ;
  reg      signed[  31:00]                       y_shift         ;
  reg      signed[  31:00]                       z_rotate        ;
  wire                                           d_sign          ;
  assign                                             d_sign         = z_rotate[31];

  always @(posedge clk ) begin
    case(state_c)
      IDLE : begin
        x_shift <= 32'h9b59;
        y_shift <= 32'd0;
        z_rotate <= (angle_pre <<< 16);
      end
      WORK : begin
        if (d_sign == 1'b1) begin
          x_shift <= x_shift + (y_shift >>> cnt);
          y_shift <= y_shift - (x_shift >>> cnt);
          z_rotate <= z_rotate + rotate_table[cnt];
        end
        else begin
          x_shift <= x_shift - (y_shift >>> cnt);
          y_shift <= y_shift + (x_shift >>> cnt);
          z_rotate <= z_rotate - rotate_table[cnt];
        end
      end
      DONE : begin
        x_shift <= 32'h9b59;
        y_shift <= 32'd0;
        z_rotate <= (angle_pre <<< 16);
      end
      default: ;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sin_out<= 32'd0;
      cos_out<= 32'd0;
      out_valid <= 1'b0;
    end
    else if (state_n == DONE)begin
      case(quadrant)
        2'b00:begin
          sin_out <= y_shift;
          cos_out <= x_shift;
          out_valid <= 1'b1;
        end
        2'b01:begin
          sin_out <= x_shift ;
          cos_out <= (~y_shift) + 1'b1;
          out_valid <= 1'b1;
        end
        2'b10:begin
          sin_out <= (~y_shift) + 1'b1;
          cos_out <= (~x_shift) + 1'b1;
          out_valid <= 1'b1;
        end
        2'b11:begin
          sin_out <=  (~x_shift) + 1'b1;
          cos_out <= y_shift;
          out_valid <= 1'b1;
        end
        default:begin
          sin_out<= 32'd0;
          cos_out<= 32'd0;
          out_valid <= 1'b0;
        end
      endcase
    end
    else begin
      sin_out <= sin_out ;
      cos_out <= cos_out ;
      out_valid <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt <= 4'd0;
    end
    else if(state_c == IDLE )begin
      cnt <= 4'd0;
    end
    else if(state_c == WORK)begin
      if (cnt < 4'd15) begin
        cnt <= cnt + 1'd1;
      end
      else begin
        cnt <= cnt;
      end
    end
    else begin
      cnt <= 4'd0;
    end
  end

                                                                   
                                                                   
endmodule
