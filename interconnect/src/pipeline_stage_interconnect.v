`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 01:09:47 PM
// Design Name: 
// Module Name: pipeline_stage_interconnect
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipeline_stage_interconnect
#(
    parameter DATA_WIDTH = 32,
    parameter CTRL_WIDTH = 16,
    parameter BUFFER_DEPTH = 1
)
(
    input wire [CTRL_WIDTH-1:0] ctrl_data_i,

    output wire [CTRL_WIDTH-1:0] ctrl_data_o,

    input wire axis_s_data_tvalid,
    output wire axis_s_data_tready,
    input wire [DATA_WIDTH-1:0] axis_s_data_tdata,

    output wire axis_m_data_tvalid,
    input wire axis_m_data_tready,
    output wire [DATA_WIDTH-1:0] axis_m_data_tdata,

    input wire clk,
    input wire rst
);

wire full;
wire empty;

assign axis_s_data_tready = ~full;
assign axis_m_data_tvalid = ~empty;

fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(BUFFER_DEPTH)
) data_buffer (
    .data_in(axis_s_data_tdata),
    .write_enable(axis_s_data_tvalid),
    .data_out(axis_m_data_tdata),
    .read_enable(axis_m_data_tready),
    .empty(empty),
    .full(full),
    .clk(clk),
    .rst(rst)
);

fifo #(
    .DATA_WIDTH(CTRL_WIDTH),
    .DEPTH(BUFFER_DEPTH)
) ctrl_buffer (
    .data_in(ctrl_data_i),
    .write_enable(axis_s_data_tvalid),
    .data_out(ctrl_data_o),
    .read_enable(axis_m_data_tready),
    .empty(empty),
    .full(full),
    .clk(clk),
    .rst(rst)
);

endmodule
