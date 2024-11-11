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
// Last modified Date:     2024/08/06 15:55:11 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/08/06 15:55:11 
// Version:                V1.0 
// TEXT NAME:              eth_udp_loopback_gmii.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\1000Methnet\eth_udp_loopback_gmii.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module eth_udp_loopback_gmii(
  input                                          rst_n           ,

  input                                          rgmii_rx_clk    ,
  input          [   3: 0]                       rgmii_rxd       ,
  input                                          rgmii_rxdv      ,

  output                                         rgmii_tx_clk    ,
  (*IOB = "TRUE"*) output         [   3: 0]                       rgmii_txd       ,
  (*IOB = "TRUE"*) output                                         rgmii_txen
);
  localparam                                         FPGA_MAC       = {48'h00_0a_35_01_fe_c0};
  localparam                                         FPGA_IP        = {32'hc0_a8_00_02};
  localparam                                         FPGA_PORT      = 16'D5000;
  wire                                           locked          ;
  wire                                           rgmii_rx_clk_90  ;
  wire                                           gmii_rx_clk     ;
  wire           [   7: 0]                       gmii_rxd        ;
  wire                                           gmii_rxdv       ;
  wire                                           gmii_rxerr      ;
  wire                                           wr_fifo_full    ;

  reg                                            data_over_flow_i  ;
  always @(posedge rgmii_rx_clk_90 ) begin
    data_over_flow_i <= wr_fifo_full;
  end
  wire           [  47:00]                       exter_mac       ;
  wire           [  31:00]                       exter_ip        ;
  wire           [  15:00]                       exter_port      ;
  wire           [  15:00]                       rx_data_length  ;
  wire           [  07:00]                       payload_data_o  ;
  wire                                           payload_valid_o  ;
  wire                                           one_pkt_done    ;
  wire                                           pkt_error       ;
  wire           [  31:00]                       debug_crc_check  ;
  wire                                           tx_done         ;
  wire           [   7: 0]                       gmii_txd        ;
  wire                                           gmii_txen       ;
  wire           [  11:00]                       wrusedw         ;

  eth_clk_phase_90 u_eth_clk_phase_90
   (
  .clk_out1                                          (rgmii_rx_clk_90),// output clk_out1
  .reset                                             (!rst_n         ),// input reset
  .locked                                            (locked         ),// output locked
  .clk_in1                                           (rgmii_rx_clk   ) 
  );                                                                // input clk_in1

  rgmii_to_gmii u_rgmii_to_gmii(
  .rst_n                                             (locked         ),
  .rgmii_rx_clk                                      (rgmii_rx_clk),
  .rgmii_rxd                                         (rgmii_rxd      ),
  .rgmii_rxdv                                        (rgmii_rxdv     ),
  .gmii_rx_clk                                       (gmii_rx_clk    ),
  .gmii_rxd                                          (gmii_rxd       ),
  .gmii_rxdv                                         (gmii_rxdv      ),
  .gmii_rxerr                                        (gmii_rxerr     ) 
  );

  ip_recive u_ip_recive(
  .rst_n                                             (locked         ),
  .gmii_rx_clk                                       (gmii_rx_clk    ),
  .gmii_rxdv                                         (gmii_rxdv      ),
  .gmii_rxd                                          (gmii_rxd       ),
  .local_mac                                         (FPGA_MAC       ),
  .local_ip                                          (FPGA_IP        ),
  .local_port                                        (FPGA_PORT      ),
  .data_over_flow_i                                  (data_over_flow_i),
  .exter_mac                                         (exter_mac      ),
  .exter_ip                                          (exter_ip       ),
  .exter_port                                        (exter_port     ),
  .rx_data_length                                    (rx_data_length ),
  .payload_data_o                                    (payload_data_o ),
  .payload_valid_o                                   (payload_valid_o),
  .one_pkt_done                                      (one_pkt_done   ),
  .pkt_error                                         (pkt_error      ),
  .debug_crc_check                                   (debug_crc_check) 
  );

ip_send u_ip_send(
  .rst_n                                             (locked         ),
  .tx_done                                           (tx_done        ),
  .des_mac                                           (exter_mac      ),
  .src_mac                                           (FPGA_MAC       ),
  .des_port                                          (exter_port     ),
  .src_port                                          (FPGA_PORT      ),
  .des_ip                                            (exter_ip       ),
  .src_ip                                            (FPGA_IP        ),
  .data_length                                       (rx_data_length ),
  .gmii_tx_clk                                       (rgmii_rx_clk),
  .gmii_txd                                          (gmii_txd       ),
  .gmii_txen                                         (gmii_txen      ),
  .wrreq                                             (payload_valid_o),
  .wrdata                                            (payload_data_o ),
  .wrclk                                             (gmii_rx_clk    ),
  .aclr                                              (!locked         ),
  .wr_fifo_full                                      (wr_fifo_full   ),
  .wrusedw                                           (wrusedw        ) 
);

gmii_to_rgmii u_gmii_to_rgmii(
  .rst_n                                             (locked         ),
  .gmii_tx_clk                                       (rgmii_rx_clk),
  .gmii_txd                                          (gmii_txd       ),
  .gmii_txen                                         (gmii_txen      ),
  .gmii_txer                                         (1'b0      ),
  .rgmii_tx_clk                                      (rgmii_tx_clk   ),
  .rgmii_txd                                         (rgmii_txd      ),
  .rgmii_txen                                        (rgmii_txen     ) 
);



                                                                   
                                                                   
endmodule
