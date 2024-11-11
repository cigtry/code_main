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
// Last modified Date:     2024/09/23 13:57:03 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/09/23 13:57:03 
// Version:                V1.0 
// TEXT NAME:              sfp_decode.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\sfp_8b10b\src\sfp_decode.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module sfp_decode#(
  parameter                                          VS_POSE_DATA1  = 32'h55a101bc,
  parameter                                          VS_POSE_DATA2  = 32'h55a102bc,
  parameter                                          DATA_START1    = 32'h55a105bc,
  parameter                                          DATA_START2    = 32'h55a106bc,
  parameter                                          DATA_END1      = 32'h55a107bc,
  parameter                                          DATA_END2      = 32'h55a108bc,
  parameter                                          UNUSE_DATA     = 32'h55a109bc
 )(
  input                                          clk_in          ,
  input                                          rst_n           ,
  input                                          rx_clk          ,
  input                                          rx_rst_n        ,
  input          [  31:00]                       rx_data_align   ,
  input          [  03:00]                       rx_charisk_align,
  output reg                                     vs_out          ,
  output         [  15:00]                       data_out        ,
  output reg                                     data_valid_out   
);
//parameter define

//reg define
  reg                                            sfp_line_end    ;
  reg                                            sfp_line_end_t  ;
  reg                                            sfp_line_end_t1  ;

  reg                                            data_start_en   ;
  reg                                            data_end_en     ;
  reg            [  07:00]                       data_end_en_d   ;
  reg            [  03:00]                       data_start_en_d  ;
  reg            [  07:00]                       cnt_vs          ;
  reg                                            fifo_wren       ;
  reg            [  31:00]                       fifo_datain     ;
  reg                                            fifo_rd_en      ;
  reg            [  31:00]                       rx_data_align_d0  ;
  reg            [  03:00]                       rx_charisk_align_d0  ;
  reg            [  31:00]                       rx_data_align_d1  ;
  reg            [  03:00]                       rx_charisk_align_d1  ;

//wire define	
  wire                                           fifo_almost_empty  ;

//*********************************************************************************************
//**                    main code
//**********************************************************************************************
//对输入数据打拍
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      rx_data_align_d0      <=32'b0 ;
      rx_charisk_align_d0   <=4'b0  ;
      rx_data_align_d1      <=32'b0 ;
      rx_charisk_align_d1   <=4'b0  ;
    end
    else begin
      rx_data_align_d0      <=rx_data_align         ;
      rx_charisk_align_d0   <=rx_charisk_align      ;
      rx_data_align_d1      <=rx_data_align_d0      ;
      rx_charisk_align_d1   <=rx_charisk_align_d0   ;
    end
  end                                                               //always end
  
//对数据接收开始和结束信号进行移位
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      data_end_en_d   <= 8'b0;
      data_start_en_d <= 4'b0;
    end
    else begin
      data_end_en_d   <= {data_end_en_d[06:00],data_end_en};
      data_start_en_d <= {data_start_en_d[02:00],data_start_en};
    end
  end                                                               //always end

//产生一行数据接收结束信号
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      sfp_line_end <= 1'b0;
    end
    else if(data_end_en_d > 0 )begin
      sfp_line_end <= 1'b1;
    end
    else begin
      sfp_line_end <= 1'b0;
    end
  end                                                               //always end
  
//产生场输出信号
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      vs_out <= 1'b0;
      cnt_vs <= 8'd0;
    end
    else if((rx_charisk_align==4'd1) && (rx_data_align == VS_POSE_DATA2) && (rx_data_align_d0 == VS_POSE_DATA1))begin
      vs_out <= 1'b1;
      cnt_vs <= 8'd0;
    end
    else if(cnt_vs >= 8'd100)begin
      vs_out <= 1'b0;
      cnt_vs <= cnt_vs;
    end
    else begin
      vs_out <= vs_out;
      cnt_vs <= cnt_vs + 1'd1;
    end
  end                                                               //always end
  
//产生数据接收开始信号
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      data_start_en <= 1'b0;
    end
    else if((rx_charisk_align==4'd1) && (rx_data_align == DATA_START2) && (rx_data_align_d0 == DATA_START1))begin
      data_start_en <= 1'b1;
    end
    else begin
      data_start_en <= 1'b0;
    end
  end                                                               //always end

//产生数据接收结束信号
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      data_end_en <= 1'b0;
    end
    else if((rx_charisk_align==4'd1) && (rx_data_align == DATA_END2) && (rx_data_align_d0 == DATA_END1))begin
      data_end_en <= 1'b1;
    end
    else begin
      data_end_en <= 1'b0;
    end
  end                                                               //always end

//产生fifo写使能
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      fifo_wren <= 1'b0;
    end
    else if(data_start_en_d[1])begin
      fifo_wren <= 1'b1;
    end
    else if(data_end_en)begin
      fifo_wren <= 1'b0;
    end
    else begin
      fifo_wren <= fifo_wren;
    end
  end                                                               //always end

//产生fifo写数据
  always @ (posedge rx_clk or negedge rx_rst_n)begin
    if(!rx_rst_n)begin
      fifo_datain <= 32'b0;
    end
    else begin
      fifo_datain <= rx_data_align_d1;
    end
  end                                                               //always end


/****************读数据*****************/

//对一行数据接收结束信号进行时钟域切换
  always @ (posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
      sfp_line_end_t <= 1'b0;
      sfp_line_end_t1 <= 1'b0;
    end
    else begin
      sfp_line_end_t <= sfp_line_end;
      sfp_line_end_t1 <=sfp_line_end_t;
    end
  end                                                               //always end

//产生 fifo 读使能
  always @ (posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
      fifo_rd_en <= 1'b0;
    end
    else begin
      if (sfp_line_end_t1) begin
        fifo_rd_en <= 1'b1;
      end
      else if(fifo_almost_empty)begin
        fifo_rd_en <= 1'b0;
      end
      else begin
        fifo_rd_en <= fifo_rd_en;
      end
    end
  end                                                               //always end

//产生数据输出有效信号
  always @ (posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
      data_valid_out <= 1'b0;
    end
    else begin
      data_valid_out <= fifo_rd_en;
    end
  end                                                               //always end
  
//fifo
  sfp_rx_32x1024 u_sfp_rx_32x1024 (
  .rst                                               (vs_out         ),// input wire rst
  .wr_clk                                            (rx_clk         ),// input wire wr_clk
  .rd_clk                                            (clk_in         ),// input wire rd_clk
  .din                                               (fifo_datain    ),// input wire [31 : 0] din
  .wr_en                                             (fifo_wren      ),// input wire wr_en
  .rd_en                                             (fifo_rd_en     ),// input wire rd_en
  .dout                                              (data_out       ),// output wire [15 : 0] dout
  .full                                              (               ),// output wire full
  .empty                                             (               ),// output wire empty
  .almost_empty                                      (fifo_almost_empty),// output wire almost_empty
  .wr_rst_busy                                       (               ),// output wire wr_rst_busy
  .rd_rst_busy                                       (               ) // output wire rd_rst_busy
);
                                                                   
                                                                   
endmodule
