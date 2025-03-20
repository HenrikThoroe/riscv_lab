`timescale 1ns / 1ps

module top_wrapper
(

    input wire [31:0] i_address,
    input wire [31:0] i_data,
    output wire [31:0] o_data,
    input wire i_enable_read,
    input wire i_enable_write,

    output wire [31:0] o_dma_read_0,
    output wire [31:0] o_dma_read_1,
    input wire [31:0] i_dma_write,

    output reg o_write_to_reg,
    input wire i_write_to_reg,
    output reg [4:0] o_dst_reg,
    input wire [4:0] i_dst_reg,

    input wire clk,
    input wire rst
);

reg [31:0] mem [127:0];
reg [31:0] dma_0 = 0;
reg [31:0] dma_1 = 0;
reg [31:0] main_mem;
integer i = 0;

assign o_data = main_mem;
assign o_dma_read_0 = dma_0;
assign o_dma_read_1 = dma_1;

always @ (posedge clk) begin
    if (!rst) begin
        main_mem <= 0;
        o_write_to_reg <= 0;
        o_dst_reg <= 0;
        dma_0 <= 0;
        dma_1 <= 0;
        for (i = 0; i < 128; i = i + 1) begin
            mem[i] <= 0;
        end
    end else begin
        o_write_to_reg <= i_write_to_reg;
        o_dst_reg <= i_dst_reg;

        if (i_enable_read) begin
            if (i_address == 0)
                main_mem <= i_dma_write;
            else
                main_mem <= mem[i_address];
        end else begin
            main_mem <= i_address;
        end

        if (i_enable_write) begin 
            mem[i_address] <= i_data;
        end

        if (i_address == 1 && i_enable_write == 1) 
            dma_0 <= i_data;
        else
            dma_0 <= dma_0;

        if (i_address == 2 && i_enable_write == 1) 
            dma_1 <= i_data;
        else
            dma_1 <= dma_1;
    end
end

endmodule
