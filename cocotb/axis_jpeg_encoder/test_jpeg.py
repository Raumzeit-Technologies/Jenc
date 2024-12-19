#
# Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
#
# GPL-3.0 license
#
# Copyright (C) 2024 Robert Metchev
#
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Timer
import sys, os, time, random, logging

import numpy as np

if os.environ['SIM'] != 'modelsim':
    import cv2

#from encoder import writeJPG_header, writeJPG_footer    # ../jed

np.set_printoptions(suppress=True, precision=3)
np.random.seed(0)




@cocotb.test()
async def jpeg_test(dut):
    pass
