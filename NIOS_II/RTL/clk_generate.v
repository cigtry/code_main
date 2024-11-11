`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
//Company        :    maccura    
//Engineer        :    FuXin     
//Creat Date      :    2023-01-01
//Design Name      :             
//Module Name      :             
//Project Name      :            
//Target Devices    :            
//Tool Version      :            
//Description      :             
//Revisoion      :               
//Additional Comments  :          
//
////////////////////////////////////////////////////////////////
module clk_generate(
  input  wire                                    clk_1m          ,//1mhz
  input  wire                                    rst_n           ,//reset, low valid
  
  output reg                                     clk_10k        
);
  reg            [   5: 0]                       cnt_20k         ;
  reg            [   4: 0]                       cnt_1K          ;
always @ (posedge clk_1m or negedge rst_n)begin
  if(!rst_n)begin
    cnt_20k <= 6'b0;
  end
  else if(cnt_20k == 6'd49)begin
    cnt_20k <= 6'b0;
  end
  else begin
    cnt_20k <= cnt_20k + 1'b1;
  end
end                                                                 //always end

always @(posedge clk_1m or negedge rst_n) begin
  if(!rst_n)begin
    clk_10k <= 1'b1;
  end
  else if(cnt_20k == 6'd49)begin
    clk_10k <= ~clk_10k;
  end
  else begin
    clk_10k <= clk_10k;
  end
end




endmodule

