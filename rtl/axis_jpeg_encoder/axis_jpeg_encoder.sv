/*
 * Description: Top level for AXI-Stream + APB based JPEG Encoder + ISP
 * 
 *
 * Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
 *
 * CERN Open Hardware Licence Version 2 - Permissive
 *
 * Copyright (C) 2024 Robert Metchev
 */
 module axis_jpeg_encoder #(
    parameter DW = 8,
    parameter SENSOR_X_SIZE    = 720, //1280,
    parameter SENSOR_Y_SIZE    = 720
)(
    input   logic [23:0]        s_axis_video_tdata,     // Video Data {B,G,R}
    input   logic               s_axis_video_tvalid,
    output  logic               s_axis_video_tready,
    input   logic               s_axis_video_tuser,     // Start Of Frame
    input   logic               s_axis_video_tlast,     // End Of Line

    output  logic [31:0]        m_axis_video_tdata,     // 4 bytes of JPEG data
    output  logic               m_axis_video_tvalid,
    input   logic               m_axis_video_tready,
    //output  logic [15:0]        m_axis_video_tuser,     // Adress of 4-byte data in image buffer (in bytes) - Let the image buffer do the counting
    output  logic               m_axis_video_tlast,     // Set to 1 when compression finished. If 1, size of encoded data is address_out

    // APB
    input   logic [3:0]         paddr,                  // 16 registers
    input   logic               pwrite,
    input   logic               psel,
    input   logic               penable,
    output  logic               pready,
    input   logic [31:0]        pwdata,                 // 4 bytes 
    output  logic [31:0]        prdata,                 // 4 bytes 
    input   logic               pclk,                   // APB clock
    input   logic               presetn,
 
    input   logic               pixel_clock,            // video pixel clock
    input   logic               pixel_reset_n,
    input   logic               jpeg_fast_clock,        // must be >= 2 x jpeg_clock, RAM technology dependent
    input   logic               jpeg_fast_reset_n,
    input   logic               jpeg_clock,             // JPEG encoder clock, can be same or slower (or faster) than pixel clock
    input   logic               jpeg_reset_n
);

//  Registers
logic                   start_capture, start_capture_0, start_capture_1;
logic[1:0]              qf_select;              // select one of the 4 possible QF
logic[$clog2(SENSOR_X_SIZE)-1:0] x_size_m1;
logic[$clog2(SENSOR_Y_SIZE)-1:0] y_size_m1;

// Video in
logic unsigned[DW-1:0]  rgb24[2:0];             // to do: make pktized interface
logic                   rgb24_valid;
logic                   rgb24_hold;
logic                   frame_valid;
logic                   line_valid;

// JPEG ISP -> Encoder
logic signed[DW-1:0]    di[7:0]; 
logic                   di_valid;
logic                   di_hold;
logic [2:0]             di_cnt;

// JPEG FSM
enum logic[2:0] {IDLE, RESET, WAIT_FOR_FRAME_START, COMPRESS, IMAGE_VALID} jstate;
logic                   compress_2_image_valid;

// data out
logic [31:0]            out_data, out_data_rr;
logic                   image_valid;
logic [19:0]            image_size;


//  APB Registers
japb #(
    .SENSOR_X_SIZE(SENSOR_X_SIZE), 
    .SENSOR_Y_SIZE(SENSOR_Y_SIZE)
) japb (
    .*
);

// AXI-Stream video slave
jaxis_video_slave #(
    .DW(DW), 
    .SENSOR_X_SIZE(SENSOR_X_SIZE), 
    .SENSOR_Y_SIZE(SENSOR_Y_SIZE)
) jaxis_video_slave (
    .*
);

// JPEG FSM
// To do: put into separate glue logic module
always @(posedge pixel_clock_in)
if (!pixel_reset_n_in)
    jstate <= IDLE;
else 
    case(jstate)
    RESET:                  if (~frame_valid) jstate <= WAIT_FOR_FRAME_START;   // reset state (1), hold in reset until end of previous frame
    WAIT_FOR_FRAME_START:   if (frame_valid) jstate <= COMPRESS;                // wait for frame start (2)
    COMPRESS:               if (compress_2_image_valid) jstate <= IMAGE_VALID;  // compress state (3)
    default:                if (start_capture_0) jstate <= RESET;            // idle state (0) or image valid state (4)
    endcase        

//always_comb jpeg_en     = jstate inside {WAIT_FOR_FRAME_START, COMPRESS};
always_comb jpeg_en     = jstate == WAIT_FOR_FRAME_START | jstate == COMPRESS;
always_comb image_valid = jstate == IMAGE_VALID;

// pulse sync
psync1 psync_start_capture_0 (
    .in(start_capture), .in_clk(pclk), .in_reset_n(presetn), 
    .out(start_capture_0), .out_clk(pixel_clock), .out_reset_n(pixel_reset_n)
);

psync1 psync_fsm (
    .in(out_valid & ~out_hold & out_tlast), .in_clk(jpeg_clock), .in_reset_n(jpeg_reset_n), 
    .out(compress_2_image_valid), .out_clk(pixel_clock), .out_reset_n(pixel_reset_n)
);

psync1 psync_start_capture_1 (
    .in(start_capture), .in_clk(pclk), .in_reset_n(presetn), 
    .out(start_capture_1), .out_clk(jpeg_clock), .out_reset_n(jpeg_reset_n)
);

// JPEG ISP (RGB2YUV, 4:4:4 2 4:2:0, 16-line MCU buffer)
jisp #(
    .SENSOR_X_SIZE      (SENSOR_X_SIZE),
    .SENSOR_Y_SIZE      (SENSOR_Y_SIZE)
) jisp (
    .clk                (pixel_clock),
    .resetn             (pixel_reset_n),
    .rgb24_valid        (jpeg_en & line_valid_in),
    .frame_valid_in     (jpeg_en & frame_valid_in),
    .line_valid_in      (jpeg_en & line_valid_in),
    .*
);

// Encoder
jenc #(
    .SENSOR_X_SIZE      (SENSOR_X_SIZE),
    .SENSOR_Y_SIZE      (SENSOR_Y_SIZE)
) jenc (
    .clk                (jpeg_clock),
    .resetn             (jpeg_reset_n),
    
    .out_valid          (m_axis_video_tvalid),
    .out_hold           (m_axis_video_tready),
    .out_tlast          (m_axis_video_tlast),
    
    .*
);

always @(posedge jpeg_clock)
if (start_capture_1)
    image_size <= 0;
else if (m_axis_video_tvalid & m_axis_video_tready)
    image_size <= image_size + 4;

// data out: need to reverse endianness 
always_comb
    for(int i=0; i<4; i++)
        out_data_rr[8*i +: 8] = out_data[8*(3-i) +: 8];    

always_comb m_axis_video_tdata = out_data_rr;       // 4 bytes of JPEG data
//always_comb m_axis_video_tuser = image_size;        // Adress of 4-byte data in image buffer (in bytes) - Let the image buffer do the counting

endmodule
