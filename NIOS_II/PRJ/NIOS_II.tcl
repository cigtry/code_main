# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: NIOS_II.tcl
# Generated on: Mon Jul 15 11:00:49 2024

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "NIOS_II"]} {
		puts "Project NIOS_II is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists NIOS_II]} {
		project_open -revision NIOS_II NIOS_II
	} else {
		project_new -revision NIOS_II NIOS_II
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CSEMA5F31C8
	set_global_assignment -name TOP_LEVEL_ENTITY NIOS_II_top
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 18.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "09:33:10  JUNE 17, 2024"
	set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Standard Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name ENABLE_OCT_DONE OFF
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
	set_global_assignment -name ENABLE_SIGNALTAP ON
	set_global_assignment -name USE_SIGNALTAP_FILE stp1.stp
	set_global_assignment -name SLD_NODE_CREATOR_ID 110 -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_ENTITY_NAME sld_signaltap -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_BLOCK_TYPE=AUTO" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_NODE_INFO=805334528" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_POWER_UP_TRIGGER=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SEGMENT_SIZE=1024" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ATTRIBUTE_MEM_MODE=OFF" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_FLOW_USE_GENERATED=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_BITS=11" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_BUFFER_FULL_STOP=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_CURRENT_RESOURCE_WIDTH=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INCREMENTAL_ROUTING=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SAMPLE_DEPTH=1024" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_IN_ENABLED=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_COUNTER_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ADVANCED_TRIGGER_ENTITY=basic,1," -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL_PIPELINE=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ENABLE_ADVANCED_TRIGGER=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_DATA_BITS=218" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_BITS=218" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_BITS=218" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK=000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK_LENGTH=678" -section_id auto_signaltap_0
	set_global_assignment -name SLD_FILE db/stp1_auto_stripped.stp
	set_global_assignment -name QSYS_FILE ../QSYS/HARDWARE/nios_ii.qsys
	set_global_assignment -name SDC_FILE NIOS_II.out.sdc
	set_global_assignment -name VERILOG_FILE ../RTL/motor_reg.v
	set_global_assignment -name VERILOG_FILE ../RTL/motor_ctrl_top.v
	set_global_assignment -name VERILOG_FILE ../RTL/motor_arbit.v
	set_global_assignment -name VERILOG_FILE ../RTL/gen_step_pluse.v
	set_global_assignment -name VERILOG_FILE ../RTL/clk_generate.v
	set_global_assignment -name VERILOG_FILE ../RTL/cb_io_filter.v
	set_global_assignment -name VERILOG_FILE ../RTL/cb_filter_app.v
	set_global_assignment -name VERILOG_FILE ../RTL/reset_sig.v
	set_global_assignment -name VERILOG_FILE ../RTL/NIOS_II_top.v
	set_global_assignment -name QIP_FILE IP/pll.qip
	set_global_assignment -name SIGNALTAP_FILE stp1.stp
	set_location_assignment PIN_K14 -to clk
	set_location_assignment PIN_AJ6 -to rxd
	set_location_assignment PIN_AG12 -to txd
	set_location_assignment PIN_F11 -to dirction
	set_location_assignment PIN_K12 -to step
	set_location_assignment PIN_G10 -to coe_enable
	set_location_assignment PIN_AH8 -to limit_signal
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to coe_enable
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dirction
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to limit_signal
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rxd
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to step
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to txd
	set_location_assignment PIN_G13 -to tmc_clk
	set_location_assignment PIN_H15 -to tmc_miso
	set_location_assignment PIN_H13 -to tmc_mosi
	set_location_assignment PIN_G7 -to tmc_cs
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tmc_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tmc_cs
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tmc_miso
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tmc_mosi
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_clk -to "pll:inst_pll|outclk_0" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[8] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[13] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[23] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[25] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[27] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[29] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[31] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[0] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|busy" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[0] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|busy" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[4] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[6] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[7] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[9] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[10] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[11] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[21] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[1] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|clear" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[2] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[3] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[4] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[5] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[6] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[7] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[8] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[9] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[10] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[11] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[12] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[13] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[14] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[15] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[16] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[17] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[18] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[19] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[20] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[21] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[22] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[23] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[24] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[25] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[26] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[27] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[28] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[29] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[30] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[31] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[32] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[33] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[34] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[35] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[36] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[37] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|encoder_sginal" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[38] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|encoder_sginal_d" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[39] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|pos_encoser_signal" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[40] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[41] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[42] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[43] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[44] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[45] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[46] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[47] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[48] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[49] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[50] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[51] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[52] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[53] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[54] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[55] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[56] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[57] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[58] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[59] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[60] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[61] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[62] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[63] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[64] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[65] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[66] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[67] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[68] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[69] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[70] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[71] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[72] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[73] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[74] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[75] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[76] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[77] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[78] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[79] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[80] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[81] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[82] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[83] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[84] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[85] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[86] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[87] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[88] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[89] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[90] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[91] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[92] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[93] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[94] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[95] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[96] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[97] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[98] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[99] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[100] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[101] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[102] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[103] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[104] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[105] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[106] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[107] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[108] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[109] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[110] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[111] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[112] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[113] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[114] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[115] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[116] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[117] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[118] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[119] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[120] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[121] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[122] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[123] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[124] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[125] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[126] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[127] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[128] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[129] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[130] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[131] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[132] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[133] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[134] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[135] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[136] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[137] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[138] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[139] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[140] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[141] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[142] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[143] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[144] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[145] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[146] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[147] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[148] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[149] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[150] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[151] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[152] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[153] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[154] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[155] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[156] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[157] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[158] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[159] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[160] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[161] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[162] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[163] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[164] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[165] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[166] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[167] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[168] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[169] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[170] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[171] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[172] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[173] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[174] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[175] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[176] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[177] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[178] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[179] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[180] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[181] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[182] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[183] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[184] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[185] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[186] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[187] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[188] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[189] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[190] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[191] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[192] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[193] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[194] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[195] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[196] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[197] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[198] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[199] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[200] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[201] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[202] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[203] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[204] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[205] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[206] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[207] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[208] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[209] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[210] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[211] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[212] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[213] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[214] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[215] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[216] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[217] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[1] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|clear" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[2] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[3] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[4] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[5] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[6] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[7] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[8] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[9] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[10] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[11] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ms[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[12] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[13] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[14] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[15] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[16] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[17] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[18] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[19] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[20] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[21] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[22] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[23] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[24] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[25] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[26] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[27] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[28] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_ns[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[29] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[30] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[31] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[32] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[33] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[34] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[35] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[36] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|cnt_over_time[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[37] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|encoder_sginal" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[38] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|encoder_sginal_d" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[39] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|pos_encoser_signal" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[40] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[41] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[42] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[43] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[44] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[45] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[46] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[47] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[48] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[49] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[50] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[51] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[52] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[53] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[54] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[55] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[56] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[57] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[58] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[59] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[60] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[61] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[62] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[63] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[64] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[65] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[66] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[67] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[68] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[69] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[70] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[71] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|speed[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[72] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[73] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[74] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[75] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[76] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[77] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[78] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[79] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[80] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[81] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[82] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[83] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[84] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[85] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[86] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[87] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[88] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[89] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[90] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[91] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[92] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[93] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[94] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[95] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[96] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[97] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[98] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[99] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[100] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[101] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[102] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[103] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[104] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[105] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[106] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[107] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[108] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[109] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[110] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[111] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[112] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[113] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[114] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[115] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[116] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[117] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[118] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[119] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[120] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[121] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[122] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[123] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[124] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[125] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[126] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[127] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[128] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[129] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[130] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[131] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[132] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[133] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[134] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[135] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[136] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[137] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[138] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[139] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[140] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[141] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[142] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[143] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[144] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[145] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[146] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[147] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[148] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[20]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[149] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[21]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[150] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[22]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[151] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[23]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[152] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[24]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[153] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[25]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[154] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[26]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[155] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[27]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[156] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[28]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[157] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[29]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[158] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[159] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[30]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[160] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[31]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[161] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[162] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[163] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[164] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[165] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[166] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[167] -to "nios_ii:u_nios_ii|encoder_top:encoder_0|encoder:u_encoder|step_record_d[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[168] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[169] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[170] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[171] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[172] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|move_mode[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[173] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[174] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[175] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[176] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[177] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[178] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[179] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[180] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[181] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[182] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[183] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[184] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[185] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[186] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[187] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[188] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[189] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[190] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[191] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[192] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_s[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[193] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[194] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[10]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[195] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[11]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[196] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[12]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[197] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[13]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[198] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[14]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[199] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[15]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[200] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[16]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[201] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[17]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[202] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[18]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[203] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[19]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[204] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[205] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[206] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[207] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[4]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[208] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[5]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[209] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[6]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[210] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[7]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[211] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[8]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[212] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|mt_current_v[9]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[213] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[0]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[214] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[1]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[215] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[2]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[216] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[3]" -section_id auto_signaltap_0
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[217] -to "nios_ii:u_nios_ii|motor_ctrl_top:motor_ctrl_0|motor_arbit:u_motor_arbit|state_c[4]" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[0] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[1] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[2] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[3] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[5] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[12] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[14] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[15] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[16] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[17] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[18] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[19] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[20] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[22] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[24] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[26] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[28] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[30] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Including default assignments
	set_global_assignment -name REVISION_TYPE BASE -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS OFF -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone V"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 30 -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "Cyclone V"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "Cyclone V"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "Cyclone V"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 3 -family "Cyclone V"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "Cyclone V"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "Cyclone V"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "Cyclone V"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "Cyclone V"
	set_global_assignment -name ADVANCED_PHYSICAL_OPTIMIZATION ON -family "Cyclone V"

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
