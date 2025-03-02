`timescale 1ns / 1ps

module top_wrapper_tb();

reg clk;
reg rst;

reg [31:0] provider_data;
reg [31:0] provider_addr;
reg [16:0] provider_ctrl;
reg provider_valid;
reg provider_ready;

reg consumer_valid;
reg consumer_ready;
reg [31:0] consumer_data;

top_wrapper #(.SIZE(4)) dut (
    .clk(clk),
    .rst(rst),
    .ctrl_data_i(provider_ctrl),
    .axis_m_data_tvalid(consumer_valid),
    .axis_m_data_tready(consumer_ready),
    .axis_m_data_tdata(consumer_data),
    .axis_s_data_tvalid(provider_valid),
    .axis_s_data_tready(provider_ready),
    .axis_s_data_tdata(provider_data),
    .axis_s_addr_tvalid(provider_valid),
    .axis_s_addr_tready(provider_ready),
    .axis_s_addr_tdata(provider_addr)
);

task reset;
    begin
        provider_data <= 0;
        provider_addr <= 0;
        provider_ctrl <= 0;
        provider_valid <= 0;
        consumer_ready <= 0;
        rst <= 0;
        repeat (10) @(posedge clk);
        rst <= 1;
    end
endtask;

initial begin
    clk <= 0;
    forever #1 clk <= ~clk;
end

initial begin
    reset;

    provider_ctrl <= 17'b00000000000000000;
    provider_data <= 1;
    provider_addr <= 2;
    provider_valid <= 1;
    consumer_ready <= 1;
    repeat (1) @(posedge clk);
    assert(consumer_data == 2) else $error("Does not propagate data correctly.");

    reset;

    provider_ctrl[6:0] <= 7'b0000011;
    provider_data <= 1;
    provider_addr <= 2;
    provider_valid <= 1;
    consumer_ready <= 1;
    repeat (1) @(posedge clk);
    assert(consumer_data == 0) else $error("Does not read memory correctly.");

    provider_ctrl[6:0] <= 7'b0100011;
    provider_data <= 42;
    provider_addr <= 1;
    provider_valid <= 1;
    consumer_ready <= 1;
    repeat (1) @(posedge clk);
    provider_ctrl[6:0] <= 7'b0000011;
    provider_data <= 0;
    provider_addr <= 1;
    provider_valid <= 1;
    consumer_ready <= 1;
    repeat (1) @(posedge clk);
    assert(consumer_data == 42) else $error("Does not read/write memory correctly.");
    provider_addr <= 0;
    repeat (1) @(posedge clk);
    assert(consumer_data == 0) else $error("Does not read/write memory correctly.");
end

endmodule
