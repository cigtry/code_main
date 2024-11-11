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
// Last modified Date:     2024/08/26 09:23:54 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/26 09:23:54 
// Version:                V1.0 
// TEXT NAME:              ddr3_ctrl.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\ov5640+ethnet+ddr\src\ddr3_app\ddr3_ctrl.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ddr3_ctrl#
(
  parameter                                          H_SYNC         = 11'd40,//行同步
  parameter                                          H_BACK         = 11'd220,  //行显示后沿
  parameter                                          H_DISP         = 11'd1280, //行有效数据
  parameter                                          H_FRONT        = 11'd110,  //行显示前沿
  parameter                                          H_TOTAL        = 11'd1650, //行扫描周期

  parameter                                          V_SYNC         = 11'd5 ,    //场同步
  parameter                                          V_BACK         = 11'd20,   //场显示后沿
  parameter                                          V_DISP         = 11'd720,  //场有效数据
  parameter                                          V_FRONT        = 11'd5 ,    //场显示前沿
  parameter                                          V_TOTAL        = 11'd750,  //场扫描周期 */    
  parameter                                          DATA_IN_WIDTH  = 16    ,  //写入fifo的数据如果输出为128，输入最低支持16
  parameter                                          DATA_WIDTH     = 128   ,  //数据位宽，根据MIG例化而来
  parameter                                          ADDR_WIDTH     = 28    //地址位宽
)(
  input                                          clk             ,
  input                                          rst_n           ,
  //video_in
  input                                          wr_clk          ,
  input          [  15:00]                       cmos_frame_data ,
  input                                          cmos_frame_valid,
  input                                          cmos_frame_sop  ,//帧头，与第一个数据对齐
  input                                          cmos_frame_eop  ,//帧尾，与最后一个数据对齐
  //video_out信号
  input                                          rd_clk          ,
  output reg                                     post_img_vsync  ,
  output reg                                     post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output         [  23:00]                       post_img_data   ,
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
  localparam                                         BASE_ADDR0     = 29'h0000_0000;
  localparam                                         BASE_ADDR1     = 29'h0100_0000;
  localparam                                         BASE_ADDR2     = 29'h0200_0000;
  localparam                                         BASE_ADDR3     = 29'h0300_0000;
//reg define
  reg                                            wr_burst_start  ;//一次突发写开始	由外部写请求产生
  reg            [ADDR_WIDTH - 1:0]              wr_burst_addr   ;//突发写入的首地址						
  reg                                            rd_burst_start  ;//一次突发读开始								
  reg            [ADDR_WIDTH - 1:0]              rd_burst_addr   ;//突发读取的首地址
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
  wire           [   7: 0]                       wr_fifo_rd_data_count  ;
  wire           [   10: 0]                       wr_fifo_wr_data_count  ;
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
  wire           [   10: 0]                       rd_fifo_rd_data_count  ;
  wire           [   7: 0]                       rd_fifo_wr_data_count  ;
  wire                                           rd_fifo_wr_rst_busy  ;
  wire                                           rd_fifo_rd_rst_busy  ;
//读写仲裁
  (*use_dsp48="yes"*)reg            [  28:00]                       DATA_NUM;
  (*use_dsp48="yes"*)reg            [  28:00]                       BURAST_NUM;
  reg            [  28:00]                       wr_burast_data_num  ;
  reg            [ADDR_WIDTH - 1 : 0]            wr_address_beign  ;
  reg            [ADDR_WIDTH - 1 : 0]            wr_address_end  ;
  reg            [  01:00]                       wr_bank_cnt     ;
  reg                                            pos_wr_req      ;
  reg                                            pos_wr_req_d    ;
  reg                                            wr_two_bank_flag  ;
  reg                                            rd_busy         ;
  reg            [  28:00]                       rd_burast_data_num  ;
  reg            [ADDR_WIDTH - 1 : 0]            rd_address_beign  ;
  reg            [ADDR_WIDTH - 1 : 0]            rd_address_end  ;
  reg            [  01:00]                       rd_bank_cnt_judge;
  reg            [  01:00]                       rd_bank_cnt     ;
  reg                                            pos_rd_req      ;
  reg                                            pos_rd_req_d    ;
  wire           [  15:00]                       rd_dout         ;
  wire                                           img_hsync       ;
  wire                                           img_vsync       ;
  wire                                           img_valid       ;
  wire           [  23:00]                       img_data        ;

//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  assign                                             wr_burst_len   = 29'd2;
  assign                                             rd_burst_len   = 29'd2;
  assign                                             app_en         = wr_burst_busy ? app_wr_en : app_rd_en;
  assign                                             app_cmd        = wr_burst_busy ? app_wr_cmd : app_rd_cmd;
  assign                                             app_addr       = wr_burst_busy ? app_wr_addr : app_rd_addr;
  assign                                             rd_dout_vld    = (!rd_fifo_empty);

  //wr_burst_start,rd_burst_start:读写请求信号
  always@(posedge clk)begin
      if(!rst_n)begin
          wr_burst_start <= 1'b0;
          rd_burst_start <= 1'b0;
      end
  	//初始化完成后响应读写请求,优先执行写操作，防止写入ddr3中的数据丢失
      else begin
          if(~wr_burst_busy && ~rd_burst_busy)begin
  			//写FIFO中的数据量达到写突发长度
              if(wr_fifo_rd_data_count >= wr_burst_len && ~wr_burst_start && ~rd_burst_start)begin
                  wr_burst_start <= 1'b1;                           //写请求有效
                  rd_burst_start <= 1'b0;
              end
  			//读FIFO中的数据量小于读突发长度,且读使能信号有效
              else if(rd_busy && ~rd_burst_start && ~wr_burst_start)begin
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
  end
  //一帧数据的大小
  always @(posedge clk ) begin
    DATA_NUM <= (H_DISP * V_DISP) ;
    BURAST_NUM <= DATA_NUM / (8*wr_burst_len);
  end
  //存完一帧数据后跳到下一个地址
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_burast_data_num <= 29'b0;
    end
    else if((wr_burast_data_num == BURAST_NUM - 1'b1) && wr_burst_done)begin
      wr_burast_data_num <= 29'b0;
    end
    else if(wr_burst_done)begin
      wr_burast_data_num <= wr_burast_data_num + 1'b1;
    end
    else begin
      wr_burast_data_num <= wr_burast_data_num;
    end
  end
  //地址区域
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_bank_cnt<=2'b0;
    end
    else if((wr_burast_data_num == BURAST_NUM - 1'b1) && wr_burst_done)begin
      wr_bank_cnt <= wr_bank_cnt + 2'd1;
    end
    else begin
      wr_bank_cnt <= wr_bank_cnt;
    end
  end
  //写地址地址开始和结束区域
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_address_beign <= {ADDR_WIDTH{1'b0}};
      wr_address_end <= DATA_NUM;
    end
    else begin
      case(wr_bank_cnt)
        0:begin
          wr_address_beign <= BASE_ADDR0;
          wr_address_end <= BASE_ADDR0 + DATA_NUM;
        end
        1:begin
          wr_address_beign <= BASE_ADDR1;
          wr_address_end <= BASE_ADDR1 + DATA_NUM;
        end
        2:begin
          wr_address_beign <= BASE_ADDR2;
          wr_address_end <= BASE_ADDR2 + DATA_NUM;
        end
        3:begin
          wr_address_beign <= BASE_ADDR3;
          wr_address_end <= BASE_ADDR3 + DATA_NUM;
        end
        default:begin
          wr_address_beign <= {ADDR_WIDTH{1'b0}};
          wr_address_end <= DATA_NUM;
        end
      endcase
    end
  end
  //刷新地址起始
  always @(posedge clk ) begin
    if (!rst_n) begin
      pos_wr_req <= 1'b0;
    end
    else if((wr_burast_data_num == BURAST_NUM - 1'b1)&& wr_burst_done && !pos_wr_req)begin
      pos_wr_req <= 1'b1;
    end
    else begin
      pos_wr_req <= 1'b0;
    end
  end
  always @(posedge clk ) begin
    pos_wr_req_d <= pos_wr_req;
  end
  //wr_burst_addr:ddr3写地址
  always@(posedge clk)begin
      if(!rst_n)
          wr_burst_addr <= wr_address_beign;
      else if(pos_wr_req_d)
          wr_burst_addr <= wr_address_beign;                        //复位fifo则地址为初始地址
      else if(wr_burst_done)begin                                   //一次突发写结束,更改写地址
        if(wr_burst_addr < (wr_address_end - wr_burst_len * 8))
          wr_burst_addr <= wr_burst_addr + wr_burst_len * 8;        //未达到末地址,写地址累加
        else
          wr_burst_addr <= wr_address_beign;                        //到达末地址,回到写起始地址
      end
  end
  //写完两帧标志
  always @(posedge clk ) begin
    if (!rst_n) begin
      wr_two_bank_flag <= 1'b0;
    end
    else if(wr_bank_cnt  >= 2'd1)begin
      wr_two_bank_flag <= 1'b1;
    end
    else begin
      wr_two_bank_flag <= wr_two_bank_flag;
    end
  end
  //*************************************************************//
  //写完两帧数据后开始读取
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_busy <= 1'b0;
    end
    else if (wr_two_bank_flag && (rd_fifo_wr_data_count < (H_DISP >> 3))) begin
      rd_busy <= 1'b1;
    end
    else begin
      rd_busy <= 1'b0;
    end
  end
  //存完一帧数据后跳到下一个地址
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_burast_data_num <= 29'b0;
    end
    else if((rd_burast_data_num == BURAST_NUM - 1'd1)&& rd_burst_done)begin
      rd_burast_data_num <= 29'b0;
    end
    else if(rd_burst_done)begin
      rd_burast_data_num <= rd_burast_data_num + 1'b1;
    end
    else begin
      rd_burast_data_num <= rd_burast_data_num;
    end
  end
  //地址区域
    always @(posedge clk ) begin
    if (!rst_n) begin
      rd_bank_cnt_judge <= 2'd0;
    end
    else begin
      rd_bank_cnt_judge <= rd_bank_cnt + 1'd1;
    end
  end
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_bank_cnt<=2'b0;
    end
    else if((rd_burast_data_num == BURAST_NUM - 1'd1) && rd_burst_done && (rd_bank_cnt_judge != wr_bank_cnt))begin
      rd_bank_cnt <= rd_bank_cnt + 2'd1;
    end
    else begin
      rd_bank_cnt <= rd_bank_cnt;
    end
  end
  //写地址地址开始和结束区域
  always @(posedge clk ) begin
    if (!rst_n) begin
      rd_address_beign <= {ADDR_WIDTH{1'b0}};
      rd_address_end <= DATA_NUM;
    end
    else begin
      case(rd_bank_cnt)
        0:begin
          rd_address_beign <= BASE_ADDR0;
          rd_address_end <= BASE_ADDR0 + DATA_NUM;
        end
        1:begin
          rd_address_beign <= BASE_ADDR1;
          rd_address_end <= BASE_ADDR1 + DATA_NUM;
        end
        2:begin
          rd_address_beign <= BASE_ADDR2;
          rd_address_end <= BASE_ADDR2 + DATA_NUM;
        end
        3:begin
          rd_address_beign <= BASE_ADDR3;
          rd_address_end <= BASE_ADDR3 + DATA_NUM;
        end
        default:begin
          rd_address_beign <= {ADDR_WIDTH{1'b0}};
          rd_address_end <= DATA_NUM;
        end
      endcase
    end
  end
  //刷新地址起始
  always @(posedge clk ) begin
    if (!rst_n) begin
      pos_rd_req <= 1'b0;
    end
    else if((rd_burast_data_num == BURAST_NUM - 1'd1 ) && rd_burst_done && !pos_rd_req)begin
      pos_rd_req <= 1'b1;
    end
    else begin
      pos_rd_req <= 1'b0;
    end
  end
  always @(posedge clk ) begin
    pos_rd_req_d <= pos_rd_req;
  end
  //rd_burst_addr:ddr3写地址
  always@(posedge clk)begin
      if(!rst_n)
          rd_burst_addr <= rd_address_beign;
      else if(pos_rd_req_d)
          rd_burst_addr <= rd_address_beign;                        //复位fifo则地址为初始地址
      else if(rd_burst_done)begin                                   //一次突发写结束,更改写地址
        if(rd_burst_addr < (rd_address_end - rd_burst_len * 8))
          rd_burst_addr <= rd_burst_addr + rd_burst_len * 8;        //未达到末地址,写地址累加
        else
          rd_burst_addr <= rd_address_beign;                        //到达末地址,回到写起始地址
      end
  end
  //转hdmi
  always @(posedge rd_clk ) begin
    post_img_vsync  <= img_vsync   ;
    post_img_hsync  <= img_hsync  ;
    post_img_valid  <= img_valid  ;
  end
  assign                                             post_img_data  = img_data;
  reg                                            hdmi_rst_sync   ;
  always @(posedge clk ) begin
    if (!rst_n) begin
      hdmi_rst_sync <= 1'b0;
    end
    else if(wr_two_bank_flag && rd_fifo_rd_data_count >= H_DISP)begin
      hdmi_rst_sync <= 1'b1;
    end
    else begin
      hdmi_rst_sync <= hdmi_rst_sync;
    end
  end
  reg                                            hdmi_rst_sync1  ;
  reg                                            hdmi_rst_sync2  ;
  always @(posedge rd_clk ) begin
    hdmi_rst_sync1 <= hdmi_rst_sync;
    hdmi_rst_sync2 <= hdmi_rst_sync1;
  end

video_driver#(
  .H_SYNC                                            (H_SYNC         ),
  .H_BACK                                            (H_BACK         ),
  .H_DISP                                            (H_DISP         ),
  .H_FRONT                                           (H_FRONT        ),
  .H_TOTAL                                           (H_TOTAL        ),
  .V_SYNC                                            (V_SYNC         ),
  .V_BACK                                            (V_BACK         ),
  .V_DISP                                            (V_DISP         ),
  .V_FRONT                                           (V_FRONT        ),
  .V_TOTAL                                           (V_TOTAL        ) 
) u_video_driver(
  .pixel_clk                                         (rd_clk         ),
  .sys_rst_n                                         (hdmi_rst_sync2 ),
    //RGB接口
  .img_hsync                                         (img_hsync      ),// 行同步信号
  .img_vsync                                         (img_vsync      ),// 场同步信号
  .img_valid                                         (img_valid      ),// 数据使能
  .img_data                                          (img_data       ),// RGB888颜色数据
  .pixel_data                                        (rd_dout        ) // 像素点数据
);
                                                                   
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
  .din                                               (cmos_frame_data),// input wire [15 : 0] din
  .wr_en                                             (cmos_frame_valid),// input wire wr_en
  .rd_en                                             (app_wr_en      ),// input wire rd_en
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
  .rd_en                                             (img_valid      ),// input wire rd_en
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
