`timescale 1 ns / 1 ps

module top_wrapper 
(
    output wire [9:0] o_led_ctrl_sig,
    input wire [11:0] i_switch_ctrl_sig,
    output wire [7:0] o_display_sig,
    output wire [3:0] o_anode_sig,
    input wire [31:0] i_data_0,
    input wire [31:0] i_data_1,
    output wire [31:0] o_data,
    input wire i_clk,
    input wire i_rstn
);

reg [31:0] led_ctrl;
reg [31:0] dply_ctrl;
reg [31:0] address;
reg enable_write;

assign o_led_ctrl_sig = led_ctrl[9:0];
assign o_data = {20'h00000, i_switch_ctrl_sig};

seven_seg_ctrl seg_ctrl (
    .i_data(dply_ctrl[15:0]),
    .o_display(o_display_sig),
    .o_anode(o_anode_sig),
    .i_clk(i_clk),
    .i_rstn(i_rstn)
);

always @(posedge i_clk) begin
    if (i_rstn == 1'b0) begin
        led_ctrl <= 32'h00000000;
        dply_ctrl <= 32'h00000000;
    end else begin
        led_ctrl <= i_data_0;
        dply_ctrl <= i_data_1;
    end
end

endmodule
