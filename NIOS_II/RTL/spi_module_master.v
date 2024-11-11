//--###############################################################################
//--# Company        :    maccura
//--# File Name   :  spi_module_master.v
//--# Designer        :  Gong Ting
//--# Tool            :  Quartus II 15.1
//--# Checked by  :
//--# Design Date :  2019-12-01
//--# Description :  The SPI communication is realized,the bit width is adjustable ,
//--#                        and the chip select signal delay pull-up time is adjustable.
//--#                1. SPI_SCLK  = sys_clk / DIV_NUM ;
//--#                2. send data : negedge
//--#                3. receive data : posedge
//--#
//--# Version     :  0.3 (2020-05-20): logic optimization
//--# History     :  0.1   0.2   : add "parameter"
//--###############################################################################

`timescale 1ns/1ps

module spi_module_master
    #(
         parameter    SPI_DATA = 40 ,
         parameter    DIV_NUM    = 499
     )(
         input                                           sys_clk,
         input                                           rst_n,

         input                 [SPI_DATA - 1 : 0]        mosi_data,
         input                                           start_en,
         output                                          spi_cs_rise,

         input                                           MISO,
         output     reg        [SPI_DATA - 1 : 0]        miso_data,
         output     reg                                  spi_cs,
         output     reg                                  spi_sclk,
         output     reg                                  MOSI
     );

    reg        [02:0]          current_state;
    reg        [18:0]          cnt_bit;
    reg        [18:0]          cnt_clk;
    reg                        spi_sclk_delay;
    reg                        spi_cs_delay;
    wire                        spi_sclk_rise;
    wire                        spi_sclk_fall;

    reg        [ SPI_DATA - 1 : 00 ]        dout_temp;

    localparam    CNT_NUM        =    DIV_NUM >> 1;// 100M/50 = 2M

    localparam    IDLE           =    3'b000,// 0    ->    wait start_en
                  SEND_START0    =    3'b001,// 1    ->    delay time : CNT_NUM * T
                  SEND_START1    =    3'b011,// 3    -> "clear cnt_clk" and "change spi_sclk"
                  SEND_BIT       =    3'b010,// 2    -> send MOSI
                  BIT_END        =    3'b110,// 6    -> "clear cnt_clk"
                  SPI_END        =    3'b101;// 5    ->  END



    ////////////////////////////////////////////    detect edge    /////////////////////////////////////////

    always@(posedge    sys_clk )
    begin
        spi_sclk_delay      <=         spi_sclk  ;
    end
    always@(posedge    sys_clk )
    begin
        spi_cs_delay        <=        spi_cs ;
    end

    assign        spi_sclk_rise        =    (~ spi_sclk_delay) & spi_sclk ;
    assign        spi_sclk_fall        =    (~ spi_sclk) & spi_sclk_delay ;
    assign        spi_cs_rise          =  spi_cs & (~ spi_cs_delay ) ;

    ////////////////////////////////////////////    state machine    /////////////////////////////////////////


    always@( posedge    sys_clk    or     negedge    rst_n )
    begin
        if(!rst_n)
            current_state                <=        IDLE;
        else
        begin
            case(current_state)
                IDLE    :
                begin                        //wait start_en
                    if(start_en)
                        current_state        <=        SEND_START0;
                    else
                        current_state        <=        IDLE;
                end
                SEND_START0 :
                begin
                    if(cnt_clk == CNT_NUM)//DELAY_TIME  (spi_sclk_rise)//the posedge of the spi_sclk
                        current_state        <=        SEND_START1;
                    else
                        current_state        <=        SEND_START0;
                end
                SEND_START1 :
                    current_state            <=        SEND_BIT; // "clear cnt_clk" and "change spi_sclk"
                SEND_BIT :
                begin                                    // send MOSI
                    if(cnt_bit == SPI_DATA)//8'd32
                        current_state        <=        BIT_END;
                    else
                        current_state        <=        SEND_BIT;
                end
                BIT_END    :
                    current_state            <=        SPI_END;
                SPI_END    :
                begin

                    if(cnt_clk == CNT_NUM)//DELAY_TIME 8'd10
                        current_state        <=        IDLE;
                    else
                        current_state        <=        SPI_END;
                end
                default        :
                    current_state            <=        IDLE;
            endcase
        end
    end
    ////////////////////////////////////////////    state machine    /////////////////////////////////////////

    always@(posedge sys_clk )//or negedge rst_n
    begin
        case(current_state)
            IDLE            :
            begin
                spi_cs        <=        1'b1;
                cnt_clk       <=        12'b0;
                cnt_bit       <=        8'b0;
                spi_sclk      <=        1'b1;
            end
            SEND_START0 :
            begin                        // delay time : DELAY_TIME * T
                spi_cs        <=        1'b0;
                cnt_clk       <=        cnt_clk + 1'b1;
            end
            SEND_START1 :
            begin                        // "clear cnt_clk" and "change spi_sclk"
                spi_sclk      <=        1'b0;
                cnt_clk       <=        12'b0;
            end
            SEND_BIT     :
            begin                         //  send MOSI
                if(cnt_clk    ==    CNT_NUM)
                begin
                    spi_sclk   <=        ~ spi_sclk;
                    cnt_clk    <=        12'b0;
                end
                else
                begin
                    spi_sclk   <=        spi_sclk;
                    cnt_clk    <=        cnt_clk    +    1'b1;
                end

                if(spi_sclk_rise)
                    cnt_bit    <=        cnt_bit    +    1'b1;
                else
                    cnt_bit    <=        cnt_bit;
            end
            BIT_END        :
                cnt_clk        <=        12'b0;
            SPI_END         :
                cnt_clk        <=        cnt_clk    +    1'b1;//spi_cs        <=        1'b1;
            default:
            begin
                spi_cs         <=        1'b1;
                cnt_clk        <=        12'b0;
                cnt_bit        <=        8'b0;
            end
        endcase
    end
    //////////////////////////////////////////    send the data to MOSI    /////////////////////////////////////////
    always@(posedge    sys_clk        or        negedge        rst_n)
    begin
        if(!rst_n)
            MOSI            <=        1'b1;
        else    if((!spi_cs) & spi_sclk_fall)
            MOSI            <=        mosi_data[SPI_DATA - cnt_bit - 1'b1];
        else
            MOSI            <=        MOSI;
    end

    //////////////////////////////////////////    receive the data from MISO    /////////////////////////////////////////

    always@(posedge    sys_clk        or        negedge        rst_n)
    begin
        if(!rst_n)
            dout_temp        <=     {SPI_DATA{1'd0}};
        else if((!spi_cs) &    spi_sclk_rise)
            dout_temp        <=     {dout_temp[SPI_DATA - 2 :0],MISO};
        else
            dout_temp        <=        dout_temp;
    end

    always@(posedge    sys_clk        )
    begin
        if(spi_cs)                            //save the final data
            miso_data        <=     dout_temp;
        else
            miso_data        <=        miso_data;
    end

endmodule
