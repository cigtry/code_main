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
// Last modified Date:     2024/07/30 10:10:33 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/30 10:10:33 
// Version:                V1.0 
// TEXT NAME:              ddr3_arbit.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\DDR3_RW\ddr3_arbit.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_arbit#
(   parameter    integer                    DATA_IN_WIDTH = 16     ,//写入fifo的数据如果输出为128，输入最低支持16
    parameter    integer                    DATA_WIDTH    = 128    ,//数据位宽，根据MIG例化而来
    parameter    integer                    ADDR_WIDTH    = 28      //地址位宽
)(
  //时钟和复位------------------------------------------------------
  input                                          clk             ,//ddr3时钟
  input                                          rst_n           ,//复位信号低有效
  input                                          init_calib_complete,//ddr3初始化完成
  //用户信号---------------------------------------------------------
    //写fifo-------------------------------------------------
  input                                          wr_clk          ,//写fifo时钟
  input                                          wr_req          ,//写请求,用以刷新地址，
  input          [ADDR_WIDTH - 1 : 0]            wr_address_beign,//写起始地址
  input          [ADDR_WIDTH - 1 : 0]            wr_address_end  ,//写结束地址
  input          [DATA_IN_WIDTH - 1 : 0]         wr_din          ,//写入fifo的数据
  input                                          wr_din_vld      ,//写入fifo数据有效信号
    //读fifo------------------------------------------------
  input                                          rd_clk          ,//读fifo时钟
  input                                          rd_req          ,//读请求
  input          [ADDR_WIDTH - 1 : 0]            rd_address_beign,//读起始地址
  input          [ADDR_WIDTH - 1 : 0]            rd_address_end  ,//读结束地址
  output         [DATA_IN_WIDTH - 1 : 0]         rd_dout         ,//fifo读出的数据
  output                                         rd_dout_vld     ,//fifo读出数据有效信号
//MIG端控制信号----------------------------------------------	
  output                                         app_en          ,//MIG IP发送命令使能	
  input                                          app_rdy         ,//MIG IP命令接收准备好标致 空闲
  output         [   2: 0]                       app_cmd         ,//MIG IP操作命令，读或者写
  output         [ADDR_WIDTH - 1:0]              app_addr        ,//MIG IP操作地址	
  input                                          app_wdf_rdy     ,//MIG IP数据接收准备好 写数据空闲
  output                                         app_wdf_wren    ,//MIG IP写数据使能
  output                                         app_wdf_end     ,//MIG IP突发写当前时钟最后一个数据
  output         [(DATA_WIDTH/8) - 1:0]          app_wdf_mask    ,//MIG IP数据掩码
  output         [DATA_WIDTH - 1:0]              app_wdf_data    ,//MIG IP写数据
  input          [DATA_WIDTH - 1:0]              app_rd_data     ,//MIG读出的数据
  input                                          app_rd_data_end ,//MIG读出的最后一个数据
  input                                          app_rd_data_valid //MIG读出的数据有效
);
//parameter define

//reg define

  reg                                            wr_burst_start  ;//一次突发写开始	由外部写请求产生
  reg            [ADDR_WIDTH - 1:0]              wr_burst_addr   ;//突发写入的首地址						
  reg                                            rd_burst_start  ;//一次突发读开始								
  reg            [ADDR_WIDTH - 1:0]              rd_burst_addr   ;//突发读取的首地址
  reg                                            wr_req_d        ;
  reg                                            rd_req_d        ;
//wire define	
  //ddr3读写接口
  wire                                           app_wr_en       ;//MIG IP发送命令使能	
  wire           [   2: 0]                       app_wr_cmd      ;//MIG IP操作命令写
  wire           [ADDR_WIDTH - 1:0]              app_wr_addr     ;//MIG IP操作地址	
  wire                                           app_rd_en       ;
  wire           [   2: 0]                       app_rd_cmd      ;
  wire           [ADDR_WIDTH - 1:0]              app_rd_addr     ;
  //ddr3wr接口
  wire           [ADDR_WIDTH - 1:0]              wr_burst_len    ;//突发写入的长度							
  wire           [DATA_WIDTH - 1:0]              wr_burst_data   ;//需要突发写入的数据。来源写FIFO							
  wire                                           wr_burst_ack    ;//突发写响应，为高时代表正在写入数据为低时可以请求下次数据							
  wire                                           wr_burst_done   ;//一次突发写完成
  wire                                           wr_burst_busy   ;//突发写忙状态，高电平有效  
  //wr_fifo接口
  wire                                           wr_fifo_full    ;
  wire                                           wr_fifo_empty   ;
  wire           [   5: 0]                       wr_fifo_rd_data_count  ;
  wire           [   8: 0]                       wr_fifo_wr_data_count  ;
  wire                                           wr_fifo_wr_rst_busy  ;
  wire                                           wr_fifo_rd_rst_busy  ;
  //ddr3rd接口
  wire           [ADDR_WIDTH - 1:0]              rd_burst_len    ;//突发读取的长度								
  wire           [DATA_WIDTH - 1:0]              rd_burst_data   ;//突发读取的数据。存入读FIFO			
  wire                                           rd_burst_ack    ;//突发读响应，高电平表示正在进行突发读操作			
  wire                                           rd_burst_done   ;//一次突发读完成
  wire                                           rd_burst_busy   ;//突发读忙状态，高电平有效	
  //rd_fifo接口
  wire                                           rd_fifo_full    ;
  wire                                           rd_fifo_empty   ;
  wire           [   8: 0]                       rd_fifo_rd_data_count  ;
  wire           [   5: 0]                       rd_fifo_wr_data_count  ;
  wire                                           rd_fifo_wr_rst_busy  ;
  wire                                           rd_fifo_rd_rst_busy  ;

  wire  pos_wr_req;
  wire  pos_rd_req;
//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  assign                                             wr_burst_len   = 29'd1;
  assign                                             rd_burst_len   = 29'd4;

  assign                                             app_en         = wr_burst_busy ? app_wr_en : app_rd_en;
  assign                                             app_cmd        = wr_burst_busy ? app_wr_cmd : app_rd_cmd;
  assign                                             app_addr       = wr_burst_busy ? app_wr_addr : app_rd_addr;
  assign                                             rd_dout_vld    = rd_req && (!rd_fifo_empty);
  assign pos_wr_req = wr_req && (!wr_req_d);
  assign pos_rd_req = rd_req && (!rd_req_d);
  always @(posedge clk ) begin
    wr_req_d <= wr_req;
    rd_req_d <= rd_req;
  end

  //wr_burst_start,rd_burst_start:读写请求信号
  always@(posedge clk)begin
      if(!rst_n)begin
          wr_burst_start <= 1'b0;
          rd_burst_start <= 1'b0;
      end
  	//初始化完成后响应读写请求,优先执行写操作，防止写入ddr3中的数据丢失
      else if(init_calib_complete) begin
          if(~wr_burst_busy && ~rd_burst_busy)begin
  			//写FIFO中的数据量达到写突发长度
              if(wr_fifo_rd_data_count >= wr_burst_len && ~wr_burst_start && ~rd_burst_start)begin
                  wr_burst_start <= 1'b1;                           //写请求有效
                  rd_burst_start <= 1'b0;
              end
  			//读FIFO中的数据量小于读突发长度,且读使能信号有效
              else if((rd_fifo_wr_data_count < rd_burst_len) && rd_req && ~rd_burst_start && ~wr_burst_start)begin
                  wr_burst_start <= 1'b0;
                  rd_burst_start <= 1'b1;                           //读请求有效
              end
              else begin
                  wr_burst_start <= 1'b0;
                  rd_burst_start <= 1'b0;
              end
          end
          else begin                                                //非空闲状态
              wr_burst_start <= 1'b0;
              rd_burst_start <= 1'b0;
          end
      end
      else begin                                                    //MIG初始化未完成
          wr_burst_start <= 1'b0;
          rd_burst_start <= 1'b0;
      end
  end
//wr_burst_addr:ddr3写地址
always@(posedge clk)begin
    if(!rst_n)
        wr_burst_addr <= wr_address_beign;
    else if(pos_wr_req)
        wr_burst_addr <= wr_address_beign;                          //复位fifo则地址为初始地址
    else if(wr_burst_done)                                          //一次突发写结束,更改写地址
        begin
            if(wr_burst_addr < (wr_address_end - wr_burst_len * 8))
                wr_burst_addr <= wr_burst_addr + wr_burst_len * 8;  //未达到末地址,写地址累加
            else
                wr_burst_addr <= wr_address_beign;                  //到达末地址,回到写起始地址
        end
end
 
//rd_burst_addr:ddr3读地址
always@(posedge clk)begin
    if(!rst_n)
        rd_burst_addr <= rd_address_beign;
    else if(pos_rd_req)
        rd_burst_addr <= rd_address_beign;
    else if(rd_burst_done)                                          //一次突发读结束,更改读地址
        begin
            if(rd_burst_addr < (rd_address_end - rd_burst_len * 8))
                rd_burst_addr <= rd_burst_addr + rd_burst_len * 8;  //读地址未达到末地址,读地址累加
            else
                rd_burst_addr <= rd_address_beign;                  //到达末地址,回到首地址
        end
end


ddr3_wr#
(   .DATA_IN_WIDTH  ( DATA_IN_WIDTH )  ,                            //写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (DATA_WIDTH     ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (ADDR_WIDTH     ) //地址位宽
) u_ddr3_wr(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
//用户端信号------------------------------------------------- 	
  .wr_burst_start                                    (wr_burst_start ),
  .wr_burst_len                                      (wr_burst_len   ),
  .wr_burst_addr                                     (wr_burst_addr  ),
  .wr_burst_data                                     (wr_burst_data  ),
  .wr_burst_ack                                      (wr_burst_ack   ),
  .wr_burst_done                                     (wr_burst_done  ),
  .wr_burst_busy                                     (wr_burst_busy  ),
//MIG端控制信号----------------------------------------------	
  .app_en                                            (app_wr_en      ),
  .app_rdy                                           (app_rdy        ),
  .app_cmd                                           (app_wr_cmd     ),
  .app_addr                                          (app_wr_addr    ),
  .app_wdf_rdy                                       (app_wdf_rdy    ),
  .app_wdf_wren                                      (app_wdf_wren   ),
  .app_wdf_end                                       (app_wdf_end    ),
  .app_wdf_mask                                      (app_wdf_mask   ),
  .app_wdf_data                                      (app_wdf_data   ) 
);


ddr3_rd#
(   .DATA_IN_WIDTH  ( DATA_IN_WIDTH )  ,                            //写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (DATA_WIDTH     ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (ADDR_WIDTH     ) //地址位宽
) u_ddr3_rd(
//时钟与复位-------------------------------------------------       	
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
//用户端信号------------------------------------------------- 	
  .rd_burst_start                                    (rd_burst_start ),
  .rd_burst_len                                      (rd_burst_len   ),
  .rd_burst_addr                                     (rd_burst_addr  ),
  .rd_burst_data                                     (rd_burst_data  ),
  .rd_burst_ack                                      (rd_burst_ack   ),
  .rd_burst_done                                     (rd_burst_done  ),
  .rd_burst_busy                                     (rd_burst_busy  ),
//MIG端控制信号----------------------------------------------	
  .app_en                                            (app_rd_en      ),
  .app_rdy                                           (app_rdy        ),
  .app_cmd                                           (app_rd_cmd     ),
  .app_addr                                          (app_rd_addr    ),
  .app_rd_data                                       (app_rd_data    ),
  .app_rd_data_end                                   (app_rd_data_end),
  .app_rd_data_valid                                 (app_rd_data_valid) 
);

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
wr_fifo u_wr_fifo (
  .rst                                               (!rst_n         ),// input wire rst
  .wr_clk                                            (wr_clk         ),// input wire wr_clk
  .rd_clk                                            (clk            ),// input wire rd_clk
  .din                                               (wr_din         ),// input wire [15 : 0] din
  .wr_en                                             (wr_din_vld     ),// input wire wr_en
  .rd_en                                             (wr_burst_ack   ),// input wire rd_en
  .dout                                              (wr_burst_data  ),// output wire [127 : 0] dout
  .full                                              (wr_fifo_full   ),// output wire full
  .empty                                             (wr_fifo_empty  ),// output wire empty
  .rd_data_count                                     (wr_fifo_rd_data_count),// output wire [6 : 0] rd_data_count
  .wr_data_count                                     (wr_fifo_wr_data_count),// output wire [9 : 0] wr_data_count
  .wr_rst_busy                                       (wr_fifo_wr_rst_busy),// output wire wr_rst_busy
  .rd_rst_busy                                       (wr_fifo_rd_rst_busy) // output wire rd_rst_busy
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
rd_fifo u_rd_fifo (
  .rst                                               (!rst_n         ),// input wire rst
  .wr_clk                                            (clk            ),// input wire wr_clk
  .rd_clk                                            (rd_clk         ),// input wire rd_clk
  .din                                               (rd_burst_data  ),// input wire [127 : 0] din
  .wr_en                                             (rd_burst_ack   ),// input wire wr_en
  .rd_en                                             (rd_req && (!rd_fifo_empty)),// input wire rd_en
  .dout                                              (rd_dout        ),// output wire [15 : 0] dout
  .full                                              (rd_fifo_full   ),// output wire full
  .empty                                             (rd_fifo_empty  ),// output wire empty
  .rd_data_count                                     (rd_fifo_rd_data_count),// output wire [9 : 0] rd_data_count
  .wr_data_count                                     (rd_fifo_wr_data_count),// output wire [6 : 0] wr_data_count
  .wr_rst_busy                                       (rd_fifo_wr_rst_busy),// output wire wr_rst_busy
  .rd_rst_busy                                       (rd_fifo_rd_rst_busy) // output wire rd_rst_busy
);
// INST_TAG_END ------ End INSTANTIATION Template ---------                                                                   
                                                                   
endmodule
