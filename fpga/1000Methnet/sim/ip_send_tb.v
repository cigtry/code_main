`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE plug-in 
// VSCODE plug-in version: Verilog-Hdl-Format-2.3.20240512
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              ip_send_tb.v
// Last modified Date:     2024/08/07 17:23:05
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             
// Created date:           2024/08/07 17:23:05
// Version:                V1.0
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module    ip_send_tb();
  reg                                            rst_n           ;
  wire                                           tx_done         ;
  reg            [  47:00]                       des_mac         ;
  reg            [  47:00]                       src_mac         ;
  reg            [  15:00]                       des_port        ;
  reg            [  15:00]                       src_port        ;
  reg            [  31:00]                       des_ip          ;
  reg            [  31:00]                       src_ip          ;
  reg            [  15:00]                       data_length     ;
  reg                                            gmii_tx_clk     ;
  wire           [   7: 0]                       gmii_txd        ;
  wire                                           gmii_txen       ;
  reg                                            wrreq           ;
  reg            [  07:00]                       wrdata          ;
  wire                                           wr_fifo_full    ;
  wire           [  11:00]                       wrusedw         ;
  wire                                           rgmii_tx_clk    ;
  wire           [   3: 0]                       rgmii_txd       ;
  wire                                           rgmii_txen      ;

    initial
        begin
            #2
                    rst_n = 0   ;
                    gmii_tx_clk = 0     ;
            #100
                    rst_n = 1   ;
                    wrdata = 0;
        end
                                                           
  parameter                                          gmii_tx_clk_FREQ= 125   ;//Mhz                       
    always # ( 1000/gmii_tx_clk_FREQ/2 ) gmii_tx_clk = ~gmii_tx_clk ;
                                                           
//模拟主机发送数据
  //主机mac {48'hC8_5B_76_DD_0B_38}
  //主机ip  {32'hc0_a8_00_03}
  //主机端口 {16'd6102}        
  //FPGAmac {48'h00_0a_35_01_fe_c0}
  //FPGAip  {32'hc0_a8_00_02}
  //fpga端口 {16'd5000}                                              
ip_send u_ip_send_test(
  .rst_n                                             (rst_n          ),
  .tx_done                                           (tx_done        ),
  .des_mac                                           ({48'h00_0a_35_01_fe_c0}),
  .src_mac                                           ({48'hC8_5B_76_DD_0B_38}),
  .des_port                                          ({16'd5000}     ),
  .src_port                                          ({16'd6102}     ),
  .des_ip                                            ({32'hc0_a8_00_02}),
  .src_ip                                            ({32'hc0_a8_00_03}),
  .data_length                                       (16'd23         ),
  .gmii_tx_clk                                       (gmii_tx_clk    ),
  .gmii_txd                                          (gmii_txd       ),
  .gmii_txen                                         (gmii_txen      ),
  .wrreq                                             (wrreq          ),
  .wrdata                                            (wrdata         ),
  .wrclk                                             (gmii_tx_clk    ),
  .aclr                                              (!rst_n         ),
  .wr_fifo_full                                      (wr_fifo_full   ),
  .wrusedw                                           (wrusedw        ) 
);

gmii_to_rgmii u_gmii_to_rgmii_test(
  .rst_n                                             (rst_n          ),
  .gmii_tx_clk                                       (gmii_tx_clk    ),
  .gmii_txd                                          (gmii_txd       ),
  .gmii_txen                                         (gmii_txen      ),
  .gmii_txer                                         (1'b0           ),
  .rgmii_tx_clk                                      (rgmii_tx_clk   ),
  .rgmii_txd                                         (rgmii_txd      ),
  .rgmii_txen                                        (rgmii_txen     ) 
);

  wire                                           rgmii_tx_clk_o  ;
  wire           [   3: 0]                       rgmii_txd_o     ;
  wire                                           rgmii_txen_o    ;

eth_udp_loopback_gmii u_eth_udp_loopback_gmii(
  .rst_n                                             (rst_n          ),
  .rgmii_rx_clk                                      (rgmii_tx_clk   ),
  .rgmii_rxd                                         (rgmii_txd      ),
  .rgmii_rxdv                                        (rgmii_txen     ),
  .rgmii_tx_clk                                      (rgmii_tx_clk_o ),
  .rgmii_txd                                         (rgmii_txd_o    ),
  .rgmii_txen                                        (rgmii_txen_o   ) 
);

  reg            [   7: 0]                       tx_byte_cnt     ;

always@(posedge gmii_tx_clk or negedge rst_n)
if(!rst_n)begin
  tx_byte_cnt <= 16'd0;
  wrreq <= 1'b0;
end
else if(!wr_fifo_full && tx_byte_cnt <= 22)begin
tx_byte_cnt <= tx_byte_cnt + 1'b1;
wrreq <= 1'b1;
end
else begin
  tx_byte_cnt <= tx_byte_cnt;
  wrreq <= 1'b0;
end

always@(posedge gmii_tx_clk)
begin
case(tx_byte_cnt)
16'd0 : wrdata <= "H";
16'd1 : wrdata <= "e";
16'd2 : wrdata <= "l";
16'd3 : wrdata <= "l";
16'd4 : wrdata <= "o";
16'd5 : wrdata <= ",";
16'd6 : wrdata <= " ";
16'd7 : wrdata <= "w";
16'd8 : wrdata <= "e";
16'd9 : wrdata <= "l";
16'd10 : wrdata <= "c";
16'd11 : wrdata <= "o";
16'd12 : wrdata <= "m";
16'd13 : wrdata <= "e";
16'd14 : wrdata <= " ";
16'd15 : wrdata <= "t";
16'd16 : wrdata <= "o";
16'd17 : wrdata <= " ";
16'd18 : wrdata <= "F";
16'd19 : wrdata <= "P";
16'd20 : wrdata <= "G";
16'd21 : wrdata <= "A";
16'd22 : wrdata <= "!";
default: wrdata <= 8'd0;
endcase
end

  initial begin
    wait(rst_n);
    #200;
    @(posedge tx_done);
    #500;
    $stop(2);
  end

endmodule