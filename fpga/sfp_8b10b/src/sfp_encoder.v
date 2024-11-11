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
// Last modified Date:     2024/09/20 14:30:22 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/09/20 14:30:22 
// Version:                V1.0 
// TEXT NAME:              sfp_encoder.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\sfp_8b10b\src\sfp_encoder.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module sfp_encoder#(
  parameter                                          VS_POSE_DATA1  = 32'h55a101bc,
  parameter                                          VS_POSE_DATA2  = 32'h55a102bc,
  parameter                                          DATA_START1    = 32'h55a105bc,
  parameter                                          DATA_START2    = 32'h55a106bc,
  parameter                                          DATA_END1      = 32'h55a107bc,
  parameter                                          DATA_END2      = 32'h55a108bc,
  parameter                                          UNUSE_DATA     = 32'h55a109bc
 )(
  input  wire                                    clk_in          ,
  input  wire                                    rst_n           ,
  input  wire                                    vs_in           ,
  input  wire                                    data_valid_in   ,
  input  wire    [  15:00]                       data_in         ,
  input  wire                                    tx_clk          ,//光口tx端时钟
  input  wire                                    tx_rst_n        ,
  output reg     [  03:00]                       gt_txcharisk    ,//光口tx端k码发送信号
  output reg     [  31:00]                       gt_txdata        
);
//parameter define
  localparam                                         TX_UNUSE_DATA  = 8'B0000_0001;
  localparam                                         TX_VS_POSE1    = 8'B0000_0010;
  localparam                                         TX_VS_POSE2    = 8'B0000_0100;
  localparam                                         TX_DATA_START1 = 8'B0000_1000;
  localparam                                         TX_DATA_START2 = 8'B0001_0000;
  localparam                                         TX_SEND_DATA   = 8'B0010_0000;
  localparam                                         TX_DATA_END1   = 8'B0100_0000;
  localparam                                         TX_DATA_END2   = 8'B1000_0000;
//reg define
  reg                                            vs_in_d0        ;
  reg                                            vs_in_d1        ;
  reg                                            data_valid_in_d0  ;
  reg            [  15:00]                       data_in_d0      ;
  reg                                            vs_pose         ;
  reg            [  07:00]                       state           ;
  reg            [  07:00]                       cnt_data        ;
  reg                                            fifo_rd_en      ;
  reg            [  07:00]                       cnt_fifo_rst    ;
  reg                                            fifo_rst        ;
  reg                                            data_start      ;
  reg                                            data_start_d0   ;
//wire define	
  wire           [  31:00]                       fifo_dout       ;
  wire                                           fifo_empty      ;
  wire                                           fifo_almost_empty  ;
  wire           [  09:00]                       rd_data_count   ;
  wire           [  09:00]                       fifo_threshold_value  ;
//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  assign                                             fifo_threshold_value= 10'd500;

//对输入数据寄存
always @(posedge clk_in or negedge rst_n ) begin
  if (!rst_n) begin
    data_valid_in_d0 <= 1'b0;
    data_in_d0 <= 16'd0;
  end
  else begin
    data_valid_in_d0 <= data_valid_in;
    data_in_d0 <= data_in;
  end
end

//对输入信号进行跨时钟域处理
always @(posedge tx_clk or negedge tx_rst_n ) begin
  if(!tx_rst_n)begin
    vs_in_d0 <= 1'b0;
    vs_in_d1 <= 1'b0;
  end
  else begin
    vs_in_d0 <= vs_in;
    vs_in_d1 <= vs_in_d0;
  end
end

always @(posedge tx_clk or negedge tx_rst_n ) begin
  if(!tx_rst_n)begin
    data_start_d0 <= 1'b0;
  end
  else begin
    data_start_d0 <= data_start;
  end
end

//产生场信号上升沿
always @(posedge tx_clk or negedge tx_rst_n ) begin
  if(!tx_rst_n)begin
    vs_pose <= 1'b0;
  end
  else if(vs_in_d0 && ~vs_in_d1)begin
    vs_pose <= 1'b1;
  end
  else begin
    vs_pose <= 1'b0;
  end
end

//数据发送开始信号
always @(posedge tx_clk or negedge tx_rst_n ) begin
  if(!tx_rst_n)begin
    data_start <= 1'b0;
  end
  else if(fifo_empty || vs_pose)begin
    data_start <= 1'b0;
  end
  else if(rd_data_count >= fifo_threshold_value)begin
    data_start <= 1'b1;
  end
  else begin
    data_start <= data_start;
  end
end

//产生tx端k码发送信号和发送数据
always @ (posedge tx_clk or negedge tx_rst_n)begin
  if(!tx_rst_n)begin
    gt_txcharisk  <= 4'd0;
    gt_txdata     <= 32'd0;
    state         <= TX_UNUSE_DATA;
    fifo_rd_en    <= 1'b0;
    cnt_data      <= 8'd0;
  end
  else begin
     if(vs_pose)begin
       gt_txcharisk <= 4'd0;
       gt_txdata <= 32'ha151a252;
       state <= TX_VS_POSE1;
       cnt_data <= 0;
     end
     else if (data_start && ~data_start_d0) begin
       gt_txcharisk <= 4'd0;
       gt_txdata <= 32'ha151a252;
       state <= TX_DATA_START1;
       cnt_data <= 0;
     end
     else begin
       case(state)
          TX_UNUSE_DATA :begin
            cnt_data <= cnt_data + 1'd1;
            fifo_rd_en <= 1'b0;
            if (cnt_data == 8'd255) begin
              gt_txcharisk <= 4'd1;
              gt_txdata <= UNUSE_DATA;
              state <= TX_UNUSE_DATA;
            end
            else begin
              gt_txcharisk <= 4'd0;
              gt_txdata <= 32'ha151a252;
              state <= TX_UNUSE_DATA;
            end
          end
          TX_VS_POSE1   :begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= VS_POSE_DATA1;
            state <= TX_VS_POSE2;
            fifo_rd_en <= 1'b0;
          end
          TX_VS_POSE2   :begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= VS_POSE_DATA2;
            state <= TX_UNUSE_DATA;
            fifo_rd_en <= 1'b0;
          end
          TX_DATA_START1:begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= DATA_START1;
            state <= TX_DATA_START2;
            fifo_rd_en <= 1'b1;
          end
          TX_DATA_START2:begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= DATA_START2;
            state <= TX_SEND_DATA;
            fifo_rd_en <= 1'b1;
          end
          TX_SEND_DATA  :begin
            if (!fifo_almost_empty) begin
              gt_txcharisk <= 4'd0;
              gt_txdata <= fifo_dout;
              state <= TX_SEND_DATA;
              fifo_rd_en <= 1'b1;
            end
            else if (fifo_almost_empty & !fifo_empty) begin
              gt_txcharisk <= 4'd0;
              gt_txdata <= fifo_dout;
              state <= TX_SEND_DATA;
              fifo_rd_en <= 1'b0;
            end
            else begin
              gt_txcharisk <= 4'd0;
              gt_txdata <= fifo_dout;
              state <= TX_DATA_END1;
              fifo_rd_en <= 1'b0;
            end
          end
          TX_DATA_END1  :begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= DATA_END1;
            state <= TX_DATA_END2;
            fifo_rd_en <= 1'b0;
          end
          TX_DATA_END2  :begin
            gt_txcharisk <= 4'd1;
            gt_txdata <= DATA_END2;
            state <= TX_UNUSE_DATA;
            fifo_rd_en <= 1'b0;
          end
         default:begin
            cnt_data <= cnt_data + 1'd1;
            fifo_rd_en <= 1'b0;
            if (cnt_data == 8'd255) begin
              gt_txcharisk <= 4'd1;
              gt_txdata <= UNUSE_DATA;
              state <= TX_UNUSE_DATA;
            end
            else begin
              gt_txcharisk <= 4'd0;
              gt_txdata <= 32'ha151a252;
              state <= TX_UNUSE_DATA;
            end
          end
       endcase
     end
  end
end                                                                 //always end

//产生FIFO复位信号
always @(posedge tx_clk or negedge tx_rst_n) begin
  if(!tx_rst_n)begin
    cnt_fifo_rst <= 8'd0;
    fifo_rst <= 1'b1;
  end
  else if (vs_pose) begin
    cnt_fifo_rst <= 8'd0;
    fifo_rst <= 1'b1;
  end
  else if (cnt_fifo_rst >= 100) begin
    cnt_fifo_rst <= cnt_fifo_rst;
    fifo_rst <= 1'b0;
  end
  else begin
    cnt_fifo_rst <= cnt_fifo_rst + 1'd1;
    fifo_rst <= fifo_rst;
  end
end

//fifo例化在这里
sfp_tx_2048x16 u_sfp_tx_2048x16 (
  .rst                                               (fifo_rst       ),// input wire rst
  .wr_clk                                            (clk_in         ),// input wire wr_clk
  .rd_clk                                            (tx_clk         ),// input wire rd_clk
  .din                                               (data_in_d0     ),// input wire [15 : 0] din
  .wr_en                                             (data_valid_in_d0),// input wire wr_en
  .rd_en                                             (fifo_rd_en     ),// input wire rd_en
  .dout                                              (fifo_dout      ),// output wire [31 : 0] dout
  .full                                              (               ),// output wire full
  .empty                                             (fifo_empty     ),// output wire empty
  .almost_empty                                      (fifo_almost_empty),// output wire almost_empty
  .rd_data_count                                     (rd_data_count  ),// output wire [9 : 0] rd_data_count
  .wr_rst_busy                                       (               ),// output wire wr_rst_busy
  .rd_rst_busy                                       (               ) // output wire rd_rst_busy
);
                                                                   
endmodule