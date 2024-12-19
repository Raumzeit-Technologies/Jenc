/*
 * Description: AXI-Stream to hsync/vsync converter for AXI-Stream  JPEG Encoder 
 * 
 *
 * Authored by: Robert Metchev / Raumzeit Technologies (robert@raumzeit.co)
 *
 * GPL-3.0 license
 *
 * Copyright (C) 2024 Robert Metchev
 */
 module jaxis_video_slave  #(
    parameter DW = 8,
    parameter SENSOR_X_SIZE    = 720, //1280,
    parameter SENSOR_Y_SIZE    = 720
)(
    input   logic [23:0]        s_axis_video_tdata,     // Video Data {B,G,R}
    input   logic               s_axis_video_tvalid,
    output  logic               s_axis_video_tready,
    input   logic               s_axis_video_tuser,     // Start Of Frame
    input   logic               s_axis_video_tlast,     // End Of Line

    output  logic unsigned[DW-1:0]  rgb24[2:0], // to do: make pktized interface
    output  logic               rgb24_valid,
    input   logic               rgb24_hold,
    output  logic               frame_valid,
    output  logic               line_valid,

    //  Registers
    input   logic[$clog2(SENSOR_X_SIZE)-1:0] x_size_m1,
    input   logic[$clog2(SENSOR_Y_SIZE)-1:0] y_size_m1,

    input   logic               clk,
    input   logic               resetn
);

logic [$clog2(SENSOR_Y_SIZE)-1:0] line_count;
enum logic [1:0] {VBLANK_IDLE, ACTIVE, HBLANK_1ST, HBLANK} video_state;

// For now, combinatorial, may want to add a flop stage later for timing
always_comb begin
    rgb24[0] = s_axis_video_tdata[7:0];
    rgb24[1] = s_axis_video_tdata[15:8];
    rgb24[2] = s_axis_video_tdata[23:16];
end

// Video FSM
always @(posedge clk)
if (!resetn)
    video_state <= VBLANK_IDLE;
else if (s_axis_video_tvalid & s_axis_video_tready)
    case (video_state)
    VBLANK_IDLE: 
        if (s_axis_video_tuser) begin
            video_state <= ACTIVE;
            line_count <= 0;
        end
    ACTIVE: 
        if (s_axis_video_tlast) begin
            line_count <= line_count + 1;
            if (line_count == y_size_m1)
                video_state <= VBLANK_IDLE;
            else
                video_state <= HBLANK_1ST;
        end
    HBLANK_1ST: 
        video_state <= HBLANK;
    HBLANK: 
        video_state <= ACTIVE;
    endcase

always_comb s_axis_video_tready = ~rgb24_hold & video_state != HBLANK_1ST;
always_comb rgb24_valid = s_axis_video_tvalid;

always_comb frame_valid = (s_axis_video_tuser & s_axis_video_tvalid) | video_state != VBLANK_IDLE;  // (SOF & valid) | frame_valid_state
always_comb line_valid =  ((s_axis_video_tuser | video_state == HBLANK) & s_axis_video_tvalid) | video_state == ACTIVE; // ((SOF | SOL) & valid) | line_valid_state


endmodule
