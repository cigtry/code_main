/////////////////////////////////////////////////////////////////////////////////
// Company       : 武汉芯路恒科技有限公司
//                 http://xiaomeige.taobao.com
// Web           : http://www.corecourse.cn
// 
// Create Date   : 2019/05/01 00:00:00
// Module Name   : camera_init
// Description   : 摄像头初始化驱动模块
// 
// Dependencies  : 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////////

module camera_init #(
  parameter CAMERA_TYPE     = "ov2640", //"ov2640" or "ov7725"
  parameter IMAGE_TYPE      = 0,        //0:RGB 1:JPEG
  parameter IMAGE_WIDTH     = 640,
  parameter IMAGE_HEIGHT    = 480,
  parameter IMAGE_FLIP_EN   = 0,
  parameter IMAGE_MIRROR_EN = 0
)
(
  input      Clk,
  input      Rst_n,

  output reg Init_Done,
  output     camera_rst_n,
  output     camera_pwdn,

  output     i2c_sclk,
  inout      i2c_sdat
);
  localparam RGB = 0;
  localparam JPEG = 1;

  wire [15:0]addr;
  reg wrreg_req;
  reg rdreg_req;
  wire [7:0]wrdata;
  wire [7:0]rddata;
  wire RW_Done;
  wire ack;
  reg [31:0] i2c_dly_cnt_max;

  reg [7:0]cnt;
  wire [23:0]lut;

  wire [7:0]lut_size;
  wire [7:0]device_id;
  wire addr_mode;

  assign camera_pwdn = 0;

  generate
  ////////////////////////////ov5640///////////////////////////////
  if(CAMERA_TYPE == "ov2640")
  begin
    assign device_id = 8'h60;
    assign addr_mode = 1'b0;
    assign addr = {8'd0, lut[15:8]};
    assign wrdata = lut[7:0];

    if(IMAGE_TYPE == RGB) //------RGB------
    begin
      assign lut_size = 185;

      ov2640_init_table_rgb #(
        .IMAGE_WIDTH     (IMAGE_WIDTH     ),
        .IMAGE_HEIGHT    (IMAGE_HEIGHT    ),
        .IMAGE_FLIP_EN   (IMAGE_FLIP_EN   ),
        .IMAGE_MIRROR_EN (IMAGE_MIRROR_EN )
      )ov2640_init_table_rgb_inst
      (
        .addr (cnt ),
        .clk  (Clk ),
        .q    (lut )
      );
    end
    else  //------JPEG------
    begin
      assign lut_size = 250;

      ov5640_init_table_jpeg #(
        .IMAGE_WIDTH     (IMAGE_WIDTH     ),
        .IMAGE_HEIGHT    (IMAGE_HEIGHT    ),
        .IMAGE_FLIP_EN   (IMAGE_FLIP_EN   ),
        .IMAGE_MIRROR_EN (IMAGE_MIRROR_EN )
      )ov5640_init_table_jpeg_inst
      (
        .addr (cnt ),
        .clk  (Clk ),
        .q    (lut )
      );
    end
  end
  ////////////////////////////ov7725////////////////////////////////
  else if(CAMERA_TYPE == "ov7725")
  begin
    assign device_id = 8'h42;
    assign addr_mode = 1'b0;
    assign addr = lut[15:8];
    assign wrdata = lut[7:0];

    if(IMAGE_TYPE == RGB) //------RGB------
    begin
      assign lut_size  = 68;

      ov7725_init_table_rgb #(
        .IMAGE_WIDTH     (IMAGE_WIDTH     ),
        .IMAGE_HEIGHT    (IMAGE_HEIGHT    ),
        .IMAGE_FLIP_EN   (IMAGE_FLIP_EN   ),
        .IMAGE_MIRROR_EN (IMAGE_MIRROR_EN )
      )ov7725_init_table_rgb_inst
      (
        .addr (cnt ),
        .clk  (Clk ),
        .q    (lut )
      );
    end
  end
  endgenerate


  i2c_control i2c_control(
    .Clk         (Clk             ),
    .Rst_n       (Rst_n           ),
    .wrreg_req   (wrreg_req       ),
    .rdreg_req   (0               ),
    .addr        (addr            ),
    .addr_mode   (addr_mode       ),
    .wrdata      (wrdata          ),
    .rddata      (rddata          ),
    .device_id   (device_id       ),
    .RW_Done     (RW_Done         ),
    .ack         (ack             ),
    .dly_cnt_max (i2c_dly_cnt_max ),
    .i2c_sclk    (i2c_sclk        ),
    .i2c_sdat    (i2c_sdat        )
  );

  wire Go;   //initial enable
	reg [19:0] delay_cnt;
	always @ (posedge Clk or negedge Rst_n)
	if (!Rst_n)
		delay_cnt <= 20'd0;
	else if (delay_cnt == 20'hfffff)
		delay_cnt <= delay_cnt;
	else
		delay_cnt <= delay_cnt + 10'd1;
	
	assign Go = (delay_cnt == 20'hffffe) ? 1'b1 : 1'b0;
	assign camera_rst_n = (delay_cnt > 20'd10000);

  always@(posedge Clk or negedge Rst_n)
  if(~Rst_n)
    cnt <= 0;
  else if(Go) 
    cnt <= 0;
  else if(cnt < lut_size)begin
    if(RW_Done && (!ack))
      cnt <= cnt + 1'b1;
    else
      cnt <= cnt;
  end
  else
    cnt <= 0;

  always@(posedge Clk or negedge Rst_n)
  if(~Rst_n)
    Init_Done <= 0;
  else if(Go) 
    Init_Done <= 0;
  else if(cnt == lut_size)
    Init_Done <= 1;

  reg [1:0]state;

  always@(posedge Clk or negedge Rst_n)
  if(~Rst_n)begin
    state <= 0;
    wrreg_req <= 1'b0;
    i2c_dly_cnt_max <= 32'd0;
  end
  else if(cnt < lut_size)begin
    case(state)
      0:
        if(Go)
          state <= 1;
        else
          state <= 0;
      1:
        begin
          wrreg_req <= 1'b1;
          state <= 2;
          if(cnt == 1)
            i2c_dly_cnt_max <= 32'h40000; //延时5ms
          else
            i2c_dly_cnt_max <= 32'd0;
        end
      2:
        begin
          wrreg_req <= 1'b0;
          if(RW_Done)
            state <= 1;
          else
            state <= 2;
        end
      default:state <= 0;
    endcase
  end
  else
    state <= 0;

endmodule
