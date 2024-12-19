#
# Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
#
# GPL-3.0 license
#
# Copyright (C) 2024 Robert Metchev
#

SHELL=/bin/bash
# defaults
SIM ?= verilator
#SIM ?= modelsim|icarus
export SIM := $(SIM)
TOPLEVEL_LANG ?= verilog


# VERILOG_SOURCES and VERILOG_INCLUDE_DIRS are defined in the inlude source file list 
include $(realpath ./source_files.mk)

# compile flags
ifeq ($(SIM),icarus)
        COMPILE_ARGS += -DCOCOTB_SIM=1
        COMPILE_ARGS += -DRADIANT
        COMPILE_ARGS += -DTOP_SIM
        COMPILE_ARGS += -DCOCOTB_ICARUS
else # verilator + modelsim
        EXTRA_ARGS += +define+COCOTB_SIM=1
        EXTRA_ARGS += +define+RADIANT
        EXTRA_ARGS += +define+TOP_SIM
endif

ifeq ($(SIM),icarus)
        COMPILE_ARGS += -DINFER_HUFFMAN_CODES_ROM    # rtl version
        COMPILE_ARGS += -DINFER_QUANTIZATION_TABLES_ROM    # rtl version
        COMPILE_ARGS += -DNO_MIPI_IP_SIM          # Simulate Bayer input
        COMPILE_ARGS += -DNO_PLL_SIM              # Emulate PLL
        COMPILE_ARGS += -Wall
        COMPILE_ARGS += -v
        #COMPILE_ARGS += -g2005-sv
endif
ifeq ($(SIM),verilator)
        EXTRA_ARGS += +define+INFER_HUFFMAN_CODES_ROM    # rtl version
        EXTRA_ARGS += +define+INFER_QUANTIZATION_TABLES_ROM    # rtl version
        EXTRA_ARGS += +define+NO_MIPI_IP_SIM    # Simulate Bayer input
        EXTRA_ARGS += +define+NO_PLL_SIM        # Emulate PLL
        EXTRA_ARGS += --timing
        ifneq ($(WAVES),0)
                EXTRA_ARGS += --trace --trace-structs --trace-fst
        endif
        WNO = fatal WIDTHTRUNC WIDTHEXPAND ASCRANGE EOFNEWLINE PINCONNECTEMPTY DECLFILENAME GENUNNAMED VARHIDDEN UNUSEDPARAM
        EXTRA_ARGS += -Wall $(WNO:%=-Wno-%)
endif
ifeq ($(SIM),modelsim)
        #EXTRA_ARGS += +define+USE_LATTICE_LARGE_RAM     # RTL vs. memory models explicitely
        EXTRA_ARGS += +define+USE_LATTICE_EBR           # use EBR explicitely
        EXTRA_ARGS += +define+COCOTB_MODELSIM
        EXTRA_ARGS += -suppress vlog-2244 -suppress  vlog-13314
ifeq ($(GATE_SIM),1)
        EXTRA_ARGS += -suppress vsim-3620
endif    
        EXTRA_ARGS += -L lifcl -L ovi_lifcl -L pmi_work
        EXTRA_ARGS += +memory

ifeq ($(WAVES),1)
        EXTRA_ARGS += +DUMP
endif
        
ifeq ($(GATE_SIM),1)
        EXTRA_ARGS += +define+GATE_SIM
ifeq ($(SDF_ANNO),1)
        SIM_ARGS += +nosdferror -sdfmax /tb_top/dut=$(FRAME_SDF)
        #SIM_ARGS += +no_notifier
        #SIM_ARGS += +notimingchecks
endif
endif
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL =  axis_jpeg_encoder

# MODULE is the basename of the Python test file
MODULE = test_jpeg 

export COCOTB_RESOLVE_X=ZEROS
export PYTHONPATH := $(realpath .):$(COMMONS_PATH):$(JPEG_COMMON):$(JED)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Build Lattice IP (CSI, PLL, EBR) as prerequisite
.PHONY: ip
ip:
	make -C $(CAMERA_PATH)/testbenches/csi/source/csi/pll_sim_ip
ifeq ($(SIM),modelsim)
sim: ip
endif

ifeq ($(SIM),icarus)
        DUMP := sim_build/tb_top.fst
else
ifeq ($(SIM),verilator)
        DUMP := dump.fst
else #modelsim
        DUMP := dump.vcd
endif
endif

.PHONY: g gtkwave
g gtkwave:
	gtkwave $(DUMP) -o -a 1.gtkw

clean::
	rm -rf __pycache__ results.xml obj_dir
	rm -rf dump.vcd dump.vcd.fst dump.vcd.fst.hier 
	rm -rf dump.fst dump.fst.hier 
	rm -rf transcript modelsim.ini vsim.wlf vsim_stacktrace.vstf vish_stacktrace.vstf
	rm -rf frame_frame_vo.sdf_*.csd
	#make clean -C ../../testbenches/csi/source/csi/pll_sim_ip
	rm -rf f wlft*
