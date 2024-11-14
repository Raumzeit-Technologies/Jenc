/*
 * Description: APB registers for AXI-Stream  JPEG Encoder 
 * 
 *
 * Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
 *
 * CERN Open Hardware Licence Version 2 - Permissive
 *
 * Copyright (C) 2024 Robert Metchev
 */
 module japb  #(
    parameter SENSOR_X_SIZE    = 720, //1280,
    parameter SENSOR_Y_SIZE    = 720
)(
    //  Registers
    output logic                start_capture,
    output logic[1:0]           qf_select,              // select one of the 4 possible QF
    output logic[$clog2(SENSOR_X_SIZE)-1:0] x_size_m1,
    output logic[$clog2(SENSOR_Y_SIZE)-1:0] y_size_m1,
    
    input                       image_valid,
    input  logic [19:0]         image_size,


    // APB
    input   logic [3:0]         paddr,                  // 16 registers
    input   logic               pwrite,
    input   logic               psel,
    input   logic               penable,
    output  logic               pready,
    input   logic [31:0]        pwdata,                 // 4 bytes 
    output  logic [31:0]        prdata,                 // 4 bytes 
    input   logic               pclk,                   // APB clock
    input   logic               presetn
);

// register addresses
parameter START_CAPTURE     = 'h0; // WO
parameter QUALITY_FACTOR    = 'h6; // RW
parameter IMAGE_SIZE        = 'h9; // RW
parameter IMAGE_READY_FLAG  = 'ha; // RO
parameter COMPRESSED_BYTES  = 'hb; // RO

logic[1:0]           image_valid_sync;


// CDC synchronzier to avoid discussions
always @(posedge pclk) 
    image_valid_sync <= {image_valid_sync, image_valid};

// APB registers
always_comb pready = 1;

always @(posedge pclk)
if (!presetn) 
    start_capture <= 0;
else 
    start_capture <= pwrite & psel & penable & pready & paddr == START_CAPTURE;

always @(posedge pclk)
if (pwrite & psel & penable & pready) begin
    case(paddr)
    QUALITY_FACTOR: qf_select <= pwdata;
    IMAGE_SIZE: begin
        x_size_m1 <= pwdata;
        y_size_m1 <= pwdata >> 16;
    end
    endcase
end

// APB read data
always_comb
if (psel)
    case(paddr)
    QUALITY_FACTOR:     prdata = qf_select;
    IMAGE_SIZE:         prdata = x_size_m1 | (y_size_m1 << 16);
    IMAGE_READY_FLAG:   prdata = image_valid_sync[1];
    COMPRESSED_BYTES:   prdata = image_size;
    default:            prdata = 0;
    endcase
else
    prdata = 0;

endmodule
