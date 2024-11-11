//===================================================================================
//Author    : TRZ
//Data      : 2021/08/16
//Funcation : IO 滤波
//===================================================================================

module cb_io_filter # (
    parameter     FILTER_CNT   =   8   
)
(
//-----------------------------------------------------------------------------------
// Filter & System Clock & Reset
//-----------------------------------------------------------------------------------
    input                               filter_clk                  , 
    input                               sys_clk                     ,
    input                               rst_n                       ,  
//-----------------------------------------------------------------------------------
// Orign IO Photoelectric Signal input
//-----------------------------------------------------------------------------------
	input                               orign_opt_i                 , 
//-----------------------------------------------------------------------------------
// IO Photoelectric Signal output After filter
//-----------------------------------------------------------------------------------
	output  reg                         filter_opt_o
); 
//=================================================================================//
// ----------------------------------Parameter Area------------------------------- //
//=================================================================================// 
function integer clogb2;
    input   [31:0]    value;
    begin
        value = value - 1;
        for (clogb2=0; value>0; clogb2=clogb2+1) begin
            value = value >> 1;
        end
    end
endfunction
localparam  DATA_BIT_WITH = clogb2(FILTER_CNT);
localparam  FILTER_NUM    = FILTER_CNT-2;

    reg  [DATA_BIT_WITH-1 : 0]     filter_cnt         ;
    reg  [4-1:0]                   orign_opt_shift    ; 
    reg                            opt_rise , opt_fall;
    reg                            filter_start       ;



//=================================================================================//
// -------------------------------------Logic Area-------------------------------- //
//=================================================================================//
    //---IO shift register by filter_clk---//
    //消除亚稳态
	always @ (posedge filter_clk)
	begin
		orign_opt_shift <= {orign_opt_shift[4-2:0] , orign_opt_i};   
	end 
	//光电上升沿
	always @ (posedge filter_clk or negedge rst_n)
	begin
		if ( !rst_n )
           opt_rise  <=  1'b0;
        else if (orign_opt_shift[3:2] == ({1'b0 , 1'b1}))
           opt_rise  <=  1'b1;
        else 
           opt_rise  <=  1'b0;
    end
    //光电下降沿
	always @ (posedge filter_clk or negedge rst_n)
	begin
		if ( !rst_n )
           opt_fall  <=  1'b0;
        else if (orign_opt_shift[3:2] == ({1'b1 , 1'b0}))
           opt_fall  <=  1'b1;
        else 
           opt_fall  <=  1'b0;
    end
    //光电滤波计数 
	always @(posedge filter_clk or negedge rst_n)
	begin
		if( !rst_n ) 
			filter_cnt <= {DATA_BIT_WITH{1'b0}};
		else if ( filter_start == 1'b1 )  
			filter_cnt <= filter_cnt + {{(DATA_BIT_WITH-1){1'b0}},1'b1};          
		else 
			filter_cnt <= {DATA_BIT_WITH{1'b0}};
	end 
    //光电滤波标志
	always @(posedge filter_clk or negedge rst_n)
	begin
		if( !rst_n ) 
			filter_start <= 1'b0;
		else if ( opt_rise==1'b1 || opt_fall==1'b1)
		begin 
		    if (filter_start == 1'b1)     
			    filter_start <= 1'b0;
			else 
			    filter_start <= 1'b1;
	    end 
	    else if (filter_cnt == FILTER_NUM) 
			filter_start <= 1'b0;
	    else 
	        filter_start <= filter_start;
	end  

    always @(posedge sys_clk or negedge rst_n)
    begin
        if( !rst_n ) 
            filter_opt_o  <=  orign_opt_shift[3];
        else if (filter_cnt == FILTER_NUM) 
            filter_opt_o  <=  orign_opt_shift[3];
        else 
            filter_opt_o  <=  filter_opt_o;
    end 

endmodule

