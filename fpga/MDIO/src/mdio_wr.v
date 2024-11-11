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
// Last modified Date:     2024/08/06 14:19:57 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/06 14:19:57 
// Version:                V1.0 
// TEXT NAME:              mdio_wr.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\MDIO\src\mdio_wr.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module mdio_wr(
  input                                          mdc             ,//mdio时钟接口
  input                                          rst_n           ,//模块复位信号,低电平有效
  input                                          start           ,//开始传输数据
  input                                          wr_cmd          ,//读写控制,1:read 0:wirte
  input          [  04:00]                       phy_addr        ,//5位的phy地址输入信号，最高2位为0
  input          [  04:00]                       reg_addr        ,//5位的reg地址输入信号
  input          [  15:00]                       wr_data         ,//写入phy寄存器的16位数据
  inout                                          mdio            ,//数据接口
  output reg                                     done            ,//操作完成标志
  output reg     [  15:00]                       rd_data          //从phy寄存器读取的16位数据
);
//parameter define
  localparam                                         IDLE           = 8'h01 ;
  localparam                                         PRE            = 8'h02 ;
  localparam                                         ST             = 8'h04 ;
  localparam                                         OP             = 8'h08 ;
  localparam                                         PHYAD          = 8'h10 ;
  localparam                                         REGAD          = 8'h20 ;
  localparam                                         TA             = 8'h40 ;
  localparam                                         DATA           = 8'h80 ;
//reg define
  reg                                            mdio_o          ;
  reg                                            mdio_oe         ;
  reg            [  07:00]                       state           ;
  reg            [  05:00]                       cnt             ;
//wire define	  
  assign  mdio = mdio_oe ? mdio_o : 1'bz;

//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  always @(posedge mdc or negedge rst_n)begin
    if (!rst_n) begin
      state <= IDLE;
      cnt <= 6'd0;
      mdio_o <= 1'b0;
      mdio_oe <= 1'b0;
      done <= 1'b0;
      rd_data <= 16'h00_00;
    end
    else begin
      case(state)
        IDLE     :begin
          mdio_o <= 1'b1;
          mdio_oe<=1'b0;
          done <= 1'b0;
          rd_data<=16'h00_00;
          if (start) begin
            cnt <= 6'd0;
            state = PRE;
          end
        end
        PRE      :begin
          mdio_o <= 1'b1;
          mdio_oe<=1'b1;
          done <= 1'b0;
          rd_data<=16'h00_00;
          cnt <= cnt + 1'b1;
          if(cnt > 6'd30)begin
            cnt <= 6'd0;
            state <= ST;
            mdio_o <= 1'b0;
          end
        end
        ST       :begin
          mdio_o <= 1'b1;
          mdio_oe<=1'b1;
          done <= 1'b0;
          rd_data<=16'h00_00;
          cnt <= cnt + 1'b1;
          if(cnt >= 6'd1)begin
            cnt <= 6'd0;
            state <= OP;
            mdio_o <= wr_cmd;
          end
        end
        OP       :begin
          mdio_o <= !wr_cmd;
          mdio_oe<=1'b1;
          done <= 1'b0;
          rd_data<=16'h00_00;
          cnt <= cnt + 1'b1;
          if(cnt >= 6'd1)begin
            cnt <= 6'd0;
            state <= PHYAD;
            mdio_o <= phy_addr[4];
          end
        end
        PHYAD    :begin
          mdio_oe<=1'b1;
          done <= 1'b0;
          rd_data<=16'h00_00;
          cnt <= cnt + 1'b1;
          if(cnt >= 6'd4)begin
            cnt <= 6'd0;
            state <= REGAD;
            mdio_o <= reg_addr[4];
          end
          else begin
            mdio_o <= phy_addr[4- cnt[2:0] - 1'b1];
          end
        end
        REGAD    :begin
          done <= 1'b0;
          rd_data<=16'h00_00;
          cnt <= cnt + 1'b1;
          if(cnt >= 6'd4)begin
            cnt <= 6'd0;
            state <= TA;
            mdio_o <= !wr_cmd;
            mdio_oe<= !wr_cmd;
          end
          else begin
            mdio_o <= reg_addr[4- cnt[2:0] - 1'b1];
          end
        end
        TA       :begin
          mdio_o <= 1'b0;
          cnt <= cnt + 1'b1;
          if (cnt >= 6'd1) begin
            cnt <= 6'd0;
            state <= DATA;
            mdio_o <= wr_data[15];
          end
        end
        DATA     :begin
          cnt <= cnt + 1'b1;
          if (cnt < 6'd15) begin
            if (wr_cmd) begin
              rd_data <= {rd_data[14:00],mdio};
            end
            else begin
              mdio_o <= wr_data[15 - cnt[3:0] - 1];
            end
          end
          else begin
            cnt <= 'd0;
            state <= IDLE;
            mdio_o <= 1'b1;
            mdio_oe <= 1'b0;
            done <= 1'b1;
          end
        end
        default:;
      endcase
    end
  end
                                                                   
                                                                   
endmodule
