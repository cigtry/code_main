`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
//Company             :    maccura    
//Engineer            :    FuXin     
//Creat Date          :    2024-05-14
//Design Name         :             
//Module Name         :             
//Project Name        :            
//Target Devices      :            
//Tool Version        :            
//Description         :            
//Revisoion           :               
//Additional Comments :          
/***
 * ░░░░░░░░░░░░░░░░░░░░░░░░▄░░
 * ░░░░░░░░░▐█░░░░░░░░░░░▄▀▒▌░
 * ░░░░░░░░▐▀▒█░░░░░░░░▄▀▒▒▒▐
 * ░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
 * ░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
 * ░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
 * ░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒
 * ░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
 * ░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄
 * ░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒
 * ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒
 * 单身狗就这样默默地看着你，一句话也不说 。
*/
////////////////////////////////////////////////////////////////
module motor_arbit#(
  parameter                                          S_MODE         = 1     ,
  parameter                                          BIT_A          = 19    ,
  parameter                                          BIT_V          = 19    ,
  parameter                                          BIT_S          = 19    ,
  parameter                                          OPT_LONG       = 2000  ,
  parameter                                          QUIT_LONG      = 200   
)(
  input  wire                                    clk             ,//system clock 100MHz
  input  wire                                    rst_n           ,//reset, low valid
  //电机基础参数部分      
  input  wire                                    start           ,//电机启动信号
  input  wire                                    stop            ,//电机停止信号
  input  wire                                    dec             ,//电机减速信号
  input  wire    [BIT_A -1:00]                   acc             ,//加速度
  input  wire    [  15:00]                       start_speed     ,//初速度
  input  wire    [BIT_V-1:00]                    max_speed       ,//最大速度
  input  wire    [BIT_V-1:00]                    offset_speed    ,//是复位速度
  input  wire    [BIT_V-1:00]                    target_speed    ,//速度模式目标速度
  input  wire    [BIT_S-1:00]                    position_set    ,//运动距离
  input  wire    [  10:00]                       zero_position   ,//电机复位原点位置，离光电边沿的距离
  input  wire    [  10:00]                       liquid_position ,//电机正常复位，需要先匀速提出液面的距离
  input  wire                                    set_dir         ,//初始方向（正向以此为准）
  //电机运动控制部分      
  input  wire    [  04:00]                       move_mode       ,//电机运动模式
  input  wire                                    limit_signal    ,//复位光电信号
  //电机反馈部分
  output reg  signed[  31:00]                       abs_position    ,//电机绝对位置反馈（虚拟编码器）
  input  wire signed[  31:00]                       abs_set_position,//电机初始位置设置
  input  wire                                    abs_position_set_flag,//电机初始位置使能信号
  input  wire                                    clear_mt_success,//电机运动完成标志清除
  output reg                                     mt_success_int  ,//电机运动完成标志
  output reg                                     limit_signal_delay,//存储电机完成时的光电状态
  output reg     [  04:00]                       error_data      ,
  //电机输出部分  
  output reg                                     dirction        ,
  output wire                                    pulse            
);
  localparam                                         POWER_ON_RST         = 5'd0  ;/* ->上电复位          */
  localparam                                         NORMAL_RST           = 5'd1  ;/* ->正常复位          */
  localparam                                         FORWORD_MOVE         = 5'd2  ;/* ->正向运动          */  
  localparam                                         BACKWORD_MOVE        = 5'd3  ;/* ->反向运动          */
  localparam                                         FORWORD_SPEED        = 5'd4  ;/* ->正向速度模式      */  
  localparam                                         BACKWORD_SPEED       = 5'd5  ;/* ->反向速度模式      */
  localparam                                         FORWORD_SPEED_LIMIT  = 5'd6  ;/* ->正向限制速度模式  */  
  localparam                                         BACKWORD_SPEED_LIMIT = 5'd7  ;/* ->反向限制速度模式  */

  parameter                                          IDLE           = 5'd1  ;//空闲
  parameter                                          QUIT_OPT       = 5'd2  ;//退出光电
  parameter                                          IN_OPT         = 5'd3  ;//进入光电
  parameter                                          ACC_STATE      = 5'd4  ;//加速阶段
  parameter                                          KEEP_STATE     = 5'd5  ;//匀速阶段
  parameter                                          DEC_STATE      = 5'd6  ;//减速阶段
  parameter                                          ERROR          = 5'd7  ;//报错阶段
  parameter                                          END_STATE      = 5'd8  ;//结束
  reg                [  04:00]        state_c,state_n           /* synthesis preserve = 1 */ ;
  reg            [  04:00]                       move_mode_r     ;//运动模式锁存
  reg                                            motor_busy      ;
  reg                                            limit_signal_d  ;
  reg                                            opt_in2out      ;
  reg                                            opt_in2out_ok   ;//电机退出光电成功标志
  reg                                            opt_out2in      ;
  reg                                            opt_out2in_ok   ;//电机进入光电成功标志
  reg                                            quit_opt_ok     ;//退出光电成功
  reg                                            quit_opt_error  ;//退出光电失败
  reg                                            in_opt_ok       ;//进入光电成功
  reg                                            in_opt_error    ;//进入光电失败
  reg                                            acc2keep        ;//速度到达最大速度后保持匀速运动
  reg                                            acc2error       ;//正常复位时 加速阶段触发到光电信号
  reg                                            acc2dec         ;//运动距离较短不支持达到最大速度，运动距离过半直接减速
  reg                                            keep2dec        ;//剩余距离等于加速段距离开始减速
  reg                                            keep2error      ;//匀速过程中触发到光电
  reg                                            dec2end         ;//运动完成回到空闲状态
  reg                                            dec2err         ;//正常复位减速过程中提前触碰到光电
  reg                                            dec2in_opt      ;//正常复位减速到匀速进入光电
  reg                                            speed_mode_acc2keep  ;//速度模式 加速到匀速
  reg                                            speed_mode_acc2dec  ;//速度模式 加速到减速
  reg                                            speed_mode_keep2dec  ;//速度模式 匀速到减速
  reg                                            speed_mode_keep2acc  ;//速度模式 匀速到加速
  reg                                            speed_mode_dec2keep  ;//速度模式 减速到匀速
  reg                                            speed_mode_dec2acc  ;//速度模式 减速到加速
  reg                                            speed_mode_limit_end_flag  ;//速度限制模式，走完规定步长后停止
  reg                                            error_report_ok  ;//错误码返回完成  
  reg                                            start_d         ;//开始信号打一拍
  wire                                           pos_start       ;
  reg                                            short_normal_rst_flag  ;//设置的复位距离小于原点加QUIT_LONG;时直接走上电复位

  reg            [BIT_S-1:00]                    position        ;
  reg                                            normal_in_opt_error  ;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_d <= 1'b0;
    end
    else begin
      start_d  <= start;
    end
  end

  assign                                             pos_start      = start && (!start_d);

  always @(posedge clk or negedge rst_n)begin
      if(!rst_n)
        move_mode_r   <= POWER_ON_RST;
      else if(start)
        move_mode_r <= move_mode ;
      else
        move_mode_r <= move_mode_r ;
  end

  always @(posedge clk )begin
    limit_signal_d <= limit_signal;
  end

  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
      opt_in2out <= 1'b0;
    else if((!limit_signal ) && (limit_signal_d ))
      opt_in2out <= 1'b1;
    else
      opt_in2out <= 1'b0;
  end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      opt_out2in <= 1'b0;
    end
    else if((limit_signal ) && (!limit_signal_d ))begin
      opt_out2in <= 1'b1;
    end
    else begin
      opt_out2in <= 1'b0;
    end
  end                                                               //always end
  reg                                            dec_d           ;
  wire                                           pos_dec         ;
  assign                                             pos_dec        = dec && (!dec_d);
  reg                                            dec_flag        ;//减速标志
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      dec_flag <= 1'b0;
    end
    else if(state_c == END_STATE)begin
      dec_flag <= 1'b0;
    end
    else if(pos_dec)begin
      dec_flag <= 1'b1;
    end
    else begin
      dec_flag <= dec_flag ;
    end
  end                                                               //always end
  
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      dec_d <= 1'b0;
    end
    else begin
      dec_d <= dec;
    end
  end                                                               //always end
  
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      state_c <= IDLE;
    end
    else if(stop && motor_busy)
      state_c <= END_STATE;
    else if(speed_mode_limit_end_flag && motor_busy)begin
      state_c <= END_STATE;
    end
    else if (pos_dec && motor_busy )
      state_c <= DEC_STATE ;
    else
      state_c <= state_n;
  end

    always @(*)begin
    case(state_c)
      IDLE       : begin
        if(pos_start)begin
          case(move_mode)
            POWER_ON_RST : begin
              if(limit_signal)
                state_n = QUIT_OPT;
              else
                state_n = IN_OPT;
            end
            NORMAL_RST : begin
              if(limit_signal )
                state_n = QUIT_OPT;
              else if(short_normal_rst_flag)
                state_n = IN_OPT;
              else
                state_n = ACC_STATE;
            end
            FORWORD_MOVE : begin
                state_n = ACC_STATE;
            end
            BACKWORD_MOVE : begin
                state_n = ACC_STATE;
            end
            FORWORD_SPEED : begin
                state_n = ACC_STATE;
            end
            BACKWORD_SPEED : begin
                state_n = ACC_STATE;
            end
            FORWORD_SPEED_LIMIT : begin
                state_n = ACC_STATE;
            end
            BACKWORD_SPEED_LIMIT : begin
                state_n = ACC_STATE;
            end
            default:state_n = state_c;
          endcase
        end
        else begin
          state_n = state_c;
        end
      end
      QUIT_OPT   : begin
        if(quit_opt_ok)begin
          state_n = IN_OPT;
        end
        else if(quit_opt_error)begin
          state_n = ERROR;
        end
        else
          state_n = state_c;
      end
      IN_OPT     : begin
        if (in_opt_ok) begin
          state_n = END_STATE;
        end
        else if (in_opt_error) begin
          state_n = ERROR;
        end
        else begin
          state_n = state_c;
        end
      end
      ACC_STATE  : begin
        if (acc2error) begin
          state_n = ERROR;
        end
        else if (acc2dec | speed_mode_acc2dec) begin
          state_n = DEC_STATE;
        end
        else if(acc2keep | speed_mode_acc2keep)begin
          state_n = KEEP_STATE;
        end
        else begin
          state_n = state_c;
        end
      end
      KEEP_STATE : begin
        if (keep2error) begin
          state_n = ERROR;
        end
        else if (keep2dec| speed_mode_keep2dec) begin
          state_n = DEC_STATE;
        end
        else if(speed_mode_keep2acc)begin
          state_n = ACC_STATE;
        end
        else begin
          state_n = state_c;
        end
      end
      DEC_STATE  : begin
        if (dec2in_opt) begin
          state_n = IN_OPT;
        end
        else if(speed_mode_dec2keep)begin
          state_n = KEEP_STATE;
        end
        else if(speed_mode_dec2acc)begin
          state_n = ACC_STATE;
        end
        else if (dec2end) begin
          state_n = END_STATE;
        end
        else begin
          state_n = state_c;
        end
      end
      ERROR      : begin
        if (error_report_ok) begin
          state_n = END_STATE;
        end
        else begin
          state_n = state_c;
        end
      end
      END_STATE  : begin
        state_n =IDLE;
      end
      default : begin state_n =IDLE;end
    endcase
  end
//=================================================//
//---------------电机运动计算部分-------------------//
//=================================================//
//----------------SPTA Unit-----------------//
//spta算法 以时钟周期T为最小加法单位，累加时钟频率个时钟周期为1秒，
//即t=100_000_000*T=100M*10ns=1s,以1s为基准，参考速度变快或者变慢

  localparam                                         CLK_FRQE       = 28'd100_000_000;
  reg            [  27:00]                       v_unit          ;
  reg            [  27:00]                       s_unit          ;
  reg            [BIT_S - 1: 00]                 mt_current_s    ;//当前位移量
  reg            [BIT_S - 1: 00]                 mt_current_s_d  ;//位移量打一拍
  reg            [BIT_V - 1: 00]                 mt_current_v    ;//当前速度
  reg            [BIT_A - 1: 00]                 acc_state_acc   ;//加速阶段的加速度
  reg                                            start_gen_step  ;//脉冲产生标志
  reg            [BIT_S - 1 : 00]                dec_current_s   ;
  reg            [BIT_S - 2 : 00]                acc_current_s   ;//加速阶段的脉冲数

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      short_normal_rst_flag <= 1'b0;
    end
    else if((move_mode == NORMAL_RST) && (position_set < (zero_position + QUIT_LONG)) && start)begin
      short_normal_rst_flag <= 1'b1;
    end
    else if(state_c == END_STATE)begin
      short_normal_rst_flag <= 1'b0;
    end
    else begin
      short_normal_rst_flag <= short_normal_rst_flag;
    end
  end

  always @(posedge clk ) begin
    if ((!short_normal_rst_flag) && (move_mode_r == NORMAL_RST)) begin
      position <= position_set - zero_position - QUIT_LONG - liquid_position;
    end
    else begin
      position <= position_set;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      motor_busy <= 1'b0;
    end
    else if (state_c == END_STATE) begin
      motor_busy <= 1'b0;
    end
    else if(start && (~motor_busy))begin
      motor_busy <= 1'b1 ;
    end
    else begin
       motor_busy <= motor_busy ;
    end
  end

  generate
  if (S_MODE == 1) begin
  reg            [BIT_V - 2 : 00 ]               s_v_judge_speed  ;
  reg            [  27:00]                       a_unit          ;
      always @(posedge clk ) begin
        s_v_judge_speed <= (max_speed - start_speed) >> 1 ;
      end
      //--加速度单元
      always @ (posedge clk or negedge rst_n)begin
        if ( !rst_n )
            a_unit  <=  28'd0;
        else begin
            case ( state_c )
                ACC_STATE  :  begin
                  if (a_unit >= CLK_FRQE)
                    a_unit  <=  a_unit - CLK_FRQE + acc;
                  else
                    a_unit  <=  a_unit + acc;
                end
                DEC_STATE  :  begin
                  if (a_unit >= CLK_FRQE)
                    a_unit  <=  a_unit - CLK_FRQE + acc;
                  else
                    a_unit  <=  a_unit + acc;
                end
                default : a_unit <= 28'd0;
            endcase
        end
      end
      //当前加速度
      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          acc_state_acc <= {(BIT_A - 1 ){1'b0}};
        end
        else begin
         case ( state_c )
                ACC_STATE  :  begin
                  if (mt_current_v <= s_v_judge_speed) begin
                    if (a_unit >= CLK_FRQE)
                      acc_state_acc  <=  acc_state_acc + {{(BIT_A-1){1'b0}},1'b1};
                    else
                      acc_state_acc  <=  acc_state_acc;
                  end
                  else begin
                    if (a_unit >= CLK_FRQE)
                      acc_state_acc  <=  acc_state_acc - {{(BIT_A-1){1'b0}},1'b1};
                    else
                      acc_state_acc  <=  acc_state_acc;
                  end
                end
                DEC_STATE  :  begin
                  if (mt_current_v > s_v_judge_speed) begin
                    if (a_unit >= CLK_FRQE)
                      acc_state_acc  <=  acc_state_acc + {{(BIT_A-1){1'b0}},1'b1};
                    else
                      acc_state_acc  <=  acc_state_acc;
                  end
                  else begin
                    if (a_unit >= CLK_FRQE)
                      acc_state_acc  <=  acc_state_acc - {{(BIT_A-1){1'b0}},1'b1};
                    else
                      acc_state_acc  <=  acc_state_acc;
                  end
                end
                default : acc_state_acc <= 28'd0;
            endcase
        end
      end
    end
    else begin
      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          acc_state_acc <= {(BIT_A - 1 ){1'b0}};
        end
        else begin
          acc_state_acc <= acc;
        end
      end
    end
  endgenerate
  
  //--速度单元
    always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          v_unit  <=  28'd0;
      else begin
          case ( state_c )
              ACC_STATE ,DEC_STATE :  begin
                if (v_unit >= CLK_FRQE)
                  v_unit  <=  v_unit - CLK_FRQE + acc_state_acc;
                else
                  v_unit  <=  v_unit + acc_state_acc;
              end
              default : v_unit <= 28'd0;
          endcase
      end
    end

  //--当前移动速度
  always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          mt_current_v  <=  {BIT_V{1'b0}};
      else begin
          case ( state_c )
              IDLE   :  begin
                  mt_current_v  <=  start_speed;                    //配置启动速度
              end
              IN_OPT , QUIT_OPT : begin
                  mt_current_v  <=  offset_speed;                   //配置复位速度
              end
              ACC_STATE  :  begin
                  if (v_unit >= CLK_FRQE)
                      mt_current_v  <=  mt_current_v + {{(BIT_V-1){1'b0}},1'b1};
                  else
                      mt_current_v  <=  mt_current_v;
              end
              KEEP_STATE :  begin
                mt_current_v <= max_speed;
              end
              DEC_STATE  :  begin
                if(mt_current_v <= start_speed)begin
                  mt_current_v <= start_speed;
                end
                else begin
                  if (v_unit >= CLK_FRQE)
                      mt_current_v  <=  mt_current_v - {{(BIT_V-1){1'b0}},1'b1};
                  else
                      mt_current_v  <=  mt_current_v;
                end
              end
              ERROR ,END_STATE : begin
                mt_current_v  <=  {BIT_V{1'b0}};
              end
              default : begin
                mt_current_v  <=  {BIT_V{1'b0}};
              end
          endcase
      end
  end

  //--位移单元
  always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          s_unit  <=  28'd0;
      else if (state_c != IDLE) begin
          if (s_unit >= CLK_FRQE)
              s_unit  <=  s_unit - CLK_FRQE + mt_current_v;
          else
              s_unit  <=  s_unit + mt_current_v;
      end
      else
          s_unit  <=  28'd0;
  end

  //--当前位移量
  always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          mt_current_s  <=  {BIT_S{1'b0}};
      else if (state_c != IDLE) begin
          if (s_unit >= CLK_FRQE)
              mt_current_s  <=  mt_current_s + {{(BIT_S-1){1'b0}},1'b1};
         else
              mt_current_s  <=  mt_current_s;
      end
      else
          mt_current_s  <=  {BIT_S{1'b0}};
  end

//Motor step
    always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          mt_current_s_d    <=  {BIT_S{1'b0}};
      else
          mt_current_s_d    <=  mt_current_s;
    end

    always @ (posedge clk or negedge rst_n)begin
      if ( !rst_n )
          start_gen_step  <=  1'b0;
      else if (state_c != IDLE) begin
          if (mt_current_s_d != mt_current_s)
              start_gen_step  <=  1'b1;
          else
              start_gen_step  <=  1'b0;
      end
      else
          start_gen_step  <=  1'b0;
    end

//电机逻辑处理
  reg            [  15:00]                       quit_opt_s      ;//退出光电后运动的距离 
  reg            [  15:00]                       in_opt_s        ;//进入光电后运动的距离
  //========================================================//
  //================退出光电部分============================//
  //电机执行复位命令，正常或者上电后，开始时检测到光电会先退出光电//
  //如果电机走完了整个光电的长度（在这里加了余量）防止不够 还未检测到光电的跳变就报错  5   //
  //电机成功退出光电后再向外走QUIT_OPT的距离，退出光电动作完成下一步，进入光电//

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      opt_in2out_ok <= 1'b0;
    end
    else if(pos_start && (~motor_busy))begin
      opt_in2out_ok <= 1'b0;
    end
    else if( (state_c == QUIT_OPT))begin
      if (limit_signal) begin
        opt_in2out_ok <= 1'b0;
      end
      else if(opt_in2out)
        opt_in2out_ok <= 1'b1;
      else begin
        opt_in2out_ok <= opt_in2out_ok ;
      end
    end
    else begin
      opt_in2out_ok <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      quit_opt_error <= 1'b0;
    end
    else if((state_c == QUIT_OPT) && (!opt_in2out_ok) &&  (mt_current_s == (QUIT_LONG + OPT_LONG)))begin
      quit_opt_error <= 1'b1;
    end
    else begin
      quit_opt_error <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      quit_opt_ok <= 1'b0;
    end
    else if(quit_opt_s == QUIT_LONG)begin
      quit_opt_ok <= 1'b1;
    end
    else begin
      quit_opt_ok <= 1'b0;
    end
  end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      quit_opt_s <= {8{1'b0}};
    end
    else if(state_c == QUIT_OPT)begin
      if (opt_in2out)begin
        quit_opt_s <= {8{1'b0}};
      end
      else if (opt_in2out_ok && (!limit_signal)) begin
        quit_opt_s <= quit_opt_s  + {7'b0,start_gen_step};
      end
      else begin
        quit_opt_s <= quit_opt_s;
      end
    end
    else begin
      quit_opt_s <= {8{1'b0}};
    end
  end

//========================================================//
  //================进入光电部分============================//
  //电机在光电外部时或者退出完成后，执行复位命令，匀速进入光电//
  //如果电机走完了设置的最大距离仍然没有检测到光电报错  1 //
  //电机检测到光电后，在运动zero_position的距离到达原点//
  //运动完成后再检测一次光电的值，如果光电值为0，报错 6 //
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      opt_out2in_ok <= 1'b0;
    end
    else if(pos_start && (~motor_busy))begin
      opt_out2in_ok <= 1'b0;
    end
    else if( (state_c == IN_OPT))begin
      if (!limit_signal) begin
        opt_out2in_ok <= 1'b0;
      end
      else if(opt_out2in )
        opt_out2in_ok <= 1'b1;
      else begin
        opt_out2in_ok <= opt_out2in_ok ;
      end
    end
    else begin
      opt_out2in_ok <= 1'b0;
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      normal_in_opt_error <= 1'b0;
    end
    else if((move_mode_r == NORMAL_RST)&&(mt_current_s ==position + OPT_LONG + QUIT_LONG )&& (!opt_out2in_ok)  )begin
      normal_in_opt_error <= 1'b1;
    end
    else begin
      normal_in_opt_error <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      in_opt_error <= 1'b0;
    end
    else if((move_mode_r == POWER_ON_RST)&&(mt_current_s ==position )&& (!opt_out2in_ok) && (state_c == IN_OPT) )begin
      in_opt_error <= 1'b1;
    end
    else begin
      in_opt_error <= 1'b0;
    end
  end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      in_opt_ok <= 1'b0;
    end
    else if(in_opt_s == zero_position)begin
      in_opt_ok <= 1'b1;
    end
    else begin
      in_opt_ok <= 1'b0;
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      in_opt_s <= {11{1'b0}};
    end
    else if(state_c == IN_OPT)begin
      if (opt_out2in)begin
        in_opt_s <= {11{1'b0}};
      end
      else if (opt_out2in_ok && (limit_signal)) begin
        in_opt_s <= in_opt_s  + {10'b0,start_gen_step};
      end
      else begin
        in_opt_s <= in_opt_s;
      end
    end
    else begin
      in_opt_s <= {11{1'b0}};
    end
  end

  //========================================================//
  //====================加速部分============================//
  //正常复位模式，加速阶段触碰到光电，报错， 2//
    
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      acc2error <= 1'b0;
    end
    else if((move_mode_r == NORMAL_RST) && (state_c == ACC_STATE) && (opt_in2out|| opt_out2in))begin
      acc2error <= 1'b1;
    end
    else begin
      acc2error <= 1'b0;
    end
  end

    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        acc2dec <= 1'b0;
      end
      else if((state_c == ACC_STATE) && (mt_current_s == (position>>1 ))  &&  start_gen_step)begin
        acc2dec <= 1'b1;
      end
      else begin
        acc2dec <= 1'b0;
      end
    end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      acc2keep <= 1'b0;
    end
    else if((state_c == ACC_STATE) && (mt_current_v == max_speed) && (v_unit >= CLK_FRQE))begin
      acc2keep <= 1'b1;
    end
    else begin
      acc2keep <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      acc_current_s <= {BIT_S - 2 {1'b0}};
    end
    else if(pos_start && (~motor_busy))begin
      acc_current_s <= {BIT_S - 2 {1'b0}};
    end
    else if (state_c == ACC_STATE) begin
      acc_current_s <= acc_current_s + {{BIT_S - 3{1'b0}},start_gen_step};
    end
    else begin
      acc_current_s <=acc_current_s ;
    end
  end

  //========================================================//
  //====================匀速部分============================//
  //正常复位模式，匀速阶段触碰到光电，报错， 3//
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      keep2error <= 1'b0;
    end
    else if((move_mode_r == NORMAL_RST) && (state_c == KEEP_STATE) && (opt_in2out|| opt_out2in))begin
      keep2error <= 1'b1;
    end
    else begin
      keep2error <= 1'b0;
    end
  end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        keep2dec <= 1'b0;
      end
      else if((state_c == KEEP_STATE) && (dec_current_s == acc_current_s) && start_gen_step)begin
        keep2dec <= 1'b1;
      end
      else begin
        keep2dec <= 1'b0;
      end
    end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dec_current_s <= {(BIT_S - 1){1'b0}};
    end
    else if(motor_busy)begin
      dec_current_s <= position - mt_current_s;
    end
    else begin
       dec_current_s <= dec_current_s ;
    end
  end

  //========================================================//
  //====================减速部分============================//
  //正常复位模式，减速阶段提前触碰到光电，报错， 7//


  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      dec2err <= 1'b0;
    end
    else if((move_mode_r == NORMAL_RST) && (state_c == DEC_STATE) && opt_out2in && (limit_signal))begin
      dec2err <= 1'b1;
    end
    else begin
      dec2err <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dec2in_opt <= 1'b0;
    end
    else if((move_mode_r == NORMAL_RST) && (dec_current_s == {(BIT_S - 1){1'b0}}) && start_gen_step)begin
      dec2in_opt <= 1'b1;
    end
    else begin
      dec2in_opt <= 1'b0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dec2end <= 1'b0;
    end
    else if(dec_flag && (mt_current_v <= start_speed))begin
      dec2end <= 1'b1;
    end
    else if(((move_mode_r == FORWORD_MOVE)||(move_mode_r == BACKWORD_MOVE)) && (mt_current_s == position) && start_gen_step)begin
      dec2end <= 1'b1;
    end
    else begin
      dec2end <= 1'b0;
    end
  end
  //========================================================//
  //====================速度模式判断部分============================//
/*reg                                            speed_mode_acc2keep  ;//速度模式 加速到匀速
  reg                                            speed_mode_acc2dec  ;//速度模式 加速到减速
  reg                                            speed_mode_keep2dec  ;//速度模式 匀速到减速
  reg                                            speed_mode_keep2acc  ;//速度模式 匀速到加速
  reg                                            speed_mode_dec2keep  ;//速度模式 减速到匀速
  reg                                            speed_mode_dec2acc  ;//速度模式 减速到加速
  reg                                            speed_mode_limit_end_flag  ;//速度限制模式，走完规定步长后停止*/
  reg                                            speed_mode_flag  ;
  always @(posedge clk ) begin
    if (!rst_n) begin
      speed_mode_flag <= 1'b0;
    end
    else if((move_mode_r == FORWORD_SPEED) || (move_mode_r==BACKWORD_SPEED) || (move_mode_r==FORWORD_SPEED_LIMIT) ||(move_mode_r==BACKWORD_SPEED_LIMIT))begin
      speed_mode_flag <= 1'b1;
    end
    else begin
      speed_mode_flag <= 1'b0;
    end
  end
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_acc2keep <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == ACC_STATE) && (mt_current_v == max_speed))begin
      speed_mode_acc2keep <= 1'b1;
    end
    else begin
      speed_mode_acc2keep <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_acc2dec <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == ACC_STATE) && (mt_current_v > max_speed))begin
      speed_mode_acc2dec <= 1'b1;
    end
    else begin
      speed_mode_acc2dec <= 1'b0;
    end
  end                                                               //always end
  
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_keep2dec <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == KEEP_STATE) && (mt_current_v > max_speed))begin
      speed_mode_keep2dec <= 1'b1;
    end
    else begin
      speed_mode_keep2dec <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_keep2acc <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == KEEP_STATE) && (mt_current_v < max_speed))begin
      speed_mode_keep2acc <= 1'b1;
    end
    else begin
      speed_mode_keep2acc <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_dec2keep <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == DEC_STATE) && (mt_current_v == max_speed))begin
      speed_mode_dec2keep <= 1'b1;
    end
    else begin
      speed_mode_dec2keep <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_dec2acc <= 1'b0;
    end
    else if(speed_mode_flag && (state_c == DEC_STATE) && (mt_current_v < max_speed))begin
      speed_mode_dec2acc <= 1'b1;
    end
    else begin
      speed_mode_dec2acc <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      speed_mode_limit_end_flag <= 1'b0;
    end
    else if((move_mode_r == FORWORD_SPEED_LIMIT || move_mode_r == BACKWORD_SPEED_LIMIT) && (mt_current_s == position) && start_gen_step)begin
      speed_mode_limit_end_flag <= 1'b1;
    end
    else begin
      speed_mode_limit_end_flag <= 1'b0;
    end
  end                                                               //always end
  

//虚拟编码器
always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            abs_position                 <= 32'd0;
        else if(((move_mode_r == NORMAL_RST) ||(move_mode_r == POWER_ON_RST))&& mt_success_int)begin
            abs_position                 <= 32'd0;
        end
        else if(abs_position_set_flag)                              //
            abs_position                 <= abs_set_position;
        else begin
          if(motor_busy)begin
            if( dirction ==  set_dir  )
                abs_position     <= abs_position + start_gen_step;
            else
                abs_position     <= abs_position - start_gen_step;
          end
        else
          abs_position         <=      abs_position;
        end
    end

//handling motor interruptions
    always @ ( posedge clk or negedge rst_n )begin
      if( !rst_n )begin
        mt_success_int <= 1'd0;
      end
      else if(clear_mt_success)begin                                //clear motor interruption
          mt_success_int <= 1'd0;
      end
      else if(state_c == END_STATE )begin                           // busy_fall
          mt_success_int  <=   1'd1;
      end
      else begin
        mt_success_int <= mt_success_int;
      end
    end

//报错码
  always @(posedge clk or negedge rst_n)           begin
    if(!rst_n)
      limit_signal_delay <= 1'b0;
    else if (pos_start && (~motor_busy)) begin
      limit_signal_delay <= 1'b0;
    end
    else if(state_c == ERROR)
      limit_signal_delay <= limit_signal;
    else
      limit_signal_delay <=limit_signal_delay;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      error_report_ok <= 1'b0;
    end
    else if(state_c == ERROR)begin
      error_report_ok <= 1'b1;
    end
    else begin
      error_report_ok <= 1'b0;
    end
  end

  always @(posedge clk ) begin
    if(pos_start && (~motor_busy))begin
      error_data <= 5'b0;
    end
    else if(in_opt_error)begin
      error_data <= 5'd1;
    end
    else if(acc2error)begin
      error_data <= 5'd2;
    end
    else if(keep2error)begin
      error_data <= 5'd3;
    end
    else if(normal_in_opt_error)begin
      error_data <= 5'd4;
    end
    else if(quit_opt_error)begin
      error_data <= 5'd5;
    end
    else if((state_c == ERROR) && (!limit_signal_delay)&&(error_data == 5'd0))begin
      error_data <= 5'd6;
    end
    else if(dec2err)begin
      error_data <= 5'd7;
    end
    else begin
      error_data <= error_data;
    end
  end

//dirction
    always @(posedge clk ) begin
      case(state_c)
          IDLE          :  begin
            dirction <= set_dir;
          end
          QUIT_OPT         :  begin
            dirction <= set_dir;
          end
          IN_OPT           :  begin
            dirction <= ~set_dir;
          end
          ACC_STATE ,KEEP_STATE, DEC_STATE :  begin
            if ((move_mode_r == NORMAL_RST) ||(move_mode_r == BACKWORD_MOVE) || (move_mode_r == BACKWORD_SPEED) ||(move_mode_r == BACKWORD_SPEED_LIMIT)) begin
              dirction <= ~set_dir;
            end
            else begin
              dirction <= set_dir;
            end
          end
        default :dirction <= dirction ;
      endcase
    end
//===============================================================//
// -------------------------Instance Range---------------------- //
//===============================================================//
gen_step_pluse U_gen_step_pluse
(
//---------------------------------------------------------------
// System clock & Reset
//---------------------------------------------------------------
  .sys_clk                                           (clk            ),
  .rst_n                                             (rst_n          ),
//---------------------------------------------------------------
// Step Motor Driver step generate
//---------------------------------------------------------------
  .start                                             (start_gen_step ),
  .mt_step_o                                         (pulse          ) 
);
endmodule



