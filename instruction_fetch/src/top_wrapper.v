`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 04:52:36 PM
// Design Name: 
// Module Name: top_wrapper
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


module top_wrapper
(
    output wire [16:0] ctrl_data_o,

    output reg axis_m_data_tvalid,
    input wire axis_m_data_tready,
    output wire [31:0] axis_m_data_tdata,

    input wire axis_s_offset_tvalid,
    output reg axis_s_offset_tready,
    input wire [31:0] axis_s_offset_tdata,

    input wire clk,
    input wire rst
);

reg [31:0] address;
reg should_stall;

wire [31:0] instruction;
wire is_valid;
wire is_jmp;
wire can_send_next;
wire enable_read;

instruction_memory #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32)
) mem (
    .address(address),
    .enable_read(enable_read),
    .data(instruction),
    .data_valid(is_valid),
    .clk(clk),
    .rst(rst)
);

assign is_jmp = (instruction[6] == 1'b1);
assign ctrl_data_o = {instruction[31:25], instruction[14:12], instruction[6:0]};
assign axis_m_data_tdata = instruction;
assign can_send_next = axis_m_data_tready & is_valid;
assign enable_read = !should_stall & can_send_next;

initial begin
    address = 0;
    should_stall = 0;
    axis_s_offset_tready = 0;
end

always @(posedge clk) begin
    if (!rst) begin
        address <= 0;
    end else begin
        if (should_stall) begin
            axis_s_offset_tready <= 1;

            if (axis_s_offset_tvalid) begin
                address <= axis_s_offset_tdata + address;
                should_stall <= 0;
            end
        end else begin
            axis_s_offset_tready <= 0;

            if (can_send_next) begin
                axis_m_data_tvalid <= 1;

                if (is_jmp) begin
                    should_stall <= 1;
                end else begin
                    address <= address + 1;
                end
            end
        end
    end
end

endmodule
