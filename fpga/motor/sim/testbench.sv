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
//----------------------------------------------------------------------
  parameter                                          BIT_A          = 19    ;
  parameter                                          BIT_V          = 19    ;
  parameter                                          BIT_S          = 19    ;
  parameter                                          OPT_LONG       = 2000  ;
  parameter                                          QUIT_LONG      = 200   ;
  parameter                                          IDLE           = 5'd1  ;//空闲
  parameter                                          QUIT_OPT       = 5'd2  ;//退出光电
  parameter                                          IN_OPT         = 5'd3  ;//进入光电
  parameter                                          ACC_STATE      = 5'd4  ;//加速阶段
  parameter                                          KEEP_STATE     = 5'd5  ;//匀速阶段
  parameter                                          DEC_STATE      = 5'd6  ;//减速阶段
  parameter                                          ERROR          = 5'd7  ;//报错阶段
  parameter                                          END_STATE      = 5'd8  ;//结束
  reg            [ 255: 0]                       state           ;
    always @(*)begin
    case(u_motor_arbit.state_c)
        IDLE          :state = "idle";
        QUIT_OPT      :state = "QUIT_OPT  ";
        IN_OPT        :state = "IN_OPT    ";
        ACC_STATE     :state = "ACC_STATE ";
        KEEP_STATE    :state = "KEEP_STATE";
        DEC_STATE     :state = "DEC_STATE ";
        ERROR         :state = "ERROR     ";
        END_STATE     :state = "END_STATE ";
        default:    ;
    endcase
end
  reg                                            start           ;
  reg                                            stop            ;
  reg                                            dec             ;
  reg            [BIT_A -1:00]                   acc             ;
  reg            [  15:00]                       start_speed     ;
  reg            [BIT_V-1:00]                    max_speed       ;
  reg            [BIT_V-1:00]                    offset_speed    ;
  reg            [BIT_V-1:00]                    target_speed    ;
  reg            [BIT_S-1:00]                    position_set    ;
  reg            [  10:00]                       zero_position   ;
  reg            [  10:00]                       liquid_position  ;
  reg                                            set_dir         ;
  reg            [  04:00]                       move_mode       ;
  reg                                            limit_signal    ;
  wire     signed[  31:00]                       abs_position    ;
  reg      signed[  31:00]                       abs_set_position  ;
  reg                                            abs_position_set_flag  ;
  reg                                            clear_mt_success  ;
  wire                                           mt_success_int  ;
  wire                                           limit_signal_delay  ;
  wire           [  04:00]                       error_data      ;
  wire                                           dirction        ;
  wire                                           pulse           ;

motor_arbit#(
  .S_MODE                                            (0              ),
  .BIT_A                                             (19             ),
  .BIT_V                                             (19             ),
  .BIT_S                                             (19             ),
  .OPT_LONG                                          (2000           ),
  .QUIT_LONG                                         (200            ) 
)
 u_motor_arbit(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  //电机基础参数部分      
  .start                                             (start          ),
  .stop                                              (stop           ),
  .dec                                               (dec            ),
  .acc                                               (acc            ),
  .start_speed                                       (start_speed    ),
  .max_speed                                         (max_speed      ),
  .offset_speed                                      (offset_speed   ),
  .target_speed                                      (target_speed   ),
  .position_set                                      (position_set   ),
  .zero_position                                     (zero_position  ),
  .liquid_position                                   (liquid_position),
  .set_dir                                           (set_dir        ),
  //电机运动控制部分      
  .move_mode                                         (move_mode      ),
  .limit_signal                                      (limit_signal   ),
  //电机反馈部分
  .abs_position                                      (abs_position   ),
  .abs_set_position                                  (abs_set_position),
  .abs_position_set_flag                             (abs_position_set_flag),
  .clear_mt_success                                  (clear_mt_success),
  .mt_success_int                                    (mt_success_int ),
  .limit_signal_delay                                (limit_signal_delay),
  .error_data                                        (error_data     ),
  //电机输出部分  
  .dirction                                          (dirction       ),
  .pulse                                             (pulse          ) 
);

motor_arbit#(
  .S_MODE                                            (1              ),
  .BIT_A                                             (19             ),
  .BIT_V                                             (19             ),
  .BIT_S                                             (19             ),
  .OPT_LONG                                          (2000           ),
  .QUIT_LONG                                         (200            ) 
)
 u_motor_arbi2(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  //电机基础参数部分      
  .start                                             (start          ),
  .stop                                              (stop           ),
  .dec                                               (dec            ),
  .acc                                               (acc            ),
  .start_speed                                       (start_speed    ),
  .max_speed                                         (max_speed      ),
  .offset_speed                                      (offset_speed   ),
  .target_speed                                      (target_speed   ),
  .position_set                                      (position_set   ),
  .zero_position                                     (zero_position  ),
  .liquid_position                                   (liquid_position),
  .set_dir                                           (set_dir        ),
  //电机运动控制部分      
  .move_mode                                         (move_mode      ),
  .limit_signal                                      (limit_signal   ),
  //电机反馈部分
  .abs_position                                      (abs_position   ),
  .abs_set_position                                  (abs_set_position),
  .abs_position_set_flag                             (abs_position_set_flag),
  .clear_mt_success                                  (clear_mt_success),
  .mt_success_int                                    (mt_success_int ),
  .limit_signal_delay                                (limit_signal_delay),
  .error_data                                        (error_data     ),
  //电机输出部分  
  .dirction                                          (dirction       ),
  .pulse                                             (pulse          ) 
);

    initial  begin
        wait (rst_n);
        max_speed   = 0;
        set_dir = 1;
        zero_position = 10;
        liquid_position = 0;
         start  = 0;
         move_mode = 2;
        acc   = 0;
        position_set     = 0;
        start_speed = 0;
       // stop_speed  = 0;
        dec      = 0;
        repeat(50) @(posedge clk);
        max_speed   = 24000;
        acc   = 600000;
        position_set     = 18000;
        start_speed = 100;
         repeat(50) @(posedge clk);
         start  = 1;
         repeat(1) @(posedge clk);
         start  = 0;
         @(posedge u_motor_arbit.dec2end)  ;
         
         repeat(500) @(posedge clk);
      $stop(2);
    end
endmodule