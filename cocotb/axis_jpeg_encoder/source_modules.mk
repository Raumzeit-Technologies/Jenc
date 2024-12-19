#
# Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
#
# GPL-3.0 license
#
# Copyright (C) 2024 Robert Metchev
#

VERILOG_INCLUDE_DIRS += $(realpath ../.. ../../jpeg_encoder ../../jpeg_encoder/jisp  ../../jpeg_encoder/jenc ../../jpeg_encoder/jlib .)

# JISP
VERILOG_FILES += \
        ../../jpeg_encoder/jisp/jisp.sv \
        ../../jpeg_encoder/jisp/mcu_buffer.sv \
        ../../jpeg_encoder/jisp/rgb2yuv.sv \
        ../../jpeg_encoder/jisp/subsample.sv

# JENC
VERILOG_FILES += \
        ../../jpeg_encoder/jpeg_encoder.sv \
        ../../jpeg_encoder/jenc/jenc.sv \
        ../../jpeg_encoder/jenc/dct_1d_aan.sv \
        ../../jpeg_encoder/jenc/dct_2d.sv \
        ../../jpeg_encoder/jenc/transpose.sv \
        ../../jpeg_encoder/jenc/zigzag.sv \
        ../../jpeg_encoder/jenc/quant.sv \
        ../../jpeg_encoder/jenc/quant_tables.sv \
        ../../jpeg_encoder/jenc/entropy.sv \
        ../../jpeg_encoder/jenc/huff_tables.sv \
        ../../jpeg_encoder/jenc/bit_pack.sv \
        ../../jpeg_encoder/jenc/byte_pack.sv \
        ../../jpeg_encoder/jenc/ff00.sv \
        ../../jpeg_encoder/jlib/psync1.sv \
        ../../jpeg_encoder/jlib/afifo.v

#        ../../jpeg_encoder/jenc/quant_seq_mult_15x13_p4.sv

# Camera
VERILOG_FILES += \
        ../../image_buffer.sv \
        ../../spi_registers.sv \
        ../../jpeg_encoder/jenc_cdc.sv \
        ../../crop.sv \
        ../../debayer.sv \
        ../../metering.sv \
        ../../camera.sv \

# Top
VERILOG_FILES += \
        ../../../../top.sv \
        ../../../spi/spi_peripheral.sv \
        ../../../spi/spi_register.sv \
        ../../../pll/pll_wrapper.sv \
        ../../../graphics/color_palette.sv \
        ../../../graphics/display_buffers.sv \
        ../../../graphics/display_driver.sv \
        ../../../graphics/graphics.sv \
        ../../../graphics/sprite_engine.sv \

# inferrable RAM models
VERILOG_FILES += \
        ../../jpeg_encoder/jlib/dp_ram.sv
        
ifneq ($(SIM),modelsim)
VERILOG_FILES += \
        ../../jpeg_encoder/jlib/dp_ram_be.sv
endif

ifeq ($(SIM),modelsim)
# Lattice verif models
VERILOG_FILES += \
        ../../testbenches/csi/source/csi/csi2_transmitter_ip/rtl/csi2_transmitter_ip.v \
        ../../testbenches/csi/source/csi/pixel_to_byte_ip/rtl/pixel_to_byte_ip.v \
        ../../testbenches/csi/source/csi/pll_sim_ip/rtl/pll_sim_ip.v

# RAM/ROM as EBR
VERILOG_FILES += \
        ../../jpeg_encoder/jlib/huffman_codes_rom_EBR.sv \
        ../../jpeg_encoder/jlib/ram_dp_w32_b4_d64_EBR.sv \
        ../../jpeg_encoder/jlib/ram_dp_w64_b8_d1440_EBR.sv \
        ../../jpeg_encoder/jlib/ram_dp_w64_b8_d2880_EBR.sv 

# Lattice models
#VERILOG_FILES += \
#        ../../../../radiant/huffman_codes_rom/ipgen/rtl/huffman_codes_rom.v \
#        ../../../../radiant/jenc/ram_dp_w32_b4_d64/rtl/ram_dp_w32_b4_d64.v \
#        ../../../../radiant/jisp/ram_dp_w18_d360/rtl/ram_dp_w18_d360.v \
#        ../../../../radiant/jisp/ram_dp_w64_b8_d2880/rtl/ram_dp_w64_b8_d2880.v \
#        ../../../../radiant/jisp/ram_dp_w64_b8_d1440/rtl/ram_dp_w64_b8_d1440.v \
#        ../../../../radiant/image_buffer/large_ram_dp_w32_d16k_q/rtl/large_ram_dp_w32_d16k_q.v

VERILOG_FILES += \
        ../../../../radiant/csi2_receiver_ip/rtl/csi2_receiver_ip.v \
        ../../../../radiant/byte_to_pixel_ip/rtl/byte_to_pixel_ip.v \
        ../../../../radiant/pll_ip/rtl/pll_ip.v
endif

VERILOG_SOURCES += $(realpath $(VERILOG_FILES))
