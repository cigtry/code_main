`timescale  100ps/100ps
module testbench;

//----------------------------------------------------------------------
//  clk & rst_n
  reg                                            clk             ;
  reg                                          q0_clk;
  reg                                        clk_in                     ;
  reg                                            rst_n           ;

initial
begin
    clk = 1'b0;
    forever #100 clk = ~clk;
end


initial
begin
    q0_clk = 1'b0;
    forever #40 q0_clk = ~q0_clk;
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
  parameter                                          VIN_BMP_PATH   = "D:/fuxin/code_main/picture/";
  parameter                                          VOUT_BMP_PATH  = VIN_BMP_PATH;//"../../../../../vouBmpV/";
  parameter                                          VOUT_BMP_NAME  = "sfp_8b10b_top";
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


    wire                                         q0_ck1_n_in                ;
    wire                                         q0_ck1_p_in                ;
    reg                       [  01:00]        rxn_in                     ;
    reg                       [  01:00]        rxp_in                     ;
    wire                      [  01:00]        txn_out                    ;
    wire                      [  01:00]        txp_out                    ;
    wire                      [  01:00]        tx_disable                 ;

    assign     rxn_in = {txn_out[0],txn_out[1]}  ;
    assign     rxp_in = {txp_out[0],txp_out[1]}  ;
    reg                                        vs_in                      ;
    reg                                        data_valid_in              ;
    reg                       [  15:00]        data_in                    ;
    wire                                       vs_out                     ;
    wire                                       data_valid_out             ;
    wire                      [  15:00]        data_out                   ;
    
OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
   ) OBUFDS_inst (
      .O(q0_ck1_n_in),     // Diff_p output (connect directly to top-level port)
      .OB(q0_ck1_p_in),   // Diff_n output (connect directly to top-level port)
      .I(q0_clk)      // Buffer input
   );
sfp_8b10b_top u_sfp_8b10b_top(
  //光口接口
    .q0_ck1_n_in                        (q0_ck1_n_in               ),
    .q0_ck1_p_in                        (q0_ck1_p_in               ),
    .rxn_in                             (rxn_in                    ),
    .rxp_in                             (rxp_in                    ),
    .txn_out                            (txn_out                   ),
    .txp_out                            (txp_out                   ),
    .tx_disable                         (tx_disable                ),
  //用户接口
    .drp_clk                            (clk                       ),
    .clk_in                             (clk                       ),
    .rst_n                              (rst_n                     ),
    .vs_in                              (pre_img_vsync                     ),
    .data_valid_in                      (pre_img_valid            ),
    .data_in                            (pre_img_data[15:00]                    ),
    .vs_out                             (vs_out                    ),
    .data_valid_out                     (data_valid_out            ),
    .data_out                           (data_out                  )
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
  .vin_dat                                           (data_out[7:0]     ),//视频数据
  .vin_valid                                         (data_valid_out ),//视频数据有效
  .vin_ready                                         (v2_ready       ),//准备好
  .frame_sync_n                                      (~vs_out),//视频帧同步复位，低有效
  .vin_xres                                          (bmp1_xres      ),//视频水平分辨率
  .vin_yres                                          (bmp1_yres      ) //视频垂直分辨率
    ); 

initial
begin
    wait(rst_n);
    @(u_sfp_8b10b_top.rx1_rst_n);
    repeat(5) @(posedge clk);
    fork
      vout_begin_task ;
        //image_result_check;
    join
end
endmodule