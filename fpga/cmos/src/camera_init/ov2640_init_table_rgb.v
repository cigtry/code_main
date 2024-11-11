/////////////////////////////////////////////////////////////////////////////////
// Company       : 武汉芯路恒科技有限公司
//                 http://xiaomeige.taobao.com
// Web           : http://www.corecourse.cn
// 
// Create Date   : 2022/08/16 00:00:00
// Module Name   : ov2640_init_table_rgb
// Description   : OV2640初始化寄存器表(RGB模式专用)
// 
// Dependencies  : 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////////

module ov2640_init_table_rgb #(
  parameter DATA_WIDTH      = 16,
  parameter ADDR_WIDTH      = 8,
  parameter IMAGE_WIDTH     = 16'd640,
  parameter IMAGE_HEIGHT    = 16'd480,
  parameter IMAGE_FLIP_EN   = 1'b0,
  parameter IMAGE_MIRROR_EN = 1'b0
)
(
  clk,
  addr,
  q
);
  input clk;
  input [(ADDR_WIDTH-1):0] addr;
  output reg [(DATA_WIDTH-1):0] q;

  // Declare the ROM variable
  reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
 
  	initial begin
                rom[0] = 16'hff01;
			    rom[1] = 16'h1280;
    			rom[2] = 16'hff00;//选中DSP Address
    			rom[3] = 16'h2cff;
    			rom[4] = 16'h2edf;
    			rom[5] = 16'hff01;
    			rom[6] = 16'h3c32;
    			//
    			rom[7] = 16'h1100;
    			rom[8] = 16'h0902;
//     			rom[9] = 16'h04d8;//水平镜像,垂直翻转   			
    			rom[9] = {8'h04,{IMAGE_MIRROR_EN,IMAGE_FLIP_EN,1'b0,1'b1},4'h8};//水平镜像,垂直翻转
    			rom[10] = 16'h13e5;
    			rom[11] = 16'h1448;
    			rom[12] = 16'h2c0c;
    			rom[13] = 16'h3378;
    			rom[14] = 16'h3a33;
    			rom[15] = 16'h3bfB;
    			//
    			rom[16] = 16'h3e00;
    			rom[17] = 16'h4311;
    			rom[18] = 16'h1610;
    			//
    			rom[19] = 16'h3992;
    			//
    			rom[20] = 16'h35da;
    			rom[21] = 16'h221a;
    			rom[22] = 16'h37c3;
    			rom[23] = 16'h2300;
    			rom[24] = 16'h34c0;
    			rom[25] = 16'h361a;
    			rom[26] = 16'h0688;
    			rom[27] = 16'h07c0;
    			rom[28] = 16'h0d87;
    			rom[29] = 16'h0e41;
    			rom[30] = 16'h4c00;
    			rom[31] = 16'h4800;
    			rom[32] = 16'h5B00;
    			rom[33] = 16'h4203;
    			//
    			rom[34] = 16'h4a81;
    			rom[35] = 16'h2199;
    			//
    			rom[36] = 16'h2440;
    			rom[37] = 16'h2538;
    			rom[38] = 16'h2682;
    			rom[39] = 16'h5c00;
    			rom[40] = 16'h6300;
    			rom[41] = 16'h4622;
    			rom[42] = 16'h0c3c;
    			//
    			rom[43] = 16'h6170;
    			rom[44] = 16'h6280;
    			rom[45] = 16'h7c05;
    			//
    			rom[46] = 16'h2080;
    			rom[47] = 16'h2830;
    			rom[48] = 16'h6c00;
    			rom[49] = 16'h6d80;
    			rom[50] = 16'h6e00;
    			rom[51] = 16'h7002;
    			rom[52] = 16'h7194;
    			rom[53] = 16'h73c1;
    			rom[54] = 16'h3d34;
    			rom[55] = 16'h5a57;
    			//根据分辨率不同而设置
    			rom[56] = 16'h1240;//SVGA 800*600
    			rom[57] = 16'h1711;//传感器窗口设置
    			rom[58] = 16'h1843;//传感器窗口设置
    			rom[59] = 16'h1900;//传感器窗口设置
    			rom[60] = 16'h1a4b;//传感器窗口设置
    			rom[61] = 16'h3209;
    			rom[62] = 16'h37c0;
    			//
    			rom[63] = 16'h4fca;
    			rom[64] = 16'h50a8;
    			rom[65] = 16'h5a23;
    			rom[66] = 16'h6d00;
    			rom[67] = 16'h3d38;
    			//
    			rom[68] = 16'hff00;
    			rom[69] = 16'he57f;
    			rom[70] = 16'hf9c0;
    			rom[71] = 16'h4124;
    			rom[72] = 16'he014;
    			rom[73] = 16'h76ff;
    			rom[74] = 16'h33a0;
    			rom[75] = 16'h4220;
    			rom[76] = 16'h4318;
    			rom[77] = 16'h4c00;
    			rom[78] = 16'h87d5;
    			rom[79] = 16'h883f;
    			rom[80] = 16'hd703;
    			rom[81] = 16'hd910;
    			rom[82] = 16'hd382;
    			//
    			rom[83] = 16'hc808;
    			rom[84] = 16'hc980;
    			//
    			rom[85] = 16'h7c00;
    			rom[86] = 16'h7d00;
    			rom[87] = 16'h7c03;
    			rom[88] = 16'h7d48;
    			rom[89] = 16'h7d48;
    			rom[90] = 16'h7c08;
    			rom[91] = 16'h7d20;
    			rom[92] = 16'h7d10;
    			rom[93] = 16'h7d0e;
    			//
    			rom[94] = 16'h9000;
    			rom[95] = 16'h910e;
    			rom[96] = 16'h911a;
    			rom[97] = 16'h9131;
    			rom[98] = 16'h915a;
    			rom[99] = 16'h9169;
    			rom[100] = 16'h9175;
    			rom[101] = 16'h917e;
    			rom[102] = 16'h9188;
    			rom[103] = 16'h918f;
    			rom[104] = 16'h9196;
    			rom[105] = 16'h91a3;
    			rom[106] = 16'h91af;
    			rom[107] = 16'h91c4;
    			rom[108] = 16'h91d7;
    			rom[109] = 16'h91e8;
    			rom[110] = 16'h9120;
    			//
    			rom[111] = 16'h9200;
    			rom[112] = 16'h9306;
    			rom[113] = 16'h93e3;
    			rom[114] = 16'h9305;
    			rom[115] = 16'h9305;
    			rom[116] = 16'h9300;
    			rom[117] = 16'h9304;
    			rom[118] = 16'h9300;
    			rom[119] = 16'h9300;
    			rom[120] = 16'h9300;
    			rom[121] = 16'h9300;
    			rom[122] = 16'h9300;
    			rom[123] = 16'h9300;
    			rom[124] = 16'h9300;
    			//
    			rom[125] = 16'h9600;
    			rom[126] = 16'h9708;
    			rom[127] = 16'h9719;
    			rom[128] = 16'h9702;
    			rom[129] = 16'h970c;
    			rom[130] = 16'h9724;
    			rom[131] = 16'h9730;
    			rom[132] = 16'h9728;
    			rom[133] = 16'h9726;
    			rom[134] = 16'h9702;
    			rom[135] = 16'h9798;
    			rom[136] = 16'h9780;
    			rom[137] = 16'h9700;
    			rom[138] = 16'h9700;
    			//
    			rom[139] = 16'hc3ed;
    			rom[140] = 16'ha400;
    			rom[141] = 16'ha800;
    			rom[142] = 16'hc511;
    			rom[143] = 16'hc651;
    			rom[144] = 16'hbf80;
    			rom[145] = 16'hc710;
    			rom[146] = 16'hb666;
    			rom[147] = 16'hb8A5;
    			rom[148] = 16'hb764;
    			rom[149] = 16'hb97C;
    			rom[150] = 16'hb3af;
    			rom[151] = 16'hb497;
    			rom[152] = 16'hb5FF;
    			rom[153] = 16'hb0C5;
    			rom[154] = 16'hb194;
    			rom[155] = 16'hb20f;
    			rom[156] = 16'hc45c;
    			//根据分辨率不同而设置
    			rom[157] = 16'hc064;//图像尺寸设置 //800 = 100(0x64) * 8
    			//SCCB_Write(= 0x1_4B;//图像尺寸设置 //600 = 75(0x4B) * 8 //3C
    			rom[158] = 16'hc14B;//图像尺寸设置 //600 = 75(0x4B) * 8 //3C
    			rom[159] = 16'h8c00;//图像尺寸设置
    			rom[160] = 16'h863D;
    			rom[161] = 16'h5000;
    			rom[162] = 16'h51C8;//图像窗口设置
    			rom[163] = 16'h5296;//图像窗口设置
    			rom[164] = 16'h5300;//图像窗口设置
    			rom[165] = 16'h5400;//图像窗口设置
    			rom[166] = 16'h5500;//图像窗口设置
    			rom[167] = 16'h5aC8;
    			rom[168] = 16'h5b96;
    			rom[169] = 16'h5c00;
    	       //
    			rom[170] = 16'hd382;//auto设置要小心   82
    			//
    			rom[171] = 16'hc3ed;
    			rom[172] = 16'h7f00;

    			rom[173] = 16'hda08;//08

    			rom[174] = 16'hc20e;
    			rom[175] = 16'he51f;
    			rom[176] = 16'he167;
    			rom[177] = 16'he000;
    			rom[178] = 16'hdd7f;
    			rom[179] = 16'h0500;



    			rom[180] = 16'hFF00;
				rom[181] = 16'hD703;
			    rom[182] = 16'hDF02;
				rom[183] = 16'h33a0;
			    rom[184] = 16'h3C00;
				rom[185] = 16'he167;
	end
   
  always @ (posedge clk)
  begin
    q <= rom[addr];
  end

endmodule
