`timescale 1ns / 1ps

module top_wrapper
#(
    parameter SIZE = 128
)
(
    input wire [16:0] ctrl_data_i,

    output wire axis_m_data_tvalid,
    input wire axis_m_data_tready,
    output wire [31:0] axis_m_data_tdata,

    input wire axis_s_data_tvalid,
    output wire axis_s_data_tready,
    input wire [31:0] axis_s_data_tdata,

    input wire axis_s_addr_tvalid,
    output wire axis_s_addr_tready,
    input wire [31:0] axis_s_addr_tdata,

    input wire clk,
    input wire rst
);

reg [31:0] mem [SIZE-1:0];
wire is_load;
wire is_store;

integer i;

assign is_load = ctrl_data_i[6:0] == 7'b0000011;
assign is_store = ctrl_data_i[6:0] == 7'b0100011;

assign axis_m_data_tdata = is_load ? mem[axis_s_addr_tdata] : axis_s_addr_tdata;
assign axis_s_data_tready = axis_m_data_tready;
assign axis_s_addr_tready = axis_m_data_tready; 
assign axis_m_data_tvalid = 1;

initial begin
    for (i = 0; i < SIZE-1; i = i + 1) begin
        mem[i] <= 0;
    end
end

always @(posedge clk) begin
    if (!rst) begin
        for (i = 0; i < SIZE-1; i = i + 1) begin
            mem[i] <= 0;
        end
    end else begin
        if (is_store) begin
            mem[axis_s_addr_tdata] <= axis_s_data_tdata;
        end
    end
end


endmodule
