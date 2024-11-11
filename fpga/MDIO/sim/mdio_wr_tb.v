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
// File name:              mdio_wr_tb.v
// Last modified Date:     2024/08/06 15:02:13
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             
// Created date:           2024/08/06 15:02:13
// Version:                V1.0
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module    mdio_wr_tb();
    reg                                        mdc                        ;
    reg                                        rst_n                      ;
    reg                                        start                      ;
    reg                                        wr_cmd                     ;
    reg                       [  04:00]        phy_addr                   ;
    reg                       [  04:00]        reg_addr                   ;
    reg                       [  15:00]        wr_data                    ;
    wire                                       mdio                       ;
    wire                                       done                       ;
    wire                      [  15:00]        rd_data                    ;



    initial
        begin
            #2                                             
                    rst_n = 0   ;                          
                    mdc = 0     ;                          
            #10                                            
                    rst_n = 1   ;                          
        end                                                
                                                           
    parameter   mdc_FREQ = 100;//Mhz                       
    always # ( 1000/mdc_FREQ/2 ) mdc = ~mdc ;              
                                                           
   pullup PUP(mdio);                                                        
mdio_wr u_mdio_wr(
    .mdc                                (mdc                       ),
    .rst_n                              (rst_n                     ),
    .start                              (start                     ),
    .wr_cmd                             (wr_cmd                    ),
    .phy_addr                           (phy_addr                  ),
    .reg_addr                           (reg_addr                  ),
    .wr_data                            (wr_data                   ),
    .mdio                               (mdio                      ),
    .done                               (done                      ),
    .rd_data                            (rd_data                   )
);

  initial begin
mdc = 1;
rst_n = 0;
wr_cmd = 0;
phy_addr = 5'b00000;
reg_addr = 5'b00000;
wr_data = 16'd0;
start = 0;
#201;
rst_n = 1;
wr_cmd = 1;
phy_addr = 5'b00000;
reg_addr = 5'b00000;
wr_data = 16'h2100;
@(posedge mdc);
start = 1;
@(posedge done);
#200;
$stop;
end


endmodule                                                  