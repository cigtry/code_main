//--###############################################################################
//--#                                                       							 
//--# File Name   : reset_sig.v                           			 			 
//--# Designer		:  Gong Ting
//--# Tool			:  Quartus II 15.1                                                    
//--# Checked by  :  				                                                 
//--# Design Date :  2019-12-10                                                   
//--# Description :    
//--#						 																				 
//--#                               						             					 
//--# Version     :  0.1                                                          
//--# History     :                                     								 
//--###############################################################################

`timescale 1ns/1ps

module reset_sig
(
		input						clk_sys, 
		output	reg			rst_n
	);
	
reg		[31:0]		cnt = 0;	

always@(posedge		clk_sys)
	begin
		if(	cnt[5] == 0	)
			cnt		<=		cnt	+	1'b1;
		else
			cnt		<=		cnt	;
	end
// 0xfff_ffff * 20ns = 	5.37s
always@(posedge		clk_sys)
	begin
		if(	cnt[5] == 0	)
			rst_n		<=		1'b0;
		else
			rst_n		<=		1'b1	;
	end	
	
endmodule
