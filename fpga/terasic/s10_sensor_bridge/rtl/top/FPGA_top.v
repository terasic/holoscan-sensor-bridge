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

`include "HOLOLINK_def.svh"

module FPGA_top #(
    parameter                           BUILD_REV = 48'h0
) (
  
    //FPGA Clock and Push Button Reset
    input  logic                        FPGA_CLK_IN     ,
    input  logic                        FPGA_PB_RESET_L ,
    
    //Reconfig
    output logic                        FPGA_RECONFIG   ,
    
    //QSFP SERDES
    input  logic    [ 1:0][3:0]         QSFP_RX_P       ,
    output logic    [ 1:0][3:0]         QSFP_TX_P       ,

    //FMC SERDES
    input  logic    [ `JESD_NUM_LANES-1:0]              JESD_RXDP       ,
    input  logic    [ `JESD_NUM_LANES-1:0]              JESD_RXDN       ,
    output logic    [ `JESD_NUM_LANES-1:0]              JESD_TXDP       ,
    output logic    [ `JESD_NUM_LANES-1:0]              JESD_TXDN       ,

    //REFCLKs
    input  logic                        FPGA_REFCLK_EXT ,   //REFCLK0
    input  logic                        FPGA_ETH_REFCLK ,   //REFCLK1
    input  logic                        FMC_GBTCLK0_M2C ,   //REFCLK2
    input  logic                        FMC_GBTCLK1_M2C ,   //REFCLK3
    input  logic                        FMC_GBTCLK2_M2C ,   //REFCLK4
    input  logic                        FMC_GBTCLK3_M2C ,   //REFCLK5
    input  logic                        AD9545_REFCLK   ,   //REFCLK6
    input  logic                        JESD_REFCLK2    ,   //REFCLK7
    input  logic                        ETH_REFCLK0     ,   //REFCLK8
    
    //I2C
    inout tri                           FMC_I2C_SCL_1V8 ,
    inout tri                           FMC_I2C_SDA_1V8 ,
    
    
    
    //Headers, LEDs, and Straps
    output logic                        FPGA_HB_LED     ,
    output logic    [15:0]              DBG_HEADER      ,
    output logic    [15:0]              STX_DBG_LED     ,
    input  logic    [15:0]              DBG_SWITCH      ,
    input  logic    [ 3:0]              STX_STRAP       ,
    
    output logic                        FMC_LA04_N,         //FMC H11 - SPI0_SCLK - AD_SCLK - OUTPUT
    output logic                        FMC_LA04_P,         //FMC H10 - SPI0_MOSI - AD_MOSI - INOUT
    input  logic                        FMC_LA05_N,         //FMC D12 - SPI0_MISO - AD_MISO - INOUT
    output logic                        FMC_LA05_P,         //FMC D11 - SPI0_CSB - AD_CSN - OUTPUT
    output logic                        FMC_LA07_P,         //FMC H13 - RSTB - AD_RST - OUTPUT
    output logic                        FMC_LA11_P,         //                      HMC_SCLK
    inout tri                           FMC_LA12_N,         //FMC G16 - SPI1_SDIO - HMC_SDIO
    output logic                        FMC_LA12_P,         //FMC G15 - SPI1_CSB - HMC_CSNoutput          hmc_csn         ,
    input  logic                        FMC_LA00_CC_TERM_P, //HMC CLK10
    
  
    //QSFP0
//  input  logic                        QSFP0_PWR_GOOD_1V8, //
    output logic                        QSFP0_LPMODE,       //
    output logic                        QSFP0_RESET_L,      //                       
    inout  tri                          QSFP0_SCL,          //
    inout  tri                          QSFP0_SDA,          //
//  input  logic                        QSFP0_INT_L,        //
    output logic                        QSFP0_MODSEL_L,     //
    input  logic                        QSFP0_MODPRS_L,     //
    output logic                        QSFP0_PWR_EN,       //
                                                            
                                                            
    //QSFP1                                                 
//  input  logic                        QSFP1_PWR_GOOD_1V8, //
    output logic                        QSFP1_LPMODE,       //
    output logic                        QSFP1_RESET_L,      //
    inout  tri                          QSFP1_SCL,          //
    inout  tri                          QSFP1_SDA,          //
//  input  logic                        QSFP1_INT_L,        //
    output logic                        QSFP1_MODSEL_L,     //
    input  logic                        QSFP1_MODPRS_L,     //
    output logic                        QSFP1_PWR_EN,       //
    
    
    input  logic                        FMC_CLK0_M2C_TERM_P ,
    input  logic                        FMC_CLK1_M2C_TERM_P ,
    input  logic                        FMC_CLK2_BIDIR_IN_P ,
    
    //FMC Power
    output logic                        FMC_PWR_EN          ,
    output logic                        FMC_LA22_P          ,
    output logic                        FPGA_PG_C2M         ,
    
    //FPGA EEPROM 
    inout  tri                          FPGA_EEPROM_SCL     ,
    inout  tri                          FPGA_EEPROM_SDA     ,
    
    //FPGA EXT Clock OUT
    output logic                        FPGA_EXT_CLK_OUT_P  ,
    //AD9545
    input  logic                        AD9545_CORECLK_P,
    output logic                        AD9545_RESETB,            
    input  logic                        AD9545_M0,                
    input  logic                        AD9545_M1,                
    input  logic                        AD9545_M2,                
    input  logic                        AD9545_M3,                
    input  logic                        AD9545_M4,                
    input  logic                        AD9545_M5,                
    input  logic                        AD9545_M6,                
    inout  tri                          AD9545_SCK,
    inout  tri                          AD9545_SDA  
);

localparam                        HALF_SECOND   = 26'h2FAF07F;

//------------------------------------------------------------------------------
// Reset, clocks, and initialization 
//------------------------------------------------------------------------------
logic                             ninit_done;
logic                             fpga_clk_pll_rst;           //FPGA clock PLL reset
logic                             fpga_clk_100;               //100MHz clock from FPGA PLL
logic                             fpga_clk_50;                //50MHz clock from FPGA PLL
logic                             fpga_clk_pll_lock;          //FPGA PLL lock
logic                             rst_sys;                    //System reset - synchronous to 100MHz clock
logic [`HOST_IF_INST-1:0]         eth_rdy;                    //Ethernet ready indication. 
logic                             sys_rst;                    //Hololink Sys Reset
logic [`HOST_IF_INST-1:0]         eth_rst_n;                  //Reset from ethernet module. Synced to eth_clk_div64 from each. 
logic [`HOST_IF_INST-1:0]         eth_clk_div64;              //Ethernet module output clock. 402.83MHz from IP.
logic                             apb_clk;                    //APB clock
logic                             apb_rst;                    //APB reset. From Hololink.
logic                             hif_clk;                    //Hololink host interface clock
logic                             hif_pll_locked;             //Hololink host interface clock PLL lock
logic                             sif_clk;                    //Hololink sensor interface clock
logic                             sif_rst;                    //Hololink sensor interface reset
logic                             hololink_init_done;         //Hololink initialization done
logic                             pb_rst_debounced;           //Debounced push button
logic                             hl_sw_rst;                  //Hololink software reset
logic                             clk_checker_source;         //Source clock for the clock checker module
logic                             jesd_core_pll_refclk;       //Source clock for the JESD PLL refclk
logic                             jesd_core_clk;              //JESD core clock output from PLL
logic                             jesd_core_dev_clk;          //JESD core device clock
logic                             jesd_pll_locked;            //JESD core PLL locked
// Observability only: nothing consumes these, so synthesis prunes them unless a
// keep attribute is added. Re-add /* synthesis keep */ to tap them in Signal Tap.
logic                             jesd_rx_sh_lock;            //JESD204C RX sync header lock
logic                             jesd_rx_emb_lock;           //JESD204C RX extended multiblock lock
logic [7:0]                       jesd_rx_lane_ready;         //JESD204C RX per-lane ready
logic [7:0]                       jesd_tx_lane_ready;         //JESD204C TX per-lane ready
logic                             ptp_clk;
logic                             ptp_rst;
logic                             frame_clk;                  //Altera JESD subsystem frame clock (SIF interface), 245.76MHz
logic                             link_clk;                   //Altera JESD subsystem link clock, 122.88Mhz

//------------------------------------------------------------------------------
// Heartbeat and debug LEDs 
//------------------------------------------------------------------------------
logic                             heartbeat;                  //Heartbeat LED signal
logic   [25:0]                    second_cnt;                 //Counter for heartbeat LED logic
logic   [15:0]                    dbg_led_out;                //Debug LED output

//------------------------------------------------------------------------------
// User APB Drops 
//------------------------------------------------------------------------------
logic [`REG_INST-1:0]             apb_psel;
logic                             apb_penable;
logic [31         :0]             apb_paddr;
logic [31         :0]             apb_pwdata;
logic                             apb_pwrite;
logic [`REG_INST-1:0]             apb_pready;
// Unpacked array bounds must match the HOLOLINK_top port declarations exactly.
// The updated IP declares these ports as [N-1:0] (descending); connecting an
// ascending [N] array to them silently reverses the elements.
logic [31         :0]             apb_prdata              [`REG_INST-1:0];
logic [`REG_INST-1:0]             apb_pserr;

//------------------------------------------------------------------------------
// Hololink Host Rx/Tx 
//------------------------------------------------------------------------------
logic [`HOST_IF_INST-1:0]         hl_axis_rx_tvalid;
logic [`HOST_WIDTH-1:0]           hl_axis_rx_tdata      [`HOST_IF_INST-1:0];
logic [`HOST_IF_INST-1:0]         hl_axis_rx_tlast;
logic [`HOSTUSER_WIDTH-1:0]       hl_axis_rx_tuser      [`HOST_IF_INST-1:0];
logic [`HOST_WIDTH/8-1:0]         hl_axis_rx_tkeep      [`HOST_IF_INST-1:0];
      
logic [`HOST_IF_INST-1:0]         hl_axis_tx_tvalid;
logic [`HOST_WIDTH-1:0]           hl_axis_tx_tdata      [`HOST_IF_INST-1:0];
logic [`HOST_IF_INST-1:0]         hl_axis_tx_tlast;
logic [`HOSTUSER_WIDTH-1:0]       hl_axis_tx_tuser      [`HOST_IF_INST-1:0];
logic [`HOST_WIDTH/8-1:0]         hl_axis_tx_tkeep      [`HOST_IF_INST-1:0];
logic [`HOST_IF_INST-1:0]         hl_axis_tx_tready;

//------------------------------------------------------------------------------
// Hololink Sensor Rx/Tx 
//------------------------------------------------------------------------------
// sif_rx_tvalid/sif_tx_tready are pure aliases of jesd_rx_valid/jesd_tx_ready, so the
// merge collapses each pair to one node and only one of the two names survives. Tapping
// these by name in Signal Tap needs /* synthesis keep */ on both sides of the alias.
logic [`SENSOR_IF_INST-1:0]       sif_rx_tready;
logic [`DATAPATH_WIDTH-1:0]       sif_rx_tdata      [`SENSOR_IF_INST-1:0];
logic [`SENSOR_IF_INST-1:0]       sif_rx_tvalid;

logic [`SENSOR_IF_INST-1:0]       sif_tx_tready;
logic [`DATAPATH_WIDTH-1:0]       sif_tx_tdata      [`SENSOR_IF_INST-1:0];
logic [`SENSOR_IF_INST-1:0]       sif_tx_tvalid;

//------------------------------------------------------------------------------
// Altera JESD
//------------------------------------------------------------------------------
// Avalon Streaming
logic         jesd_rx_ready;
logic [511:0] jesd_rx_data;
logic         jesd_rx_valid;

logic         jesd_tx_ready;
logic [511:0] jesd_tx_data;
logic         jesd_tx_valid;

// Word addressed Avalon MM bus
logic         jesd_avmm_waitrequest;
logic [31:0]  jesd_avmm_readdata;
logic         jesd_avmm_readdatavalid;
logic [31:0]  jesd_avmm_writedata;
logic [23:0]  jesd_avmm_address;
logic         jesd_avmm_write;
logic         jesd_avmm_read;

// Transceiver Byte addressed Avalon MM bus
logic         xcvr_avmm_waitrequest;
logic [7:0]   xcvr_avmm_readdata;
logic         xcvr_avmm_readdatavalid;
logic [7:0]   xcvr_avmm_writedata;
logic [22:0]  xcvr_avmm_address;
logic         xcvr_avmm_write;
logic         xcvr_avmm_read;

//------------------------------------------------------------------------------
// I2C
//------------------------------------------------------------------------------
logic [`I2C_INST-1:0]             i2c_scl;
logic [`I2C_INST-1:0]             i2c_sda;
logic [`I2C_INST-1:0]             i2c_scl_en;
logic [`I2C_INST-1:0]             i2c_sda_en;
            
logic                             fpga_eeprom_i2c_scl_sync;
logic                             fpga_eeprom_i2c_sda_sync;
logic                             ad9545_i2c_scl_sync;
logic                             ad9545_i2c_sda_sync;
  
//------------------------------------------------------------------------------
// SPI
//------------------------------------------------------------------------------
logic [`SPI_INST-1:0]             spi_csn;
logic [`SPI_INST-1:0]             spi_sck;
logic [3          :0]             spi_sdio_i [`SPI_INST-1:0];
logic [3          :0]             spi_sdio_o [`SPI_INST-1:0];
logic [`SPI_INST-1:0]             spi_oen;
          
logic                             hmc_spi_sdio_sync;
logic                             adi_spi_miso_sync;
logic                             adi_mosi;
logic                             adi_miso;
logic                             hmc_sdio;
logic [`GPIO_INST-1:0]            hl_gpio;

//------------------------------------------------------------------------------
// General Purpose Registers
//------------------------------------------------------------------------------
logic                             clk_chk_en;
logic  [31:0]                     clk_target;
logic  [31:0]                     clk_tolerance;
logic                             clk_in_tol;
logic  [31:0]                     clk_count;
logic                             sw_rst_ad9545;
logic                             sw_fpga_reconfig;
logic  [6:0]                      ad9545_mode_pins;

//------------------------------------------------------------------------------
// GPIO Signals needed for MxFE board
//------------------------------------------------------------------------------
logic  [1:0]                      hl_gpio_sync_0;
logic  [1:0]                      hl_gpio_sync_1;
logic  [1:0]                      hl_gpio_sync_2;
logic  [1:0]                      hl_gpio_sync_3;

//------------------------------------------------------------------------------
// PPS
//------------------------------------------------------------------------------
logic        sys_pps;
logic        sys_pps_stretch;
logic [17:0] timer_cnt;
logic        timer_done;
logic [47:0] ptp_sec;
logic [31:0] ptp_nano;

//------------------------------------------------------------------------------
// Intel Reset Release IP. Indicates when the FPGA has fully configured and 
// user-logic can start to operate.
//------------------------------------------------------------------------------
reset_ip intel_reset_ip (
  .ninit_done                       ( ninit_done       )
);

//------------------------------------------------------------------------------
// Hold the FPGA clock PLL in reset until the FPGA has completely configured.
//------------------------------------------------------------------------------
assign fpga_clk_pll_rst = ninit_done;

//------------------------------------------------------------------------------
// FPGA PLL - drives the 100MHz clock and an unused 50MHz clock.
//------------------------------------------------------------------------------
fpga_clk_pll_mfg  fpga_clk_pll (                  
  .rst                            ( fpga_clk_pll_rst    ),
  .refclk                         ( FPGA_CLK_IN         ),
  .locked                         ( fpga_clk_pll_lock   ),   
  .outclk_0                       ( fpga_clk_100        ), 
  .outclk_1                       ( fpga_clk_50         ) 
);


//------------------------------------------------------------------------------
// FPGA reset module. Drives an async reset and a sync reset on the 100MHz clock.
//------------------------------------------------------------------------------
logic   hl_sw_rst_sync;
logic   fpga_clk_pll_lock_sync;
logic   hif_pll_locked_sync;



  
data_sync    #(
  .DATA_WIDTH ( 3                                      )
) rst_and_lock_sync (
  .clk        ( fpga_clk_100                           ),
  .rst_n      ( 1'b1                                   ),
  .sync_in    ({hl_sw_rst, fpga_clk_pll_lock, hif_pll_locked}),
  .sync_out   ({hl_sw_rst_sync, fpga_clk_pll_lock_sync, hif_pll_locked_sync})
);
assign rst_sys  = !fpga_clk_pll_lock_sync || hl_sw_rst_sync || pb_rst_debounced;


//------------------------------------------------------------------------------
// Reset Push Button Debouncer
//------------------------------------------------------------------------------
rst_pb_debounce  rst_pb_debounce (
  .clk                            ( fpga_clk_100        ),
  .pb_rst_in                      ( FPGA_PB_RESET_L     ),
  .pb_rst_out                     ( pb_rst_debounced    )
);


//------------------------------------------------------------------------------
// Hololink System Reset
//------------------------------------------------------------------------------
assign sys_rst  = rst_sys || !hif_pll_locked_sync;


//------------------------------------------------------------------------------
// Heartbeat LED Logic
//------------------------------------------------------------------------------
always_ff @(posedge apb_clk) begin
  if (rst_sys) begin
    second_cnt                            <= 26'b0;
    heartbeat                             <= 1'b0;
  end else begin
    
    if (second_cnt == HALF_SECOND) begin
      second_cnt                          <= 26'b0;
      heartbeat                           <= ~heartbeat;
    end else begin                
      second_cnt                          <= second_cnt + 1'b1;
    end
  end
end

always_ff @(posedge apb_clk) begin
  FPGA_HB_LED                             <= heartbeat;
end


//------------------------------------------------------------------------------
// Debug LED Logic
//------------------------------------------------------------------------------
dbg_led u_dbg_led (
  .clk                            ( apb_clk             ),
  .rst                            ( rst_sys             ),
  .led                            ( dbg_led_out         )
);

always_ff @(posedge apb_clk) begin
  STX_DBG_LED                           <= dbg_led_out;
end

//------------------------------------------------------------------------------
// APB Clock
//------------------------------------------------------------------------------
assign apb_clk                          = fpga_clk_100;


//------------------------------------------------------------------------------
// Sensor Interface
//------------------------------------------------------------------------------
//sif_clk is connected to jesd_frame_clk, the output of the JESD PLL. The input to
//the JESD PLL is dependent on JESD_USE_FMC_CLK define. 

assign sif_clk  = frame_clk;

//------------------------------------------------------------------------------
// QSFP GPIO
//------------------------------------------------------------------------------
assign QSFP0_LPMODE                     = 1'b0;
assign QSFP0_RESET_L                    = 1'b1;
assign QSFP0_MODSEL_L                   = 1'b0;
assign QSFP0_PWR_EN                     = 1'b1;
assign QSFP1_LPMODE                     = 1'b0;
assign QSFP1_RESET_L                    = 1'b1;
assign QSFP1_MODSEL_L                   = 1'b0;
assign QSFP1_PWR_EN                     = 1'b1;


//------------------------------------------------------------------------------
// Hololink Host Interface PLL
//------------------------------------------------------------------------------
hif_pll hif_pll (
  .rst                            ( !eth_rst_n[0]       ),      //Reset from ethernet core. Released after TX PLL is locked.
  .refclk                         ( eth_clk_div64[0]    ),      //Ethernet IP output clock - div64 (402.83MHz)
  .locked                         ( hif_pll_locked      ),      //Locked
  .outclk_0                       ( /* x1 clk */        ),      //x1 clock output
  .outclk_1                       ( hif_clk             ),      //div2 clock output 201.415MHz
  .outclk_2                       ( ptp_clk             )
);


//------------------------------------------------------------------------------
// General Purpose Registers
//------------------------------------------------------------------------------

//Mode pins from the AD9545
data_sync    #(
  .DATA_WIDTH ( 7                                                                           )
) ad9545_mode_pins_sync (
  .clk        ( apb_clk                                                                     ),
  .rst_n      ( ~apb_rst                                                                    ),
  .sync_in    ({AD9545_M6, AD9545_M5, AD9545_M4, AD9545_M3, AD9545_M2, AD9545_M1, AD9545_M0}),
  .sync_out   (ad9545_mode_pins                                                             )
);


general_purpose_regs #(
  .N_CTRL_REGS                    (4),
  .N_STAT_REGS                    (3)
) u_gen_purpose_regs (
  .i_apb_clk                      (apb_clk),
  .i_apb_rst                      (apb_rst),
  .i_apb_psel                     (apb_psel[4]),
  .i_apb_penable                  (apb_penable),         
  .i_apb_paddr                    (apb_paddr),           
  .i_apb_pwdata                   (apb_pwdata),          
  .i_apb_pwrite                   (apb_pwrite),          
  .o_apb_pready                   (apb_pready[4]),
  .o_apb_prdata                   (apb_prdata[4]),
  .o_apb_pserr                    (apb_pserr[4]),
  //Control Regs
  .o_sw_ad9545_rst                (sw_rst_ad9545),
  .o_sw_fpga_reconfig             (sw_fpga_reconfig),
  .o_clk_chk_en                   (clk_chk_en),
  .o_clk_chk_target               (clk_target),
  .o_clk_chk_tolerance            (clk_tolerance),
  //Status Regs                   
  .i_clk_chk_in_tolerance         (clk_in_tol),
  .i_clk_chk_count                (clk_count),
  .i_ad9545_mode_pins             (ad9545_mode_pins)
);


//------------------------------------------------------------------------------
// Intel 100Gb Host Interfaces
//------------------------------------------------------------------------------
genvar i;
generate
  for (i=0; i<`HOST_IF_INST; i++) begin: ethernet_100gb
    eth_top eth_top_inst  (
      .hif_clk                    ( hif_clk             ),
      .fpga_clk_100               ( fpga_clk_100        ),
      .eth_reset_in               ( rst_sys             ),
      .eth_rdy                    ( eth_rdy[i]          ),
      .heartbeat                  ( heartbeat           ),
                                    
      .eth_clk                    ( eth_clk_div64[i]    ),
      .eth_rst_n                  ( eth_rst_n[i]        ),
      // 25G IO                     
      .i_clk_ref                  ( FPGA_ETH_REFCLK     ),
      .i_rx_serial                ( QSFP_RX_P[i]        ),
      .o_tx_serial                ( QSFP_TX_P[i]        ),
      //RX                          
      .o_eth_axis_rx_tvalid       ( hl_axis_rx_tvalid[i]),
      .o_eth_axis_rx_tdata        ( hl_axis_rx_tdata[i] ),
      .o_eth_axis_rx_tlast        ( hl_axis_rx_tlast[i] ),
      .o_eth_axis_rx_tuser        ( hl_axis_rx_tuser[i] ),
      .o_eth_axis_rx_tkeep        ( hl_axis_rx_tkeep[i] ),
      //TX                          
      .i_eth_axis_tx_tvalid       ( hl_axis_tx_tvalid[i]),
      .i_eth_axis_tx_tdata        ( hl_axis_tx_tdata[i] ),
      .i_eth_axis_tx_tlast        ( hl_axis_tx_tlast[i] ),
      .i_eth_axis_tx_tuser        ( hl_axis_tx_tuser[i] ),
      .i_eth_axis_tx_tkeep        ( hl_axis_tx_tkeep[i] ),
      .o_eth_axis_tx_tready       ( hl_axis_tx_tready[i]),
      //APB                              
      .i_eth_apb_psel             ( apb_psel[i]         ),
      .i_eth_apb_penable          ( apb_penable         ),
      .i_eth_apb_paddr            ( apb_paddr           ),
      .i_eth_apb_pwdata           ( apb_pwdata          ),
      .i_eth_apb_pwrite           ( apb_pwrite          ),
      .o_eth_apb_pready           ( apb_pready[i]       ),
      .o_eth_apb_prdata           ( apb_prdata[i]       ),
      .o_eth_apb_pserr            ( apb_pserr[i]        )
    );
  end
endgenerate


//------------------------------------------------------------------------------
// JESD Core Clock
//------------------------------------------------------------------------------
`ifdef JESD_USE_FMC_CLK
  assign jesd_core_pll_refclk         = FMC_CLK1_M2C_TERM_P;
`else
  assign jesd_core_pll_refclk         = AD9545_CORECLK_P;
`endif
assign jesd_core_dev_clk    = jesd_core_pll_refclk;

//------------------------------------------------------------------------------
// Hololink
//------------------------------------------------------------------------------
HOLOLINK_top
#(
  .BUILD_REV                    (BUILD_REV            )
) u_hololink_top (
  .i_sys_rst                    (sys_rst              ),
  // Control Plane
  .i_apb_clk                    (apb_clk              ),
  .o_apb_rst                    (apb_rst              ),
  // APB Register Interface
  .o_apb_psel                   (apb_psel             ),
  .o_apb_penable                (apb_penable          ),
  .o_apb_paddr                  (apb_paddr            ),
  .o_apb_pwdata                 (apb_pwdata           ),
  .o_apb_pwrite                 (apb_pwrite           ),
  .i_apb_pready                 (apb_pready           ),
  .i_apb_prdata                 (apb_prdata           ),
  .i_apb_pserr                  (apb_pserr            ),
//------------------------------------------------------------------------------
// User Auto Initialization Complete
//------------------------------------------------------------------------------
  .o_init_done                  (hololink_init_done   ),  
//------------------------------------------------------------------------------
// Sensor IF
//------------------------------------------------------------------------------
  // Sensor Rx Interface Clock and Reset
  .i_sif_rx_clk                 (sif_clk              ),
  .o_sif_rx_rst                 (sif_rst              ),
   // Sensor Tx Interface Clock and Reset
  .i_sif_tx_clk                 (sif_clk              ),
  .o_sif_tx_rst                 (                     ),
  // Sensor Rx Streaming Interface
  .i_sif_axis_tvalid            (sif_rx_tvalid        ),
  .i_sif_axis_tlast             ('0                   ),
  .i_sif_axis_tdata             (sif_rx_tdata         ),
  .i_sif_axis_tkeep             ('{default:'1}        ),
  .i_sif_axis_tuser             ('{default:0}         ),
  .o_sif_axis_tready            (sif_rx_tready        ),
  // Sensor Tx Streaming Interface
  .o_sif_axis_tvalid            (sif_tx_tvalid        ),
  .o_sif_axis_tlast             (                     ),
  .o_sif_axis_tdata             (sif_tx_tdata         ),
  .o_sif_axis_tkeep             (                     ),
  .o_sif_axis_tuser             (                     ),
  .i_sif_axis_tready            (sif_tx_tready        ),
  // Sensor Event
  .i_sif_event                  ('b0                  ),
//------------------------------------------------------------------------------
// Host IF
//------------------------------------------------------------------------------
  // Host Interface Clock and Reset
  .i_hif_clk                    (hif_clk              ),
  .o_hif_rst                    (                     ),
  // Host Rx Interface
  .i_hif_axis_tvalid            (hl_axis_rx_tvalid    ),
  .i_hif_axis_tlast             (hl_axis_rx_tlast     ),
  .i_hif_axis_tdata             (hl_axis_rx_tdata     ),
  .i_hif_axis_tkeep             (hl_axis_rx_tkeep     ),
  .i_hif_axis_tuser             (hl_axis_rx_tuser     ),
  .o_hif_axis_tready            (                     ),
  // Host Tx Interface
  .o_hif_axis_tvalid            (hl_axis_tx_tvalid    ),
  .o_hif_axis_tlast             (hl_axis_tx_tlast     ),
  .o_hif_axis_tdata             (hl_axis_tx_tdata     ),
  .o_hif_axis_tkeep             (hl_axis_tx_tkeep     ),
  .o_hif_axis_tuser             (hl_axis_tx_tuser     ),
  .i_hif_axis_tready            (hl_axis_tx_tready    ),
//------------------------------------------------------------------------------
// Peripheral IF
//------------------------------------------------------------------------------
  // SPI Interface, QSPI compatable
  .o_spi_csn                    (spi_csn              ),
  .o_spi_sck                    (spi_sck              ),
  .i_spi_sdio                   (spi_sdio_i           ),
  .o_spi_sdio                   (spi_sdio_o           ),
  .o_spi_oen                    (spi_oen              ),
  // I2C Interface
  .i_i2c_scl                    (i2c_scl              ),
  .i_i2c_sda                    (i2c_sda              ),
  .o_i2c_scl_en                 (i2c_scl_en           ),
  .o_i2c_sda_en                 (i2c_sda_en           ),
  // GPIO
  .o_gpio                       (hl_gpio              ),
  .i_gpio                       ('b0                  ),
//------------------------------------------------------------------------------
// sensor reset
//------------------------------------------------------------------------------
  .o_sw_sys_rst                 (hl_sw_rst),
  .o_sw_sen_rst                 (),
//------------------------------------------------------------------------------
// PTP
//------------------------------------------------------------------------------
  .i_ptp_clk                    ( ptp_clk           ),
  .o_ptp_rst                    ( ptp_rst           ),
  .o_ptp_sec                    ( ptp_sec           ),
  .o_ptp_nanosec                ( ptp_nano          ),
  .o_pps                        ( sys_pps           )
);


//------------------------------------------------------------------------------
// I2C Interface
//------------------------------------------------------------------------------

  // Adding a glitch filter, but can be removed if IO pads itself provides glitch filtering
  glitch_filter  #(
    .DATA_WIDTH   ( 4                                                   ),
    .RESET_VALUE  ( 1'b1                                  ),
    .FILTER_DEPTH ( 8                                     )
  ) i2c_glitch_filter (
    .clk          ( apb_clk                               ),
    .rst_n        (~apb_rst                               ),
    .sync_in      ({FPGA_EEPROM_SDA, FPGA_EEPROM_SCL,             
                    AD9545_SDA,      AD9545_SCK                         }),
    .sync_out     ({fpga_eeprom_i2c_sda_sync, fpga_eeprom_i2c_scl_sync,
                    ad9545_i2c_sda_sync,      ad9545_i2c_scl_sync       })
  );

  assign i2c_scl[0]   = i2c_scl_en[0] ? fpga_eeprom_i2c_scl_sync : 1'b0;
  assign i2c_sda[0]   = i2c_sda_en[0] ? fpga_eeprom_i2c_sda_sync : 1'b0;
  assign i2c_scl[1]   = i2c_scl_en[1] ? ad9545_i2c_scl_sync  : 1'b0;
  assign i2c_sda[1]   = i2c_sda_en[1] ? ad9545_i2c_sda_sync  : 1'b0;
  
  assign FPGA_EEPROM_SCL = i2c_scl_en[0] ? 1'bz : 1'b0;
  assign FPGA_EEPROM_SDA = i2c_sda_en[0] ? 1'bz : 1'b0;
  assign AD9545_SCK       = i2c_scl_en[1] ? 1'bz : 1'b0;
  assign AD9545_SDA       = i2c_sda_en[1] ? 1'bz : 1'b0;
  

//------------------------------------------------------------------------------
// SPI Interface
//------------------------------------------------------------------------------

  data_sync    #(
    .DATA_WIDTH ( 1                                      )
  ) adi_spi_glitch_filter (
    .clk        ( apb_clk                                ),
    .rst_n      ( ~apb_rst                               ),
    .sync_in    (FMC_LA05_N ),
    .sync_out   (adi_spi_miso_sync)
  );
  
  data_sync    #(
    .DATA_WIDTH ( 1                                      )
  ) hmc_spi_glitch_filter (
    .clk        ( apb_clk                                ),
    .rst_n      ( ~apb_rst                               ),
    .sync_in    (FMC_LA12_N ),
    .sync_out   (hmc_spi_sdio_sync)
  );

  // ADI ADC/DAC SPI
  assign adi_miso       = adi_spi_miso_sync;
  assign adi_mosi       = spi_sdio_o[0][0];  
  assign spi_sdio_i[0]  = {1'b0, 1'b0, adi_miso, 1'b0};
  
  // HMC SPI
  assign FMC_LA12_N     = hmc_sdio;
  assign hmc_sdio       = spi_oen   [1] ? spi_sdio_o[1][0] : 1'bz;
  assign spi_sdio_i[1]  = {1'b0, 1'b0, hmc_spi_sdio_sync, hmc_spi_sdio_sync};
  
  always_ff @(posedge apb_clk) begin
    FMC_LA04_N      <= spi_sck   [0];
    FMC_LA05_P      <= spi_csn   [0];
    FMC_LA04_P      <= adi_mosi;
    FMC_LA12_P      <= spi_csn   [1];
    FMC_LA11_P      <= spi_sck   [1];
  end


//------------------------------------------------------------------------------
// Intel Mailbox IP for QSPI configuration/remote system update
//------------------------------------------------------------------------------
mailbox_top u_mailbox_top (
  .apb_clk                        (apb_clk),
  .apb_rst                        (apb_rst),
  .i_mailbox_apb_psel             (apb_psel[2]),   
  .i_mailbox_apb_penable          (apb_penable),
  .i_mailbox_apb_paddr            (apb_paddr),  
  .i_mailbox_apb_pwdata           (apb_pwdata), 
  .i_mailbox_apb_pwrite           (apb_pwrite), 
  .o_mailbox_apb_pready           (apb_pready[2]),           
  .o_mailbox_apb_prdata           (apb_prdata[2]),           
  .o_mailbox_apb_pserr            (apb_pserr[2])
);


//------------------------------------------------------------------------------
// GPIO Signals needed for MxFE board
//------------------------------------------------------------------------------
logic           [3:0]           hl_gpio_sync_in;
logic           [3:0]           hl_gpio_sync_out;

assign hl_gpio_sync_in      = {hl_gpio[3], hl_gpio[2], hl_gpio[1], hl_gpio[0]};
data_sync #(
  .DATA_WIDTH             (4) 
) hl_gpio_sync (
  .clk                    (apb_clk),
  .rst_n                  (!rst_sys),
  .sync_in                (hl_gpio_sync_in),
  .sync_out               (hl_gpio_sync_out)
);
always_ff @(posedge apb_clk) begin
  FMC_PWR_EN            <= hl_gpio_sync_out[0];
  FPGA_PG_C2M           <= hl_gpio_sync_out[1];
  FMC_LA07_P            <= hl_gpio_sync_out[2];
  FMC_LA22_P            <= hl_gpio_sync_out[3];
end


//------------------------------------------------------------------------------
// Miscellaneous
//------------------------------------------------------------------------------
always_ff @(posedge apb_clk) begin
  FPGA_RECONFIG                   <= sw_fpga_reconfig;
end

always_ff @(posedge ptp_clk) begin
  DBG_HEADER                      <= {15'h7FFF, sys_pps_stretch};
end

//------------------------------------------------------------------------------
// Misc. Logic
//------------------------------------------------------------------------------
always_ff @(posedge apb_clk) begin
  AD9545_RESETB                   <= !sw_rst_ad9545;
end


assign clk_checker_source       = frame_clk;

clock_checker #(
) u_clk_chk (
  .test_clk                       ( clk_checker_source                                    ),                             
  .rst                            ( apb_rst                                               ),                                  
  .en                             ( clk_chk_en                                            ),
  .test_clk_target                ( clk_target                                            ),
  .test_clk_tol                   ( clk_tolerance                                         ),
  .latch_count                    ( heartbeat                                             ),
  .clk_in_tolerance               ( clk_in_tol                                            ),
  .last_clk_count                 ( clk_count                                             )
);


//Tie off unused APB bus signals. 
assign apb_pserr[3]         = 1'b0;
assign apb_pready[3]        = 1'b1;
assign apb_prdata[3]        = '{default:0};
assign apb_pserr[6]         = 1'b0;
assign apb_pready[6]        = 1'b1;
assign apb_prdata[6]        = '{default:0};

//------------------------------------------------------------------------------
// PPS
//------------------------------------------------------------------------------
assign timer_done = timer_cnt[17];
  always_ff @ (posedge ptp_clk) begin
    if (ptp_rst) begin 
      sys_pps_stretch <= 1'b0;
      timer_cnt   <= '0;
    end else begin
      if (sys_pps) begin
        sys_pps_stretch <= 1'b1;
      end else if (timer_done) begin
        timer_cnt   <= '0;
        sys_pps_stretch <= 1'b0;
      end else if (sys_pps_stretch) begin
        timer_cnt   <= timer_cnt + 1'b1;
      end
    end
  end

//------------------------------------------------------------------------------
// Altera JESD204C interface data mapping
//------------------------------------------------------------------------------

// One Converter = One Lane
// I and Q converter per Device
// 16b per sample, one sample per converter
// D = Device
// I = I sample
// Q = Q sample

// For Altera JESD, each 128b of 512b bus contains one sample for each converter
// Arranged as IQ pairs
// 4 samples total for each converter in 512b
// 127:0    = D0{I3,Q3}, D1{I3,Q3}, D2{I3,Q3}, D3{I3,Q3}
// 255:128  = D0{I2,Q2}, D1{I2,Q2}, D2{I2,Q2}, D3{I2,Q2}
// 383:256  = D0{I1,Q1}, D1{I1,Q1}, D2{I1,Q1}, D3{I1,Q1}
// 511:384  = D0{I0,Q0}, D1{I0,Q0}, D2{I0,Q0}, D3{I0,Q0}

// HSB SW expects all 4 samples for a Converter to be contiguous
// 127:0    = D0{Q0,Q1,Q2,Q3}, D0{I0,I1,I2,I3}
// 255:128  = D1{Q0,Q1,Q2,Q3}, D1{I0,I1,I2,I3}
// 383:256  = D2{Q0,Q1,Q2,Q3}, D2{I0,I1,I2,I3}
// 511:384  = D3{Q0,Q1,Q2,Q3}, D3{I0,I1,I2,I3}

// Replicate Tx data
// Device 0
// I & Q samples 0
assign jesd_tx_data[511:496] = sif_tx_tdata[0][63:48];
assign jesd_tx_data[495:480] = sif_tx_tdata[0][127:112];
// I & Q samples 1
assign jesd_tx_data[383:368] = sif_tx_tdata[0][47:32];
assign jesd_tx_data[367:352] = sif_tx_tdata[0][111:96];
// I & Q samples 2
assign jesd_tx_data[255:240] = sif_tx_tdata[0][31:16];
assign jesd_tx_data[239:224] = sif_tx_tdata[0][95:80];
// I & Q samples 3
assign jesd_tx_data[127:112] = sif_tx_tdata[0][15:0];
assign jesd_tx_data[111:96]  = sif_tx_tdata[0][79:64];

// Device 1
// I & Q samples 0
assign jesd_tx_data[479:464] = sif_tx_tdata[0][63:48];
assign jesd_tx_data[463:448] = sif_tx_tdata[0][127:112];
// I & Q samples 1
assign jesd_tx_data[351:336] = sif_tx_tdata[0][47:32];
assign jesd_tx_data[335:320] = sif_tx_tdata[0][111:96];
// I & Q samples 2
assign jesd_tx_data[223:208] = sif_tx_tdata[0][31:16];
assign jesd_tx_data[207:192] = sif_tx_tdata[0][95:80];
// I & Q samples 3
assign jesd_tx_data[95:80]   = sif_tx_tdata[0][15:0];
assign jesd_tx_data[79:64]   = sif_tx_tdata[0][79:64];

// Device 2
// I & Q samples 0
assign jesd_tx_data[447:432] = sif_tx_tdata[0][63:48];
assign jesd_tx_data[431:416] = sif_tx_tdata[0][127:112];
// I & Q samples 1
assign jesd_tx_data[319:304] = sif_tx_tdata[0][47:32];
assign jesd_tx_data[303:288] = sif_tx_tdata[0][111:96];
// I & Q samples 2
assign jesd_tx_data[191:176] = sif_tx_tdata[0][31:16];
assign jesd_tx_data[175:160] = sif_tx_tdata[0][95:80];
// I & Q samples 3
assign jesd_tx_data[63:48]   = sif_tx_tdata[0][15:0];
assign jesd_tx_data[47:32]   = sif_tx_tdata[0][79:64];

// Device 3
// I & Q samples 0
assign jesd_tx_data[415:400] = sif_tx_tdata[0][63:48];
assign jesd_tx_data[399:384] = sif_tx_tdata[0][127:112];
// I & Q samples 1
assign jesd_tx_data[287:272] = sif_tx_tdata[0][47:32];
assign jesd_tx_data[271:256] = sif_tx_tdata[0][111:96];
// I & Q samples 2
assign jesd_tx_data[159:144] = sif_tx_tdata[0][31:16];
assign jesd_tx_data[143:128] = sif_tx_tdata[0][95:80];
// I & Q samples 3
assign jesd_tx_data[31:16]   = sif_tx_tdata[0][15:0];
assign jesd_tx_data[15:0]    = sif_tx_tdata[0][79:64];

// Tx control signals
assign jesd_tx_valid    = sif_tx_tvalid[0];
assign sif_tx_tready[0] = jesd_tx_ready;

// Drop all Rx data other than ADC0
// I & Q samples 0
assign sif_rx_tdata[0][63:48]   = jesd_rx_data[511:496];
assign sif_rx_tdata[0][127:112] = jesd_rx_data[495:480];
// I & Q samples 1
assign sif_rx_tdata[0][47:32]   = jesd_rx_data[383:368];
assign sif_rx_tdata[0][111:96]  = jesd_rx_data[367:352];
// I & Q samples 2
assign sif_rx_tdata[0][31:16]   = jesd_rx_data[255:240];
assign sif_rx_tdata[0][95:80]   = jesd_rx_data[239:224];
// I & Q samples 3
assign sif_rx_tdata[0][15:0]    = jesd_rx_data[127:112];
assign sif_rx_tdata[0][79:64]   = jesd_rx_data[111:96];

// Rx control signals
assign sif_rx_tvalid[0] = jesd_rx_valid;
assign jesd_rx_ready    = sif_rx_tready[0];


// Instantiate the Alera JESD PD subsystem
jesd_ss u_alt_jesd_ss (
  // AVMM clock and reset
  .clk_100_in_clk                   (apb_clk),               //   input,    width = 1,       clk_100_in.clk
  .rst_100_in0_reset                (apb_rst),               //   input,    width = 1,      rst_100_in0.reset
  
  // JESD PLL
  .iopll_0_refclk_clk               (jesd_core_pll_refclk),  //   input,    width = 1,   iopll_0_refclk.clk
  // Outputs exported for phase clock generation
  // SIF Clock should use the frame clock
  .frame_clk_out_clk                (frame_clk),             //  output,    width = 1,    frame_clk_out.clk
  .link_clk_out_clk                 (link_clk),              //  output,    width = 1,     link_clk_out.clk

  // Use Ethernet refclock for intial configuration, SW switches to JESD refclk once that clock is configured
  .xcvr_refclk_in_clk               (FPGA_ETH_REFCLK),       //   input,    width = 1,   xcvr_refclk_in.clk
  
  // Serial Data Lanes
  .rx_serial_data_export            (JESD_RXDP),             //   input,    width = 8,   rx_serial_data.export
  .rx_serial_data_n_export          (JESD_RXDN),             //   input,    width = 8, rx_serial_data_n.export
  .tx_serial_data_export            (JESD_TXDP),             //  output,    width = 8,   tx_serial_data.export
  .tx_serial_data_n_export          (JESD_TXDN),             //  output,    width = 8, tx_serial_data_n.export
  
  // ED drives lclk_ctrl high and generates a logical phase signal for fclk_ctrl
  .txlclk_ctrl_export               (1'b1),                  //   input,    width = 1,      txlclk_ctrl.export
  .txfclk_ctrl_export               (w_phase_x2x4),          //   input,    width = 1,      txfclk_ctrl.export
  .rxlclk_ctrl_export               (1'b1),                  //   input,    width = 1,      rxlclk_ctrl.export
  .rxfclk_ctrl_export               (w_phase_x2x4),          //   input,    width = 1,      rxfclk_ctrl.export
  
  // JESD AVST Tx
  .tx_avst_data                     (jesd_tx_data),          //   input,    width = 512,        tx_avst.data
  .tx_avst_valid                    (jesd_tx_valid),         //   input,    width = 1,                 .valid
  .tx_avst_ready                    (jesd_tx_ready),         //  output,    width = 1,                 .ready
    
  // JESD AVST Rx
  .rx_avst_data                     (jesd_rx_data),          //  output,    width = 512,        rx_avst.data
  .rx_avst_valid                    (jesd_rx_valid),         //  output,    width = 1,                 .valid
  .rx_avst_ready                    (jesd_rx_ready),         //   input,    width = 1,                 .ready

  // Safe state control signals for this design
  .tx_avst_control_export           (1'b0),                  //   input,    width = 1,  tx_avst_control.export
  .rx_avst_control_export           (),                      //  output,    width = 1,  rx_avst_control.export
  
  // CMD bus safe stated in this design
  .tx_cmd_data                      ({48{1'b0}}),            //   input,   width = 48,           tx_cmd.data
  .tx_cmd_valid                     (1'b0),                  //   input,    width = 1,                 .valid
  .tx_cmd_ready                     (),                      //  output,    width = 1,                 .ready

  .rx_cmd_data                      (),                      //  output,   width = 48,           rx_cmd.data
  .rx_cmd_valid                     (),                      //  output,    width = 1,                 .valid
  .rx_cmd_ready                     (1'b1),                  //   input,    width = 1,                 .ready
  .rx_cmd_par_err_export            (),                      //  output,    width = 8,   rx_cmd_par_err.export

  // Sysref required only with subclass 1, setting to 0 for this design
  .tx_sysref_export                 (1'b0),                  //   input,    width = 1,        tx_sysref.export
  .rx_sysref_export                 (1'b0),                  //   input,    width = 1,        rx_sysref.export

  // Start of multiblock/extended multiblock - leave open
  .tx_somb_export                   (),                      //  output,    width = 1,          tx_somb.export
  .tx_soemb_export                  (),                      //  output,    width = 1,         tx_soemb.export
  .rx_somb_export                   (),                      //  output,    width = 1,          rx_somb.export
  .rx_soemb_export                  (),                      //  output,    width = 1,         rx_soemb.export

  // IRQs - leave open
  .tx_int_irq                       (),                      //  output,    width = 1,           tx_int.irq
  .rx_int_irq                       (),                      //  output,    width = 1,           rx_int.irq
  
  // Tx Control and Status - leave open
  .tx_csr_l_export                  (),                      //  output,    width = 4,         tx_csr_l.export
  .tx_csr_f_export                  (),                      //  output,    width = 8,         tx_csr_f.export
  .tx_csr_m_export                  (),                      //  output,    width = 8,         tx_csr_m.export
  .tx_csr_cs_export                 (),                      //  output,    width = 2,        tx_csr_cs.export
  .tx_csr_n_export                  (),                      //  output,    width = 5,         tx_csr_n.export
  .tx_csr_np_export                 (),                      //  output,    width = 5,        tx_csr_np.export
  .tx_csr_s_export                  (),                      //  output,    width = 5,         tx_csr_s.export
  .tx_csr_hd_export                 (),                      //  output,    width = 1,        tx_csr_hd.export
  .tx_csr_cf_export                 (),                      //  output,    width = 5,        tx_csr_cf.export
  .tx_csr_e_export                  (),                      //  output,    width = 8,         tx_csr_e.export
  .tx_csr_testmode_export           (),                      //  output,    width = 4,  tx_csr_testmode.export
  
  // Rx Control and Status - leave open
  .rx_csr_l_export                  (),                      //  output,    width = 4,         rx_csr_l.export
  .rx_csr_f_export                  (),                      //  output,    width = 8,         rx_csr_f.export
  .rx_csr_m_export                  (),                      //  output,    width = 8,         rx_csr_m.export
  .rx_csr_cs_export                 (),                      //  output,    width = 2,        rx_csr_cs.export
  .rx_csr_n_export                  (),                      //  output,    width = 5,         rx_csr_n.export
  .rx_csr_np_export                 (),                      //  output,    width = 5,        rx_csr_np.export
  .rx_csr_s_export                  (),                      //  output,    width = 5,         rx_csr_s.export
  .rx_csr_hd_export                 (),                      //  output,    width = 1,        rx_csr_hd.export
  .rx_csr_cf_export                 (),                      //  output,    width = 5,        rx_csr_cf.export
  .rx_csr_e_export                  (),                      //  output,    width = 8,         rx_csr_e.export
  .rx_csr_testmode_export           (),                      //  output,    width = 4,  rx_csr_testmode.export
  
  
  // Lock status
  .rx_sh_lock_export                (jesd_rx_sh_lock),       //  output,    width = 1,       rx_sh_lock.export
  .rx_emb_lock_export               (jesd_rx_emb_lock),      //  output,    width = 1,      rx_emb_lock.export

  // CRC Error - leave open
  .rx_crc_err_export                (),                      //  output,    width = 8,       rx_crc_err.export
  
  // Ready signals
  .rx_ready_export                  (jesd_rx_lane_ready),    //  output,    width = 8,         rx_ready.export
  .tx_ready_export                  (jesd_tx_lane_ready),    //  output,    width = 8,         tx_ready.export
  
  // AVMM Word addressed bus
  .mm_bridge_0_waitrequest          (jesd_avmm_waitrequest),   //  output,    width = 1,      mm_bridge_0.waitrequest
  .mm_bridge_0_readdata             (jesd_avmm_readdata),      //  output,   width = 32,                 .readdata
  .mm_bridge_0_readdatavalid        (jesd_avmm_readdatavalid), //  output,    width = 1,                 .readdatavalid
  .mm_bridge_0_burstcount           (1'b1),                    //   input,    width = 1,                 .burstcount
  .mm_bridge_0_writedata            (jesd_avmm_writedata),     //   input,   width = 32,                 .writedata
  .mm_bridge_0_address              (jesd_avmm_address),       //   input,   width = 23,                 .address
  .mm_bridge_0_write                (jesd_avmm_write),         //   input,    width = 1,                 .write
  .mm_bridge_0_read                 (jesd_avmm_read),          //   input,    width = 1,                 .read
  .mm_bridge_0_byteenable           (4'b1111),                 //   input,    width = 4,                 .byteenable
  .mm_bridge_0_debugaccess          (1'b0),                    //   input,    width = 1,                 .debugaccess
  
  // AVMM Byte addressed bus
  .mm_bridge_byteaddr_waitrequest   (xcvr_avmm_waitrequest),    //  output,    width = 1, mm_bridge_byteaddr.waitrequest
	.mm_bridge_byteaddr_readdata      (xcvr_avmm_readdata),       //  output,    width = 8,                   .readdata
	.mm_bridge_byteaddr_readdatavalid (xcvr_avmm_readdatavalid),  //  output,    width = 1,                   .readdatavalid
	.mm_bridge_byteaddr_burstcount    (1'b1),                     //   input,    width = 1,                   .burstcount
	.mm_bridge_byteaddr_writedata     (xcvr_avmm_writedata),      //   input,    width = 8,                   .writedata
	.mm_bridge_byteaddr_address       (xcvr_avmm_address),        //   input,   width = 22,                   .address
	.mm_bridge_byteaddr_write         (xcvr_avmm_write),          //   input,    width = 1,                   .write
	.mm_bridge_byteaddr_read          (xcvr_avmm_read),           //   input,    width = 1,                   .read
	.mm_bridge_byteaddr_byteenable    (1'b1),                     //   input,    width = 1,                   .byteenable
	.mm_bridge_byteaddr_debugaccess   (1'b0)                      //   input,    width = 1,                   .debugaccess

);

//------------------------------------------------------------------------------
// APB to AVMM translation for JESD subsystem word addressed bus
//------------------------------------------------------------------------------
avmm_to_apb #(
  .AVMM_ADDR_WIDTH                  (32),
  .AVMM_DATA_WIDTH                  (32),
  .USE_AVMM_READDATAVALID           (1),
  .AVMM_RD_LATENCY                  (0)         
) u_jesd_avmm_to_apb (
  .clk                              (apb_clk),
  .rst                              (apb_rst),
  
  .psel                             (apb_psel[5]),
  .penable                          (apb_penable),
  .paddr                            (apb_paddr),
  .pwrite                           (apb_pwrite),
  .pwdata                           (apb_pwdata),
  .pready                           (apb_pready[5]),
  .prdata                           (apb_prdata[5]),
  .pserr                            (apb_pserr[5]),
  
  .avmm_address                     (jesd_avmm_address),
  .avmm_write                       (jesd_avmm_write),
  .avmm_writedata                   (jesd_avmm_writedata),
  .avmm_read                        (jesd_avmm_read),
  .avmm_readdata                    (jesd_avmm_readdata),
  .avmm_readdatavalid               (jesd_avmm_readdatavalid),
  .avmm_waitrequest                 (jesd_avmm_waitrequest)
);

//------------------------------------------------------------------------------
// APB to AVMM translation for JESD subsystem Byte addressed bus
//------------------------------------------------------------------------------
avmm_to_apb #(
  .AVMM_ADDR_WIDTH                  (32),
  .AVMM_DATA_WIDTH                  (32),
  .USE_AVMM_READDATAVALID           (1),
  .AVMM_RD_LATENCY                  (0)         
) u_xvcr_avmm_to_apb (
  .clk                              (apb_clk),
  .rst                              (apb_rst),
  
  .psel                             (apb_psel[7]),
  .penable                          (apb_penable),
  .paddr                            ({2'b00, apb_paddr[31:2]}),
  .pwrite                           (apb_pwrite),
  .pwdata                           (apb_pwdata),
  .pready                           (apb_pready[7]),
  .prdata                           (apb_prdata[7]),
  .pserr                            (apb_pserr[7]),
  
  .avmm_address                     (xcvr_avmm_address),
  .avmm_write                       (xcvr_avmm_write),
  .avmm_writedata                   (xcvr_avmm_writedata),
  .avmm_read                        (xcvr_avmm_read),
  .avmm_readdata                    (xcvr_avmm_readdata),
  .avmm_readdatavalid               (xcvr_avmm_readdatavalid),
  .avmm_waitrequest                 (xcvr_avmm_waitrequest)
);

//------------------------------------------------------------------------------
// Phase offset logic from ALtera JESD example design
//------------------------------------------------------------------------------
// generate 2x and 4x phase relationship
logic link_div2 = 1'b0; 
logic link_div2_d_fclk = 1'b0;
logic w_phase_x2x4;

// create a signal which is div2 of link_clk
always @(posedge link_clk ) begin
    link_div2 <= ~link_div2;
end

// Delay div2 of link_clk by using the faster frame clock. Then XOR the
// difference to create a phase pulse
always @(posedge frame_clk) begin
    link_div2_d_fclk <= link_div2;
end

// fixed relationship so can use w_phase_x2x4 without further logic from example
assign w_phase_x2x4 = link_div2 ^ link_div2_d_fclk;


endmodule
