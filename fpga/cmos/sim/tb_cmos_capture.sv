/* ================================================ *\
      Filename ﹕
      Author ﹕ fffff
    Description  ﹕
     Called by ﹕
Revision History  ﹕ 2022/-/-
              Revision 1.0
          Email﹕ 17602369756@163.com
      Company﹕
\* ================================================ */

`timescale 1ns/1ns                                                  //仿真系统时间尺度定义

`define clk_period 12                                               //时钟周期参数定义  

module tb_cmos_capture();
//激励信号定义  
  reg                                            cmos_pclk       ;
  reg                                            rst_n           ;

  reg                                            cmos_vsync      ;
  reg                                            cmos_herf       ;
  reg            [   7: 0]                       cmos_data       ;

  reg                                            config_done     ;
  wire                                           cmos_frame_sop  ;
  wire                                           cmos_frame_eop  ;
  wire                                           cmos_frame_valid  ;
  wire           [  23: 0]                       cmos_frame_data  ;
//响应信号定义    
cmos_capture   cmos_capture(
  .rst_n                                             (rst_n          ),//reset, low valid

  .cmos_pclk                                         (cmos_pclk      ),
  .cmos_vsync                                        (cmos_vsync     ),
  .cmos_herf                                         (cmos_herf      ),
  .cmos_data                                         (cmos_data      ),
  .cmos_cfg_done                                     (config_done    ),

  .cmos_frame_valid_w                                (cmos_frame_valid),
  .cmos_frame_data                                   (cmos_frame_data),
  .cmos_frame_sop_w                                  (cmos_frame_sop ),//帧头，与第一个数据对齐
  .cmos_frame_eop_w                                  (cmos_frame_eop ) //帧尾，与最后一个数据对齐
);

//实例化
  localparam                                         image_width    = 1280  ;
  localparam                                         image_height   = 720   ;

//实例化
  task  img_input;                                                  //任务名
  reg            [  31: 0]                       row_cnt         ;
  reg            [  31: 0]                       col_cnt         ;
  reg            [   7: 0]                       mem                [image_width*image_height*3-1:0]  ;
      $readmemh("D:/fuxin/matlab/img_RGB.dat",mem);
        repeat(5)@(posedge cmos_pclk);
        cmos_vsync = 1'b1;
      for (row_cnt = 0 ;row_cnt< image_height ; row_cnt++) begin

        repeat(5)@(posedge cmos_pclk);
        cmos_vsync = 1'b0;
        repeat(5)@(posedge cmos_pclk);
        for (col_cnt = 0;col_cnt< image_width ;col_cnt++ ) begin
          cmos_herf  = 1'b1;
          cmos_data =mem[(row_cnt*image_width+col_cnt)];
          @(posedge cmos_pclk);
        end
         cmos_herf  = 1'b0;
      end
      cmos_vsync = 1'b0;
      @(posedge cmos_pclk);
      repeat(50)@(posedge cmos_pclk);
  endtask : img_input

//产生时钟                          
  initial cmos_pclk = 1'b0;
  always #(`clk_period / 2) cmos_pclk = ~cmos_pclk;

//产生激励   
  initial  begin
        rst_n = 1'b0;
        cmos_vsync =1'b0;
        cmos_herf = 1'b0;
        config_done=1'b1;
        #(`clk_period * 10 + 3);
        rst_n = 1'b1;
        /* #(`clk_period * 10);
        cmos_vsync =1'b1;
        #(`clk_period * 50);
        cmos_herf = 1'b1;
       //repeat(50)begin
       //    cmos_data=8'h25;
       //    #(`clk_period * 1); 
       //end
        repeat(50)begin
            cmos_data=$random();
            #(`clk_period * 1);
        end
        cmos_data=8'h25;
            #(`clk_period * 20);
       cmos_herf = 1'b0;
        #(`clk_period * 50);
         cmos_vsync =1'b0;
          #(`clk_period * 500); */
        wait(rst_n);
        repeat(50)begin
          fork
          begin
            repeat(5) @(posedge cmos_pclk );
            img_input;
          end
        join
        repeat(500) @(posedge cmos_pclk );
        end
        
        $stop(2);
    end

endmodule