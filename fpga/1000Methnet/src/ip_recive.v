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
// Last modified Date:     2024/08/02 11:24:11 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/02 11:24:11 
// Version:                V1.0 
// TEXT NAME:              ip_recive.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\ip_recive.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module ip_recive(
  input                                          rst_n           ,
  input                                          gmii_rx_clk     ,//接收数据参考时钟，时钟频率为 125MHz。 RX_CLK 是由 PHY 侧提供的
  input                                          gmii_rxdv       ,//即 Reveive Data Valid， 接收数据有效信号， 作用类似于发送通道的 TX_EN
  input          [  07:00]                       gmii_rxd        ,//即 ReceiveData，数据接收信号，共 8 根信号线
  input          [  47:00]                       local_mac       ,//本地 mac 地址
  input          [  31:00]                       local_ip        ,//本地 ip 地址
  input          [  15:00]                       local_port      ,//本地端口号
  input                                          data_over_flow_i,//输入数据溢出
  output reg     [  47:00]                       exter_mac       ,//目的 mac 地址
  output reg     [  31:00]                       exter_ip        ,//目的 ip 地址
  output reg     [  15:00]                       exter_port      ,//目的端口号 
  output reg     [  15:00]                       rx_data_length  ,//接收数据长度信号
  output reg     [  07:00]                       payload_data_o  ,//8 位数据输出信号
  output reg                                     payload_valid_o ,//输出数据有效信号
  output reg                                     one_pkt_done    ,//以太网包传输完成信号
  output reg                                     pkt_error       ,//接收数据错误标志信号
  output reg     [  31:00]                       debug_crc_check  //调试 CRC 检验信号

);
  //parameter define
  localparam                                         IDLE           = 4'd0  ;
  localparam                                         RX_PREAMBLE    = 4'd1  ;
  localparam                                         RX_ETH_HEADER  = 4'd2  ;
  localparam                                         RX_IP_HEADER   = 4'd3  ;
  localparam                                         RX_UDP_HEADER  = 4'd4  ;
  localparam                                         RX_DATA        = 4'd5  ;
  localparam                                         RX_DRP_DATA    = 4'd6  ;
  localparam                                         RX_CRC         = 4'd7  ;
  localparam                                         PKT_CHECK      = 4'd8  ;

  localparam                                         ETH_TYPE       = 16'h0800;
  localparam                                         IP_ver         = 4'h4  ;
  localparam                                         IP_hdr_len     = 4'h5  ;
  localparam                                         IP_protocol    = 8'd17 ;
  //reg define
  reg            [  03:00]                       state_c       ,state_n;
  reg            [  07:00]                       gmii_rxd_d      ;
  reg                                            gmii_rxdv_d     ;
  reg            [  07:00]                       gmii_rxd_dly1   ;
  reg                                            gmii_rxdv_dly1  ;
  reg            [  07:00]                       gmii_rxd_dly2   ;
  reg                                            gmii_rxdv_dly2  ;
  //前导码和sfd
  reg            [  03:00]                       cnt_preamble    ;
  //mac头部
  reg            [  03:00]                       cnt_eth_header  ;
  reg            [  47:00]                       local_mac_reg   ;
  reg            [  47:00]                       rx_dst_mac      ;
  reg            [  47:00]                       rx_src_mac      ;
  reg            [  15:00]                       rx_eth_type     ;
  reg                                            eth_header_check_ok  ;
  //ip报文头部
  reg            [  04:00]                       cnt_ip_header   ;
  reg            [  31:00]                       local_ip_reg    ;
  reg            [  03:00]                       rx_ip_ver       ;
  reg            [  03:00]                       rx_ip_hdr_len   ;
  reg            [  07:00]                       rx_ip_tos       ;
  reg            [  15:00]                       rx_total_len    ;
  reg            [  15:00]                       rx_ip_id        ;
  reg                                            rx_ip_rsv       ;
  reg                                            rx_ip_df        ;
  reg                                            rx_ip_mf        ;
  reg            [  12:00]                       rx_ip_frag_offset  ;
  reg            [  07:00]                       rx_ip_ttl       ;
  reg            [  07:00]                       rx_ip_protocol  ;
  reg            [  15:00]                       rx_ip_check_sum  ;
  reg            [  31:00]                       rx_src_ip       ;
  reg            [  31:00]                       rx_dst_ip       ;
  reg                                            ip_header_check_ok  ;
  //udp头部
  reg            [  03:00]                       cnt_udp_header  ;
  reg            [  15:00]                       local_port_reg  ;
  reg            [  15:00]                       rx_src_port     ;
  reg            [  15:00]                       rx_dst_port     ;
  reg            [  15:00]                       rx_udp_length   ;
  reg            [  15:00]                       rx_udp_check_sum  ;
  reg                                            udp_header_check_ok  ;
  //数据
  reg            [  15:00]                       cnt_data        ;
  reg            [  04:00]                       cnt_drp_data    ;
  //crc 
  reg            [  03:00]                       cnt_crc         ;
  reg            [  31:00]                       crc_check       ;
  reg                                            data_over_flow_reg  ;
  //wire define	 
  wire           [  15: 0]                       cal_check_sum   ;
  wire           [  31:00]                       suma,sumb       ;
    assign suma =    {rx_ip_ver,rx_ip_hdr_len,rx_ip_tos} + rx_total_len+rx_ip_id
                    +{rx_ip_rsv,rx_ip_df,rx_ip_mf,rx_ip_frag_offset}+{rx_ip_ttl,rx_ip_protocol}
                    +rx_src_ip[31:16]+rx_src_ip[15:00]+rx_dst_ip[31:16]+rx_dst_ip[15:00];
  assign                                             sumb           = (suma[31:16]+suma[15:00]);
  assign                                             cal_check_sum  = sumb[31:16] ? (~(sumb[31:16] + sumb[15:0])) : (~sumb);
  reg                                            crc_en          ;
  wire                                           crc_clr         ;
  wire           [  31: 0]                       crc_out         ;
  assign                                             crc_clr        = (state_c == IDLE);


    CRC32_D8 CRC32_D8(
  .Clk                                               (gmii_rx_clk    ),
  .Reset                                             (crc_clr        ),
  .Data_in                                           (gmii_rxd_dly2  ),
  .Enable                                            (crc_en         ),
  .Crc                                               (               ),
  .CrcNext                                           (               ),
  .Crc_eth                                           (crc_out        ) 
    );
  //*********************************************************************************************
  //**                    main code
  //**********************************************************************************************
  //将以太网输入的接收信号寄存
  always @(posedge gmii_rx_clk or negedge rst_n) begin
    if (!rst_n) begin
      gmii_rxd_d  <= 8'h00;
      gmii_rxdv_d <= 1'b0;
    end
    else begin
      gmii_rxd_d  <= gmii_rxd;
      gmii_rxdv_d <= gmii_rxdv;
    end
  end
  //将以太网输入的接收信号寄存后打拍
  always @(posedge gmii_rx_clk ) begin
    gmii_rxd_dly1  <=  gmii_rxd_d ;
    gmii_rxdv_dly1 <=  gmii_rxdv_d;
    gmii_rxd_dly2  <=  gmii_rxd_dly1  ;
    gmii_rxdv_dly2 <=  gmii_rxdv_dly1 ;
  end

  //输入端口寄存
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      local_mac_reg <= 48'h00_00_00_00_00_00;
      local_ip_reg <= 32'h00_00_00_00;
      local_port_reg <= 16'h00_00;
    end
    else begin
      local_mac_reg <= local_mac;
      local_ip_reg<= local_ip;
      local_port_reg <= local_port;
    end
  end                                                               //always end
  

  always @(posedge gmii_rx_clk or negedge rst_n) begin
    if (!rst_n) begin
      state_c <= IDLE;
    end
    else begin
      state_c <= state_n;
    end
  end

  always @(*) begin
    case(state_c)
      IDLE          :begin
        if (!gmii_rxdv_dly2 && gmii_rxdv_dly1) begin
          state_n = RX_PREAMBLE;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_PREAMBLE   :begin
        if (gmii_rxd_dly2 == 8'hd5 && cnt_preamble > 4'd5) begin
          state_n = RX_ETH_HEADER;
        end
        else if(cnt_preamble > 4'd7)begin
          state_n = IDLE;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_ETH_HEADER :begin
        if (cnt_eth_header == 4'd13) begin
          state_n = RX_IP_HEADER;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_IP_HEADER  :begin
        if (cnt_ip_header == 5'd2 && eth_header_check_ok == 1'b0) begin
          state_n = IDLE;
        end
        else if(cnt_ip_header == 5'd19)begin
          state_n = RX_UDP_HEADER;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_UDP_HEADER :begin
        if (cnt_udp_header == 4'd2 && ip_header_check_ok == 1'b0) begin
          state_n = IDLE;
        end
        else if(cnt_udp_header == 4'd7 && udp_header_check_ok==1'b0)begin
          state_n = IDLE;
        end
        else if(cnt_udp_header == 4'd7)begin
          state_n = RX_DATA;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_DATA       :begin
        if (rx_data_length < 5'd18 && rx_data_length - 1'b1) begin
          state_n = RX_DRP_DATA;
        end
        else if(cnt_data==rx_data_length - 1'b1)begin
          state_n = RX_CRC;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_DRP_DATA   :begin
        if(cnt_drp_data == 5'd17 - rx_data_length)begin
          state_n = RX_CRC;
        end
        else begin
          state_n = state_c;
        end
      end
      RX_CRC        :begin
        if (gmii_rxdv_dly2 == 1'b0) begin
          state_n = PKT_CHECK;
        end
        else begin
          state_n = state_c;
        end
      end
      PKT_CHECK     :begin
        state_n = IDLE;
      end
      default:state_n = IDLE;
    endcase
  end

  always @(posedge gmii_rx_clk or negedge rst_n ) begin
    if (!rst_n) begin
      cnt_preamble <= 4'd0;
    end
    else if(state_c == RX_PREAMBLE && gmii_rxd_dly2 == 8'h55)begin
      cnt_preamble <= cnt_preamble + 1'b1;
    end
    else begin
      cnt_preamble <= 4'd0;
    end
  end

  always @(posedge gmii_rx_clk or negedge rst_n ) begin
    if (!rst_n) begin
      cnt_eth_header <= 4'd0;
    end
    else if(state_c == RX_ETH_HEADER)begin
      cnt_eth_header <= cnt_eth_header + 1'b1;
    end
    else begin
      cnt_eth_header <= 4'd0;
    end
  end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      rx_dst_mac <= 48'h00_00_00_00_00_00;
      rx_src_mac <= 48'h00_00_00_00_00_00;
      rx_eth_type<= 16'h00_00;
    end
    else if(state_c == RX_ETH_HEADER)begin
      case(cnt_eth_header)
        4'd0 :rx_dst_mac[47:40] <= gmii_rxd_dly2;
        4'd1 :rx_dst_mac[39:32] <= gmii_rxd_dly2;
        4'd2 :rx_dst_mac[31:24] <= gmii_rxd_dly2;
        4'd3 :rx_dst_mac[23:16] <= gmii_rxd_dly2;
        4'd4 :rx_dst_mac[15:8] <= gmii_rxd_dly2;
        4'd5 :rx_dst_mac[7:0] <= gmii_rxd_dly2;
        4'd6 :rx_src_mac[47:40] <= gmii_rxd_dly2;
        4'd7 :rx_src_mac[39:32] <= gmii_rxd_dly2;
        4'd8 :rx_src_mac[31:24] <= gmii_rxd_dly2;
        4'd9 :rx_src_mac[23:16] <= gmii_rxd_dly2;
        4'd10:rx_src_mac[15:8] <= gmii_rxd_dly2;
        4'd11:rx_src_mac[7:0] <= gmii_rxd_dly2;
        4'd12:rx_eth_type[15:8] <= gmii_rxd_dly2;
        4'd13:rx_eth_type[7:0] <= gmii_rxd_dly2;
        default:;
      endcase
    end
    else begin
        rx_dst_mac <=  rx_dst_mac ;
        rx_src_mac <=  rx_src_mac ;
        rx_eth_type<=  rx_eth_type;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      cnt_ip_header <= 5'd0;
    end
    else if(state_c==RX_IP_HEADER)begin
      cnt_ip_header <= cnt_ip_header + 1'b1;
    end
    else begin
      cnt_ip_header <= 5'd0;
    end
  end                                                               //always end

  always@(posedge gmii_rx_clk or posedge rst_n)begin
    if(!rst_n)begin
      {rx_ip_ver,rx_ip_hdr_len}     <= 8'h0;
      rx_ip_tos                     <= 8'h0;
      rx_total_len                  <= 16'h0;
      rx_ip_id                      <= 16'h0;
      {rx_ip_rsv,rx_ip_df,rx_ip_mf} <= 3'h0;
      rx_ip_frag_offset             <= 13'h0;
      rx_ip_ttl                     <= 8'h0;
      rx_ip_protocol                <= 8'h0;
      rx_ip_check_sum               <= 16'h0;
      rx_src_ip                     <= 32'h0;
      rx_dst_ip                     <= 32'h0;
    end
    else if(state_c == RX_IP_HEADER)begin
      case(cnt_ip_header)
        5'd0:{rx_ip_ver,rx_ip_hdr_len}  <= gmii_rxd_dly2;
        5'd1:rx_ip_tos                  <= gmii_rxd_dly2;
        5'd2:rx_total_len[15:08]        <= gmii_rxd_dly2;
        5'd3:rx_total_len[07:00]        <= gmii_rxd_dly2;
        5'd4:rx_ip_id[15:08]            <= gmii_rxd_dly2;
        5'd5:rx_ip_id[07:00]            <= gmii_rxd_dly2;
        5'd6:{rx_ip_rsv,rx_ip_df,rx_ip_mf,rx_ip_frag_offset[12:8]}<=gmii_rxd_dly2;
        5'd7:rx_ip_frag_offset[07:00]   <= gmii_rxd_dly2;
        5'd8:rx_ip_ttl                  <= gmii_rxd_dly2;
        5'd9:rx_ip_protocol             <= gmii_rxd_dly2;
        5'd10:rx_ip_check_sum[15:08]    <= gmii_rxd_dly2;
        5'd11:rx_ip_check_sum[07:00]    <= gmii_rxd_dly2;
        5'd12:rx_src_ip[31:24]          <= gmii_rxd_dly2;
        5'd13:rx_src_ip[23:16]          <= gmii_rxd_dly2;
        5'd14:rx_src_ip[15:08]          <= gmii_rxd_dly2;
        5'd15:rx_src_ip[07:00]          <= gmii_rxd_dly2;
        5'd16:rx_dst_ip[31:24]          <= gmii_rxd_dly2;
        5'd17:rx_dst_ip[23:16]          <= gmii_rxd_dly2;
        5'd18:rx_dst_ip[15:08]          <= gmii_rxd_dly2;
        5'd19:rx_dst_ip[07:00]          <= gmii_rxd_dly2;
      default: ;
      endcase
    end
    else begin
      {rx_ip_ver,rx_ip_hdr_len}     <={rx_ip_ver,rx_ip_hdr_len}     ;
      rx_ip_tos                     <=rx_ip_tos                     ;
      rx_total_len                  <=rx_total_len                  ;
      rx_ip_id                      <=rx_ip_id                      ;
      {rx_ip_rsv,rx_ip_df,rx_ip_mf} <={rx_ip_rsv,rx_ip_df,rx_ip_mf} ;
      rx_ip_frag_offset             <=rx_ip_frag_offset             ;
      rx_ip_ttl                     <=rx_ip_ttl                     ;
      rx_ip_protocol                <=rx_ip_protocol                ;
      rx_ip_check_sum               <=rx_ip_check_sum               ;
      rx_src_ip                     <=rx_src_ip                     ;
      rx_dst_ip                     <=rx_dst_ip                     ;
    end
  end


  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      eth_header_check_ok <= 1'b0;
    end
    else if(rx_eth_type == ETH_TYPE && (rx_dst_mac == local_mac_reg || rx_dst_mac == 48'hff_ff_ff_ff_ff_ff))begin
      eth_header_check_ok <= 1'b1;
    end
    else begin
      eth_header_check_ok <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      cnt_udp_header <= 4'd0;
    end
    else if(state_c==RX_UDP_HEADER)begin
      cnt_udp_header <= cnt_udp_header + 1'b1;
    end
    else begin
      cnt_udp_header <= 4'd0;
    end
  end                                                               //always end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      rx_src_port     <= 16'h00_00;
      rx_dst_port     <= 16'h00_00;
      rx_udp_length   <= 16'h00_00;
      rx_udp_check_sum<= 16'h00_00;
    end
    else if(state_c==RX_UDP_HEADER)begin
      case(cnt_udp_header)
        0: rx_src_port[15:08] <= gmii_rxd_dly2;
        1: rx_src_port[07:00] <= gmii_rxd_dly2;
        2: rx_dst_port[15:08] <= gmii_rxd_dly2;
        3: rx_dst_port[07:00] <= gmii_rxd_dly2;
        4: rx_udp_length[15:08] <= gmii_rxd_dly2;
        5: rx_udp_length[07:00] <= gmii_rxd_dly2;
        6: rx_udp_check_sum[15:08] <= gmii_rxd_dly2;
        7: rx_udp_check_sum[07:00] <= gmii_rxd_dly2;
        default: ;
      endcase
    end
    else begin
      rx_src_port     <=rx_src_port     ;
      rx_dst_port     <=rx_dst_port     ;
      rx_udp_length   <=rx_udp_length   ;
      rx_udp_check_sum<=rx_udp_check_sum;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      udp_header_check_ok <= 1'b0;
    end
    else if(rx_dst_port == local_port_reg)begin
      udp_header_check_ok <= 1'b1;
    end
    else begin
      udp_header_check_ok <= 1'b0;
    end
  end                                                               //always end
  

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      ip_header_check_ok <= 1'b0;
    end
    else if({IP_ver,IP_hdr_len,IP_protocol,cal_check_sum,local_ip_reg} ==
{rx_ip_ver,rx_ip_hdr_len,rx_ip_protocol,rx_ip_check_sum,rx_dst_ip})begin
      ip_header_check_ok <= 1'b1;
    end
    else begin
      ip_header_check_ok <= 1'b0;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      cnt_data <= 16'd0;
    end
    else if(state_c==RX_DATA)begin
      cnt_data <= cnt_data + 1'b1;
    end
    else begin
      cnt_data <= 16'd0;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      rx_data_length <= 16'd0;
    end
    else if(state_c== RX_IP_HEADER && cnt_ip_header == 5'd19)begin
      rx_data_length <= rx_total_len - 8'd20 - 8'd8;
    end
    else begin
      rx_data_length <= rx_data_length;
    end
  end                                                               //always end
  

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      cnt_drp_data <= 5'd0;
    end
    else if(state_c == RX_DRP_DATA)begin
      cnt_drp_data <= cnt_drp_data + 1'b1;
    end
    else begin
      cnt_drp_data <= 5'd0;
    end
  end                                                               //always end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      crc_en <= 1'b0;
    end
    else if((cnt_data==rx_data_length - 1'b1) || (cnt_drp_data == 5'd17 - rx_data_length))begin
      crc_en <= 1'B0;
    end
    else if((gmii_rxd_dly2 == 8'hd5 && cnt_preamble > 4'd5))begin
      crc_en <= 1'B1;
    end
    else begin
      crc_en <= crc_en;
    end
  end                                                               //always end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      cnt_crc <= 4'd0;
    end
    else if(state_c==RX_CRC)begin
      cnt_crc <= cnt_crc + 1'b1;
    end
    else begin
      cnt_crc <= 4'd0;
    end
  end                                                               //always end

  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      crc_check <= 32'h00_00_00_00;
    end
    else if(state_c == RX_CRC)begin
      case(cnt_crc)
        0 : crc_check[31:24] <= gmii_rxd_dly2;
        1 : crc_check[23:16] <= gmii_rxd_dly2;
        2 : crc_check[15:08] <= gmii_rxd_dly2;
        3 : crc_check[07:00] <= gmii_rxd_dly2;
        default:crc_check <= crc_check;
      endcase
    end
    else begin
      crc_check <= crc_check;
    end
  end                                                               //always end
  
  
//payload output
  always@(posedge gmii_rx_clk or posedge rst_n)begin
    if(!rst_n)begin
      payload_valid_o <= 1'b0;
      payload_data_o <= 8'h0;
    end
    else if(state_c == RX_DATA)begin
      payload_valid_o <= 1'b1;
      payload_data_o <= gmii_rxd_dly2;
    end
    else begin
      payload_valid_o <= 1'b0;
      payload_data_o <= 8'h0;
    end
  end

  //
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      one_pkt_done  <= 1'b0;
      pkt_error <= 1'b0;
    end
    else if(state_c == PKT_CHECK)begin
      one_pkt_done <= 1'b1;
      if (crc_check == crc_out && data_over_flow_reg == 1'b0) begin
        pkt_error <= 1'b0;
      end
      else begin
        pkt_error <= 1'b1;
      end
    end
    else begin
      one_pkt_done  <= 1'b0;
      pkt_error <= 1'b0;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      data_over_flow_reg <= 1'b0;
    end
    else if(state_c == RX_DATA && data_over_flow_i == 1'B1)begin
      data_over_flow_reg <= 1'B1;
    end
    else begin
      data_over_flow_reg <= data_over_flow_reg;
    end
  end                                                               //always end
  
  always @ (posedge gmii_rx_clk or negedge rst_n)begin
    if(!rst_n)begin
      exter_mac     <= 48'h00_00_00_00_00_00;
      exter_ip      <= 32'h00_00_00_00;
      exter_port    <= 16'h00_00;
      debug_crc_check <= 32'h00_00_00_00;
    end
    else begin
      exter_mac     <= rx_src_mac;
      exter_ip      <= rx_src_ip;
      exter_port    <= rx_src_port;
      debug_crc_check <= crc_check;
    end
  end                                                               //always end
  

endmodule
