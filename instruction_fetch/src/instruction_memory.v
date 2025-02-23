`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 04:52:36 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)
(
    input wire [ADDR_WIDTH-1:0] address,
    input wire enable_read,
    output wire [DATA_WIDTH-1:0] data,
    output wire data_valid,

    input wire clk,
    input wire rst
);

reg [DATA_WIDTH-1:0] memory [3:0];

assign data_valid = enable_read;
assign data = memory[address];

initial begin
    memory[0] = 32'h3e800093;
    memory[1] = 32'h7d008113;
    memory[2] = 32'h014000ef;
    memory[3] = 32'h83018213;
end

always @(posedge clk) begin
    if (!rst) begin
    end else begin
    end
end

endmodule
