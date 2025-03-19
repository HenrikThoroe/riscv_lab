`timescale 1 ns / 1 ps

module top_wrapper 
(
    output wire [9:0] led_ctrl_sig,
    input wire [11:0] switch_ctrl_sig,
    input wire [31:0] data_i,
    output wire [31:0] data_o,
    output wire [31:0] mem_adr,
    output wire enable_mem_write,
    input wire clk,
    input wire aresetn
);

reg [31:0] led_ctrl;
reg [31:0] address;
reg enable_write;

assign led_ctrl_sig = led_ctrl[9:0];
assign data_o = {20'h00000, switch_ctrl_sig};
assign mem_adr = address;
assign enable_mem_write = enable_write;

always @(posedge clk) begin
    if (aresetn == 1'b0) begin
        led_ctrl <= 32'h80000001;
    end else begin
        led_ctrl <= data_i;
        address <= 0;
        enable_write <= 0;
        // if (address == 0) begin
        //     // led_ctrl <= data_i;
        //     // enable_write <= 1;
        //     address <= 1;
        // end

        // if (address == 1) begin 
        //     enable_write <= 0;
        //     address <= 0;
        // end 
    end
end

endmodule