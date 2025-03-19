`timescale 1ns / 1ps

module id_tb();

reg clk;
reg rst;
wire [31:0] inst;
reg jmp_en;
reg [15:0] jmp;
wire [15:0] pc;


task empty;
    begin
        assert(pc == 0) else $error("When the fetch stage is empty, pc has to be zero.");
        assert(jmp == 0) else $error("When the fetch stage is empty, jmp has to be zero.");
        assert(jmp_en == 0) else $error("When the fetch stage is empty, jmp_en has to be zero.");
        assert(inst == 0) else $error("When the fetch stage is empty, inst has to be zero.");
    end
endtask;

task reset;
    begin
        jmp <= 0;
        jmp_en <= 0;
        rst <= 0;
        repeat (10) @(posedge clk);
        rst <= 1;

        empty;
    end
endtask;


initial begin
    clk <= 0;
    forever #1 clk <= ~clk;
end

top_wrapper dut (
    .ctrl_data_o(),
    .axis_m_data_tvalid(),
    .axis_m_data_tready(),
    .axis_m_data_tdata(inst),
    .pc(pc),
    .jmp(jmp),
    .jmp_enable(jmp_en),
    .clk(clk),
    .rst(rst)
);

initial begin
    reset;

    repeat (2) @(posedge clk);
    assert(inst == 32'b00000000111000000000000100010011) else $error("The instruction is not correct.");
    assert(pc == 4) else $error("The pc is not correct, it is %d.", pc);

    repeat (1) @(posedge clk);
    assert(inst == 32'b00000000000000000000000000010011) else $error("The instruction is not correct.");
    assert(pc == 8) else $error("The pc is not correct, it is %d.", pc);

    // jmp_en <= 1;
    // jmp <= 0;
    // repeat (1) @(posedge clk);
    // assert(inst == 0) else $error("The instruction is not correct.");
    // assert(pc == 0) else $error("The pc is not correct, it is %d.", pc);

    // jmp_en <= 0;
    // jmp <= 32;
    // repeat (1) @(posedge clk);
    // assert(pc == 4) else $error("The pc is not correct, it is %d.", pc);

    // repeat (1) @(posedge clk);
    // assert(pc == 8) else $error("The pc is not correct, it is %d.", pc);

    // repeat (1) @(posedge clk);
    // assert(pc == 12) else $error("The pc is not correct, it is %d.", pc);

    repeat (10) @(posedge clk);
    $finish;
end

endmodule