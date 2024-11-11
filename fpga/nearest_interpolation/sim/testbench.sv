`timescale  1ns/1ns
module testbench;

//----------------------------------------------------------------------
//  clk & rst_n
  reg                                            clk             ;
  reg                                            rst_n           ;
  reg  rst;
  wire                                           clk_25_2m       ;
  wire                                           clk_40m         ;
  wire                                           clk_65m         ;
  wire                                           clk_74_25m      ;
  wire                                           clk_108m        ;

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial
begin
    rst = 1'b1;
    repeat(10) @(posedge clk);
    rst = 1'b0;
end
initial
begin
    rst_n = 1'b0;
    repeat(200) @(posedge clk);
    rst_n = 1'b1;
end
//------------------------------ ----------------------------------------

  pll u_pll(
  .refclk                                            (clk            ),//  refclk.clk
  .rst                                               (rst         ),//   reset.reset
  .outclk_0                                          (clk_25_2m      ),// outclk0.clk
  .outclk_1                                          (clk_40m        ),// outclk1.clk
  .outclk_2                                          (clk_65m        ),// outclk2.clk
  .outclk_3                                          (clk_74_25m     ),// outclk3.clk
  .outclk_4                                          (clk_108m       ),// outclk4.clk
  .locked                                            (locked        ) //  locked.export
    );
  reg                                            pre_img_vsync   ;
  reg                                            pre_img_hsync   ;
  reg                                            pre_img_valid   ;
  reg            [  07:00]                       pre_img_data    ;
  wire                                           post_img_vsync  ;
  wire                                           post_img_hsync  ;
  wire                                           post_img_valid  ;
  wire           [  07:00]                       post_img_data   ;

  wire                                           vout_done       ;

  reg                                            vout_begin    =0;
task  vout_begin_task;                                              //任务名
    // input  ;
    begin
      repeat(5) @(posedge clk);
      vout_begin = 1;
      repeat(5) @(posedge clk);
      vout_begin = 0;
    end
endtask : vout_begin_task
  parameter                                          VIN_BMP_FILE   = "Scart.bmp";
  parameter                                          VIN_BMP_PATH   = "../../../../picture/";
  parameter                                          VOUT_BMP_PATH  = VIN_BMP_PATH;//"../../../../../vouBmpV/";
  parameter                                          VOUT_BMP_NAME  = "nearest_interpolation";
bmp_to_videoStream    #
(
  .iBMP_FILE_PATH                                    (VIN_BMP_PATH   ),
  .iBMP_FILE_NAME                                    (VIN_BMP_FILE)  ) 
U_bmp_to_videoStream(
  .clk                                               (clk_25_2m        ),
  .rst_n                                             (rst_n          ),
  .vout_vsync                                        (pre_img_vsync  ),//输出数据场同步信号
  .vout_hsync                                        (pre_img_hsync  ),//输出数据行同步信号
  .vout_dat                                          (pre_img_data   ),//输出视频数据
  .vout_valid                                        (pre_img_valid  ),//输出视频数据有效
  .vout_begin                                        (vout_begin     ),//开始转换
  .vout_done                                         (vout_done      ),//转换结束
  .vout_xres                                         (bmp1_xres      ),//输出视频水平分辨率
  .vout_yres                                         (bmp1_yres      ) //输出视频垂直分辨率
);


nearest_interpolation#(
  .pre_img_x_res                                     (640            ),
  .pre_img_y_res                                     (480            ),
  .X_RATIO                                           (32768          ),
  .Y_RATIO                                           (43960          ) 
)
 u_nearest_interpolation(
  .pre_clk                                           (clk_25_2m        ),
  .post_clk                                          (clk_74_25m       ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (pre_img_vsync  ),
  .pre_img_hsync                                     (pre_img_hsync  ),
  .pre_img_valid                                     (pre_img_valid  ),
  .pre_img_data                                      (pre_img_data   ),
  .post_img_vsync                                    (post_img_vsync ),
  .post_img_hsync                                    (post_img_hsync ),
  .post_img_valid                                    (post_img_valid ),
  .post_img_data                                     (post_img_data  ) 
);

    bmp_for_videoStream    #
    (
  .iREADY                                            (10             ),//插入 0-10 级流控信号， 10 是满级全速无等待
  .iBMP_FILE_PATH                                    (VOUT_BMP_PATH  ),
  .iBMP_FILE_NAME                                    (VOUT_BMP_NAME  ) 
    )
    u_bmp_for_videoStream
    (
  .clk                                               (clk_74_25m       ),
  .rst_n                                             (rst_n          ),
  .vin_dat                                           (post_img_data  ),//视频数据
  .vin_valid                                         (post_img_valid ),//视频数据有效
  .vin_ready                                         (v2_ready       ),//准备好
  .frame_sync_n                                      (~pre_img_vsync ),//视频帧同步复位，低有效
  .vin_xres                                          (1280           ),//视频水平分辨率
  .vin_yres                                          (720            ) //视频垂直分辨率
    );

initial
begin
    wait(rst_n);
    repeat(500) @(posedge clk);
    fork
      vout_begin_task ;
    join
end
endmodule