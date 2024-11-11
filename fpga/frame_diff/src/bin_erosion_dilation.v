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
// Last modified Date:     2024/06/05 14:35:35 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/05 14:35:35 
// Version:                V1.0 
// TEXT NAME:              bin_erosion_dilation.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\bin_erosion_dilation\src\bin_erosion_dilation.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module bin_erosion_dilation#(
    parameter  EROSION_DILATION = 0,
    parameter  THRESH = 3
)(
  input                                          clk             ,
  input                                          rst_n           ,
  input                                          pre_img_vsync   ,
  input                                          pre_img_hsync   ,
  input                                          pre_img_valid   ,
  input                                          pre_img_data    ,

  output reg                                     post_img_vsync  ,
  output reg                                     post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output reg                                     post_img_data    
);
  wire                                           matrix_img_vsync  ;
  wire                                           matrix_img_hsync  ;
  wire                                           matrix_img_valid  ;
  wire                                           matrix_top_edge_flag  ;
  wire                                           matrix_bottom_edge_flag  ;
  wire                                           matrix_left_edge_flag  ;
  wire                                           matrix_right_edge_flag  ;
  wire                                           matrix_p11      ;
  wire                                           matrix_p12      ;
  wire                                           matrix_p13      ;
  wire                                           matrix_p21      ;
  wire                                           matrix_p22      ;
  wire                                           matrix_p23      ;
  wire                                           matrix_p31      ;
  wire                                           matrix_p32      ;
  wire                                           matrix_p33      ;

generate_3x3_winndows_bit1 u_generate_3x3_winndows(
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

  reg            [   3: 0]                       data_sum1       ;
  reg            [   3: 0]                       data_sum2       ;
  reg            [   3: 0]                       data_sum3       ;
  always @(posedge clk ) begin
    data_sum1 <= matrix_p11 + matrix_p12 + matrix_p13;
    data_sum2 <= matrix_p21 + matrix_p22 + matrix_p23;
    data_sum3 <= matrix_p31 + matrix_p32 + matrix_p33;
  end

  reg            [   4: 0]                       data_sum        ;
  always @(posedge clk ) begin
    data_sum <= data_sum1 + data_sum2 + data_sum3;
  end

   //  lag 16 clocks signal sync
reg             [01:00]           matrix_img_vsync_r1;
reg             [01:00]           matrix_img_hsync_r1;
reg             [01:00]           matrix_edge_flag_r1;
reg             [01:00]           matrix_img_valid_r1  ;


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r1 <= 2'b0;
        matrix_img_hsync_r1 <= 2'b0;
        matrix_edge_flag_r1 <= 2'b0;
        matrix_img_valid_r1 <= 2'b0;
    end
    else
    begin
        matrix_img_vsync_r1 <= {matrix_img_vsync_r1[0],matrix_img_vsync};
        matrix_img_hsync_r1  <={matrix_img_hsync_r1[0],matrix_img_hsync};
        matrix_img_valid_r1 <= {matrix_img_valid_r1[0],matrix_img_valid};
        matrix_edge_flag_r1 <= {matrix_edge_flag_r1[0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end                                                 
                
  always @ (posedge clk or negedge rst_n)begin 
  if(!rst_n)begin  
    post_img_hsync <= 1'b0;
    post_img_vsync <= 1'b0;
    post_img_valid <= 1'b0;
  end  
  else begin  
    post_img_hsync <= matrix_img_hsync_r1 [1];
    post_img_vsync <= matrix_img_vsync_r1 [1];
    post_img_valid <=  matrix_img_valid_r1[1];
  end  
end //always end
  //0是腐蚀，1是膨胀
  generate
    if (!EROSION_DILATION) begin
      always @ (posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
          post_img_data <= 1'b0;
        end  
        else if(matrix_edge_flag_r1[1])begin  
          post_img_data <= 1'b0;
        end 
        else if(data_sum < THRESH)begin  
          post_img_data <= 1'b0;
        end  
        else begin  
          post_img_data <= 1'b1;
        end  
      end //always end
    end
    else begin
      always @ (posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
          post_img_data <= 1'b0;
        end  
        else if(matrix_edge_flag_r1[1])begin  
          post_img_data <= 1'b0;
        end  
        else if(data_sum >= THRESH)begin  
          post_img_data <= 1'b1;
        end  
        else begin  
          post_img_data <= 1'b0;
        end  
      end //always end
    end
  endgenerate

  
                                                                   
                                                                   
endmodule
