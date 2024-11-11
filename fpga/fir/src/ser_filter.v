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
// Last modified Date:     2024/10/15 15:21:58 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/15 15:21:58 
// Version:                V1.0 
// TEXT NAME:              ser_filter.v 
// PATH:                   D:\fuxin\code_main\fpga\fir\src\ser_filter.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ser_filter#(
  parameter                                          IDATA_WIDTH    = 16     ,//输入数据位宽
  parameter                                          PDATA_WIDTH    = IDATA_WIDTH + 1    ,//处理数据位宽
  parameter                                          FIR_TAP        = 30    ,//FTR抽头
  parameter                                          COEFF_WIDTH    = 16    ,//系数位宽
  parameter                                          OUT_WIDTH      = 16    //输出位宽
)(
  input                                          clk             ,//时钟频率为数据频率的4倍
  input                                          rst_n           ,
  input       signed[IDATA_WIDTH - 1 : 00]          filter_in       ,
  output reg  signed[OUT_WIDTH -1 :00]              filter_out       
);
//抽头系数
  wire     signed[COEFF_WIDTH - 1 : 00]          coeff               [(FIR_TAP>>1) - 1 : 00]  ;
  assign                                             coeff[0]       = 16'd169;
  assign                                             coeff[1]       = 16'd468;
  assign                                             coeff[2]       = 16'd1050;
  assign                                             coeff[3]       = 16'd2015;
  assign                                             coeff[4]       = 16'd3467;
  assign                                             coeff[5]       = 16'd5484;
  assign                                             coeff[6]       = 16'd8098;
  assign                                             coeff[7]       = 16'd11274;
  assign                                             coeff[8]       = 16'd14904;
  assign                                             coeff[9]       = 16'd18800;
  assign                                             coeff[10]      = 16'd22710;
  assign                                             coeff[11]      = 16'd26343;
  assign                                             coeff[12]      = 16'd29399;
  assign                                             coeff[13]      = 16'd31608;
  assign                                             coeff[14]      = 16'd32767;

//输入信号寄存
  reg      signed[IDATA_WIDTH - 1 : 00]          filter_in_reg   ;
//存储抽头个数对应的数据
  reg      signed[IDATA_WIDTH - 1 : 00]          shift_buf           [FIR_TAP - 1 : 00]  ;
//抽头系数对称 ，先将对应位置相加再做乘法运算减少乘法器使用数量
  reg      signed[PDATA_WIDTH - 1 : 00]          add_data            [(FIR_TAP>>1) - 1 : 00 ]  ;
//串行fir滤波器需要将时钟扩大至采样时钟的抽头系数/2倍，才可以在下一个周期输出有效数据
  reg      signed[COEFF_WIDTH - 1 : 00]          cof_reg_maca    ;
  reg      signed[PDATA_WIDTH - 1 : 00]          add_reg_macb    ;
  wire     signed[COEFF_WIDTH + PDATA_WIDTH - 1 : 00]result      ;
  reg      signed[  31:00]                       sum             ;
  reg            [ $clog2((FIR_TAP>>1)) - 1:00]  count           ;
  integer                                        i,j, k             ;


//将数据存入移位寄存器中
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for (i = 0; i <= FIR_TAP - 1;i = i + 1 ) begin
        shift_buf[i] <= {IDATA_WIDTH{1'b0}};
      end
    end
    else begin
      if (count == ((FIR_TAP>>1) - 1)) begin
        for (j = 0; j < FIR_TAP - 1; j = j + 1) begin
          shift_buf[j+1] <= shift_buf[j];
        end
        shift_buf[0] <= filter_in;
      end
    end
  end                                                               //always end
  
//将对称系数的输入数据相加，以FIR_TAP/2倍的数据输入时钟速率
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for (k = 0; k <= (FIR_TAP>>1) - 1; k = k + 1) begin
        add_data[k] <= {PDATA_WIDTH{1'b0}};
      end
    end
    else if(count == ((FIR_TAP>>1) - 1))begin
      for (k = 0; k <= (FIR_TAP>>1) - 1; k = k + 1) begin
        add_data[k] <= shift_buf[k]+shift_buf[FIR_TAP-1-k];
      end
    end
    else begin
      for (k = 0; k <= (FIR_TAP>>1) - 1; k = k + 1) begin
        add_data[k] <=add_data[k];
      end
    end
  end                                                               //always end
  

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      count <= {$clog2((FIR_TAP>>1)){1'b0}};
    end
    else begin
      if (count == (FIR_TAP>>1) - 1) begin
        count <= {$clog2((FIR_TAP>>1)){1'b0}};
      end
      else begin
        count <= count + 1'b1;
      end
    end
  end                                                               //always end
  
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      cof_reg_maca  <= {COEFF_WIDTH{1'b0}};
      add_reg_macb  <= {PDATA_WIDTH{1'b0}};
    end
    else begin
      if (count <= (FIR_TAP>>1) -1 ) begin
        cof_reg_maca <= coeff[count];
        add_reg_macb <= add_data[count];
      end
      else begin
        cof_reg_maca <= {COEFF_WIDTH{1'b0}} ;
        add_reg_macb <= {PDATA_WIDTH{1'b0}} ;
      end
    end
  end                                                               //always end

//调用乘法器时需要在count==2时将sum值赋给输出，同时将其置为result 因为乘法器的输出有一个时钟周期的延迟
// mult u_mult (
// .CLK                                               (clk            ),// input wire CLK
// .A                                                 (cof_reg_maca   ),// input wire [13 : 0] A
// .B                                                 (add_reg_macb   ),// input wire [9 : 0] B
// .P                                                 (result         ) // output wire [23 : 0] P
// );
// //不调用乘法器时需要在count==1时将sum值赋给输出，同时将其置为result 这里count为1是因为加法延迟了一个时钟周期
  assign  result = cof_reg_maca * add_reg_macb;


  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      sum <= 32'b0;
    end
    else begin
      if (count == 1) begin
        sum <= result;
      end
      else begin
        sum <= sum + result;
      end
    end
  end                                                               //always end
  
  reg  [31:00]  filter_data;
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      filter_data <= 32'b0;
    end
    else begin
      if (count == 1) begin 
        filter_data <=  sum ;
      end
      else begin
        filter_data <= filter_data;
      end
    end
  end                                                               //always end
  
  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      filter_out <= {OUT_WIDTH{1'b0}};
    end  
    else begin  
      filter_out <= (filter_data[31:00] + {filter_data[32-OUT_WIDTH],{(31-OUT_WIDTH){~filter_data[(32-OUT_WIDTH)]}}})>>>(32-OUT_WIDTH);
    end  
  end //always end
  
  
                                                                   
                                                                   
endmodule