# Holoscan Sensor Bridge 100GbE Design for Terasic Stratix 10 Sensor Processing Kit

## Overview

This design implements the
[NVIDIA Holoscan Sensor Bridge](https://docs.nvidia.com/holoscan/sensor-bridge/2-7/getting-started/build)
on the [Terasic Stratix 10 Sensor Processing Kit](http://s10spk.terasic.com/) (HSB
100G). The FPGA connects to an NVIDIA IGX Orin host over two 100GbE QSFP links and to an
Analog Devices EVAL-AD9986 MxFE board over FMC+ (JESD204C, 8 lanes). The bundled
`signal_generator` demo sends I/Q samples from the host to the AD9986 DAC and streams
ADC data back to the host via RoCE.

- Device: Stratix 10 `1ST040EH2F35E2VG`
- Tool: Altera Quartus Prime Pro Edition 26.1

## Documentation

Hardware setup, host setup, Yocto SPI VM build, demo container build, running the demo
and FPGA firmware update are described in the **HSB 100G User Guide**, available on the
[Terasic Stratix 10 Sensor Processing Kit website](http://s10spk.terasic.com/cd).

## Pre-built FPGA Image

Known-working FPGA images (`.rpd` for in-system update with `hololink program`) are
published on the
[Releases page](https://github.com/terasic/holoscan-sensor-bridge/releases). See the
"Update the FPGA Firmware" section of the user guide for the update procedure.

## Building from Source

The project expects the NVIDIA HSB IP at `fpga/nv_hsb_ip` (paths are set in
`synth/hsb_100g.qsf`).

```bash
cd synth
quartus_sh --flow compile hsb_100g
quartus_pfg -c hsb_100g-application.pfg   # generates output_files/hsb_100g-application.rpd
```
