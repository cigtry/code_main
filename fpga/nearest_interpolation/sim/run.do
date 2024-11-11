file copy -force ../../../../modelsim.ini modelsim.ini

vlib xil_defaultlib
vmap xil_defaultlib xil_defaultlib

vlog -sv -incr -work xil_defaultlib \
"../testbench.sv" \

vlog -incr +cover -work xil_defaultlib \
-f "../design_ver.f" \

if ![file isdirectory test_iputf_libs] {
	file mkdir test_iputf_libs
}

if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}
vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/twentynm_ver
vmap twentynm_ver ./verilog_libs/twentynm_ver
vlog -vlog01compat -work twentynm_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/twentynm_atoms.v}
vlog -vlog01compat -work twentynm_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v}

vlib verilog_libs/twentynm_hssi_ver
vmap twentynm_hssi_ver ./verilog_libs/twentynm_hssi_ver
vlog -vlog01compat -work twentynm_hssi_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work twentynm_hssi_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/twentynm_hssi_atoms.v}

vlib verilog_libs/twentynm_hip_ver
vmap twentynm_hip_ver ./verilog_libs/twentynm_hip_ver
vlog -vlog01compat -work twentynm_hip_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v}
vlog -vlog01compat -work twentynm_hip_ver {D:/software/intelFPGA/18.1/quartus/eda/sim_lib/twentynm_hip_atoms.v}

# 不使用任何器件库
#vsim -voptargs="+acc" -t ps -quiet -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.testbench 

# 使用altera器件库，通过-L添加对应的器件库，例如：
 vsim -voptargs="+acc" -t ps -quiet -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver  -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.testbench 

# 使用xilinx器件库，编译glbl.v并通过-L添加对应的器件库，例如：
 # vlog -work xil_defaultlib "../../../glbl.v"
 # vsim -voptargs="+acc" -t ps -coverage -L xil_defaultlib -L blk_mem_gen_v8_4_1 -L axi_mmu_v2_1_15 -L axi_clock_converter_v2_1_16 -L axi_register_slice_v2_1_17 -L axi_crossbar_v2_1_18 -L generic_baseblocks_v2_1_0 -L axi_data_fifo_v2_1_16 -L fifo_generator_v13_2_2 -L axi_infrastructure_v1_1_0 -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.testbench xil_defaultlib.glbl


add wave *
log -r /*
run 20ms
