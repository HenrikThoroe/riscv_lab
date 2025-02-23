`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 03:28:23 PM
// Design Name: 
// Module Name: fifo_tb
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

module fifo_tb();

reg clk;
reg rst;

reg write_en;
reg [31:0] write_data;
reg read_en;
reg [31:0] read_data;
reg full;
reg empty;

fifo #(.DATA_WIDTH(32), .DEPTH(4)) dut (
    .clk(clk),
    .rst(rst),
    .data_in(write_data),
    .write_enable(write_en),
    .data_out(read_data),
    .read_enable(read_en),
    .full(full),
    .empty(empty)
);

initial begin
    write_en = 0;
    write_data = 0;
    read_en = 0;
    read_data = 0;

    clk = 0;
    forever #1 clk = ~clk;
end

always @(posedge clk) assert (!(full && empty));

initial begin
    rst = 0;
    #10;
    rst = 1;

    write_data <= 1;
    write_en <= 1;
    repeat (1) @(posedge clk);
    write_data <= 2;
    repeat (1) @(posedge clk);
    write_data <= 3;
    repeat (1) @(posedge clk);
    write_data <= 4;
    repeat (1) @(posedge clk);
    write_data <= 5;
    repeat (1) @(posedge clk);
    assert(full) else $fatal("Error: full=%d", full);
    write_en <= 0;
    read_en <= 1;
    repeat (1) @(posedge clk);
    assert(read_data == 1) else $fatal("Error: read_data=%d", read_data);
    repeat (1) @(posedge clk);
    assert(!full) else $fatal("Error: full=%d", full);
    assert(read_data == 2) else $fatal("Error: read_data=%d", read_data);
    repeat (1) @(posedge clk);
    assert(read_data == 3) else $fatal("Error: read_data=%d", read_data);
    repeat (1) @(posedge clk);
    assert(read_data == 4) else $fatal("Error: read_data=%d", read_data);
    write_en <= 1;
    write_data <= 6;
    read_en <= 0;
    repeat (1) @(posedge clk);
    write_en <= 0;
    read_en <= 1;
    repeat (1) @(posedge clk);
    assert(read_data == 6) else $fatal("Error: read_data=%d", read_data);
end

endmodule
