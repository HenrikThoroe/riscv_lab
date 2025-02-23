`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 02:56:40 PM
// Design Name: 
// Module Name: fifo
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


module fifo
#(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 1
)
(
    input wire [DATA_WIDTH-1:0] data_in,
    input wire write_enable,
    output wire [DATA_WIDTH-1:0] data_out,
    input wire read_enable,
    output wire empty,
    output wire full,

    input wire clk,
    input wire rst
);

reg [DATA_WIDTH-1:0] data [DEPTH-1:0];
reg [$clog2(DEPTH):0] head;
reg [$clog2(DEPTH):0] tail;
reg [$clog2(DEPTH):0] count;

assign data_out = data[tail];
assign empty = (count == 0);
assign full = (count == DEPTH);

initial begin
    head <= 0;
    tail <= 0;
    count <= 0;
end

always @(posedge clk) begin
    if (!rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
    end else begin
        if (write_enable && !full) begin
            data[head] <= data_in;
            head <= (head + 1) % DEPTH;
        end

        if (read_enable && !empty) begin
            tail <= (tail + 1) % DEPTH;
        end

        if ((write_enable && !full) && !(read_enable && !empty)) count <= count + 1;
        if (!(write_enable && !full) && (read_enable && !empty)) count <= count - 1;
    end
end

endmodule
