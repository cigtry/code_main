`timescale 100ps/100ps

module DDR3_tb();

reg		clk_200M	= 1'b1;
always #25 begin
	clk_200M	<= ~clk_200M;
end

reg					rst_n;
wire				rst_busy;

//--------------------ddr3------------------------
wire		[63:0]	ddr3_dq;			//DQ，4片 x16 DDR的数据线

wire		[14:0]	ddr3_addr;			//Address
wire		[2:0]	ddr3_ba;			//Bank Address

wire		[7:0]	ddr3_dqs_p;			//DQ Select，0,2,4,6分别为四片DDR的DQSL(Lower Byte)，
wire		[7:0]	ddr3_dqs_n;			//1,3,5,7分别为四片DDR的DQSU(Upper Byte)
//Output with read data. Edge-aligned with read data.
//Input with write data. Center-aligned to write data.

wire		[0:0]	ddr3_ck_p;			//4片DR3共用ck、cke、odt、cs信号，故[0:0]
wire		[0:0]	ddr3_ck_n;
//differential clock inputs. All control and address input signals are sampled 
//on the crossing of the positive edge of CK and the negative edge of CK#

wire		[7:0]	ddr3_dm;			//Input Data Mask，0,2,4,6为DML，1,3,5,7为DMU
wire		[0:0]	ddr3_cke;			//Clock Enable
wire		[0:0]	ddr3_cs_n;			//Chip Select
wire				ddr3_ras_n;			//Row Address Enable
wire				ddr3_cas_n;			//Column Address Enable
wire				ddr3_we_n;			//Write Enable
wire		[0:0]	ddr3_odt;			//On-die termination enable
wire				ddr3_reset_n;

//-------------FPGA FIFO Control-------------------
reg					wr_en;				//高电平有效
reg			[63:0]	wrdat	= 64'd0;
wire				full;				//fifo_w full

reg					rd_en;				//高电平有效
wire		[63:0]	rddat;
wire				empty;				//fifo_r empty

//--------------------DDR3 Control-----------------------------------
DDR3_top DDR3_top_inst(
	.clk_200M				(clk_200M),
	.rst_n					(rst_n),
	.rst_busy				(rst_busy),

	//--------------------ddr3------------------------
	.ddr3_dq				(ddr3_dq),

	.ddr3_addr				(ddr3_addr),
	.ddr3_ba				(ddr3_ba),

	.ddr3_dqs_p				(ddr3_dqs_p),
	.ddr3_dqs_n				(ddr3_dqs_n),

	.ddr3_ck_p				(ddr3_ck_p),
	.ddr3_ck_n				(ddr3_ck_n),

	.ddr3_dm				(ddr3_dm),
	.ddr3_cke				(ddr3_cke),
	.ddr3_cs_n				(ddr3_cs_n),
	.ddr3_ras_n				(ddr3_ras_n),
	.ddr3_cas_n				(ddr3_cas_n),
	.ddr3_we_n				(ddr3_we_n),
	.ddr3_odt				(ddr3_odt),
	.ddr3_reset_n			(ddr3_reset_n),

	//-------------FPGA FIFO Control-------------------
	.wr_en					(wr_en),
	.wrdat					(wrdat),
	.full					(full),

	.rd_en					(rd_en),
	.rddat					(rddat),
	.empty					(empty)
);

//--------------------DDR3 Model-----------------------------------
ddr3_model ddr3_b1 (
	.rst_n		(ddr3_reset_n),
	.ck			(ddr3_ck_p),
	.ck_n		(ddr3_ck_n),
	.cke		(ddr3_cke),
	.cs_n		(ddr3_cs_n),
	.ras_n		(ddr3_ras_n),
	.cas_n		(ddr3_cas_n),
	.we_n		(ddr3_we_n),
	.dm_tdqs	(ddr3_dm[1:0]),
	.ba			(ddr3_ba),
	.addr		(ddr3_addr),
	.dq			(ddr3_dq[15:0]),
	.dqs		(ddr3_dqs_p[1:0]),
	.dqs_n		(ddr3_dqs_n[1:0]),
	.tdqs_n		(),
	.odt		(ddr3_odt)
);

ddr3_model ddr3_b2 (
	.rst_n		(ddr3_reset_n),
	.ck			(ddr3_ck_p),
	.ck_n		(ddr3_ck_n),
	.cke		(ddr3_cke),
	.cs_n		(ddr3_cs_n),
	.ras_n		(ddr3_ras_n),
	.cas_n		(ddr3_cas_n),
	.we_n		(ddr3_we_n),
	.dm_tdqs	(ddr3_dm[3:2]),
	.ba			(ddr3_ba),
	.addr		(ddr3_addr),
	.dq			(ddr3_dq[31:16]),
	.dqs		(ddr3_dqs_p[3:2]),
	.dqs_n		(ddr3_dqs_n[3:2]),
	.tdqs_n		(),
	.odt		(ddr3_odt)
);

ddr3_model ddr3_b3 (
	.rst_n		(ddr3_reset_n),
	.ck			(ddr3_ck_p),
	.ck_n		(ddr3_ck_n),
	.cke		(ddr3_cke),
	.cs_n		(ddr3_cs_n),
	.ras_n		(ddr3_ras_n),
	.cas_n		(ddr3_cas_n),
	.we_n		(ddr3_we_n),
	.dm_tdqs	(ddr3_dm[5:4]),
	.ba			(ddr3_ba),
	.addr		(ddr3_addr),
	.dq			(ddr3_dq[47:32]),
	.dqs		(ddr3_dqs_p[5:4]),
	.dqs_n		(ddr3_dqs_n[5:4]),
	.tdqs_n		(),
	.odt		(ddr3_odt)
);

ddr3_model ddr3_b4 (
	.rst_n		(ddr3_reset_n),
	.ck			(ddr3_ck_p),
	.ck_n		(ddr3_ck_n),
	.cke		(ddr3_cke),
	.cs_n		(ddr3_cs_n),
	.ras_n		(ddr3_ras_n),
	.cas_n		(ddr3_cas_n),
	.we_n		(ddr3_we_n),
	.dm_tdqs	(ddr3_dm[7:6]),
	.ba			(ddr3_ba),
	.addr		(ddr3_addr),
	.dq			(ddr3_dq[63:48]),
	.dqs		(ddr3_dqs_p[7:6]),
	.dqs_n		(ddr3_dqs_n[7:6]),
	.tdqs_n		(),
	.odt		(ddr3_odt)
);

//--------------------wrdat, rddat-----------------------------------
always @(posedge clk_200M) begin
	if(wr_en) begin
		wrdat	<= wrdat + 1'b1;
	end
	else begin
		wrdat	<= wrdat;
	end
end

//-----------------------tb----------------------------------------
initial begin
	wr_en	<= 1'b0;
	rd_en	<= 1'b0;

	rst_n	<= 1'b1;
	#100;
	rst_n	<= 1'b0;
	#100;
	rst_n	<= 1'b1;

	wait(~rst_busy);
	#200;

	fork 
		begin: w_r
			write(16);
			#100;

			write(16);
			#100;

			write(16);
			#100;

			// #10000;
			read(16);
			#100;

			write(16);
			#100;

			read(64);

			#2000;
			disable shut_down;
			$stop;
		end

		begin: shut_down
			#100000;
			disable w_r;
			$stop;
		end
	join
end

task write;
	input	[7:0]	num;

	integer 		i;
	begin
		for(i=0; i<num; i=i) begin
			wait(clk_200M);
			if(~full) begin
				wr_en	<= 1'b1;
				i		<= i+1;
			end
			else begin
				wr_en	<= 1'b0;
			end
			wait(~clk_200M);
		end
		wait(clk_200M);
		wr_en	<= 1'b0;
	end
endtask

task read;
	input	[7:0]	num;

	integer			i;
	begin
		for(i=0; i<num; i=i) begin
			wait(clk_200M);
			if(~empty) begin
				rd_en	<= 1'b1;
				i		<= i+1;
			end
			else begin
				rd_en	<= 1'b0;
			end
			wait(~clk_200M);
		end
		wait(clk_200M);
		rd_en	<= 1'b0;
	end
endtask

endmodule
