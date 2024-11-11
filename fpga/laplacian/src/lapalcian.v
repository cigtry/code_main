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
// Last modified Date:     2024/06/24 17:12:49 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/24 17:12:49 
// Version:                V1.0 
// TEXT NAME:              robert_sharpen.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\robert_sharpen\src\robert_sharpen.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module lapalcian(
  input                                          clk             ,
  input                                          rst_n           ,
  input                                          pre_img_vsync   ,
  input                                          pre_img_hsync   ,
  input                                          pre_img_valid   ,
  input          [  07:00]                       pre_img_data    ,

  output reg                                     post_img_vsync  ,
  output reg                                     post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output reg     [  07:00]                       post_img_data    
    
);
  wire                                           matrix_img_vsync  ;
  wire                                           matrix_img_hsync  ;
  wire                                           matrix_img_valid  ;
  wire                                           matrix_top_edge_flag  ;
  wire                                           matrix_bottom_edge_flag  ;
  wire                                           matrix_left_edge_flag  ;
  wire                                           matrix_right_edge_flag  ;
  wire           [   7: 0]                       matrix_p11      ;
  wire           [   7: 0]                       matrix_p12      ;
  wire           [   7: 0]                       matrix_p13      ;
  wire           [   7: 0]                       matrix_p21      ;
  wire           [   7: 0]                       matrix_p22      ;
  wire           [   7: 0]                       matrix_p23      ;
  wire           [   7: 0]                       matrix_p31      ;
  wire           [   7: 0]                       matrix_p32      ;
  wire           [   7: 0]                       matrix_p33      ;

generate_3x3_winndows u_generate_3x3_winndows(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (pre_img_vsync  ),
  .pre_img_hsync                                     (pre_img_hsync  ),
  .pre_img_valid                                     (pre_img_valid  ),
  .pre_img_data                                      (pre_img_data   ),
    //  Image data has been processed
  .matrix_img_vsync                                  (matrix_img_vsync),
  .matrix_img_hsync                                  (matrix_img_hsync),
  .matrix_img_valid                                  (matrix_img_valid),
  .matrix_top_edge_flag                              (matrix_top_edge_flag),
  .matrix_bottom_edge_flag                           (matrix_bottom_edge_flag),
  .matrix_left_edge_flag                             (matrix_left_edge_flag),
  .matrix_right_edge_flag                            (matrix_right_edge_flag),
  .matrix_p11                                        (matrix_p11     ),
  .matrix_p12                                        (matrix_p12     ),
  .matrix_p13                                        (matrix_p13     ),
  .matrix_p21                                        (matrix_p21     ),
  .matrix_p22                                        (matrix_p22     ),
  .matrix_p23                                        (matrix_p23     ),
  .matrix_p31                                        (matrix_p31     ),
  .matrix_p32                                        (matrix_p32     ),
  .matrix_p33                                        (matrix_p33     ) 
);
  //lapalcian
  reg            [  10:00]                       minute_data     ;
  reg            [  09:00]                       minus_data      ;
  always @(posedge clk ) begin
    minute_data <= {matrix_p22,2'b0}+matrix_p22;
    minus_data <= matrix_p12 + matrix_p21 + matrix_p23 + matrix_p32;
  end

  reg      signed[  11:00]                       pixel_data1     ;
  always @(posedge clk ) begin
    pixel_data1 <= $signed ({1'b0,minute_data}) - $signed ({1'b0,minus_data});
  end

  //lapalcian锐化图像的灰度值可能小于0 或者 大于255 ，防止数据溢出做以下处理
  reg            [   7: 0]                       pixel_data2     ;
  always @(posedge clk ) begin
    if(pixel_data1[11] == 1'b1)begin
      pixel_data2 <= 8'b0;
    end
    else if(pixel_data1[10 : 8] != 3'b0)begin
      pixel_data2 <= 8'd255;
    end
    else begin
      pixel_data2 <= pixel_data1[7:0];
    end
  end

//延迟3clock
  reg            [  07:00]                       matrix_p22_d0   ;
  reg            [  07:00]                       matrix_p22_d1   ;
  reg            [  07:00]                       matrix_p22_d2   ;
 
    always @(posedge clk)begin
      matrix_p22_d2  <= matrix_p22_d1;
      matrix_p22_d1  <= matrix_p22_d0;
      matrix_p22_d0  <= matrix_p22;
    end

  reg            [   2: 0]                       martix_img_hsync_d  ;
  reg            [   2: 0]                       martix_img_vsync_d  ;
  reg            [   2: 0]                       martix_img_valid_d  ;
  reg            [   2: 0]                       martix_img_edge_d  ;

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      martix_img_hsync_d <= 3'b0;
      martix_img_vsync_d <= 3'b0;
      martix_img_valid_d <= 3'b0;
      martix_img_edge_d  <= 3'b0;
    end
    else begin
      martix_img_hsync_d <= {martix_img_hsync_d[1:0],matrix_img_hsync};
      martix_img_vsync_d <= {martix_img_vsync_d[1:0],matrix_img_vsync};
      martix_img_valid_d <= {martix_img_valid_d[1:0],matrix_img_valid};
      martix_img_edge_d  <= {martix_img_edge_d[1:0] ,(matrix_right_edge_flag|matrix_left_edge_flag|matrix_top_edge_flag|matrix_bottom_edge_flag)};
    end
  end                                                               //always end

  reg                                            post_img_hsync_d  ;
  reg                                            post_img_vsync_d  ;
  reg                                            post_img_valid_d  ;
always @ (posedge clk or negedge rst_n)begin
  if(!rst_n)begin
    post_img_hsync_d <= 1'b0;
    post_img_vsync_d <= 1'b0;
    post_img_valid_d <= 1'b0;
  end
  else begin
    post_img_hsync_d <= martix_img_hsync_d[2];
    post_img_vsync_d <= martix_img_vsync_d[2];
    post_img_valid_d <= martix_img_valid_d[2];
  end
end                                                                 //always end

always @ (posedge clk or negedge rst_n)begin
  if(!rst_n)begin
    post_img_data <= 8'b0;
  end
  else if(martix_img_edge_d[2])begin
    post_img_data <= matrix_p22_d2;
  end
  else begin
    post_img_data <= pixel_data2;
  end
end                                                                 //always end

always @ (posedge clk or negedge rst_n)begin
  if(!rst_n)begin
    post_img_hsync <= 1'b0;
    post_img_vsync <= 1'b0;
    post_img_valid <= 1'b0;
  end
  else begin
    post_img_hsync <= post_img_hsync_d ;
    post_img_vsync <= post_img_vsync_d ;
    post_img_valid <= post_img_valid_d ;
  end
end                                                                 //always end


endmodule
