`timescale 1 ns / 1 ps

module led_driver 
(
    output wire [9:0] led_out,
    input wire [31:0] ctrl
);

assign led_out = ctrl[9:0];

endmodule