# qsys scripting (.tcl) file for nios_ii
package require -exact qsys 16.0

create_system {nios_ii}

set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE {5CSEMA5F31C8}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk clock_source 18.1
set_instance_parameter_value clk {clockFrequency} {100000000.0}
set_instance_parameter_value clk {clockFrequencyKnown} {1}
set_instance_parameter_value clk {resetSynchronousEdges} {NONE}

add_instance encoder_0 encoder 1.0

add_instance jtag_uart altera_avalon_jtag_uart 18.1
set_instance_parameter_value jtag_uart {allowMultipleConnections} {0}
set_instance_parameter_value jtag_uart {hubInstanceID} {0}
set_instance_parameter_value jtag_uart {readBufferDepth} {64}
set_instance_parameter_value jtag_uart {readIRQThreshold} {8}
set_instance_parameter_value jtag_uart {simInputCharacterStream} {}
set_instance_parameter_value jtag_uart {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
set_instance_parameter_value jtag_uart {useRegistersForReadBuffer} {0}
set_instance_parameter_value jtag_uart {useRegistersForWriteBuffer} {0}
set_instance_parameter_value jtag_uart {useRelativePathForSimFile} {0}
set_instance_parameter_value jtag_uart {writeBufferDepth} {64}
set_instance_parameter_value jtag_uart {writeIRQThreshold} {8}

add_instance motor_Ctrl_0 motor_Ctrl 1.0
set_instance_parameter_value motor_Ctrl_0 {BIT_A} {20}
set_instance_parameter_value motor_Ctrl_0 {BIT_S} {20}
set_instance_parameter_value motor_Ctrl_0 {BIT_V} {20}
set_instance_parameter_value motor_Ctrl_0 {OPT_LONG} {1000}
set_instance_parameter_value motor_Ctrl_0 {QUIT_LONG} {200}
set_instance_parameter_value motor_Ctrl_0 {S_MODE} {1}

add_instance nios2_qsys altera_nios2_gen2 18.1
set_instance_parameter_value nios2_qsys {bht_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {breakOffset} {32}
set_instance_parameter_value nios2_qsys {breakSlave} {None}
set_instance_parameter_value nios2_qsys {cdx_enabled} {0}
set_instance_parameter_value nios2_qsys {cpuArchRev} {1}
set_instance_parameter_value nios2_qsys {cpuID} {0}
set_instance_parameter_value nios2_qsys {cpuReset} {0}
set_instance_parameter_value nios2_qsys {data_master_high_performance_paddr_base} {0}
set_instance_parameter_value nios2_qsys {data_master_high_performance_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {data_master_paddr_base} {0}
set_instance_parameter_value nios2_qsys {data_master_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {dcache_bursts} {false}
set_instance_parameter_value nios2_qsys {dcache_numTCDM} {0}
set_instance_parameter_value nios2_qsys {dcache_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {dcache_size} {2048}
set_instance_parameter_value nios2_qsys {dcache_tagramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {dcache_victim_buf_impl} {ram}
set_instance_parameter_value nios2_qsys {debug_OCIOnchipTrace} {_128}
set_instance_parameter_value nios2_qsys {debug_assignJtagInstanceID} {0}
set_instance_parameter_value nios2_qsys {debug_datatrigger} {0}
set_instance_parameter_value nios2_qsys {debug_debugReqSignals} {0}
set_instance_parameter_value nios2_qsys {debug_enabled} {1}
set_instance_parameter_value nios2_qsys {debug_hwbreakpoint} {0}
set_instance_parameter_value nios2_qsys {debug_jtagInstanceID} {0}
set_instance_parameter_value nios2_qsys {debug_traceStorage} {onchip_trace}
set_instance_parameter_value nios2_qsys {debug_traceType} {none}
set_instance_parameter_value nios2_qsys {debug_triggerArming} {1}
set_instance_parameter_value nios2_qsys {dividerType} {no_div}
set_instance_parameter_value nios2_qsys {exceptionOffset} {32}
set_instance_parameter_value nios2_qsys {exceptionSlave} {onchip_ram.s1}
set_instance_parameter_value nios2_qsys {fa_cache_line} {2}
set_instance_parameter_value nios2_qsys {fa_cache_linesize} {0}
set_instance_parameter_value nios2_qsys {flash_instruction_master_paddr_base} {0}
set_instance_parameter_value nios2_qsys {flash_instruction_master_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {icache_burstType} {None}
set_instance_parameter_value nios2_qsys {icache_numTCIM} {0}
set_instance_parameter_value nios2_qsys {icache_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {icache_size} {4096}
set_instance_parameter_value nios2_qsys {icache_tagramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {impl} {Fast}
set_instance_parameter_value nios2_qsys {instruction_master_high_performance_paddr_base} {0}
set_instance_parameter_value nios2_qsys {instruction_master_high_performance_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {instruction_master_paddr_base} {0}
set_instance_parameter_value nios2_qsys {instruction_master_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {io_regionbase} {0}
set_instance_parameter_value nios2_qsys {io_regionsize} {0}
set_instance_parameter_value nios2_qsys {master_addr_map} {0}
set_instance_parameter_value nios2_qsys {mmu_TLBMissExcOffset} {0}
set_instance_parameter_value nios2_qsys {mmu_TLBMissExcSlave} {None}
set_instance_parameter_value nios2_qsys {mmu_autoAssignTlbPtrSz} {1}
set_instance_parameter_value nios2_qsys {mmu_enabled} {0}
set_instance_parameter_value nios2_qsys {mmu_processIDNumBits} {8}
set_instance_parameter_value nios2_qsys {mmu_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {mmu_tlbNumWays} {16}
set_instance_parameter_value nios2_qsys {mmu_tlbPtrSz} {7}
set_instance_parameter_value nios2_qsys {mmu_udtlbNumEntries} {6}
set_instance_parameter_value nios2_qsys {mmu_uitlbNumEntries} {4}
set_instance_parameter_value nios2_qsys {mpu_enabled} {0}
set_instance_parameter_value nios2_qsys {mpu_minDataRegionSize} {12}
set_instance_parameter_value nios2_qsys {mpu_minInstRegionSize} {12}
set_instance_parameter_value nios2_qsys {mpu_numOfDataRegion} {8}
set_instance_parameter_value nios2_qsys {mpu_numOfInstRegion} {8}
set_instance_parameter_value nios2_qsys {mpu_useLimit} {0}
set_instance_parameter_value nios2_qsys {mpx_enabled} {0}
set_instance_parameter_value nios2_qsys {mul_32_impl} {2}
set_instance_parameter_value nios2_qsys {mul_64_impl} {0}
set_instance_parameter_value nios2_qsys {mul_shift_choice} {0}
set_instance_parameter_value nios2_qsys {ocimem_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {ocimem_ramInit} {0}
set_instance_parameter_value nios2_qsys {regfile_ramBlockType} {Automatic}
set_instance_parameter_value nios2_qsys {register_file_por} {0}
set_instance_parameter_value nios2_qsys {resetOffset} {0}
set_instance_parameter_value nios2_qsys {resetSlave} {onchip_rom.s1}
set_instance_parameter_value nios2_qsys {resetrequest_enabled} {1}
set_instance_parameter_value nios2_qsys {setting_HBreakTest} {0}
set_instance_parameter_value nios2_qsys {setting_HDLSimCachesCleared} {1}
set_instance_parameter_value nios2_qsys {setting_activateMonitors} {1}
set_instance_parameter_value nios2_qsys {setting_activateTestEndChecker} {0}
set_instance_parameter_value nios2_qsys {setting_activateTrace} {0}
set_instance_parameter_value nios2_qsys {setting_allow_break_inst} {0}
set_instance_parameter_value nios2_qsys {setting_alwaysEncrypt} {1}
set_instance_parameter_value nios2_qsys {setting_asic_add_scan_mode_input} {0}
set_instance_parameter_value nios2_qsys {setting_asic_enabled} {0}
set_instance_parameter_value nios2_qsys {setting_asic_synopsys_translate_on_off} {0}
set_instance_parameter_value nios2_qsys {setting_asic_third_party_synthesis} {0}
set_instance_parameter_value nios2_qsys {setting_avalonDebugPortPresent} {0}
set_instance_parameter_value nios2_qsys {setting_bhtPtrSz} {8}
set_instance_parameter_value nios2_qsys {setting_bigEndian} {0}
set_instance_parameter_value nios2_qsys {setting_branchpredictiontype} {Dynamic}
set_instance_parameter_value nios2_qsys {setting_breakslaveoveride} {0}
set_instance_parameter_value nios2_qsys {setting_clearXBitsLDNonBypass} {1}
set_instance_parameter_value nios2_qsys {setting_dc_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_disable_tmr_inj} {0}
set_instance_parameter_value nios2_qsys {setting_disableocitrace} {0}
set_instance_parameter_value nios2_qsys {setting_dtcm_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_ecc_present} {0}
set_instance_parameter_value nios2_qsys {setting_ecc_sim_test_ports} {0}
set_instance_parameter_value nios2_qsys {setting_exportHostDebugPort} {0}
set_instance_parameter_value nios2_qsys {setting_exportPCB} {0}
set_instance_parameter_value nios2_qsys {setting_export_large_RAMs} {0}
set_instance_parameter_value nios2_qsys {setting_exportdebuginfo} {0}
set_instance_parameter_value nios2_qsys {setting_exportvectors} {0}
set_instance_parameter_value nios2_qsys {setting_fast_register_read} {0}
set_instance_parameter_value nios2_qsys {setting_ic_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_interruptControllerType} {Internal}
set_instance_parameter_value nios2_qsys {setting_itcm_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_mmu_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_oci_export_jtag_signals} {0}
set_instance_parameter_value nios2_qsys {setting_oci_version} {1}
set_instance_parameter_value nios2_qsys {setting_preciseIllegalMemAccessException} {0}
set_instance_parameter_value nios2_qsys {setting_removeRAMinit} {0}
set_instance_parameter_value nios2_qsys {setting_rf_ecc_present} {1}
set_instance_parameter_value nios2_qsys {setting_shadowRegisterSets} {0}
set_instance_parameter_value nios2_qsys {setting_showInternalSettings} {0}
set_instance_parameter_value nios2_qsys {setting_showUnpublishedSettings} {0}
set_instance_parameter_value nios2_qsys {setting_support31bitdcachebypass} {1}
set_instance_parameter_value nios2_qsys {setting_tmr_output_disable} {0}
set_instance_parameter_value nios2_qsys {setting_usedesignware} {0}
set_instance_parameter_value nios2_qsys {shift_rot_impl} {1}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_0_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_0_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_1_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_1_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_2_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_2_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_3_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_data_master_3_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_0_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_0_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_1_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_1_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_2_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_2_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_3_paddr_base} {0}
set_instance_parameter_value nios2_qsys {tightly_coupled_instruction_master_3_paddr_size} {0.0}
set_instance_parameter_value nios2_qsys {tmr_enabled} {0}
set_instance_parameter_value nios2_qsys {tracefilename} {}
set_instance_parameter_value nios2_qsys {userDefinedSettings} {}

add_instance onchip_ram altera_avalon_onchip_memory2 18.1
set_instance_parameter_value onchip_ram {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value onchip_ram {blockType} {AUTO}
set_instance_parameter_value onchip_ram {copyInitFile} {0}
set_instance_parameter_value onchip_ram {dataWidth} {32}
set_instance_parameter_value onchip_ram {dataWidth2} {32}
set_instance_parameter_value onchip_ram {dualPort} {0}
set_instance_parameter_value onchip_ram {ecc_enabled} {0}
set_instance_parameter_value onchip_ram {enPRInitMode} {0}
set_instance_parameter_value onchip_ram {enableDiffWidth} {0}
set_instance_parameter_value onchip_ram {initMemContent} {1}
set_instance_parameter_value onchip_ram {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value onchip_ram {instanceID} {NONE}
set_instance_parameter_value onchip_ram {memorySize} {40960.0}
set_instance_parameter_value onchip_ram {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value onchip_ram {resetrequest_enabled} {1}
set_instance_parameter_value onchip_ram {simAllowMRAMContentsFile} {0}
set_instance_parameter_value onchip_ram {simMemInitOnlyFilename} {0}
set_instance_parameter_value onchip_ram {singleClockOperation} {0}
set_instance_parameter_value onchip_ram {slave1Latency} {1}
set_instance_parameter_value onchip_ram {slave2Latency} {1}
set_instance_parameter_value onchip_ram {useNonDefaultInitFile} {0}
set_instance_parameter_value onchip_ram {useShallowMemBlocks} {0}
set_instance_parameter_value onchip_ram {writable} {1}

add_instance onchip_rom altera_avalon_onchip_memory2 18.1
set_instance_parameter_value onchip_rom {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value onchip_rom {blockType} {AUTO}
set_instance_parameter_value onchip_rom {copyInitFile} {0}
set_instance_parameter_value onchip_rom {dataWidth} {32}
set_instance_parameter_value onchip_rom {dataWidth2} {32}
set_instance_parameter_value onchip_rom {dualPort} {0}
set_instance_parameter_value onchip_rom {ecc_enabled} {0}
set_instance_parameter_value onchip_rom {enPRInitMode} {0}
set_instance_parameter_value onchip_rom {enableDiffWidth} {0}
set_instance_parameter_value onchip_rom {initMemContent} {1}
set_instance_parameter_value onchip_rom {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value onchip_rom {instanceID} {NONE}
set_instance_parameter_value onchip_rom {memorySize} {10240.0}
set_instance_parameter_value onchip_rom {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value onchip_rom {resetrequest_enabled} {1}
set_instance_parameter_value onchip_rom {simAllowMRAMContentsFile} {0}
set_instance_parameter_value onchip_rom {simMemInitOnlyFilename} {0}
set_instance_parameter_value onchip_rom {singleClockOperation} {0}
set_instance_parameter_value onchip_rom {slave1Latency} {1}
set_instance_parameter_value onchip_rom {slave2Latency} {1}
set_instance_parameter_value onchip_rom {useNonDefaultInitFile} {0}
set_instance_parameter_value onchip_rom {useShallowMemBlocks} {0}
set_instance_parameter_value onchip_rom {writable} {0}

add_instance tmc_ctrl_0 tmc_ctrl 1.0

add_instance uart_0 altera_avalon_uart 18.1
set_instance_parameter_value uart_0 {baud} {115200}
set_instance_parameter_value uart_0 {dataBits} {8}
set_instance_parameter_value uart_0 {fixedBaud} {1}
set_instance_parameter_value uart_0 {parity} {NONE}
set_instance_parameter_value uart_0 {simCharStream} {}
set_instance_parameter_value uart_0 {simInteractiveInputEnable} {0}
set_instance_parameter_value uart_0 {simInteractiveOutputEnable} {0}
set_instance_parameter_value uart_0 {simTrueBaud} {0}
set_instance_parameter_value uart_0 {stopBits} {1}
set_instance_parameter_value uart_0 {syncRegDepth} {2}
set_instance_parameter_value uart_0 {useCtsRts} {0}
set_instance_parameter_value uart_0 {useEopRegister} {0}
set_instance_parameter_value uart_0 {useRelativePathForSimFile} {0}

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk.clk_in
add_interface encoder_0 conduit end
set_interface_property encoder_0 EXPORT_OF encoder_0.conduit_end
add_interface motor_ctrl_0 conduit end
set_interface_property motor_ctrl_0 EXPORT_OF motor_Ctrl_0.conduit_end_0
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk.clk_in_reset
add_interface tmc_ctrl_0 conduit end
set_interface_property tmc_ctrl_0 EXPORT_OF tmc_ctrl_0.conduit_end
add_interface uart conduit end
set_interface_property uart EXPORT_OF uart_0.external_connection

# connections and connection parameters
add_connection clk.clk encoder_0.clock

add_connection clk.clk jtag_uart.clk

add_connection clk.clk motor_Ctrl_0.clock

add_connection clk.clk nios2_qsys.clk

add_connection clk.clk onchip_ram.clk1

add_connection clk.clk onchip_rom.clk1

add_connection clk.clk tmc_ctrl_0.clock

add_connection clk.clk uart_0.clk

add_connection clk.clk_reset encoder_0.reset_sink

add_connection clk.clk_reset jtag_uart.reset

add_connection clk.clk_reset motor_Ctrl_0.reset_sink

add_connection clk.clk_reset nios2_qsys.reset

add_connection clk.clk_reset onchip_ram.reset1

add_connection clk.clk_reset onchip_rom.reset1

add_connection clk.clk_reset tmc_ctrl_0.reset_sink

add_connection clk.clk_reset uart_0.reset

add_connection nios2_qsys.data_master encoder_0.avalon_slave_0_1
set_connection_parameter_value nios2_qsys.data_master/encoder_0.avalon_slave_0_1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/encoder_0.avalon_slave_0_1 baseAddress {0x00029000}
set_connection_parameter_value nios2_qsys.data_master/encoder_0.avalon_slave_0_1 defaultConnection {0}

add_connection nios2_qsys.data_master jtag_uart.avalon_jtag_slave
set_connection_parameter_value nios2_qsys.data_master/jtag_uart.avalon_jtag_slave arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/jtag_uart.avalon_jtag_slave baseAddress {0x00029c20}
set_connection_parameter_value nios2_qsys.data_master/jtag_uart.avalon_jtag_slave defaultConnection {0}

add_connection nios2_qsys.data_master motor_Ctrl_0.avalon_slave_0
set_connection_parameter_value nios2_qsys.data_master/motor_Ctrl_0.avalon_slave_0 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/motor_Ctrl_0.avalon_slave_0 baseAddress {0x00029800}
set_connection_parameter_value nios2_qsys.data_master/motor_Ctrl_0.avalon_slave_0 defaultConnection {0}

add_connection nios2_qsys.data_master nios2_qsys.debug_mem_slave
set_connection_parameter_value nios2_qsys.data_master/nios2_qsys.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/nios2_qsys.debug_mem_slave baseAddress {0x00028800}
set_connection_parameter_value nios2_qsys.data_master/nios2_qsys.debug_mem_slave defaultConnection {0}

add_connection nios2_qsys.data_master onchip_ram.s1
set_connection_parameter_value nios2_qsys.data_master/onchip_ram.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/onchip_ram.s1 baseAddress {0x00010000}
set_connection_parameter_value nios2_qsys.data_master/onchip_ram.s1 defaultConnection {0}

add_connection nios2_qsys.data_master onchip_rom.s1
set_connection_parameter_value nios2_qsys.data_master/onchip_rom.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/onchip_rom.s1 baseAddress {0x00024000}
set_connection_parameter_value nios2_qsys.data_master/onchip_rom.s1 defaultConnection {0}

add_connection nios2_qsys.data_master tmc_ctrl_0.avalon_slave_0
set_connection_parameter_value nios2_qsys.data_master/tmc_ctrl_0.avalon_slave_0 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/tmc_ctrl_0.avalon_slave_0 baseAddress {0x00029400}
set_connection_parameter_value nios2_qsys.data_master/tmc_ctrl_0.avalon_slave_0 defaultConnection {0}

add_connection nios2_qsys.data_master uart_0.s1
set_connection_parameter_value nios2_qsys.data_master/uart_0.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.data_master/uart_0.s1 baseAddress {0x00029c00}
set_connection_parameter_value nios2_qsys.data_master/uart_0.s1 defaultConnection {0}

add_connection nios2_qsys.instruction_master nios2_qsys.debug_mem_slave
set_connection_parameter_value nios2_qsys.instruction_master/nios2_qsys.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.instruction_master/nios2_qsys.debug_mem_slave baseAddress {0x00028800}
set_connection_parameter_value nios2_qsys.instruction_master/nios2_qsys.debug_mem_slave defaultConnection {0}

add_connection nios2_qsys.instruction_master onchip_ram.s1
set_connection_parameter_value nios2_qsys.instruction_master/onchip_ram.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.instruction_master/onchip_ram.s1 baseAddress {0x00010000}
set_connection_parameter_value nios2_qsys.instruction_master/onchip_ram.s1 defaultConnection {0}

add_connection nios2_qsys.instruction_master onchip_rom.s1
set_connection_parameter_value nios2_qsys.instruction_master/onchip_rom.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_qsys.instruction_master/onchip_rom.s1 baseAddress {0x00024000}
set_connection_parameter_value nios2_qsys.instruction_master/onchip_rom.s1 defaultConnection {0}

add_connection nios2_qsys.irq jtag_uart.irq
set_connection_parameter_value nios2_qsys.irq/jtag_uart.irq irqNumber {0}

add_connection nios2_qsys.irq uart_0.irq
set_connection_parameter_value nios2_qsys.irq/uart_0.irq irqNumber {1}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {nios_ii.qsys}
