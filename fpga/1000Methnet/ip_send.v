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
// Last modified Date:     2024/08/02 09:37:42 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/02 09:37:42 
// Version:                V1.0 
// TEXT NAME:              ip_send.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\ip_send.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ip_send(
  input                                          rst_n           ,
  
  output reg                                     tx_done         ,//发送完成标志
  input          [  47:00]                       des_mac         ,//接收方网卡地址
  input          [  47:00]                       src_mac         ,//发送方网卡地址
  input          [  15:00]                       des_port        ,//接收方端口号
  input          [  15:00]                       src_port        ,//发送方端口号
  input          [  31:00]                       des_ip          ,//接收方ip
  input          [  31:00]                       src_ip          ,//发送方ip
  input          [  15:00]                       data_length     ,//发送数据的长度
  input                                          gmii_tx_clk     ,//gmii发送时钟
 (*IOB = "TRUE"*) output reg     [   7: 0]                       gmii_txd        ,//gmii发送数据
 (*IOB = "TRUE"*) output reg                                     gmii_txen       ,//gmii发送使能
  input                                          wrreq           ,//以太网数据发送缓冲fifo写请求信号
  input          [  07:00]                       wrdata          ,//以太网数据发送缓冲fifo写数据内容
  input                                          wrclk           ,//以太网数据发送缓冲fifo写时钟
  input                                          aclr            ,//以太网数据发送fifo清零信号
  output         [  12:00]                       wrusedw          //以太网数据发送fifo写空间已使用值
);
//parameter define
  localparam                                         IDLE           = 4'd0  ;
  localparam                                         SEND_HEADER    = 4'd1  ; //发送前导码和sfd
  localparam                                         SEND_DES_MAC   = 4'd2  ;
  localparam                                         SEND_SRC_MAC   = 4'd3  ;
  localparam                                         SEND_FRAME_TYPE= 4'd4  ;
  localparam                                         SEND_IP_HEADER = 4'd5  ;
  localparam                                         SEND_UDP_HEADER= 4'd6  ;
  localparam                                         SEND_DATA      = 4'd7  ;
  localparam                                         SEND_CRC       = 4'd8  ;
  localparam                                         FRAME_TYPE     = 16'h0800;

//reg define
  reg            [   2: 0]                       cnt_header      ;//前导码计数器
  reg            [   2: 0]                       cnt_des_mac     ;//目标 MAC 地址计数器
  reg            [   2: 0]                       cnt_src_mac     ;//源 MAC 地址计数器
  reg                                            cnt_frame_type  ;//帧类型计数器
  reg            [   4: 0]                       cnt_ip_header   ;//IP 报头计数器
  reg            [   2: 0]                       cnt_udp_header  ;//UDP 报头计数器
  reg            [  15:00]                       cnt_data        ;//用户数据计数器
  reg            [   1: 0]                       cnt_crc         ;//crc 计数器
  //将输入缓存入寄存器减少时序路径
  reg            [  47:00]                       des_mac_d       ;
  reg            [  47:00]                       src_mac_d       ;
  reg            [  15:00]                       des_port_d      ;
  reg            [  15:00]                       src_port_d      ;
  reg            [  31:00]                       des_ip_d        ;
  reg            [  31:00]                       src_ip_d        ;
  reg            [  15:00]                       data_length_d   ;
  reg            [  31:00]                       ip_header           [04:00]  ;
  reg            [  31:00]                       udp_header          [01:00]  ;

  reg            [  03: 0]                       state_c,state_n  ;
  reg                                            tx_start        ;//启动发送信号
  reg            [   1: 0]                       ctrl_state      ;
  reg            [   7: 0]                       delay_cnt       ;
  //对输出端口加一级寄存器，方便 IO 输出寄存器
  reg            [  07:00]                       gmii_txd_reg    ;
  reg                                            gmii_txen_reg   ;
//wire define	
  wire           [   7: 0]                       fifo_rddata     ;
  reg                                            fifo_rdreq      ;
  wire           [  11: 0]                       rdusedw         ;
  fifo_generator_0 your_instance_name (
  .rst                                               (aclr           ),// input wire rst
  .wr_clk                                            (wr_clk         ),// input wire wr_clk
  .rd_clk                                            (gmii_tx_clk    ),// input wire rd_clk
  .din                                               (wrdata         ),// input wire [7 : 0] din
  .wr_en                                             (wr_req         ),// input wire wr_en
  .rd_en                                             (fifo_rdreq     ),// input wire rd_en
  .dout                                              (fifo_rddata    ),// output wire [7 : 0] dout
  .full                                              (               ),// output wire full
  .empty                                             (               ),// output wire empty
  .rd_data_count                                     (rdusedw        ),// output wire [11 : 0] rd_data_count
  .wr_data_count                                     (wrusedw        ),// output wire [11 : 0] wr_data_count
  .wr_rst_busy                                       (               ),// output wire wr_rst_busy
  .rd_rst_busy                                       (               ) // output wire rd_rst_busy
);

  wire           [  31:00]                       suma,sumb       ;
  wire           [  15:00]                       ip_checksum     ;
  reg                                            crc_en          ;
  wire  crc_clr;
  wire           [  31: 0]                       crc_data        ;
  wire           [  31: 0]                       crc_next        ;
  assign crc_clr = (state_c == IDLE);
crc32_d8 u_crc32_d8(
  .clk                                               (gmii_tx_clk            ),
  .rst_n                                             (rst_n          ),
  .data                                              (gmii_txd_reg           ),
  .crc_en                                            (crc_en         ),
  .crc_clr                                           (crc_clr         ),
  .crc_data                                          (crc_data       ),
  .crc_next                                          (crc_next       ) 
);

//*********************************************************************************************
//**                    main code
//**********************************************************************************************
  assign suma =   ip_header[0][31:16] + ip_header[0][15:00] 
                + ip_header[1][31:16] + ip_header[1][15:00]
                + ip_header[2][31:16] + ip_header[2][15:00]
                + ip_header[3][31:16] + ip_header[3][15:00];
  assign                                             sumb           = (suma[31:16]+suma[15:00]);
  assign                                             ip_checksum    = sumb[31:16] ? (~(sumb[31:16] + sumb[15:0])) : (~sumb);

  always @(posedge gmii_tx_clk ) begin
    if (tx_start) begin
      des_mac_d     <= des_mac    ;
      src_mac_d     <= src_mac    ;
      des_port_d    <= des_port   ;
      src_port_d    <= src_port   ;
      des_ip_d      <= des_ip     ;
      src_ip_d      <= src_ip     ;
      data_length_d <= data_length;
    end
    else begin
      des_mac_d     <= des_mac_d     ;
      src_mac_d     <= src_mac_d     ;
      des_port_d    <= des_port_d    ;
      src_port_d    <= src_port_d    ;
      des_ip_d      <= des_ip_d      ;
      src_ip_d      <= src_ip_d      ;
      data_length_d <= data_length_d ;
    end
  end

  always @(posedge gmii_tx_clk ) begin
    ip_header[0][31:24] <= 8'h45;                                   //协议版本+首部长度
    ip_header[0][23:16] <= 8'h00;                                   //服务类型
    ip_header[0][15:00] <= data_length_d + 8'd28;                   //IP 数据报总长度（IP 报头+数据）
    ip_header[1][31:00] <= 32'd0;                                   //数据包标识 + 标识+分段偏移
    ip_header[2][31:24] <= 8'd64;                                   //生存时间 64
    ip_header[2][23:16] <= 8'd17;                                   //UDP 协议
    ip_header[2][15:00] <= ip_checksum;                             //IP 校验和
    ip_header[3][31:00] <= src_ip_d;                                //源 IP 地址
    ip_header[4][31:00] <= des_ip_d;                                //目的 IP 地址
  end

  always @(posedge gmii_tx_clk ) begin
    udp_header[0][31:16] <= src_port_d;                             //源端口号
    udp_header[0][15:00] <= des_port_d;                             //目的端口号
    udp_header[1][31:16] <= data_length_d + 8'd8;                   //UDP 数据报总长度（UDP 报头+数据）
    udp_header[1][15:00] <= 16'h00;                                 //UDP 报头校验和 忽略
  end

//启动信号设置当fifo里的数据大于了传输数据长度就开始，发送完毕后等待一段时间，再回到空闲状态
  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      ctrl_state <= 2'd0;
      tx_start <= 1'b0;
      delay_cnt <= 8'd0;
    end
    else begin
      case(ctrl_state)
        0:begin
          if (rdusedw >= data_length) begin
            ctrl_state <= 2'd1;
            tx_start <= 1'b1;
          end
          else begin
            ctrl_state <= 2'd0;
            tx_start <= 1'b0;
          end
        end
        1:begin
          tx_start <= 1'b0;
          if (tx_done) begin
            ctrl_state <= 2'd2;
          end
          else begin
            ctrl_state <= 2'd1;
          end
        end
        2:begin
          if (delay_cnt == 8'd255) begin
            ctrl_state <= 2'd3;
            delay_cnt <= 8'd0;
          end
          else begin
            ctrl_state <= 2'd2;
            delay_cnt <= delay_cnt + 8'd1;
          end
        end
        3:begin
          ctrl_state <= 2'd0;
        end
        default:ctrl_state <= 2'd0;
      endcase
    end
  end


  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      state_c <= IDLE;
    end
    else begin
      state_c <= state_n;
    end
  end

  always @(*)begin
    case (state_c)
      IDLE           :begin
        if (tx_start) begin
          state_n = SEND_HEADER;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_HEADER    :begin
        if (cnt_header == 3'd7) begin
          state_n = SEND_DES_MAC;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_DES_MAC   :begin
        if (cnt_des_mac == 3'd5) begin
          state_n = SEND_SRC_MAC;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_SRC_MAC   :begin
        if (cnt_src_mac == 3'd5) begin
          state_n = SEND_FRAME_TYPE;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_FRAME_TYPE:begin
        if (cnt_frame_type == 1'd1) begin
          state_n = SEND_IP_HEADER;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_IP_HEADER :begin
        if (cnt_ip_header == 5'd19) begin
          state_n = SEND_UDP_HEADER;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_UDP_HEADER:begin
        if(cnt_udp_header == 3'd7) begin
          state_n = SEND_DATA;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_DATA      :begin
        if(cnt_data == data_length_d - 1'd1) begin
          state_n = SEND_CRC;
        end
        else begin
          state_n = state_c;
        end
      end
      SEND_CRC       :begin
        if(cnt_crc == 2'd3) begin
          state_n = IDLE;
        end
        else begin
          state_n = state_c;
        end
      end
      default: state_n = IDLE;
    endcase
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_header <= 3'd0;
    end
    else if(state_c == SEND_HEADER)begin
      cnt_header <= cnt_header + 1'd1;
    end
    else begin
      cnt_header <= 3'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_des_mac <= 3'd0;
    end
    else if(state_c == SEND_DES_MAC)begin
      cnt_des_mac <= cnt_des_mac + 1'd1;
    end
    else begin
      cnt_des_mac <= 3'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_src_mac <= 3'd0;
    end
    else if(state_c == SEND_SRC_MAC)begin
      cnt_src_mac <= cnt_src_mac + 1'd1;
    end
    else begin
      cnt_src_mac <= 3'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_frame_type <= 1'd0;
    end
    else if(state_c == SEND_FRAME_TYPE)begin
      cnt_frame_type <= cnt_frame_type + 1'd1;
    end
    else begin
      cnt_frame_type <= 1'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_ip_header <= 5'd0;
    end
    else if(state_c == SEND_IP_HEADER)begin
      cnt_ip_header <= cnt_ip_header + 5'd1;
    end
    else begin
      cnt_ip_header <= 5'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_udp_header <= 3'd0;
    end
    else if(state_c == SEND_UDP_HEADER)begin
      cnt_udp_header <= cnt_udp_header + 3'd1;
    end
    else begin
      cnt_udp_header <= 3'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_data <= 16'd0;
    end
    else if(state_c == SEND_DATA)begin
      cnt_data <= cnt_data + 16'd1;
    end
    else begin
      cnt_data <= 16'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_crc <= 2'd0;
    end
    else if(state_c == SEND_CRC)begin
      cnt_crc <= cnt_crc + 2'd1;
    end
    else begin
      cnt_crc <= 2'd0;
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      gmii_txd_reg <= 8'd0;
      gmii_txen_reg<=1'b0;
      crc_en<=1'b0;
    end
    else begin
      case(state_c)
        IDLE           : begin
          gmii_txd_reg <= 8'd0;
          gmii_txen_reg<=1'b0;
          crc_en<=1'b0;
        end
        SEND_HEADER    : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b0;
          case(cnt_header)
            0,1,2,3,4,5,6:gmii_txd_reg <= 8'h55;
            7:gmii_txd_reg <= 8'hd5;
            default:gmii_txd_reg <= 8'h55;
          endcase
        end
        SEND_DES_MAC   : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          case(cnt_des_mac)
            0 : gmii_txd_reg <= des_mac_d[47:40];
            1 : gmii_txd_reg <= des_mac_d[39:32];
            2 : gmii_txd_reg <= des_mac_d[31:24];
            3 : gmii_txd_reg <= des_mac_d[23:16];
            4 : gmii_txd_reg <= des_mac_d[15:08];
            5 : gmii_txd_reg <= des_mac_d[07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        SEND_SRC_MAC   : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          case(cnt_src_mac)
            0 : gmii_txd_reg <= src_mac_d[47:40];
            1 : gmii_txd_reg <= src_mac_d[39:32];
            2 : gmii_txd_reg <= src_mac_d[31:24];
            3 : gmii_txd_reg <= src_mac_d[23:16];
            4 : gmii_txd_reg <= src_mac_d[15:08];
            5 : gmii_txd_reg <= src_mac_d[07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        SEND_FRAME_TYPE: begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          case(cnt_frame_type)
            0 : gmii_txd_reg <= FRAME_TYPE[15:08];
            1 : gmii_txd_reg <= FRAME_TYPE[07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        SEND_IP_HEADER : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          case(cnt_ip_header)
            0  : gmii_txd_reg <= ip_header[0][31:24];
            1  : gmii_txd_reg <= ip_header[0][23:16];
            2  : gmii_txd_reg <= ip_header[0][15:08];
            3  : gmii_txd_reg <= ip_header[0][07:00];
            4  : gmii_txd_reg <= ip_header[1][31:24];
            5  : gmii_txd_reg <= ip_header[1][23:16];
            6  : gmii_txd_reg <= ip_header[1][15:08];
            7  : gmii_txd_reg <= ip_header[1][07:00];
            8  : gmii_txd_reg <= ip_header[2][31:24];
            9  : gmii_txd_reg <= ip_header[2][23:16];
            10 : gmii_txd_reg <= ip_header[2][15:08];
            11 : gmii_txd_reg <= ip_header[2][07:00];
            12 : gmii_txd_reg <= ip_header[3][31:24];
            13 : gmii_txd_reg <= ip_header[3][23:16];
            14 : gmii_txd_reg <= ip_header[3][15:08];
            15 : gmii_txd_reg <= ip_header[3][07:00];
            16 : gmii_txd_reg <= ip_header[4][31:24];
            17 : gmii_txd_reg <= ip_header[4][23:16];
            18 : gmii_txd_reg <= ip_header[4][15:08];
            19 : gmii_txd_reg <= ip_header[4][07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        SEND_UDP_HEADER: begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          case(cnt_udp_header)
            0  : gmii_txd_reg <= udp_header[0][31:24];
            1  : gmii_txd_reg <= udp_header[0][23:16];
            2  : gmii_txd_reg <= udp_header[0][15:08];
            3  : gmii_txd_reg <= udp_header[0][07:00];
            4  : gmii_txd_reg <= udp_header[1][31:24];
            5  : gmii_txd_reg <= udp_header[1][23:16];
            6  : gmii_txd_reg <= udp_header[1][15:08];
            7  : gmii_txd_reg <= udp_header[1][07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        SEND_DATA      : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b1;
          gmii_txd_reg <= fifo_rddata;
        end
        SEND_CRC       : begin
          gmii_txen_reg <= 1'b1;
          crc_en<=1'b0;
          case(cnt_udp_header)
            0  : gmii_txd_reg <= crc_data[31:24];
            1  : gmii_txd_reg <= crc_data[23:16];
            2  : gmii_txd_reg <= crc_data[15:08];
            3  : gmii_txd_reg <= crc_data[07:00];
            default:gmii_txd_reg <= 8'hff;
          endcase
        end
        default: ;
      endcase
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if(!rst_n)begin
      fifo_rdreq <= 1'b0;
    end  
    else if(state_n == SEND_DATA)begin
      fifo_rdreq <= 1'b1;
    end
    else begin
      fifo_rdreq <= 1'b0; 
    end
  end

  always @(posedge gmii_tx_clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_done <= 1'b0;
    end
    else if(cnt_udp_header == 2'd3)begin
      tx_done <= 1'b1;
    end
    else begin
      tx_done <= 1'b0;
    end
  end

  always @(posedge gmii_tx_clk ) begin
    gmii_txd <=gmii_txd_reg ;
    gmii_txen<=gmii_txen_reg;
  end
                                                                   
endmodule
