# SPDX-FileCopyrightText: Copyright (c) 2023-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

create_clock -name {ref_clk}            -period 6.400 -waveform { 0.000 3.200 } [get_ports {FPGA_ETH_REFCLK}]
create_clock -name {adi_sif_clk}        -period 4.069 [get_ports {AD9545_CORECLK_P}]
create_clock -name {fmc_sif_clk}        -period 4.069 [get_ports {FMC_CLK1_M2C_TERM_P}]
create_clock -name {altera_reserved_tck} -period 40                              [get_ports {altera_reserved_tck}]

set OSC_CLK         [get_clocks ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk]
set CLK100          [get_clocks fpga_clk_pll|iopll_0_fpga_clk_100]
set REF_CLK         [get_clocks ref_clk]

for {set x 0} {$x < 2} {incr x} {
        set CORECLK         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp|tx_clkout|ch0]
        
        set CORECLK_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_clkout|ch0]
        set CORECLK_PTP3    [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch3]
        
        
        set RX_CLK0         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch0]
        set RX_CLK1         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch1]
        set RX_CLK2         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch2]
        set RX_CLK3         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch3]
        
        set TX_CLK0         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch0]
        set TX_CLK1         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch1]
        set TX_CLK2         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch2]
        set TX_CLK3         [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch3]
        
        set RX_CLK0_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch0]
        set RX_CLK1_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch1]
        set RX_CLK2_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch2]
        set RX_CLK3_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|rx_transfer_clk|ch3]
        
        set TX_CLK0_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch0]
        set TX_CLK1_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch1]
        set TX_CLK2_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch2]
        set TX_CLK3_PTP     [get_clocks ethernet_100gb[$x].eth_top_inst|qsfp_inst|eth_100g_inst|alt_ehipc3_0|alt_ehipc3_hard_inst|E100GX4_FEC*.altera_xcvr_native_inst|xcvr_native_s10_etile_0_example_design_4ln_ptp*|tx_transfer_clk|ch3]



    if {! [is_post_route]} {
       # fitter; 15% at 402.83 MHz
       set_clock_uncertainty -setup -add -from $CORECLK 0.372
       set_clock_uncertainty -setup -add -from $CORECLK_PTP 0.372
    } else {
       # everywhere else
    }
    
    set_clock_groups -asynchronous -group  $CORECLK       -group $OSC_CLK  -group $REF_CLK ;#-group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $CORECLK_PTP   -group $OSC_CLK  -group $REF_CLK ;#-group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $CORECLK_PTP3  -group $OSC_CLK  -group $REF_CLK ;#-group $CLK100 ;#-group $IOPLL_REF

    set_clock_groups -asynchronous -group  $RX_CLK0       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $RX_CLK1       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK0       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK1       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF 

    set_clock_groups -asynchronous -group  $RX_CLK2       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $RX_CLK3       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK2       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK3       -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF

    set_clock_groups -asynchronous -group  $RX_CLK0_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $RX_CLK1_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK0_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK1_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF 

    set_clock_groups -asynchronous -group  $RX_CLK2_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $RX_CLK3_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK2_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF
    set_clock_groups -asynchronous -group  $TX_CLK3_PTP   -group $OSC_CLK  -group $REF_CLK -group $CLK100 ;#-group $IOPLL_REF

    set_false_path -to   QSFP$x\_LPMODE
    set_false_path -to   QSFP$x\_RESET_L

}

set_false_path  -to *qsfp*_inst|eth_100g_inst|alt_ehipc3_0|rx_adapt_dropped_frame_count_sync_inst|data_out*
set_false_path  -to *qsfp*_inst|eth_100g_inst|alt_ehipc3_0|RST_CTRL_100G.alt_ehipc3_reset_controller_inst|status_rx_reset_synchronizers|resync_chains[0].synchronizer_nocut|din_s1
set_false_path  -to *qsfp*_inst|*.synchronizer_nocut|din_s1*
set_false_path  -to *qsfp*_inst|*synchronizer_nocut_inst|din_s1*

set_false_path  -to *qsfp*_inst|*|rx_adapt_clr_sync_inst|din_s1
set_false_path  -to *qsfp*_inst|*|ack_sync_0|din_s1
set_false_path  -to *qsfp*_inst|*valid_sync_0|din_s1
set_false_path  -from *|alt_ehipc3_0|undersized_frame_csr_rst

# Update to async reset paths from TL 18/08/25
set_false_path -from [get_keepers -no_duplicates {rst_and_lock_sync|filter_pipe*}] -to [get_keepers -no_duplicates {u_hololink_top|u_rst_gen|*}]

# RX DC FIFO Arst
set_false_path -from [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|eth_rst_count_n[0]}] -to [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|u_eth_rx_dc_fifo|auto_generated|rdaclr|dffe*a[0]}]
# Eth ready to sys_rst
set_false_path -from [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|eth_rst_count_n[0]}] -to [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|*|aasr_rst*}]
# TX DC FIFO Arst
set_false_path -from [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|u_hif_rst_sync|srst[1]}] -to [get_keepers -no_duplicates {ethernet_100gb[*].eth_top_inst|qsfp_inst|u_eth_tx_dc_fifo|auto_generated|rdaclr|dffe*a[0]}]

#AD9545 Mode Pin inputs
set_false_path -from [get_ports AD9545_M*]

# From Timequest cookbook
set_clock_groups -asynchronous -group [get_clocks altera_reserved_tck]

# From "AV SoC Golden Hardware Reference Design"
set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]


#**************************************************************
# Output
#**************************************************************

set_false_path -to [get_ports *STX_DBG_LED*]
set_false_path -to [get_ports *FPGA_RECONFIG*]
set_false_path -to [get_ports *AD9545_RESETB*]
set_false_path -to [get_ports *FPGA_HB_LED*]
set_false_path -to [get_ports *FMC_PWR_EN*]
set_false_path -to [get_ports *FPGA_PG_C2M*]
set_false_path -to [get_ports *FMC_LA07_P*]
set_false_path -to [get_ports *FMC_LA22_P*]

set_false_path -from [get_ports FPGA_EEPROM_SCL]
set_false_path -from [get_ports FPGA_EEPROM_SDA]
set_false_path -from [get_ports AD9545_SCK]
set_false_path -from [get_ports AD9545_SDA]
set_false_path -from [get_ports FMC_CLK0_M2C_TERM_P]

#CDC-50003 CE-Type CDC Transfer
#ReLingo_waive_start:nv_soc:RL02
set_max_skew -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_rdfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_rdfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]
set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_rdfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_rdfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]

set_max_skew -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_reqfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_reqfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]
set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_reqfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_reqfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]

set_max_skew -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_rdfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_rdfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]
set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_rdfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_tx|u_rdfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]

set_max_skew -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_reqfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_reqfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]
set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_reqfifo|DEPTH_0.ram_ff0[*]}] -to [get_keepers {u_hololink_top|u_jesd_top|u_nvda_jesd204c|u_core_wrap|u_apbif|u_apbslv_rx|u_reqfifo|DEPTH_0.NV_AFIFO_rd_data[*]}]
#ReLingo_waive_end:nv_soc:RL02

# ######################################################################
# altera jesd constraints

set_clock_groups -asynchronous -group fpga_clk_pll|iopll_0_fpga_clk_100 \
-group {ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk} \
-group {u_alt_jesd_ss|iopll_0|iopll_0_link_clk u_alt_jesd_ss|iopll_0||iopll_0_refclk } \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|tx_clkout|ch0} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch0} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch1} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch2} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch3} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch4} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch5} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch6} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_clkout|ch7} \
-group {altera_reserved_tck}

set_clock_groups -async -group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch0} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch1} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch2} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch3} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch4} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch5} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch6} \
-group {u_alt_jesd_ss|intel_jesd204c_0|intel_jesd204c_0|j204c_phy_hip_inst|inst_xcvr|rx_transfer_clk|ch7} \
-group {u_alt_jesd_ss|iopll_0|iopll_0_link_clk u_alt_jesd_ss|iopll_0|iopll_0_frame_clk } \
-group {fpga_clk_pll|iopll_0_fpga_clk_100}

set_multicycle_path -end -setup -from u_alt_jesd_ss|iopll_0|iopll_0_link_clk -to u_alt_jesd_ss|iopll_0|iopll_0_frame_clk 2
set_multicycle_path -end -hold -from u_alt_jesd_ss|iopll_0|iopll_0_link_clk -to u_alt_jesd_ss|iopll_0|iopll_0_frame_clk 1

set_multicycle_path -start -setup -from u_alt_jesd_ss|iopll_0|iopll_0_frame_clk -to u_alt_jesd_ss|iopll_0|iopll_0_link_clk 2
set_multicycle_path -start -hold -from u_alt_jesd_ss|iopll_0|iopll_0_frame_clk -to u_alt_jesd_ss|iopll_0|iopll_0_link_clk 1

# ######################################################################


## Hololink IP Constraints
source "./hololink.sdc"

## DCFIFO Constraints
source "./dcfifo.sdc"

