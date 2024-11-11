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
// Last modified Date:     2024/07/30 15:08:57 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/30 15:08:57 
// Version:                V1.0 
// TEXT NAME:              ddr3_test.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_test.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_test#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128    ,//数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 28      //地址位宽
)(
  input                                          init_calib_complete,
  input                                          rst_n           ,
  //串口图片输入
  input          [  15:00]                       bit16_out       ,//rgb565输入
  input                                          bit16_out_vld   ,

  //video_driver信号
  output reg                                     post_img_vsync  ,
  output reg                                     post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output         [  23:00]                       post_img_data   ,
  //ddr3 native fifo 接口
    //写fifo
  input                                          wr_clk          ,
  output reg                                     wr_req          ,
  output reg     [ADDR_WIDTH - 1 : 0]            wr_address_beign,
  output reg     [ADDR_WIDTH - 1 : 0]            wr_address_end  ,
  output reg     [DATA_IN_WIDTH - 1 : 0]         wr_din          ,
  output reg                                     wr_din_vld      ,
    //读fifo
  input                                          rd_clk          ,
  output reg                                     rd_req          ,
  output reg     [ADDR_WIDTH - 1 : 0]            rd_address_beign,
  output reg     [ADDR_WIDTH - 1 : 0]            rd_address_end  ,
  input          [DATA_IN_WIDTH - 1 : 0]         rd_dout         ,
  input                                          rd_dout_vld      
);
  //parameter define
  localparam                                         DATA_NUM       = 29'h7_5300;//1280*720
  localparam                                         DELAY_TIME     = 500   ;
  //reg define
  reg            [  09:00]                       cnt_delay       ;
  reg                                        show_en                    ;
  //wire define	

    wire                                       img_hsync                  ;
    wire                                       img_vsync                  ;
    wire                                       img_valid                  ;
    wire                      [  15: 0]        img_data                   ;
  //*********************************************************************************************
  //**                    main code
  //**********************************************************************************************
    assign post_img_data =post_img_valid ? {8'b0,img_data} : 24'b0;//{img_data[15:11],3'b0,img_data[10:5],2'b0,img_data[4:0],3'b0} : 24'b0;

  always @(posedge wr_clk ) begin
    if (!rst_n) begin
      cnt_delay <= 10'd0;
    end
    else if(init_calib_complete)begin
      if (cnt_delay == DELAY_TIME - 10'd1) begin
        cnt_delay <= cnt_delay;
      end
      else begin
        cnt_delay <= cnt_delay + 10'd1;
      end
    end
    else begin
      cnt_delay <= 10'd0;
    end
  end
  always @(posedge wr_clk ) begin
    if (!rst_n) begin
      wr_req          <=  1'b0 ;
      wr_address_beign<=  {ADDR_WIDTH{1'b0}} ;
      wr_address_end  <=  {ADDR_WIDTH{1'b0}} ;
      wr_din          <=  {DATA_IN_WIDTH{1'b0}} ;
      wr_din_vld      <=  1'b0 ;
    end
    else if(init_calib_complete)begin
      if ((cnt_delay == DELAY_TIME - 10'd2)) begin
        wr_req          <=  1'b1 ;
        wr_address_beign<=  29'h0100_0000 ;
        wr_address_end  <=  29'h0100_0000  +  DATA_NUM;
        wr_din          <=  {DATA_IN_WIDTH{1'b0}} ;
        wr_din_vld      <=  1'b0 ;
      end
      else begin
        wr_req          <=  1'b0 ;
        wr_address_beign<= wr_address_beign ;
        wr_address_end  <=  wr_address_end;
        wr_din          <=  bit16_out ;
        wr_din_vld      <=  bit16_out_vld ;
      end
    end
    else begin
      wr_req          <=  1'b0 ;
      wr_address_beign<=  {ADDR_WIDTH{1'b0}} ;
      wr_address_end  <=  {ADDR_WIDTH{1'b0}} ;
      wr_din          <=  {DATA_IN_WIDTH{1'b0}} ;
      wr_din_vld      <=  1'b0 ;
    end
  end

  always @(posedge rd_clk ) begin
    if (!rst_n) begin
      rd_req           <= 1'b0 ;
      rd_address_beign <= {ADDR_WIDTH{1'b0}} ;
      rd_address_end   <= {ADDR_WIDTH{1'b0}} ;
      show_en <= 1'b0;
    end
    else if(init_calib_complete)begin
      rd_req <= img_valid;
      show_en <= 1'b1;
      rd_address_beign <= 29'h0100_0000 ;
      rd_address_end   <= 29'h0100_0000  +  DATA_NUM;
    end
    else begin
      rd_req           <= 1'b0 ;
      show_en <= show_en;
      rd_address_beign <= {ADDR_WIDTH{1'b0}} ;
      rd_address_end   <= {ADDR_WIDTH{1'b0}} ;
    end
  end

  always @(posedge rd_clk ) begin
    
    post_img_vsync  <= img_vsync ;
    post_img_hsync  <= img_hsync ;
    post_img_valid  <=  img_valid && rd_dout_vld;
  end






video_driver u_video_driver(
    .pixel_clk                          (rd_clk                 ),
    .sys_rst_n                          (init_calib_complete                 ),
    .show_en                            (show_en                   ),
    //RGB接口
    .img_hsync                          (img_hsync                 ), // 行同步信号
    .img_vsync                          (img_vsync                 ), // 场同步信号
    .img_valid                          (img_valid                 ), // 数据使能
    .img_data                           (img_data                  ), // RGB888颜色数据
    .pixel_data                         (rd_dout                ) // 像素点数据
);

                                                                   
                                                                   
endmodule
