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
module m_axi_wr#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )
(
  input  wire                                    clk             ,
  input  wire                                    rst_n           ,
//??????
  input  wire                                    wr_start        ,
  input  wire    [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr         ,
  input  wire    [  07:00]                       wr_len          ,
  input  wire    [C_M_AXI_DATA_WIDTH - 1 : 00]   wr_data         ,
  output wire                                    wr_req          ,
  output wire                                    wr_busy         ,
//AXI????????
  output wire    [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_awid        ,
  output reg     [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_awaddr      ,
  output wire    [  07:00]                       axi_awlen       ,
  output wire    [  02:00]                       axi_awsize      ,
  output wire    [  01:00]                       axi_awburst     ,
  output wire                                    axi_awlock      ,
  output wire    [  03:00]                       axi_awcache     ,
  output wire    [  02:00]                       axi_awprot      ,
  output wire    [  03:00]                       axi_awqos       ,
  output wire    [C_M_AXI_AWUSER_WIDTH-1:00]     axi_awuser      ,
  output reg                                     axi_awvalid     ,
  input  wire                                    axi_awready     ,
//AXI?????????
  output wire    [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_wdata       ,
  output wire    [C_M_AXI_DATA_WIDTH/8-1:00]     axi_wstrb       ,
  output wire                                    axi_wlast       ,
  output wire    [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_wuser       ,
  output reg                                     axi_wvalid      ,
  input  wire                                    axi_wready      ,
//AXI??????
  input  wire    [C_M_AXI_ID_WIDTH     -1 : 00]  axi_bid         ,
  input  wire    [  01:00]                       axi_bresp       ,
  input  wire    [C_M_AXI_BUSER_WIDTH - 1 : 00]  axi_buser       ,
  input  wire                                    axi_bvalid      ,
  output reg                                     axi_bready       
);
  function integer clogb2 (input integer bit_depth);
  begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  assign                                             axi_awid       = 1'b0;
  assign                                             axi_awlen      = wr_len - 1;
  assign                                             axi_awsize     = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
  assign                                             axi_awburst    = 2'b01;
  assign                                             axi_awlock     = 1'b0;
  assign                                             axi_awcache    = 4'b0000;
  assign                                             axi_awprot     = 3'h0;
  assign                                             axi_awqos      = 4'h0;
  assign                                             axi_awuser     = 1'b1;
  assign                                             axi_wuser      = 1'b1;
  assign                                             axi_wstrb      = {(C_M_AXI_DATA_WIDTH/8){1'b1}};


  localparam                                         IDLE           = 2'd0  ;
  localparam                                         W_ADDR         = 2'd1  ;
  localparam                                         W_DATA         = 2'd2  ;
  localparam                                         B_RESP         = 2'd3  ;
  reg            [  01:00]                       state_c,state_n  ;

  wire                                           axi_aw_handok   ;
  wire                                           axi_w_handok    ;
  wire                                           axi_b_handok    ;
  assign                                             axi_aw_handok  = axi_awvalid && axi_awready;
  assign                                             axi_w_handok   = axi_wvalid && axi_wready;
  assign                                             axi_b_handok   = axi_bvalid && axi_bready && (axi_bresp == 2'b00) && (axi_bid ==axi_awid[C_M_AXI_ID_WIDTH-1:00] );
  assign                                             wr_req         = axi_w_handok;
  reg            [  07:00]                       wr_index        ;
  reg                                            wr_done ;
  assign wr_busy = (state_c != IDLE);
  always @(posedge clk ) begin
    if(!rst_n )begin
      state_c <= IDLE;
    end
    else if (wr_start) begin
      state_c <= W_ADDR;
    end
    else begin
      state_c <= state_n;
    end
  end


  always @(*) begin
    case(state_c)
      IDLE   : begin
        if(wr_start)
          state_n = W_ADDR;
        else
          state_n = state_c;
      end
      W_ADDR : begin
        if(axi_aw_handok)
          state_n = W_DATA;
        else
          state_n = state_c;
      end
      W_DATA : begin
        if(wr_done)
          state_n = B_RESP;
        else
          state_n = state_c;
      end
      B_RESP : begin
        if(axi_b_handok)
          state_n = IDLE;
        else
          state_n = state_c;
      end
      default : state_n = IDLE;
    endcase
  end

  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_awaddr <= {C_M_AXI_ADDR_WIDTH{1'b0}};
    end
    else if(wr_start)begin
      axi_awaddr <= wr_addr;
    end
    else begin
      axi_awaddr <= axi_awaddr;
    end
  end                                                               //always end

  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_awvalid <= 1'b0;
    end
    else if(axi_awvalid &&  axi_awready)begin
      axi_awvalid <= 1'b0;
    end
    else if(wr_start)begin
      axi_awvalid <= 1'b1;
    end
    else begin
      axi_awvalid <= axi_awvalid;
    end
  end                                                               //always end

  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_wvalid <= 1'b0;
    end
    else if(state_c == W_DATA)begin
      if (axi_wready && axi_wvalid) begin
        axi_wvalid <= 1'b0;
      end
      else begin
        axi_wvalid <= 1'b1;
      end
    end
    else begin
      axi_wvalid <= 1'b0;
    end
  end                                                               //always end

  always @ (posedge clk  )begin
    if(!rst_n)begin
      wr_index <= 8'd0;
    end
    else if(wr_start || (wr_index == wr_len - 1 ))begin
      wr_index <= 8'd0;
    end
    else if (state_c ==W_DATA && axi_wvalid ) begin
      wr_index <= wr_index + 1'd1;
    end
    else begin
      wr_index <= wr_index;
    end
  end                                                               //always end

  assign                                             axi_wdata      = axi_w_handok ? wr_data : {C_M_AXI_DATA_WIDTH {1'b0}};

  always @ (posedge clk  )begin
    if(!rst_n)begin
      wr_done <= 1'b0;
    end
    else if((state_c == W_DATA) && (wr_index == wr_len - 1) )begin
      wr_done <= 1'b1;
    end
    else begin
      wr_done <= 1'b0;
    end
  end                                                               //always end
  
  assign                                             axi_wlast      = wr_done;

  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_bready <= 1'b0;
    end
    else if(axi_bready)begin
      axi_bready <= 1'b0;
    end
    else if(axi_bvalid && ~axi_bready)begin
      axi_bready <= 1'b1;
    end
    else begin
      axi_bready <= axi_bready;
    end
  end                                                               //always end
  

endmodule