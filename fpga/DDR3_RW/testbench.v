`timescale  100ps/100ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE plug-in 
// VSCODE plug-in version: Verilog-Hdl-Format-2.3.20240512
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              ddr3_test_top_tb.v
// Last modified Date:     2024/07/30 15:45:25
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/07/30 15:45:25
// Version:                V1.0
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module    testbench();
  reg                                            clk             ;
  reg                                            rst_n           ;
  wire           [  31: 0]                       ddr3_dq         ;
  wire           [   3: 0]                       ddr3_dqs_n      ;
  wire           [   3: 0]                       ddr3_dqs_p      ;
  wire           [  14: 0]                       ddr3_addr       ;
  wire           [   2: 0]                       ddr3_ba         ;
  wire                                           ddr3_ras_n      ;
  wire                                           ddr3_cas_n      ;
  wire                                           ddr3_we_n       ;
  wire                                           ddr3_reset_n    ;
  wire           [   0: 0]                       ddr3_ck_p       ;
  wire           [   0: 0]                       ddr3_ck_n       ;
  wire           [   0: 0]                       ddr3_cke        ;
  wire           [   0: 0]                       ddr3_cs_n       ;
  wire           [   3: 0]                       ddr3_dm         ;
  wire           [   0: 0]                       ddr3_odt        ;
  wire                                           init_calib_complete  ;
  wire                                           uart_rx         ;
  wire                                           tmds_clk_p      ;
  wire                                           tmds_clk_n      ;
  wire           [  02:00]                       tmds_data_p     ;
  wire           [  02:00]                       tmds_data_n     ;
  localparam                                         BAUD_9600      = 5208  ;
  localparam                                         BAUD_19200     = 2604  ;
  localparam                                         BAUD_38400     = 1302  ;
  localparam                                         BAUD_57600     = 868   ;
  localparam                                         BAUD_115200    = 434   ;
initial
begin
    clk = 1'b0;
    forever #100 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end
                                                           
  reg            [   7: 0]                       tx_data         ;
  reg                                            tx_req          ;
  wire                                           tx_busy         ;
  wire                                           uart_tx_end     ;

uart_tx#(
  .BAUD_9600                                         (BAUD_9600      ),
  .BAUD_19200                                        (BAUD_19200     ),
  .BAUD_38400                                        (BAUD_38400     ),
  .BAUD_57600                                        (BAUD_57600     ),
  .BAUD_115200                                       (BAUD_115200    ) 
)
 u_uart_tx(
  .clk                                               (clk            ),// system clock 50MHz
  .rst_n                                             (init_calib_complete),// reset, low valid
  .baud_sel                                          (4              ),
  .tx_data                                           (tx_data        ),
  .tx_req                                            (tx_req         ),
  .tx_busy                                           (tx_busy        ),
  .uart_tx                                           (uart_rx        ),
  .uart_tx_end                                       (uart_tx_end    ) 
);



ddr3_test_top#
( .DATA_IN_WIDTH                                     ( 16 )  ,      //写入fifo的数据如果输出为128，输入最低支持16
  .DATA_WIDTH                                        (128            ),//数据位宽，根据MIG例化而来
  .ADDR_WIDTH                                        (29             ) //地址位宽
) u_ddr3_test_top(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
      // Inouts
  .ddr3_dq                                           (ddr3_dq        ),
  .ddr3_dqs_n                                        (ddr3_dqs_n     ),
  .ddr3_dqs_p                                        (ddr3_dqs_p     ),
   // Outputs
  .ddr3_addr                                         (ddr3_addr      ),
  .ddr3_ba                                           (ddr3_ba        ),
  .ddr3_ras_n                                        (ddr3_ras_n     ),
  .ddr3_cas_n                                        (ddr3_cas_n     ),
  .ddr3_we_n                                         (ddr3_we_n      ),
  .ddr3_reset_n                                      (ddr3_reset_n   ),
  .ddr3_ck_p                                         (ddr3_ck_p      ),
  .ddr3_ck_n                                         (ddr3_ck_n      ),
  .ddr3_cke                                          (ddr3_cke       ),
  .ddr3_cs_n                                         (ddr3_cs_n      ),
  .ddr3_dm                                           (ddr3_dm        ),
  .ddr3_odt                                          (ddr3_odt       ),
  .init_calib_complete                               (init_calib_complete),
  //
  .uart_rx                                           (uart_rx        ),
  //
  .tmds_clk_p                                        (tmds_clk_p     ),
  .tmds_clk_n                                        (tmds_clk_n     ),
  .tmds_data_p                                       (tmds_data_p    ),
  .tmds_data_n                                       (tmds_data_n    ) 
);


ddr3_model u_ddr3_model(
  .rst_n                                             (ddr3_reset_n   ),
  .ck                                                (ddr3_ck_p      ),
  .ck_n                                              (ddr3_ck_n      ),
  .cke                                               (ddr3_cke       ),
  .cs_n                                              (ddr3_cs_n      ),
  .ras_n                                             (ddr3_ras_n     ),
  .cas_n                                             (ddr3_cas_n     ),
  .we_n                                              (ddr3_we_n      ),
  .dm_tdqs                                           (ddr3_dm[1:0]   ),
  .ba                                                (ddr3_ba        ),
  .addr                                              (ddr3_addr      ),
  .dq                                                (ddr3_dq[15:0]  ),
  .dqs                                               (ddr3_dqs_p[1:0]),
  .dqs_n                                             (ddr3_dqs_n[1:0]),
  .tdqs_n                                            (               ),
  .odt                                               (ddr3_odt       ) 
);

ddr3_model u_ddr3_model2(
  .rst_n                                             (ddr3_reset_n   ),
  .ck                                                (ddr3_ck_p      ),
  .ck_n                                              (ddr3_ck_n      ),
  .cke                                               (ddr3_cke       ),
  .cs_n                                              (ddr3_cs_n      ),
  .ras_n                                             (ddr3_ras_n     ),
  .cas_n                                             (ddr3_cas_n     ),
  .we_n                                              (ddr3_we_n      ),
  .dm_tdqs                                           (ddr3_dm[3:2]   ),
  .ba                                                (ddr3_ba        ),
  .addr                                              (ddr3_addr      ),
  .dq                                                (ddr3_dq[31:16] ),
  .dqs                                               (ddr3_dqs_p[3:2]),
  .dqs_n                                             (ddr3_dqs_n[3:2]),
  .tdqs_n                                            (               ),
  .odt                                               (ddr3_odt       ) 
);
always @(posedge clk ) begin
  if (!rst_n) begin
    tx_req  <= 1'b0;
  end
  else if(!init_calib_complete)begin
    tx_req  <= 1'b0;
  end
  else if(!tx_busy)begin
    tx_req <= 1'b1;
  end
  else begin
    tx_req  <= 1'b0;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    tx_data  <= 1'b0;
  end
  else if(!init_calib_complete)begin
    tx_data  <= 1'b0;
  end
  else if(uart_tx_end)begin
    tx_data <= tx_data + 1;
  end
  else begin
    tx_data  <= tx_data;
  end
end


endmodule