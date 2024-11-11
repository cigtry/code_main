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
// Last modified Date:     2024/10/16 14:52:21 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/16 14:52:21 
// Version:                V1.0 
// TEXT NAME:              per_filter.v 
// PATH:                   D:\fuxin\code_main\fpga\fir\src\per_filter.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module per_filter#(
  parameter                                          IDATA_WIDTH    = 16     ,//输入数据位宽
  parameter                                          PDATA_WIDTH    = IDATA_WIDTH + 1     ,//处理数据位宽
  parameter                                          FIR_TAP        = 128    ,//FTR抽头
  parameter                                          COEFF_WIDTH    = 16    ,//系数位宽
  parameter                                          OUT_WIDTH      = 16    //输出位宽
)(
  input                                          clk             ,//时钟频率为数据频率的4倍
  input                                          rst_n           ,
  input       signed[IDATA_WIDTH - 1 : 00]          filter_in       ,
  output reg  signed[OUT_WIDTH -1 :00]              filter_out       
);
  wire     signed[COEFF_WIDTH - 1 : 00]          coeff               [(FIR_TAP>>1) - 1 : 00]  ;
  assign                                             coeff[0]       =            39;
  assign                                             coeff[1]       =            101;
  assign                                             coeff[2]       =            208;
  assign                                             coeff[3]       =            355;
  assign                                             coeff[4]       =            526;
  assign                                             coeff[5]       =            688;
  assign                                             coeff[6]       =            797;
  assign                                             coeff[7]       =            806;
  assign                                             coeff[8]       =            682;
  assign                                             coeff[9]       =            421;
  assign                                             coeff[10]       =             51;
  assign                                             coeff[11]       =           -360;
  assign                                             coeff[12]       =           -724;
  assign                                             coeff[13]       =           -949;
  assign                                             coeff[14]       =           -975;
  assign                                             coeff[15]       =           -788;
  assign                                             coeff[16]       =           -437;
  assign                                             coeff[17]       =            -25;
  assign                                             coeff[18]       =            322;
  assign                                             coeff[19]       =            485;
  assign                                             coeff[20]       =            402;
  assign                                             coeff[21]       =             87;
  assign                                             coeff[22]       =           -365;
  assign                                             coeff[23]       =           -802;
  assign                                             coeff[24]       =          -1064;
  assign                                             coeff[25]       =          -1039;
  assign                                             coeff[26]       =           -707;
  assign                                             coeff[27]       =           -156;
  assign                                             coeff[28]       =            437;
  assign                                             coeff[29]       =            863;
  assign                                             coeff[30]       =            950;
  assign                                             coeff[31]       =            634;
  assign                                             coeff[32]       =            -11;
  assign                                             coeff[33]       =           -781;
  assign                                             coeff[34]       =          -1403;
  assign                                             coeff[35]       =          -1632;
  assign                                             coeff[36]       =          -1335;
  assign                                             coeff[37]       =           -563;
  assign                                             coeff[38]       =            456;
  assign                                             coeff[39]       =           1374;
  assign                                             coeff[40]       =           1839;
  assign                                             coeff[41]       =           1625;
  assign                                             coeff[42]       =            728;
  assign                                             coeff[43]       =           -605;
  assign                                             coeff[44]       =          -1932;
  assign                                             coeff[45]       =          -2756;
  assign                                             coeff[46]       =          -2699;
  assign                                             coeff[47]       =          -1652;
  assign                                             coeff[48]       =            143;
  assign                                             coeff[49]       =           2130;
  assign                                             coeff[50]       =           3595;
  assign                                             coeff[51]       =           3896;
  assign                                             coeff[52]       =           2702;
  assign                                             coeff[53]       =            161;
  assign                                             coeff[54]       =          -3062;
  assign                                             coeff[55]       =          -5911;
  assign                                             coeff[56]       =          -7211;
  assign                                             coeff[57]       =          -6001;
  assign                                             coeff[58]       =          -1851;
  assign                                             coeff[59]       =           4951;
  assign                                             coeff[60]       =          13392;
  assign                                             coeff[61]       =          21936;
  assign                                             coeff[62]       =          28879;
  assign                                             coeff[63]       =          32767;
  reg      signed[IDATA_WIDTH - 1 : 00]          filter_in_reg   ;

  reg      signed[IDATA_WIDTH - 1 : 00]          shift_buf           [FIR_TAP - 1 : 00]  ;
  reg      signed[PDATA_WIDTH - 1 : 00]          add_data            [(FIR_TAP>>1) - 1 : 00 ]  ;

  wire     signed[COEFF_WIDTH + PDATA_WIDTH - 1 : 00]result  [(FIR_TAP>>1) - 1 : 00]    ;
  reg      signed[  31:00]                       sum             ;
  integer                                        i,k             ;

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      filter_in_reg <={IDATA_WIDTH {1'b0}};
    end
    else begin
      filter_in_reg <= filter_in;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for (i = 0; i<=FIR_TAP - 1;i=i+1 ) begin
        shift_buf[i] <= {PDATA_WIDTH{1'b0}};
      end
    end
    else begin
      for (i = 0; i<FIR_TAP - 1; i=i+1) begin
        shift_buf[i+1] <= shift_buf[i];
        shift_buf[0] <= filter_in_reg;
      end
    end
  end                                                               //always end
  

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for (k = 0; k <= (FIR_TAP>>1) - 1; k = k + 1) begin
        add_data[k] <= {PDATA_WIDTH{1'b0}};
      end
    end
    else begin
      for (k = 0; k <= (FIR_TAP>>1) - 1; k = k + 1) begin
        add_data[k] <= shift_buf[k]+shift_buf[FIR_TAP-1-k];
      end
    end
  end                                                               //always end
  genvar j;
  generate
    for ( j= 0;j<= (FIR_TAP>>1) - 1; j=j+1) begin
      assign  result [j]=add_data[j] * coeff[j] ;
    end
  endgenerate
  


  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      sum <= 32'b0;
    end
    else begin
        sum <= result[0]
              +result[1]
              +result[2]
              +result[3]
              +result[4]
              +result[5]
              +result[6]
              +result[7]
              +result[8]
              +result[9]
              +result[10]
              +result[11]
              +result[12]
              +result[13]
              +result[14]
              +result[15]
              +result[16]
              +result[17]
              +result[18]
              +result[19]
              +result[20]
              +result[21]
              +result[22]
              +result[23]
              +result[24]
              +result[25]
              +result[26]
              +result[27]
              +result[28]
              +result[29]
              +result[30]
              +result[31]
              +result[32]
              +result[33]
              +result[34]
              +result[35]
              +result[36]
              +result[37]
              +result[38]
              +result[39]
              +result[40]
              +result[41]
              +result[42]
              +result[43]
              +result[44]
              +result[45]
              +result[46]
              +result[47]
              +result[48]
              +result[49]
              +result[50]
              +result[51]
              +result[52]
              +result[53]
              +result[54]
              +result[55]
              +result[56]
              +result[57]
              +result[58]
              +result[59]
              +result[60]
              +result[61]
              +result[62]
              +result[63];
    end
  end                                                               //always end
  

  
  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      filter_out <= {OUT_WIDTH{1'b0}};
    end  
    else begin  
      filter_out <= (sum[31:00] + {sum[32-OUT_WIDTH],{(31-OUT_WIDTH){~sum[(32-OUT_WIDTH)]}}})>>>(32-OUT_WIDTH);
    end  
  end //always end
  
  
                                                                   
                                                                   
endmodule