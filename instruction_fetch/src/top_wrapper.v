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


module top_wrapper #
(
    // Parameters of Axi Slave Bus Interface S00_AXI
    // parameter integer C_S00_AXI_DATA_WIDTH	= 32,
    // parameter integer C_S00_AXI_ADDR_WIDTH	= 14
)
(
    output wire [16:0] ctrl_data_o,

    output wire axis_m_data_tvalid,
    input wire axis_m_data_tready,
    output wire [31:0] axis_m_data_tdata,

    output wire [15:0] pc,
    input wire [15:0] jmp,
    input wire jmp_enable,

    // input wire axis_s_offset_tvalid,
    // output reg axis_s_offset_tready,
    // input wire [31:0] axis_s_offset_tdata,

    // Ports of Axi Slave Bus Interface S00_AXI
    // input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    // input wire [2 : 0] s00_axi_awprot,
    // input wire  s00_axi_awvalid,
    // output wire  s00_axi_awready,
    // input wire [64-1 : 0] s00_axi_wdata,
    // input wire [(64/8)-1 : 0] s00_axi_wstrb,
    // input wire  s00_axi_wvalid,
    // output wire  s00_axi_wready,
    // output wire [1 : 0] s00_axi_bresp,
    // output wire  s00_axi_bvalid,
    // input wire  s00_axi_bready,
    // input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    // input wire [2 : 0] s00_axi_arprot,
    // input wire  s00_axi_arvalid,
    // output wire  s00_axi_arready,
    // output wire [64-1 : 0] s00_axi_rdata,
    // output wire [1 : 0] s00_axi_rresp,
    // output wire  s00_axi_rvalid,
    // input wire  s00_axi_rready,

    input wire  clk,
    input wire  rst
);

reg [15:0] address = 0;

localparam MEM_SIZE = 26;
localparam [((32 * MEM_SIZE)-1):0] memory = {
    // 32'b00000000000100001000000010010011, // addi x1, x1, 1;
    // 32'b00000000000100000010000000100011,
    // 32'b00000000000100001000000100010011  // addi x1, x1, 1;
    // 32'b00000000000000001000000010010011,
    // 32'b00000001000000001000000010010011,
    // 32'b00000000001000001000000010010011,
    // 32'b00000000000100001000000010010011

    // 32'b0000000000000_00011_000_00011_0010011,
    // 32'b0000000_00010_00001_000_00011_0110011,
    // 32'b0000000_00000_00000_000_00010_0110011,
    // 32'b0000000000011_00010_000_00010_0010011,
    // 32'b0000000_00000_00000_000_00001_0110011,
    // 32'b0000000010001_00001_000_00001_0010011
    // 32'b000000000001_00010_000_00011_0010011,            // r3 = r3 + r4 = r3
    // 32'b0000000_00000_00000_000_00000_0110011,           // r3 = r1 + r2 = 11
    // 32'b000000000000_00000_000_00000_0010011,            // r0 = r0 + 0
    // 32'b000000000010_00001_000_00001_0010011,            // r1 = r1 + 2 = 2
    // 32'b000000000000_00000_000_00000_0010011,            // r0 = r0 + 0
    // 32'b000000001001_00010_000_00010_0010011             // r2 = 9

    // 32'b00000000001000001000000101100011
    // 32'b000000000000_00000_000_00000_0010011
    // 32'b000000001001_00010_000_00010_0010011
    // 32'b000000000000_00000_000_00000_0010011
    // 32'b000000001001_00010_000_00010_0010011
    // 32'b00000000000000000000000000010011,              // nop
    // 32'b00000000001000000010000000100011,              // sw x2, 0(x0)
    // 32'b00000000000000000000000000010011,              // nop
    // 32'b00000000010100000010000000100011,              // sw x5, 0(x0)
    // 32'b00000000000000000000000000010011,              // nop
    // 32'b00000000000000001010001010000011,              // lw x5, 0(x1)


    // 32'b00000000000000000000000000000000,              // nop
    // 32'b00000000000100000010000000100011,              // sw x1, 0(x0)
    // 32'b00000000000000000000000000000000,
    // 32'b00000000000100000010000000100011,              // sw x1, 0(x0)
    // 32'b00000000000000000000000000000000,              // nop
    // 32'b00000000001000000000000010010011,              // addi x1, x0, 2
    // 32'b00000000000000000000000000000000,             // nop
    // 32'b00000000111000000000000100010011,              // addi x2, x0, 14
    // 32'b00000000000000000000000000000000

    // 32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    // 32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    // 32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    // 32'b00000000001000000010000000100011,        // sw x2, 0(x0)


    32'b00000000000000000000000001100011,        // beq x0, x0, 0
    // 32'b00000000000000000000000000000000,        // nop
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000001000000010000000100011,        // sw x2, 0(x0)
    32'b00000000000000000000000000000000,        // nop
    32'b00000000001000100000000100110011,        // add x2, x4, x2
    32'b00000000000000000000000000000000,        // nop
    32'b00000000000100010000000100010011,        // addi x2, x2, 2
    32'b00000000000000000000000000000000,        // nop
    32'b00000000010000010000000100010011,        // addi x2, x2, 4
    32'b00000000000000000000000000000000,        // nop
    32'b00000001000000010000000100010011,        // addi x2, x2, 6
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000110010000100000011,        // lw x2, 0(x6)
    32'b00000000000000000000000000000000,        // nop
    32'b00000000000000000000000000000000,        // nop
    32'b00000000000100000000001100010011,         // addi x6, x0, 1
    32'b00000000000000000000000000000000,        // nop
    32'b00000000000000000000000000000000         // nop
};

wire [31:0] inst = memory[address+:32];

assign pc = 0;

always @(posedge clk) begin
    if (!rst) begin
        address <= 0;
    end else begin
        if (jmp_enable == 1) begin 
            address <= jmp << 3;
        end else if (address < (32'h0020 * (MEM_SIZE-1))) begin
            address <= address + 32'h0020; 
        end
        // if (address < 6) begin
        //     address <= address + 1;
        // end else begin
        //     address <= address;
        // end

        // inst <= {24'hffffff, address};

        // inst <= memory[(((address)*32))+:32];//hi
        // address <= 1;
    end
end

assign axis_m_data_tdata = inst;
assign axis_m_data_tvalid = address < MEM_SIZE;
assign ctrl_data_o = {inst[31:25], inst[14:12], inst[6:0]};

// reg [31:0] address;
// reg should_stall;

// wire [31:0] instruction;
// wire is_valid;
// wire is_jmp = instruction[6:6];
// wire can_send_next;
// wire enable_read;

// instruction_memory #(
//     .DATA_WIDTH(32),
//     .ADDR_WIDTH(32)
// ) mem (
//     .address(address),
//     .enable_read(enable_read),
//     .data(instruction),
//     .data_valid(is_valid),
//     .clk(clk),
//     .rst(rst)
// );

// memory_interconnect # ( 
//     .C_S_AXI_DATA_WIDTH(64),
//     .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
// ) mem (
//     .address(address),
//     .enable_read(enable_read),
//     .data(instruction),
//     .data_valid(is_valid),
//     .S_AXI_ACLK(clk),
//     .S_AXI_ARESETN(rst),
//     .S_AXI_AWADDR(s00_axi_awaddr),
//     .S_AXI_AWPROT(s00_axi_awprot),
//     .S_AXI_AWVALID(s00_axi_awvalid),
//     .S_AXI_AWREADY(s00_axi_awready),
//     .S_AXI_WDATA(s00_axi_wdata),
//     .S_AXI_WSTRB(s00_axi_wstrb),
//     .S_AXI_WVALID(s00_axi_wvalid),
//     .S_AXI_WREADY(s00_axi_wready),
//     .S_AXI_BRESP(s00_axi_bresp),
//     .S_AXI_BVALID(s00_axi_bvalid),
//     .S_AXI_BREADY(s00_axi_bready),
//     .S_AXI_ARADDR(s00_axi_araddr),
//     .S_AXI_ARPROT(s00_axi_arprot),
//     .S_AXI_ARVALID(s00_axi_arvalid),
//     .S_AXI_ARREADY(s00_axi_arready),
//     .S_AXI_RDATA(s00_axi_rdata),
//     .S_AXI_RRESP(s00_axi_rresp),
//     .S_AXI_RVALID(s00_axi_rvalid),
//     .S_AXI_RREADY(s00_axi_rready)
// );

// assign is_jmp = (instruction[6] == 1'b1);
// assign ctrl_data_o = {instruction[31:25], instruction[14:12], instruction[6:0]};
// assign axis_m_data_tdata = instruction;
// assign can_send_next = axis_m_data_tready & is_valid;
// assign enable_read = !should_stall & can_send_next;

// assign axis_m_data_tvalid = 1;//(~should_stall) & can_send_next;

// initial begin
//     address = 0;
//     should_stall = 0;
//     axis_s_offset_tready = 0;
//     // axis_m_data_tvalid = 1;
// end

// always @(posedge clk) begin
    // if (rst == 1'b0) begin
    //     address <= 0;
    //     should_stall <= 0;
    //     axis_s_offset_tready <= 0;
        // axis_m_data_tdata <= 32'h55555555;
    // end else begin
        // axis_m_data_tdata <= instruction;

        // if (should_stall) begin
        //     axis_s_offset_tready <= 1;

        //     if (axis_s_offset_tvalid) begin
        //         address <= axis_s_offset_tdata + address;
        //         should_stall <= 0;
        //     end
        // end else begin
        //     axis_s_offset_tready <= 0;

        //     if (can_send_next) begin
        //         // axis_m_data_tvalid <= 1;

        //         if (is_jmp) begin
        //             should_stall <= 1;
        //         end else begin
        //             address <= address + 1;
        //         end
        //     end
        // end
    // end
// end

endmodule
