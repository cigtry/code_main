`timescale  1ns/1ns
module testbench;

//----------------------------------------------------------------------
//  clk & rst_n
  reg                                            clk             ;
  reg                                            rst_n           ;

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end
//------------------------------ ----------------------------------------
logic                      pre_img_vsync;
logic                      pre_img_hsync;
logic                      pre_img_valid;
logic      [23:0]          pre_img_data;
  wire                                           vout_done       ;
logic    [15:0]    bmp1_xres;
logic    [15:0]    bmp1_yres;
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
  parameter                                          VOUT_BMP_NAME  = "RGB2YCBCR";
bmp_to_videoStream    #
(
  .iBMP_FILE_PATH                                    (VIN_BMP_PATH   ),
  .iBMP_FILE_NAME                                    (VIN_BMP_FILE)  ) 
U_bmp_to_videoStream(
  .clk                                               (clk            ),
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

  wire                                           post_img_vsync  ;
  wire                                           post_img_herf   ;
  wire                                           post_img_valid  ;
  wire           [   7: 0]                       post_img_Y      ;
  wire           [   7: 0]                       post_img_Cb     ;
  wire           [   7: 0]                       post_img_Cr     ;

rgb2ycbcr u_rgb2ycbcr(
  .clk                                               (clk            ),// system clock 50MHz
  .rst_n                                             (rst_n          ),// reset, low valid
  .per_img_vsync                                     (pre_img_vsync  ),
  .per_img_herf                                      (pre_img_hsync  ),
  .per_img_valid                                     (pre_img_valid  ),
  .per_img_red                                       (pre_img_data[15:8]),
  .per_img_green                                     (pre_img_data[23:16]),
  .per_img_blue                                      (pre_img_data[7:0]),
  .post_img_vsync                                    (post_img_vsync ),
  .post_img_herf                                     (post_img_herf  ),
  .post_img_valid                                    (post_img_valid ),
  .post_img_Y                                        (post_img_Y     ),
  .post_img_Cb                                       (post_img_Cb    ),
  .post_img_Cr                                       (post_img_Cr    ) 
);


    bmp_for_videoStream    #
    (
  .iREADY                                            (10             ),//插入 0-10 级流控信号， 10 是满级全速无等待
  .iBMP_FILE_PATH                                    (VOUT_BMP_PATH  ) ,
  .iBMP_FILE_NAME                                     (VOUT_BMP_NAME)
    )
    u03
    (
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .vin_dat                                           (post_img_Y     ),//视频数据
  .vin_valid                                         (post_img_valid ),//视频数据有效
  .vin_ready                                         (v2_ready       ),//准备好
  .frame_sync_n                                      (~post_img_vsync),//视频帧同步复位，低有效
  .vin_xres                                          (bmp1_xres      ),//视频水平分辨率
  .vin_yres                                          (bmp1_yres      ) //视频垂直分辨率
    );

initial
begin
    wait(rst_n);
    repeat(5) @(posedge clk);
    fork
      vout_begin_task ;
        //image_result_check;
    join
end
endmodule