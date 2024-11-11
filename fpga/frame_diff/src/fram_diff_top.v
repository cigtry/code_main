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
// Last modified Date:     2024/06/11 15:10:43 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/11 15:10:43 
// Version:                V1.0 
// TEXT NAME:              fram_diff_top.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\frame_diff\src\fram_diff_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module fram_diff_top(
  input                                          clk             ,
  input                                          rst_n           ,
      //当前帧输入图像
  input                                          pre_img_vsync   ,
  input                                          pre_img_hsync   ,
  input                                          pre_img_valid   ,
  input          [  07:00]                       pre_img_data    ,
  //前1 | 2 帧输入图像
  output                                         pre_frame_img_vsync,
  output                                         pre_frame_img_hsync,
  output                                         pre_frame_img_req,
  input          [  07:00]                       pre_frame_img_data,

  output                                         box_flag        ,
  output         [  10:00]                       top_edge        ,
  output         [  10:00]                       bottom_edge     ,
  output         [  10:00]                       left_edge       ,
  output         [  10:00]                       right_edge      ,

  output                                         post_img_vsync  ,
  output                                         post_img_hsync  ,
  output                                         post_img_valid  ,
  output         [  07:00]                       post_img_data    
);

//帧间差计算
  wire                                           frame_diff_post_img_vsync  ;
  wire                                           frame_diff_post_img_hsync  ;
  wire                                           frame_diff_post_img_valid  ;
  wire           [  07:00]                       frame_diff_post_img_data  ;

frame_diff u_frame_diff(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  //当前帧输入图像
  .pre_img_vsync                                     (pre_img_vsync  ),
  .pre_img_hsync                                     (pre_img_hsync  ),
  .pre_img_valid                                     (pre_img_valid  ),
  .pre_img_data                                      (pre_img_data   ),
  //前1 | 2 帧输入图像
  .pre_frame_img_vsync                               (pre_frame_img_vsync),
  .pre_frame_img_hsync                               (pre_frame_img_hsync),
  .pre_frame_img_req                                 (pre_frame_img_req),
  .pre_frame_img_data                                (pre_frame_img_data),
  .post_img_vsync                                    (frame_diff_post_img_vsync),
  .post_img_hsync                                    (frame_diff_post_img_hsync),
  .post_img_valid                                    (frame_diff_post_img_valid),
  .post_img_data                                     (frame_diff_post_img_data ) 
);

                                                                   
  //先局部二值化
  wire                                           region_bin_post_img_vsync  ;
  wire                                           region_bin_post_img_hsync  ;
  wire                                           region_bin_post_img_valid  ;
  wire                                           region_bin_post_img_data  ;

region_bin u_region_bin(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (frame_diff_post_img_vsync  ),
  .pre_img_hsync                                     (frame_diff_post_img_hsync  ),
  .pre_img_valid                                     (frame_diff_post_img_valid  ),
  .pre_img_data                                      (frame_diff_post_img_data   ),
  .post_img_vsync                                    (region_bin_post_img_vsync),
  .post_img_hsync                                    (region_bin_post_img_hsync),
  .post_img_valid                                    (region_bin_post_img_valid),
  .post_img_data                                     (region_bin_post_img_data ) 
); 

//中值滤波减少噪声
    wire                                  med_post_img_vsync             ;
    wire                                  med_post_img_hsync             ;
    wire                                  med_post_img_valid             ;
    wire                      [  07:00]   med_post_img_data              ;

med_filter u_med_filter(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .pre_img_vsync                      (region_bin_post_img_vsync ),
    .pre_img_hsync                      (region_bin_post_img_hsync ),
    .pre_img_valid                      (region_bin_post_img_valid ),
    .pre_img_data                       (region_bin_post_img_data  ),
    .post_img_vsync                     (med_post_img_vsync        ),
    .post_img_hsync                     (med_post_img_hsync        ),
    .post_img_valid                     (med_post_img_valid        ),
    .post_img_data                      (med_post_img_data         )
);

  /* assign                                             post_img_vsync = region_bin_post_img_vsync    ;
  assign                                             post_img_hsync = region_bin_post_img_hsync    ;
  assign                                             post_img_valid = region_bin_post_img_valid    ;
  assign                                             post_img_data  = region_bin_post_img_data     ?  8'd255 : 8'd0;  */

//腐蚀
  wire                                           erosion_post_img_vsync  ;
  wire                                           erosion_post_img_hsync  ;
  wire                                           erosion_post_img_valid  ;
  wire                                           erosion_post_img_data  ;

bin_erosion_dilation#(
  .EROSION_DILATION                                  (0              ),
  .THRESH                                            (6              ) 
)
 u_bin_erosion (
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (med_post_img_vsync   ),
  .pre_img_hsync                                     (med_post_img_hsync   ),
  .pre_img_valid                                     (med_post_img_valid   ),
  .pre_img_data                                      (med_post_img_data[0] ),
  .post_img_vsync                                    (erosion_post_img_vsync),
  .post_img_hsync                                    (erosion_post_img_hsync),
  .post_img_valid                                    (erosion_post_img_valid),
  .post_img_data                                     (erosion_post_img_data) 
);
/*   assign                                             post_img_vsync = erosion_post_img_vsync  ;
  assign                                             post_img_hsync = erosion_post_img_hsync  ;
  assign                                             post_img_valid = erosion_post_img_valid  ;
  assign                                             post_img_data  = erosion_post_img_data  ?  8'd255 : 8'd0;   */

//膨胀
  wire                                           dilation_post_img_vsync  ;
  wire                                           dilation_post_img_hsync  ;
  wire                                           dilation_post_img_valid  ;
  wire                                           dilation_post_img_data  ;

bin_erosion_dilation#(
  .EROSION_DILATION                                  (1              ),
  .THRESH                                            (3              ) 
)
 u_bin_dilation (
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (erosion_post_img_vsync),
  .pre_img_hsync                                     (erosion_post_img_hsync),
  .pre_img_valid                                     (erosion_post_img_valid),
  .pre_img_data                                      (erosion_post_img_data),
  .post_img_vsync                                    (dilation_post_img_vsync),
  .post_img_hsync                                    (dilation_post_img_hsync),
  .post_img_valid                                    (dilation_post_img_valid),
  .post_img_data                                     (dilation_post_img_data) 
);


  assign                                             post_img_vsync = dilation_post_img_vsync;
  assign                                             post_img_hsync = dilation_post_img_hsync;
  assign                                             post_img_valid = dilation_post_img_valid;
  assign                                             post_img_data  = dilation_post_img_data  ?  8'd255 : 8'd0; 

  //包围框大小
  
box_handle#(
  .Box_Boundary_size                                 (1000             ) 
)
 u_box_handle(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (dilation_post_img_vsync),
  .pre_img_hsync                                     (dilation_post_img_hsync),
  .pre_img_valid                                     (dilation_post_img_valid),
  .pre_img_data                                      (dilation_post_img_data ),
  .box_flag                                          (box_flag       ),
  .top_edge                                          (top_edge       ),
  .bottom_edge                                       (bottom_edge    ),
  .left_edge                                         (left_edge      ),
  .right_edge                                        (right_edge     ) 
); 
 

endmodule
