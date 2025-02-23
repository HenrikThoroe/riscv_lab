`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 02:06:01 PM
// Design Name: 
// Module Name: interconnect_tb
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

module interconnect_tb();

reg clk;
reg rst;

reg [31:0] provider_data;
reg [15:0] provider_ctrl;
reg provider_valid;
reg provider_ready;

reg [31:0] consumer_data;
reg [15:0] consumer_ctrl;
reg consumer_valid;
reg consumer_ready;

pipeline_stage_interconnect #(.DATA_WIDTH(32), .CTRL_WIDTH(16), .BUFFER_DEPTH(2)) dut (
    .clk(clk),
    .rst(rst),
    .ctrl_data_i(provider_ctrl),
    .ctrl_data_o(consumer_ctrl),
    .axis_s_data_tvalid(provider_valid),
    .axis_s_data_tready(provider_ready),
    .axis_s_data_tdata(provider_data),
    .axis_m_data_tvalid(consumer_valid),
    .axis_m_data_tready(consumer_ready),
    .axis_m_data_tdata(consumer_data)
);

task empty;
    begin
        assert(provider_ready == 1) else $error("When the interconnect is empty, provider_ready has to be high.");
        assert(consumer_valid == 0) else $error("When the interconnect is empty, consumer_valid has to be low.");
    end
endtask;

task stall_by_consumer;
    begin
        assert(provider_ready == 0) else $error("When the interconnect is stalled by the consumer, provider_ready has to be low.");
        assert(consumer_valid == 1) else $error("When the interconnect is stalled by the consumer, consumer_valid has to be high.");
    end
endtask;

task stall_by_provider;
    begin
        assert(provider_ready == 1) else $error("When the interconnect is stalled by the provider, provider_ready has to be high.");
        assert(consumer_valid == 0) else $error("When the interconnect is stalled by the provider, consumer_valid has to be low.");
    end
endtask;

task flow_through;
    begin
        assert(provider_ready == 1) else $error("When the interconnect is flowing through, provider_ready has to be high.");
        assert(consumer_valid == 1) else $error("When the interconnect is flowing through, consumer_valid has to be high.");
    end
endtask;

task reset;
    begin
        provider_data <= 0;
        provider_ctrl <= 0;
        provider_valid <= 0;
        consumer_ready <= 0;
        rst <= 0;
        repeat (10) @(posedge clk);
        rst <= 1;

        empty;
    end
endtask;

task test_keeps_data;
    begin
        provider_data <= 1;
        provider_valid <= 1;
        repeat (1) @(posedge clk);
        empty;

        provider_valid <= 0;
        provider_data <= 2;
        repeat (1) @(posedge clk);
        assert(consumer_data == 1) else $error("The consumer data is not equal to the provider data.");
        flow_through;

        repeat (1) @(posedge clk);
        assert(consumer_data == 1) else $error("The consumer data is not equal to the provider data.");
        flow_through;
    end
endtask;

task test_stalls_by_consumer;
    begin
        provider_data <= 1;
        provider_valid <= 1;
        repeat (1) @(posedge clk);
        empty;

        provider_data <= 2;
        repeat (1) @(posedge clk);
        flow_through;

        repeat (1) @(posedge clk);
        stall_by_consumer;
    end
endtask;

task test_stalls_by_provider;
    begin
        provider_data <= 1;
        provider_valid <= 1;
        repeat (1) @(posedge clk);
        empty;

        provider_data <= 2;
        repeat (1) @(posedge clk);
        flow_through;

        repeat (1) @(posedge clk);
        stall_by_consumer;

        consumer_ready <= 1;
        provider_valid <= 0;
        repeat (1) @(posedge clk);
        stall_by_consumer;
        assert(consumer_data == 1) else $error("The consumer data is not equal to the provider data.");

        repeat (1) @(posedge clk);
        flow_through;
        assert(consumer_data == 2) else $error("The consumer data is not equal to the provider data.");

        repeat (1) @(posedge clk);
        stall_by_provider;
    end
endtask;

task test_consistent_flow;
    begin
        provider_data <= 1;
        provider_valid <= 1;
        consumer_ready <= 1;
        repeat (1) @(posedge clk);
        empty;

        provider_data <= 2;
        repeat (1) @(posedge clk);
        flow_through;
        assert(consumer_data == 1) else $error("The consumer data is not equal to the provider data.");

        provider_data <= 3;
        repeat (1) @(posedge clk);
        flow_through;
        assert(consumer_data == 2) else $error("The consumer data is not equal to the provider data.");

        provider_data <= 4;
        repeat (1) @(posedge clk);
        flow_through;
        assert(consumer_data == 3) else $error("The consumer data is not equal to the provider data.");
    end
endtask;

initial begin
    clk <= 0;
    forever #1 clk <= ~clk;
end

initial begin
    reset;
    test_keeps_data;
    reset;
    test_stalls_by_consumer;
    reset;
    test_stalls_by_provider;
    reset;
    test_consistent_flow;
end

endmodule
