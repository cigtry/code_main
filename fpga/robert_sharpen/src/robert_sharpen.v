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

module robert_sharpen(
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
//----------------------------------------------------------------------
//  Gx_data = [p22,p23] * [ 0,1] = p23 - p32
//            [p32,p33]   [-1,0]
//  
//  Gy_data = [p22,p23] * [1, 0] = p22 - p33
//            [p32,p33]   [0,-1]
//
//  G_data = sqrt(Gx_data^2 + Gy_data^2)

  reg signed [08:00] gx_data;
  reg signed [08:00] gy_data;
  always @(posedge clk ) begin
    gx_data <= $signed({1'b0,matrix_p23}) - $signed({1'b0,matrix_p32});
    gy_data <= $signed({1'b0,matrix_p22}) - $signed({1'b0,matrix_p33});
  end

  reg signed [17:00] gx_square_data;
  reg signed [17:00] gy_square_data;
  always @(posedge clk ) begin
    gx_square_data <= $signed(gx_data) * $signed(gx_data);
    gy_square_data <= $signed(gy_data) * $signed(gy_data);
  end

  reg signed [16:00]  g_square_data;
  always @(posedge clk ) begin
    g_square_data <= gx_square_data[16:00] + gy_square_data[16:00];
  end

  wire  [08:00]  g_data;
  sqrt u_sqrt
(
    .sys_clk    (clk            ),
    .sys_rst    (~rst_n         ),
    .din        (g_square_data  ),
    .din_valid  (1'b1           ),
    .dout       (g_data         ),
    .dout_valid (               )
);

reg  [07:00]   matrix_p22_d0;
reg  [07:00]   matrix_p22_d1;
reg  [07:00]   matrix_p22_d2;
reg  [07:00]   matrix_p22_d3;
reg  [07:00]   matrix_p22_d4;
reg  [07:00]   matrix_p22_d5;
reg  [07:00]   matrix_p22_d6;
reg  [07:00]   matrix_p22_d7;
reg  [07:00]   matrix_p22_d8;
reg  [07:00]   matrix_p22_d9;
reg  [07:00]   matrix_p22_d10;
reg  [07:00]   matrix_p22_d11;
reg  [07:00]   matrix_p22_d12;

    always @(posedge clk)begin
      matrix_p22_d12 <= matrix_p22_d11;
      matrix_p22_d11 <= matrix_p22_d10;
      matrix_p22_d10 <= matrix_p22_d9;
      matrix_p22_d9  <= matrix_p22_d8;
      matrix_p22_d8  <= matrix_p22_d7;
      matrix_p22_d7  <= matrix_p22_d6;
      matrix_p22_d6  <= matrix_p22_d5;
      matrix_p22_d5  <= matrix_p22_d4;
      matrix_p22_d4  <= matrix_p22_d3;
      matrix_p22_d3  <= matrix_p22_d2;
      matrix_p22_d2  <= matrix_p22_d1;
      matrix_p22_d1  <= matrix_p22_d0;
      matrix_p22_d0  <= matrix_p22;
    end
//delay 13 clock 梯度运算1 平方1 求和 1 开方10 
  reg   [12:0]   martix_img_hsync_d;
  reg   [12:0]   martix_img_vsync_d;
  reg   [12:0]   martix_img_valid_d;
  reg   [12:0]   martix_img_edge_d ;

  always @ (posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
      martix_img_hsync_d <= 13'b0;
      martix_img_vsync_d <= 13'b0;
      martix_img_valid_d <= 13'b0;
      martix_img_edge_d  <= 13'b0;
    end  
    else begin  
      martix_img_hsync_d <= {martix_img_hsync_d[11:0],matrix_img_hsync};
      martix_img_vsync_d <= {martix_img_vsync_d[11:0],matrix_img_vsync};
      martix_img_valid_d <= {martix_img_valid_d[11:0],matrix_img_valid};
      martix_img_edge_d  <= {martix_img_edge_d[11:0] ,(matrix_right_edge_flag|matrix_bottom_edge_flag)};
    end  
  end //always end
//叠加运算
  reg post_img_hsync_d;
  reg post_img_vsync_d;
  reg post_img_valid_d;
  reg [9:0] post_img_data_d;
always @ (posedge clk or negedge rst_n)begin 
  if(!rst_n)begin  
    post_img_hsync_d <= 1'b0;
    post_img_vsync_d <= 1'b0;
    post_img_valid_d <= 1'b0;
  end  
  else begin  
    post_img_hsync_d <= martix_img_hsync_d[12];
    post_img_vsync_d <= martix_img_vsync_d[12];
    post_img_valid_d <= martix_img_valid_d[12];
  end  
end //always end

always @ (posedge clk or negedge rst_n)begin 
  if(!rst_n)begin  
    post_img_data_d <= 8'b0;
  end   
  else if(martix_img_edge_d[12])begin  
    post_img_data_d <= matrix_p22_d12;
  end  
  else begin
    post_img_data_d <= matrix_p22_d12 + g_data;
  end
end //always end

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
end //always end

always @ (posedge clk or negedge rst_n)begin 
  if(!rst_n)begin  
    post_img_data <= 8'b0;
  end   
  else if(post_img_data_d > 7'd255)begin  
    post_img_data <= 8'd255;
  end  
  else begin
    post_img_data <= post_img_data_d[07:00];
  end
end //always end 

endmodule
