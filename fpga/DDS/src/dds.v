module dds(
  input                                          clk             ,// 50M
  input                                          rst_n           ,
  input                                          en              ,

  input          [  31: 0]                       fword           ,// 频率控制字
  input          [  11: 0]                       pword           ,// 相位控制字

  output      signed[   7: 0]                       rom_data         
);


  reg            [  31: 0]                       fre_acc         ;
  reg            [  09: 0]                       rom_addr        ;
  


always @(posedge clk or negedge rst_n) begin                        // fword
    if(!rst_n)
        fre_acc <= 0;
    else if(en == 1'b0)
        fre_acc <= 0;
    else
        fre_acc <= fre_acc + fword;
end

always @(posedge clk or negedge rst_n) begin                        // rom_addr
    if(!rst_n)
        rom_addr <= 0;
    else if(en == 1'b0)
        rom_addr <= 0;
    else
        rom_addr <= fre_acc[31:22] + pword;
end


    blk_mem_gen_0 u_sin_rom (
  .clka                                              (clk            ),// input wire clka
  .ena                                               (en             ),// input wire ena
  .addra                                             (rom_addr       ),// input wire [11 : 0] addra
  .douta                                             (rom_data       ) // output wire [7 : 0] douta
);


endmodule