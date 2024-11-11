`timescale  1ns/1ns
module testbench;

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
  parameter                                          FRAME1_INPUT   = "../../../../data/kun1.dat";//第一帧的数据
  parameter                                          FRAME2_INPUT   = "../../../../data/kun2.dat";//第三帧的数据
  parameter                                          FRAME3_INPUT   = "../../../../data/med_filter.dat";//用第三帧的数据叠加包装盒
  parameter                                          FILE_DIFF      = "../../../../data/fram_diff1.dat";//差分帧的数据
  parameter                                          FILE_DRAW_BOX  = "../../../../data/box_diff1.dat";//画框后的数据
  integer                                        fid             ;
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
//----------------------------------------------------------------------
//  Image data prepred to be processed
  reg                                            pre_img_vsync   ;
  reg                                            pre_img_hsync   ;
  reg                                            pre_img_valid   ;
  reg            [   7: 0]                       pre_img_data    ;

//----------------------------------------------------------------------
//  task and function
task image_input;
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       mem     [H_DISP*V_DISP-1:0];
    $readmemh(FRAME1_INPUT,mem);
    
    for(row_cnt = 0;row_cnt < V_TOTAL;row_cnt++)
    begin
        for(col_cnt = 0;col_cnt < H_TOTAL;col_cnt++)
        begin

          fork
          if(row_cnt < V_SYNC)begin
            pre_img_vsync = 1'b1;
          end
          else begin
            pre_img_vsync = 1'b0;
          end

          if(col_cnt < H_SYNC )begin
            pre_img_hsync = 1'b1;
          end
          else begin
            pre_img_hsync = 1'b0;
          end

          if(((col_cnt >= H_SYNC+H_BACK) && (col_cnt < H_SYNC+H_BACK+H_DISP))
                 &&((row_cnt >= V_SYNC+V_BACK) && (row_cnt < V_SYNC+V_BACK+V_DISP)))begin
                  pre_img_valid =1'b1;
                  pre_img_data  =mem[(row_cnt - V_SYNC-V_BACK)*H_DISP+(col_cnt - H_SYNC-H_BACK)];
                 end
          else begin
            pre_img_valid =0;
            pre_img_data  =    0;
          end
          join
          @(posedge clk);
        end

    end

    
endtask : image_input



    
  wire                                           pre_frame_img_vsync  ;
  wire                                           pre_frame_img_hsync  ;
  wire                                           pre_frame_img_req  ;
  reg            [  07:00]                       pre_frame_img_data  ;
  wire           [  10:00]                       top_edge        ;
  wire           [  10:00]                       bottom_edge     ;
  wire           [  10:00]                       left_edge       ;
  wire           [  10:00]                       right_edge      ;
  wire                                           post_img_vsync  ;
  wire                                           post_img_hsync  ;
  wire                                           post_img_valid  ;
  wire           [  07:00]                       post_img_data   ;


fram_diff_top u_fram_diff_top(
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
  .pre_frame_img_data                                (pre_frame_img_data   ),
  .box_flag                                          (box_flag       ),
  .top_edge                                          (top_edge       ),
  .bottom_edge                                       (bottom_edge    ),
  .left_edge                                         (left_edge      ),
  .right_edge                                        (right_edge     ),
  .post_img_vsync                                    (post_img_vsync ),
  .post_img_hsync                                    (post_img_hsync ),
  .post_img_valid                                    (post_img_valid ),
  .post_img_data                                     (post_img_data  ) 
);
 reg                                            pre_frame_img_vsync_d  ;

  always @(posedge clk) begin
    if(!rst_n)
      pre_frame_img_vsync_d <= 1'b0;
    else
      pre_frame_img_vsync_d <= pre_frame_img_vsync;
  end

  wire                                           pre_frame_img_vsync_pos,pre_frame_img_vsync_neg  ;
  assign                                             pre_frame_img_vsync_pos= pre_frame_img_vsync& ~pre_frame_img_vsync_d;
  assign                                             pre_frame_img_vsync_neg= ~pre_frame_img_vsync&pre_frame_img_vsync_d;

task  image_req; //任务名
    bit             [31:0]      row_cnt1;
    bit             [31:0]      col_cnt1;
    bit             [7:0]       mem1     [H_DISP*V_DISP-1:0];
    $readmemh(FRAME2_INPUT,mem1);
    while(1)begin
        @(posedge clk);
          if(pre_frame_img_vsync_pos == 1'b1)begin
            row_cnt1 = 0;
            col_cnt1 = 0;
          end
          if(pre_frame_img_req == 1'b1)
          begin
          col_cnt1 = col_cnt1 + 1;
          pre_frame_img_data = mem1[(row_cnt1)*H_DISP+ col_cnt1-1];
        end
        if(col_cnt1 == H_DISP )
              begin
                  col_cnt1 = 0;
                  row_cnt1 = row_cnt1 + 1;
              end
        if(col_cnt1 == H_DISP-1 && row_cnt1 == V_DISP-1)
          begin
              $display("##############image REQ  end##############");
          end
      end
endtask :image_req

  reg                                            post_img_vsync_r  ;

  always @(posedge clk) begin
    if(!rst_n)
      post_img_vsync_r <= 1'b0;
    else
      post_img_vsync_r <= post_img_vsync;
  end

  wire                                           post_img_vsync_pos,post_img_vsync_neg  ;
  assign                                             post_img_vsync_pos= post_img_vsync& ~post_img_vsync_r;
  assign                                             post_img_vsync_neg= ~post_img_vsync&post_img_vsync_r;
  reg      data_done;
task  image_output;                                                 //任务名
  
  bit             [31:0]      row_cnt2;
  bit             [31:0]      col_cnt2;
  while(1)begin
      @(posedge clk);
        if(post_img_vsync_pos == 1'b1)begin
          row_cnt2 = 0;
          col_cnt2 = 0;
          fid = $fopen(FILE_DIFF,"w");
          $display("======image_result_check begin=========");
        end
        if(post_img_valid == 1'b1)
        begin
        $fwrite(fid,"%.2h ",post_img_data);
        col_cnt2 = col_cnt2 + 1;
      end
      if(col_cnt2 == H_DISP)
            begin
              $fwrite(fid,"\n");
                col_cnt2 = 0;
                row_cnt2 = row_cnt2 + 1;
            end
      if(col_cnt2 == H_DISP-1 && row_cnt2 == V_DISP-1)
        begin
          data_done = 1'b1;
          $fwrite(fid,"%.2h ",post_img_data);
          $fclose(fid);
            $display("##############image result check end##############");
        end
    end
endtask  : image_output


    reg                                        draw_box_pre_img_vsync              ;
    reg                                        draw_box_pre_img_hsync              ;
    reg                                        draw_box_pre_img_valid              ;
    reg                       [  07:00]        draw_box_pre_img_data               ;
    wire                                       draw_box_post_img_vsync             ;
    wire                                       draw_box_post_img_hsync             ;
    wire                                       draw_box_post_img_valid             ;
    wire                      [  07:00]        draw_box_post_img_data              ;

draw_box u_draw_box(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .pre_img_vsync                      (draw_box_pre_img_vsync             ),
    .pre_img_hsync                      (draw_box_pre_img_hsync             ),
    .pre_img_valid                      (draw_box_pre_img_valid             ),
    .pre_img_data                       (draw_box_pre_img_data              ),
    .box_flag                           (1'b1                     ),
    .top_edge                           (top_edge                  ),
    .bottom_edge                        (bottom_edge               ),
    .left_edge                          (left_edge                 ),
    .right_edge                         (right_edge                ),
    .post_img_vsync                     (draw_box_post_img_vsync            ),
    .post_img_hsync                     (draw_box_post_img_hsync            ),
    .post_img_valid                     (draw_box_post_img_valid            ),
    .post_img_data                      (draw_box_post_img_data             )
);

task image_input_diff;
    bit             [31:0]      row_cnt3;
    bit             [31:0]      col_cnt3;
    bit             [7:0]       mem3     [H_DISP*V_DISP-1:0];
    $readmemh(FRAME3_INPUT,mem3);

      for(row_cnt3 = 0;row_cnt3 < V_TOTAL;row_cnt3++)
      begin
        for(col_cnt3 = 0;col_cnt3 < H_TOTAL;col_cnt3++)
        begin
          fork

          if(row_cnt3 < V_SYNC)begin
            draw_box_pre_img_vsync = 1'b1;
          end
          else begin
            draw_box_pre_img_vsync = 1'b0;
          end

          if(col_cnt3 < H_SYNC )begin
            draw_box_pre_img_hsync = 1'b1;
          end
          else begin
            draw_box_pre_img_hsync = 1'b0;
          end

          if(((col_cnt3 >= H_SYNC+H_BACK) && (col_cnt3 < H_SYNC+H_BACK+H_DISP))
                 &&((row_cnt3 >= V_SYNC+V_BACK) && (row_cnt3 < V_SYNC+V_BACK+V_DISP)))begin
                  draw_box_pre_img_valid =1'b1;
                  draw_box_pre_img_data  =mem3[(row_cnt3 - V_SYNC-V_BACK)*H_DISP+(col_cnt3 - H_SYNC-H_BACK)];
                 end
          else begin
            draw_box_pre_img_valid =0;
            draw_box_pre_img_data  =    0;
          end
          join
          @(posedge clk);
        end
      end
endtask : image_input_diff

reg                                            draw_box_post_img_vsync_r  ;

  always @(posedge clk) begin
    if(!rst_n)
      draw_box_post_img_vsync_r <= 1'b0;
    else
      draw_box_post_img_vsync_r <= draw_box_post_img_vsync;
  end

  wire                                           draw_box_post_img_vsync_pos,draw_box_post_img_vsync_neg  ;
  assign                                             draw_box_post_img_vsync_pos= draw_box_post_img_vsync& ~draw_box_post_img_vsync_r;
  assign                                             draw_box_post_img_vsync_neg= ~draw_box_post_img_vsync&draw_box_post_img_vsync_r;


task  image_output_diff;                                                 //任务名
  
  bit             [31:0]      row_cnt4;
  bit             [31:0]      col_cnt4;
  while(1)begin
      @(posedge clk);
        if(draw_box_post_img_vsync_pos == 1'b1)begin
          row_cnt4 = 0;
          col_cnt4 = 0;
          fid = $fopen(FILE_DRAW_BOX,"w");
          $display("======image_output_diff begin=========");
        end
        if(draw_box_post_img_valid == 1'b1)
        begin
        $fwrite(fid,"%.2h ",draw_box_post_img_data);
        col_cnt4 = col_cnt4 + 1;
      end
      if(col_cnt4 == H_DISP)
            begin
              $fwrite(fid,"\n");
                col_cnt4 = 0;
                row_cnt4 = row_cnt4 + 1;
            end
      if(col_cnt4 == H_DISP-1 && row_cnt4 == V_DISP-1)
        begin
          $fwrite(fid,"%.2h ",draw_box_post_img_data);
          $fclose(fid);
            $display("############## image_output_diff  end##############");
        end
    end
endtask  : image_output_diff

initial
begin
    pre_img_vsync = 0;
    pre_img_hsync  = 0;
    pre_img_data  = 0;
    pre_img_valid = 0;
    draw_box_pre_img_vsync = 0;
    draw_box_pre_img_hsync  = 0;
    draw_box_pre_img_data  = 0;
    draw_box_pre_img_valid = 0;
    data_done = 0;
end

initial
begin
    wait(rst_n);
    repeat(5) @(posedge clk);
    fork
            image_input;
            image_req;
            image_output;
            
    join

end

  initial begin
    wait(data_done);
      repeat(5) @(posedge clk);
      fork
        image_input_diff;
        image_output_diff;
      join
  end

endmodule