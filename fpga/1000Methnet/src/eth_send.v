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
// Last modified Date:     2024/08/01 16:03:22 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/01 16:03:22 
// Version:                V1.0 
// TEXT NAME:              eth_send.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\eth_send.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module eth_send(
  input                                          rst_n           ,
  input                                          gmii_tx_clk     ,
  output reg     [   7: 0]                       gmii_tx_data    ,
  output reg                                     gmii_txen       ,
  output reg                                     gmii_txer       ,
  input                                          tx_start        ,
  input          [  47:00]                       r_des_mac       ,//目的mac地址
  input          [  47:00]                       src_mac         ,//源mac地址
  input          [  15:00]                       r_type_length   ,//以太网类型/长度
  input          [  31:00]                       crc_result      ,//crc校验结果
  input          [  10:00]                       data_length     ,//数据长度
  input          [   7: 0]                       data_in         ,//要发送的数据
  output                                         data_req         //数据发送请求

);
//parameter define

//reg define
  reg            [   5: 0]                       cnt             ;
  reg            [  10:00]                       data_num        ;

//wire define	
  wire                                           en_tx_data      ;
//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  //帧中数据发送使能信号
  assign                                             en_tx_data     = (cnt==23)&&(data_num > 1);

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      gmii_tx_data <= #1 8'd0;
    end
    else begin
      case(cnt)
        1,2,3,4,5,6,7:gmii_tx_data <=  8'h55;                       //前导码
        8:gmii_tx_data <= 8'hd5;                                    //分隔符

        //目的mac地址
        9:gmii_tx_data <= r_des_mac [47:40];
        10:gmii_tx_data <= r_des_mac[39:32];
        11:gmii_tx_data <= r_des_mac[31:24];
        12:gmii_tx_data <= r_des_mac[23:16];
        13:gmii_tx_data <= r_des_mac[15:8];
        14:gmii_tx_data <= r_des_mac[7:0];
        //源mac地址
        15:gmii_tx_data <= src_mac [47:40];
        16:gmii_tx_data <= src_mac[39:32];
        17:gmii_tx_data <= src_mac[31:24];
        18:gmii_tx_data <= src_mac[23:16];
        19:gmii_tx_data <= src_mac[15:8];
        20:gmii_tx_data <= src_mac[7:0];
        //以太网帧类型/长度
        21:gmii_tx_data <= r_type_length[15:8];
        22:gmii_tx_data <= r_type_length[7:0];
        //发送数据
        23:gmii_tx_data <= data_in;

        //发送crc校验结果
        24:gmii_tx_data <= crc_result[31:24];
        25:gmii_tx_data <= crc_result[23:16];
        26:gmii_tx_data <= crc_result[15:8];
        27:gmii_tx_data <= crc_result[7:0];

        28:gmii_tx_data <= 8'd0;
        default:gmii_tx_data <= 8'd0;
      endcase
    end
  end

  //待发送数据计数器，每发送一个数据段中的数据，该计数器减一
    always @(posedge gmii_tx_clk or negedge rst_n) begin
      if (!rst_n) begin
        data_num <= 11'd0;
      end
      else if(tx_start)begin
        data_num <= data_length;
      end
      else if(en_tx_data)begin
        data_num <= data_num - 11'd1;
      end
      else begin
        data_num <= data_num;
      end
    end

  //根据发送启动信号产生内部发送使能信号
    always @(posedge gmii_tx_clk or negedge rst_n) begin
      if (!rst_n) begin
        gmii_txen <= 1'b0;
      end
      else if(tx_start)begin
        gmii_txen <= 1'b1;
      end
      else if(cnt>=27)begin
        gmii_txen <= 1'b0;
      end
      else begin
        gmii_txen <= gmii_txen;
      end
    end
  
  //序列机计数器
    always @(posedge gmii_tx_clk or negedge rst_n) begin
      if (!rst_n) begin
        cnt <= 6'd0;
      end
      else if(gmii_txen)begin
        if (!en_tx_data) begin
          cnt <= cnt + 6'd1;
        end
        else begin
          cnt <= cnt;
        end
      end
      else begin
        cnt <= 6'd0;
      end
    end

                                                                   
                                                                   
endmodule
