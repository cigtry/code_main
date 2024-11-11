
module key_debounce(
    input        sys_clk ,
    input        sys_rst_n ,

    input        key ,         //外部输入的按键值
    output  reg  key_value ,   //消抖后的按键值
    output  reg  key_flag      //消抖后的按键值的效标志
);

//reg define
reg [19:0] cnt ;
reg        key_reg ;

//*****************************************************
//**                    main code
//*****************************************************

//按键值消抖
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt <= 20'd0;
        key_reg <= 1'b1;
    end
    else begin
        key_reg <= key;           //将按键值延迟一拍
        if(key_reg != key) begin  //如果当前按键值和前一拍的按键值不一样，即按键被按下或松开
            cnt <= 20'd100_000;  //则将计数器置为20'd100_0000，
                                  //即延时100_0000 * 20ns(1s/50MHz) = 20ms
        end
        else begin                //如果当前按键值和前一个按键值一样，即按键没有发生变化
            if(cnt > 20'd0)       //则计数器递减到0
                cnt <= cnt - 1'b1;  
            else
                cnt <= 20'd0;
        end
    end
end

//将消抖后的最终的按键值送出去
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_value <= 1'b0;
        key_flag  <= 1'b0;
    end
	//在计数器递减到1时送出按键值
    else if(cnt == 20'd1) begin
		key_value <= key;
		key_flag  <= 1'b1;
        end
    else begin
		key_value <= key_value;
		key_flag  <= 1'b0;
    end
end

endmodule
