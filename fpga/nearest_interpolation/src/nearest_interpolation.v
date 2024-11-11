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
// Last modified Date:     2024/07/08 15:44:17 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/08 15:44:17 
// Version:                V1.0 
// TEXT NAME:              nearest_interpolation.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\nearest_interpolation\src\nearest_interpolation.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module nearest_interpolation#(
  parameter                                          pre_img_x_res  = 640   ,
  parameter                                          pre_img_y_res  = 480   ,
  parameter                                          X_RATIO        = 40960 ,
  parameter                                          Y_RATIO        = 40960 
)(
  input                                          pre_clk         ,//输入图像时钟
  input                                          post_clk        ,//输出图像时钟
  input                                          rst_n           ,
  input                                          pre_img_vsync   ,
  input                                          pre_img_hsync   ,
  input                                          pre_img_valid   ,
  input          [  07:00]                       pre_img_data    ,

  output wire                                    post_img_vsync  ,
  output wire                                    post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output reg     [  07:00]                       post_img_data    
);

  //1280*720 分辨率时序参数
  parameter                                          H_SYNC         = 11'd40;   //行同步
  parameter                                          H_BACK         = 11'd220;  //行显示后沿
  parameter                                          H_DISP         = 11'd1280; //行有效数据
  parameter                                          H_FRONT        = 11'd110;  //行显示前沿
  parameter                                          H_TOTAL        = 11'd1650; //行扫描周期

  parameter                                          V_SYNC         = 11'd5 ;    //场同步
  parameter                                          V_BACK         = 11'd20;   //场显示后沿
  parameter                                          V_DISP         = 11'd720;  //场有效数据
  parameter                                          V_FRONT        = 11'd5 ;    //场显示前沿
  parameter                                          V_TOTAL        = 11'd750;  //场扫描周期
    //1024*768 分辨率时序参数
/*   parameter                                          H_SYNC         = 11'd136;   //行同步
  parameter                                          H_BACK         = 11'd160;  //行显示后沿
  parameter                                          H_DISP         = 11'd1024; //行有效数据
  parameter                                          H_FRONT        = 11'd24;  //行显示前沿
  parameter                                          H_TOTAL        = 11'd1344; //行扫描周期

  parameter                                          V_SYNC         = 11'd6 ;    //场同步
  parameter                                          V_BACK         = 11'd29;   //场显示后沿
  parameter                                          V_DISP         = 11'd768;  //场有效数据
  parameter                                          V_FRONT        = 11'd3 ;    //场显示前沿
  parameter                                          V_TOTAL        = 11'd806;  //场扫描周期 */

  reg            [  10:00]                       pre_h_cnt       ;
  reg            [  09:00]                       pre_v_cnt       ;
  reg                                            pre_img_vsync_d  ;
  reg                                            pre_img_hsync_d  ;
  wire                                           pos_img_vsync   ;
  assign                                             pos_img_vsync  = pre_img_vsync && !pre_img_vsync_d;
  wire                                           pos_img_hsync   ;
  assign                                             pos_img_hsync  = pre_img_hsync && !pre_img_hsync_d;

  always @ (posedge pre_clk or negedge rst_n)begin                  //
    if(!rst_n)begin
      pre_img_vsync_d <= 1'b0;
      pre_img_hsync_d <= 1'b0;
    end
    else begin
      pre_img_vsync_d <= pre_img_vsync;
      pre_img_hsync_d <= pre_img_hsync;
    end
  end                                                               //always end
//输入图像分辨率计数
  always @ (posedge pre_clk or negedge rst_n)begin
    if(!rst_n)begin
      pre_h_cnt <= 11'd0;
    end
    else if(pos_img_hsync ||( pre_h_cnt == pre_img_x_res - 1'b1))begin
      pre_h_cnt <= 11'd0;
    end
    else if(pre_img_valid)begin
      pre_h_cnt <= pre_h_cnt + 1'b1;
    end
    else begin
      pre_h_cnt <= pre_h_cnt;
    end
  end                                                               //always end

  always @ (posedge pre_clk or negedge rst_n)begin
    if(!rst_n)begin
      pre_v_cnt <= 10'd0;
    end
    else if(pos_img_vsync )begin
      pre_v_cnt <= 10'd0;
    end
    else if( pre_h_cnt == pre_img_x_res - 1'b1)begin
      pre_v_cnt <= pre_v_cnt + 1'b1;
    end
    else begin
      pre_v_cnt <= pre_v_cnt ;
    end
  end                                                               //always end

//例化4个双端口ram存储4行图像数据
  reg            [  11:00]                       bram_addr_x     ;
  reg            [  10:00]                       bram_addr_y     ;
  reg            [   3: 0]                       wea             ;
  reg            [  11: 0]                       addra           ;
  reg            [   7: 0]                       dina            ;
  wire           [   8*4 -1 : 0]                 doutb           ;
genvar i;
generate
  for (i = 0;i<4 ;i=i+1 ) begin
    bram_ture_dual_port#(
  .C_ADDR_WIDTH                                      (12             ),
  .C_DATA_WIDTH                                      (8              ) 
    )
     u_bram_ture_dual_port(
  .clka                                              (pre_clk        ),
  .wea                                               (wea[i]         ),
  .addra                                             (addra          ),
  .dina                                              (dina           ),
  .douta                                             (               ),
  .clkb                                              (post_clk       ),
  .web                                               (1'b0           ),
  .addrb                                             (bram_addr_x    ),
  .dinb                                              (               ),
  .doutb                                             (doutb[8*(i+1) -1 : (8*i) ]) 
    );
  end
endgenerate

//最近邻插值算法存储输入图像数据
  always @(posedge pre_clk ) begin
    if (!rst_n) begin
      wea <= 4'b0;
    end
    else begin
      case(pre_v_cnt[1:0])
        2'b00:wea <= {1'b0,1'b0,1'b0,pre_img_valid};
        2'b01:wea <= {1'b0,1'b0,pre_img_valid,1'b0};
        2'b10:wea <= {1'b0,pre_img_valid,1'b0,1'b0};
        2'b11:wea <= {pre_img_valid,1'b0,1'b0,1'b0};
        default: wea <= 4'b0;
      endcase
    end
  end

  always @(posedge pre_clk ) begin
    if (!rst_n) begin
      addra <= 12'b0;
      dina <= 8'b0;
    end
    else begin
      addra <= pre_h_cnt;
      dina <= pre_img_data;
    end
  end
//两行数据存储完成后开始完成最近插值映射
  reg     load_flag;//两行数据存储完成标志
  always @(posedge pre_clk ) begin
    if (pos_img_vsync || (( pre_h_cnt == pre_img_x_res - 1'b1) && (pre_v_cnt ==pre_img_y_res -  1'b1))) begin
      load_flag <= 1'b0;
    end
    else if (pos_img_hsync && (pre_v_cnt == 2'd2) ) begin
      load_flag <= 1'b1;
    end
    else begin
      load_flag <= load_flag;
    end
  end

  reg       [11:00]   cnt_row_x;
  reg       [11:00]   cnt_row_y;
  reg                 data_read_flag;

    always @(posedge post_clk ) begin
    if (!rst_n) begin
      data_read_flag <= 1'b0;
    end
    else if(load_flag)begin
      data_read_flag <= 1'b1;
    end
    else if((cnt_row_x == H_TOTAL - 1) && (cnt_row_y == V_DISP - 1))begin
      data_read_flag <= 1'b0;
    end
    else begin
      data_read_flag <= data_read_flag;
    end
  end

  always @(posedge post_clk ) begin
    if (!rst_n) begin
      cnt_row_x <= 12'b0;
    end
    else if((cnt_row_x == H_TOTAL - 1))begin
      cnt_row_x <= 12'b0;
    end
    else if(data_read_flag)begin
      cnt_row_x <= cnt_row_x + 1'b1;
    end
    else begin
      cnt_row_x <= 12'b0;
    end
  end

  always @(posedge post_clk ) begin
    if (!rst_n) begin
      cnt_row_y <= 12'b0;
    end
    else if(data_read_flag)begin
      if((cnt_row_x == H_TOTAL - 1))begin
        cnt_row_y <= cnt_row_y + 1'b1;
      end
      else begin
        cnt_row_y <= cnt_row_y;
      end
    end
    else begin
      cnt_row_y <= 12'b0;
    end
  end

  reg     img_valid;
  always @(posedge post_clk ) begin
    if (!rst_n) begin
      img_valid <= 1'b0;
    end
    else if(data_read_flag)begin
      if((cnt_row_x >=H_SYNC + H_BACK )&& (cnt_row_x <H_SYNC + H_BACK + H_DISP ) )begin
        img_valid <= 1'b1;
      end
      else begin
        img_valid <= 1'b0;
      end
    end
    else begin
      img_valid <= 1'b0;
    end
  end

  reg            [  26:00]                       x_dec           ;
  reg            [  26:00]                       y_dec           ;

  always @(posedge post_clk ) begin
    if (!rst_n) begin
       x_dec <= 0;
    end
    else if((x_dec == ((pre_img_x_res - 1)<<16 )))begin
      x_dec <= 0;
    end
    else if(img_valid)begin
      x_dec <= x_dec + X_RATIO;
    end
    else begin
      x_dec <= 0;
    end
  end
  always @(posedge post_clk ) begin
    if (!rst_n) begin
      y_dec <= 0;
    end
    else if((x_dec == ((pre_img_x_res - 1)<<16 ) && y_dec == ((pre_img_y_res - 1)<<16 )))begin
      y_dec <= 0;
    end
    else if (x_dec == ((pre_img_x_res - 1)<<16 )) begin
        y_dec <= y_dec + Y_RATIO;
      end
    else begin
    y_dec <= y_dec ;
    end
  end
    always @(posedge post_clk ) begin
    bram_addr_x <= x_dec[26:16]+x_dec[15];
    bram_addr_y <= y_dec[26:16]+y_dec[15];
  end
  always @(posedge post_clk ) begin
    if (!rst_n) begin
      post_img_data <= 8'h00;
    end
    else begin
      case (bram_addr_y[1:0])
        2'b00:post_img_data <= doutb[7:0];
        2'b01:post_img_data <= doutb[15:8];
        2'b10:post_img_data <= doutb[23:16];
        2'b11:post_img_data <= doutb[31:24];
        default: post_img_data <= 8'h00;
      endcase
    end
  end

  always @(posedge post_clk ) begin
    post_img_valid <= img_valid;
  end
endmodule
