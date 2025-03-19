`timescale 1ns / 1ps

module top_wrapper
#(
    parameter SIZE = 128
)
(
    // input wire [16:0] ctrl_data_i,

    // output wire axis_m_data_tvalid,
    // input wire axis_m_data_tready,
    // output wire [31:0] axis_m_data_tdata,

    // input wire axis_s_data_tvalid,
    // output wire axis_s_data_tready,
    // input wire [31:0] axis_s_data_tdata,

    // input wire axis_s_addr_tvalid,
    // output wire axis_s_addr_tready,
    // input wire [31:0] axis_s_addr_tdata,

    // output wire axis_m_dma_tvalid,
    // input wire axis_m_dma_tready,
    // output wire [31:0] axis_m_dma_tdata,

    // input wire axis_s_dma_tvalid,
    // output wire axis_s_dma_tready,
    // input wire [31:0] axis_s_dma_tdata,

    input wire [31:0] adr,
    input wire [31:0] data_i,
    output wire [31:0] data_o,
    input wire enable_read,
    input wire enable_write,

    // input wire [31:0] ifc1_adr,
    // input wire [31:0] ifc1_data_i,
    // output wire [31:0] ifc1_data_o,
    // input wire ifc1_enable_write,

    output wire [31:0] dma_read,
    input wire [31:0] dma_write,

    output reg write_to_reg,
    input wire write_to_reg_i,
    output reg [4:0] dst_reg,
    input wire [4:0] dst_reg_i,

    input wire clk,
    input wire rst
);

// reg [31:0] dma_o; 

reg [31:0] mem [SIZE-1:0];
reg [31:0] dma_0 = 0;
// reg [31:0] dma_1 = 0;
reg [31:0] main_mem;
integer i = 0;

assign data_o = main_mem;
assign dma_read = dma_0;

always @ (posedge clk) begin
    if (!rst) begin
        main_mem <= 0;
        write_to_reg <= 0;
        dst_reg <= 0;
        dma_0 <= 0;
        for (i = 0; i < SIZE; i = i + 1) begin
            mem[i] <= 0;
        end
    end else begin
        write_to_reg <= write_to_reg_i;
        dst_reg <= dst_reg_i;

        if (enable_read) begin
            if (adr == 1)
                main_mem <= dma_write;
            else
                main_mem <= mem[adr];
        end else begin
            main_mem <= adr;
        end

        if (enable_write) begin 
            mem[adr] <= data_i;
        end

        if (adr == 0 && enable_write == 1) 
            dma_0 <= data_i;
        else
            dma_0 <= dma_0;
            

        // if (adr == 0 && enable_write) begin
        //     dma_0 <= data_i;
        //     mem[adr] <= mem[adr];
        // end else begin 
        //     dma_0 <= dma_0;
        //     if (enable_write == 1'b1) 
        //         mem[adr] <= data_i;
        //     else
        //         mem[adr] <= mem[adr];
        // end
    end
end

endmodule
