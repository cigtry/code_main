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
// Last modified Date:     2024/08/01 17:36:30 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/01 17:36:30 
// Version:                V1.0 
// TEXT NAME:              check_sum.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\check_sum.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module check_sum(
  input          [  03:00]                       ver             ,//版本
  input          [  03:00]                       hdr_len         ,//首部长度
  input          [  07:00]                       tos             ,//服务类型
  input          [  15:00]                       total_len       ,//ip报文总长
  input          [  15:00]                       id              ,//分段表示
  input          [  15:00]                       offset          ,//偏移
  input          [  07:00]                       ttl             ,//生存周期
  input          [  07:00]                       protocol        ,//上层协议类型
  input          [  31:00]                       src_ip          ,//源ip地址
  input          [  31:00]                       dst_ip          ,//目的ip地址
  output         [  15:00]                       checksum_result  //校验和
);
  wire           [  31:00]                       sum_a,sum_b     ;
  assign                                             sum_a          = {ver,hdr_len,tos}+total_len+id+offset+{ttl,protocol}+src_ip[31:16]+src_ip[15:00]+dst_ip[31:16]+dst_ip[15:00];
  assign                                             sum_b          = (sum_a[31:16]+sum_a[15:00]);
  assign                                             checksum_result= sum_b[31:16] ? ~(sum_b[31:16] + sum_b[15:00]) : ~sum_b[15:00];
endmodule
