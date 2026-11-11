// SPDX-FileCopyrightText: Copyright (c) 2023-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`ifndef HOLOLINK_def
`define HOLOLINK_def

package HOLOLINK_pkg;

//-----------------------------------------------------
// Define FPGA Vendor for Macro Instantiation
//-----------------------------------------------------
  `define ALTERA
//-----------------------------------------------------
// Holoscan IP Host Clock Frequency
//
// Used for internal timer calculation
//-----------------------------------------------------

  `define HIF_CLK_FREQ  201416016

//-----------------------------------------------------
// Holoscan IP APB Clock Frequency
//
// Used for I2C clock divider setting
//-----------------------------------------------------

  `define APB_CLK_FREQ  100000000

//-----------------------------------------------------
// Holoscan IP PTP Clock Frequency
//
// Used for internal timer calculation
//-----------------------------------------------------

  `define PTP_CLK_FREQ  100707500

//-----------------------------------------------------
// Board Info Enumeration
//
// Use ENUM_EEPROM if board info is stored in an external
// EEPROM. Otherwise, soft values can be used.
//-----------------------------------------------------

  `define ENUM_EEPROM
  `define EEPROM_REG_ADDR_BITS 8
  `define UUID                 128'h0199_0f9c_5794_7169_a5af_d986_baf8_7777

`ifndef ENUM_EEPROM
  // NOTE: new IP renamed MAC_ADDR -> MAC_ADDR_0 (indexed). Only relevant if
  // ENUM_EEPROM is disabled.
  `define MAC_ADDR_0 48'hCAFEC0FFEE00
  `define BOARD_SN   56'h0
`endif

//-----------------------------------------------------
// Sensor IF
//-----------------------------------------------------

`ifndef DATAPATH_WIDTH
  `define DATAPATH_WIDTH  128                // Sensor interface data width
`endif
  `define DATAKEEP_WIDTH  `DATAPATH_WIDTH/8  // Sensor interface data keep width (= 16)
  `define DATAUSER_WIDTH  1                  // Sensor interface data user width (ref IP uses 2; was 1)

`ifndef SENSOR_RX_IF_INST
  `define SENSOR_RX_IF_INST  1               // Number of Sensor RX interfaces (single JESD)
`endif

`ifndef SENSOR_TX_IF_INST
  `define SENSOR_TX_IF_INST  1               // Number of Sensor TX interfaces (single JESD)
`endif

// Retained for backward-compatibility with FPGA_top.v local signal sizing
// (sif_rx_*/sif_tx_* arrays). RX=TX=1, so a value of 1 is correct.
`ifndef SENSOR_IF_INST
  `define SENSOR_IF_INST  1
`endif

//-----------------------------------------------------
// Host IF
//-----------------------------------------------------

`ifndef HOST_WIDTH
  `define HOST_WIDTH      512                 // Host interface data width
`endif
  `define HOSTKEEP_WIDTH  `HOST_WIDTH/8      // Host interface data keep width
  `define HOSTUSER_WIDTH  1                  // Host interface data user width
`ifndef HOST_IF_INST
  `define HOST_IF_INST    2                  // Host interface instantiation number
`endif

  `define HOST_MTU       4096

//-----------------------------------------------------
// JESD IF
//-----------------------------------------------------
`ifndef JESD_LANE_DWIDTH
  `define JESD_LANE_DWIDTH  64
`endif

`ifndef JESD_NUM_LANES
  `define JESD_NUM_LANES    8
`endif

//------------------------------------------------------------------------------
// Peripheral Control
//------------------------------------------------------------------------------

`ifndef SPI_INST
  `define SPI_INST  2   // SPI interface instantiation number
`endif
`ifndef  I2C_INST
  `define I2C_INST  2   // I2C interface instantiation number
`endif
  `define GPIO_INST 16  // INOUT GPIO instantiation number

  localparam [`GPIO_INST-1:0] GPIO_RESET_VALUE = 16'b0000000000001111;

//------------------------------------------------------------------------------
// Register IF
//
// Creates <REG_INST> number of APB register interfaces for user logic access
//------------------------------------------------------------------------------

  `define REG_INST 8

//------------------------------------------------------------------------------
// COE - Camera Over Ethernet Enable
//
// Disables COE packet generation functionality
//------------------------------------------------------------------------------
  `define DISABLE_COE 1

//------------------------------------------------------------------------------
// Packetizer / Sensor stream config
//
// Sets the Packetizer Parameters for Each Sensor IF (RX/TX split scheme)
//------------------------------------------------------------------------------

`ifdef SENSOR_RX_IF_INST
  localparam integer  SIF_RX_PACKETIZER_EN   [`SENSOR_RX_IF_INST-1:0] = '{0};    // RX packetizer disabled (was RX_PACKETIZER_EN=0)
  localparam integer  SIF_RX_WIDTH           [`SENSOR_RX_IF_INST-1:0] = '{128};  // = DATAPATH_WIDTH
  localparam integer  SIF_RX_SORT_RESOLUTION [`SENSOR_RX_IF_INST-1:0] = '{16};
  localparam integer  SIF_RX_VP_COUNT        [`SENSOR_RX_IF_INST-1:0] = '{4};
  localparam integer  SIF_RX_VP_SIZE         [`SENSOR_RX_IF_INST-1:0] = '{128};
  localparam integer  SIF_RX_NUM_CYCLES      [`SENSOR_RX_IF_INST-1:0] = '{1};
`endif

//------------------------------------------------------------------------------
// TX Stream Buffer
//
// Sets the Transmit Stream Buffer Size (number of entries) for Each Sensor IF
//------------------------------------------------------------------------------
`ifdef SENSOR_TX_IF_INST
  localparam integer  SIF_TX_WIDTH           [`SENSOR_TX_IF_INST-1:0] = '{128};  // = DATAPATH_WIDTH
  localparam integer  SIF_TX_BUF_SIZE        [`SENSOR_TX_IF_INST-1:0] = '{2048};
`endif

//------------------------------------------------------------------------------
// System Initialization
//
// Initialization for the Host Interface registers so communication can be
// established between the FPGA and the Host
//------------------------------------------------------------------------------

  `define N_INIT_REG 20

  localparam logic [63:0] init_reg [`N_INIT_REG] = '{
    // 32b Addr   | 32b Data
    // Hololink Internal Reg Initialization // TODO To be removed (not required, can be done by sw)
    {32'h0200_0020, 32'h0000_2000}, // inst_dec_0, ecb_udp_port
    {32'h0201_0020, 32'h0000_2000}, // inst_dec_1, ecb_udp_port
    {32'h0200_021C, 32'h0000_2329}, // ctrl_evt_0, ctrl_evt_host_udp_port
    {32'h0200_0220, 32'h0000_2329}, // ctrl_evt_0, ctrl_evt_fpga_udp_port
    {32'h0201_021C, 32'h0000_2329}, // ctrl_evt_1, ctrl_evt_host_udp_port
    {32'h0201_0220, 32'h0000_2329}, // ctrl_evt_1, ctrl_evt_fpga_udp_port
    {32'h0200_0304, 32'h0000_05CE}, // dp_pkt_0  , dp_pkt_len
    {32'h0200_0308, 32'h0000_3000}, // dp_pkt_0  , dp_pkt_fpga_udp_port
    {32'h0201_0304, 32'h0000_05CE}, // dp_pkt_1  , dp_pkt_len
    {32'h0201_0308, 32'h0000_3000}, // dp_pkt_1  , dp_pkt_fpga_udp_port
    {32'h0300_0210, 32'h004C_4B40}, // i2c timeout
    {32'h0200_0108, 32'h0000_0064}, // eth_pkt_0 , Eth pkt data plane priority
    {32'h0201_0108, 32'h0000_0064}, // eth_pkt_1 , Eth pkt data plane priority
    {32'h0200_0024, 32'h0000_12B7}, // inst_dec_0, stx_udp_port
    {32'h0201_0024, 32'h0000_12B7}, // inst_dec_1, stx_udp_port
    //PTP Config
    {32'h0000_0110, 32'h0000_0002}, // ptp, dpll cfg1
    {32'h0000_0114, 32'h0000_0002}, // ptp, dpll cfg2
    {32'h0000_0118, 32'h0000_0003}, // ptp, delay avg factor
    {32'h0000_010C, 32'h0000_0000}, // ptp, delay asymmetry
    {32'h0000_0104, 32'h0000_0003}  // ptp, dpll en
  };

endpackage: HOLOLINK_pkg
`endif
