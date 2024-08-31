# RZ JENC
JPEG encoder IP core(s) written in Verilog.  
  
_As of 2024/8/30, this repo is still under construction_. Feel free to contact me if you have any questions or urgently need a high-performance encoder IP.
  
Available designs:
- [```rtl/axis_jpeg_encoder```](#axis_jpeg_encoder)
- [```rtl/frame_jpeg_encoder```](#frame_jpeg_encoder)


## ```rtl/axis_jpeg_encoder``` <a name="axis_jpeg_encoder"></a>
AXI-Stream JPEG encoder derived from [enoder for **_frame_** AI glasses](#frame_jpeg_encoder).  
  
WIP.
## ```rtl/frame_jpeg_encoder``` <a name="frame_jpeg_encoder"></a>
JPEG encoder developed for **_Brilliant Labs'_** **_frame_** AI glasses. This is a copy of the original encoder design ([link](https://github.com/brilliantlabsAR/frame-codebase/tree/main/source/fpga/modules/camera/jpeg_encoder)) with just a few minor modifications.  
For more details on **_frame_**, please visit:  
- https://brilliant.xyz/products/frame  
- https://docs.brilliant.xyz/frame/frame  
- https://github.com/brilliantlabsAR/frame-codebase  
