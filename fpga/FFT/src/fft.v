`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2024/10/24 14:32:41 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/10/24 14:32:41 
// Version:                V1.0 
// TEXT NAME:              fft.v 
// PATH:                   D:\fuxin\code_main\fpga\FFT\src\fft.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module fft#(
  parameter                                          N_POINT        = 16    ,
  parameter                                          DATA_IN_WIDTH  = 16    ,
  parameter                                          DATA_OUT_WIDTH = 32    
)(
  input                                          clk             ,
  input                                          rst_n           ,
  input          [DATA_IN_WIDTH - 1:00]          data_in         ,
  input                                          data_in_valid   ,
  output      signed[DATA_OUT_WIDTH - 1:00]         data_out        ,
  output                                         data_out_valid   
);
  localparam                                         N_NUM_BIT      = $clog2(N_POINT);
  localparam                                         LAYER_BIT      = $clog2(N_NUM_BIT);
  localparam                                         IDLE           = 4'B0001;
  localparam                                         LOAD           = 4'B0010;
  localparam                                         CALCUL         = 4'B0100;
  localparam                                         END_STATE      = 4'B1000;

  wire     signed[  07:00]                       Wn                  [N_POINT>>1 : 00]  ;
  assign                                             Wn[1]          = 128;
  assign                                             Wn[2]          = 125;
  assign                                             Wn[3]          = 118;
  assign                                             Wn[4]          = 106;
  assign                                             Wn[5]          = 90;
  assign                                             Wn[6]          = 71;
  assign                                             Wn[7]          = 48;
  assign                                             Wn[8]          = 24;
  assign                                             Wn[9]          = 0;
  assign                                             Wn[10]         = -25;
  assign                                             Wn[11]         = -49;
  assign                                             Wn[12]         = -72;
  assign                                             Wn[13]         = -91;
  assign                                             Wn[14]         = -107;
  assign                                             Wn[15]         = -119;
  assign                                             Wn[16]         = -126;

  //中间数据存储需要一个三维数组，共计log2(N)层 ，每层包含(N)个值，每个值的位宽位输入数据的位宽 * 旋转因子的位宽 为了防止溢出最好
  reg            [N_NUM_BIT - 1 : 00]            data_num_cnt    ;//数据个数计数器
  wire           [N_NUM_BIT - 1 : 00]            cnt_change      ;//数据倒序输入

  reg                                            data_in_vld_r   ;
  reg            [DATA_IN_WIDTH - 1:00]          data_in_r       ;
  wire                                           pos_data_in_vld  ;

  reg            [DATA_IN_WIDTH - 1:00]          data_in_rom         [N_POINT - 1 : 00]  ;
  reg      signed[DATA_OUT_WIDTH - 1:00]         data_temp   [N_NUM_BIT - 1 : 00]  [N_POINT - 1 : 00]  ;

  reg            [LAYER_BIT - 1:00]              layer_cnt       ;//层数 例如32点的FFT共有 6层
  reg            [N_NUM_BIT - 1:00]              butterfly_cnt   ;//每层里共有多少个蝶形因子 也就是奇偶项的对数 如倒数第一次是1对，倒数第二层是两对 倒数第三层是4对以此类推 
  reg            [N_NUM_BIT - 1:00]              butterfly_couple_cnt  ;//每层里共有多少个蝶形因子 也就是奇偶项的对数 如倒数第一次是1对，倒数第二层是两对 倒数第三层是4对以此类推 
  reg            [N_NUM_BIT - 1:00]              data_num_out_cnt  ;//数据个数计数器
  reg            [  03:00]                       state_c,state_n  ;

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      state_c <= IDLE;
    end
    else begin
      state_c <= state_n;
    end
  end                                                               //always end
  
  always @(*)begin
    case(state_c)
      IDLE         :begin
        if (pos_data_in_vld) begin
          state_n = LOAD;
        end
        else begin
          state_n = state_c;
        end
      end
      LOAD         :begin
        if (data_num_cnt == N_POINT - 1) begin
          state_n = CALCUL;
        end
        else begin
          state_n = state_c;
        end
      end
      CALCUL       :begin
        if ((layer_cnt == N_NUM_BIT - 1'b1)&&((layer_cnt == N_NUM_BIT - 1)&&((butterfly_cnt == N_POINT / (2<<layer_cnt)-1) && (butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1) ) ) ) begin
          state_n = END_STATE;
        end
        else begin
          state_n = state_c;
        end
      end
      END_STATE    :begin
        if (data_num_out_cnt == N_POINT - 1) begin
          state_n = IDLE;
        end
        else begin
          state_n = state_c;
        end
      end
      default: ;
    endcase
  end

//上电复位后根据N_POINT的点数进行倒序排列
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      data_num_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if(data_num_cnt == N_POINT - 1)begin
      data_num_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if(state_c==LOAD)begin
      data_num_cnt <= data_num_cnt + 1'b1;
    end
    else begin
      data_num_cnt <= {N_NUM_BIT{1'b0}};
    end
  end                                                               //always end


//IDLE下检测到数据有效信号的上升沿进入LOAD状态
  always @(posedge clk ) begin
    data_in_vld_r <= data_in_valid;
    data_in_r      <= data_in   ;
  end
  assign                                             pos_data_in_vld= data_in_valid & (!data_in_vld_r);

//倒序
 genvar reverse_bit;
 generate
  for ( reverse_bit = 0  ; reverse_bit < N_NUM_BIT ; reverse_bit = reverse_bit + 1'B1) begin
  assign                                             cnt_change[N_NUM_BIT -1 -reverse_bit]= data_num_cnt[reverse_bit];
  end
 endgenerate

//按照倒序装载数据
  integer                                        i               ;
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for( i = 0;i<N_POINT;i=i+1)begin
        data_in_rom[i] <= {DATA_IN_WIDTH{1'b0}};
      end
    end
    else if(data_in_vld_r)begin
      data_in_rom[cnt_change] <= data_in_r;
    end
    else begin
      for( i = 0;i<N_POINT;i=i+1)begin
        data_in_rom[i] <= data_in_rom[i];
      end
    end
  end                                                               //always end
  
//数据装载完成后开始计算
  //首先第一个FOR循环 计算总共需要几层
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      layer_cnt <= {LAYER_BIT{1'b0}};
    end
    else if((layer_cnt == N_NUM_BIT - 1)&&((butterfly_cnt == N_POINT / (2<<layer_cnt)-1) && (butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1) ) )begin
      layer_cnt <= {LAYER_BIT{1'b0}};
    end
    else if((state_c==CALCUL) && ((butterfly_cnt == N_POINT / (2<<layer_cnt)-1) && (butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1)))begin
      layer_cnt <= layer_cnt + 1'b1;
    end
    else begin
      layer_cnt <= layer_cnt;
    end
  end                                                               //always end

  //然后是第二个for循环看每层需要多少个蝶形运算
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      butterfly_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if((butterfly_cnt == N_POINT / (2<<layer_cnt)-1) && (butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1))begin
      butterfly_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if((state_c==CALCUL) && butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1)begin
      butterfly_cnt <= butterfly_cnt + 1'b1;
    end
    else begin
      butterfly_cnt <= butterfly_cnt;
    end
  end                                                               //always end

  //最后是第三个for循环看每个蝶形运算中有多少对奇偶数
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      butterfly_couple_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if(butterfly_couple_cnt == ((2<<layer_cnt)>>1)-1)begin
      butterfly_couple_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if((state_c==CALCUL))begin
      butterfly_couple_cnt <= butterfly_couple_cnt + 1'b1;
    end
    else begin
      butterfly_couple_cnt <= butterfly_couple_cnt;
    end
  end                                                               //always end

  wire           [N_POINT -1 : 00]               data_inrom_cnt=(2<<layer_cnt)*butterfly_cnt+butterfly_couple_cnt  ;
  wire [N_POINT -1 : 00] data_inrom_cnt2 = (2<<layer_cnt)*butterfly_cnt+butterfly_couple_cnt+((2<<layer_cnt) >> 1);
  wire [N_POINT -1 : 00] wn_cnt = (butterfly_couple_cnt * (N_POINT /(2<<layer_cnt)) + 1);
  integer                                        layer,butterfly  ;
  //计算输出
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      for ( layer = 0; layer <N_NUM_BIT ; layer = layer + 1) begin
        for ( butterfly = 0 ; butterfly < N_POINT;butterfly = butterfly + 1 ) begin
          data_temp[layer][butterfly]<={DATA_OUT_WIDTH{1'b0}};
        end
      end
    end
    else if(state_c==CALCUL)begin
      if (layer_cnt == 0) begin
        data_temp[0][data_inrom_cnt]  <= data_in_rom[data_inrom_cnt] + data_in_rom[data_inrom_cnt2];
        data_temp[0][data_inrom_cnt2] <= data_in_rom[data_inrom_cnt] - data_in_rom[data_inrom_cnt2];
      end
      else begin
        data_temp[layer_cnt][data_inrom_cnt]  <= data_temp[layer_cnt-1][data_inrom_cnt] +  Wn[wn_cnt]*data_temp[layer_cnt-1][data_inrom_cnt2];//在这里需要根据点数输入对应的旋转因子
        data_temp[layer_cnt][data_inrom_cnt2] <= data_temp[layer_cnt-1][data_inrom_cnt] -  Wn[wn_cnt]*data_temp[layer_cnt-1][data_inrom_cnt2];//
      end
    end
    else begin
      for ( layer = 0; layer <N_NUM_BIT ; layer = layer + 1) begin
        for ( butterfly = 0 ; butterfly < N_POINT;butterfly = butterfly + 1 ) begin
          data_temp[layer][butterfly]<=data_temp[layer][butterfly];
        end
      end
    end
  end                                                               //always end

  
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      data_num_out_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if(data_num_out_cnt == N_POINT - 1)begin
      data_num_out_cnt <= {N_NUM_BIT{1'b0}};
    end
    else if(state_c == END_STATE)begin
      data_num_out_cnt <= data_num_out_cnt + 1'b1;
    end
    else begin
      data_num_out_cnt <= data_num_out_cnt;
    end
  end                                                               //always end

  assign                                             data_out       = data_temp[N_NUM_BIT-1][data_num_out_cnt];
  assign                                             data_out_valid = (state_c == END_STATE);
                                                                   
                                                                   
endmodule
