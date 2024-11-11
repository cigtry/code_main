//===========================================================================//
//---------------------------------------------------------------------------//
//--Author    :   TRZ
//--Data      :   2021/11/1
//--Email     :   1961688699@qq.com
//--Funcation :   Step Motor Driver step generate
//--              Pluse width is 500*T=500*10ns = 5us
//--              Reference TMC Manual
//--Attention :   Pluse width canot greater than 100000ns=10us
//---------------------------------------------------------------------------//
//===========================================================================//

module gen_step_pluse
(
//---------------------------------------------------------------
// System clock & Reset
//---------------------------------------------------------------
    input                                     sys_clk           ,
    input                                     rst_n             ,
//---------------------------------------------------------------
// Step Motor Driver step generate
//---------------------------------------------------------------
    input                                     start             ,
    output                                    mt_step_o         
);
//===============================================================//
// ------------------------Parameter Range---------------------- //
//===============================================================//
localparam    STEP_WIDTH_NUM  =  9'd499-9'd1;
reg                    busy          ;
reg   [ 08 : 00 ]      step_width_cnt;

//===============================================================//
// --------------------------Logic Range------------------------ //
//===============================================================//
    always @ (posedge sys_clk or negedge rst_n)
    begin
        if (rst_n == 1'b0)
            busy  <=  1'b0;
        else if (step_width_cnt > STEP_WIDTH_NUM)
            busy  <=  1'b0;
        else if (start == 1'b1)
            busy  <=  1'b1;
        else 
            busy  <=  busy;
    end

    always @ (posedge sys_clk or negedge rst_n)
    begin
        if (rst_n == 1'b0)
            step_width_cnt  <=  9'd0;
        else if (busy == 1'b1)
            if (step_width_cnt > STEP_WIDTH_NUM)
                step_width_cnt  <=  9'd0;
            else
                step_width_cnt  <=  step_width_cnt + 9'd1;
        else
            step_width_cnt  <=  9'd0;
    end

assign mt_step_o = busy;
endmodule