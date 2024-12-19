#
# Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
#
# GPL-3.0 license
#
# Copyright (C) 2024 Robert Metchev
#

#VERILOG_INCLUDE_DIRS += $(realpath ../.. ../../jpeg_encoder ../../jpeg_encoder/jisp  ../../jpeg_encoder/jenc ../../jpeg_encoder/jlib .)
VERILOG_INCLUDE_DIRS += $(realpath ../../rtl/axis_jpeg_encoder ../../rtl/frame_jpeg_encoder ../../rtl/frame_jpeg_encoder/jisp ../../rtl/frame_jpeg_encoder/jenc)

# axis_jpeg
VERILOG_FILES += \
        ../../rtl/axis_jpeg_encoder/axis_jpeg_encoder.sv \
        ../../rtl/axis_jpeg_encoder/japb.sv \
        ../../rtl/axis_jpeg_encoder/jaxis_video_slave.sv 
 
# JISP
VERILOG_FILES += \
        ../../rtl/frame_jpeg_encoder/jisp/jisp.sv \
        ../../rtl/frame_jpeg_encoder/jisp/mcu_buffer.sv \
        ../../rtl/frame_jpeg_encoder/jisp/rgb2yuv.sv \
        ../../rtl/frame_jpeg_encoder/jisp/subsample.sv


# JENC
VERILOG_FILES += \
        ../../rtl/frame_jpeg_encoder/jpeg_encoder.sv \
        ../../rtl/frame_jpeg_encoder/jenc/jenc.sv \
        ../../rtl/frame_jpeg_encoder/jenc/dct_1d_aan.sv \
        ../../rtl/frame_jpeg_encoder/jenc/dct_2d.sv \
        ../../rtl/frame_jpeg_encoder/jenc/transpose.sv \
        ../../rtl/frame_jpeg_encoder/jenc/zigzag.sv \
        ../../rtl/frame_jpeg_encoder/jenc/quant.sv \
        ../../rtl/frame_jpeg_encoder/jenc/quant_tables.sv \
        ../../rtl/frame_jpeg_encoder/jenc/entropy.sv \
        ../../rtl/frame_jpeg_encoder/jenc/huff_tables.sv \
        ../../rtl/frame_jpeg_encoder/jenc/bit_pack.sv \
        ../../rtl/frame_jpeg_encoder/jenc/byte_pack.sv \
        ../../rtl/frame_jpeg_encoder/jenc/ff00.sv

# LIBS
VERILOG_FILES += \
        ../../rz-lib/rtl/sync/psync1.sv \
        ../../rz-lib/rtl/fifo/afifo.v


# inferrable RAM models
VERILOG_FILES += \
        ../../rz-lib/rtl/bram/dp_ram.sv
        
ifneq ($(SIM),modelsim)
VERILOG_FILES += \
        ../../rz-lib/rtl/bram/dp_ram_be.sv
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
