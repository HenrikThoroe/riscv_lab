`timescale 1ns / 1ps

module id_tb();

reg clk;
reg rst;
reg [31:0] inst;
wire [31:0] imm;
wire [31:0] rs1;
wire [31:0] rs2;
wire wb_en;
wire [4:0] wb_reg;
reg [4:0] wb_reg_i;
reg [31:0] wb_data_i;
reg wb_en_i;

task empty;
    begin
        assert(imm == 0) else $error("When the decode stage is empty, imm has to be zero.");
        assert(rs1 == 0) else $error("When the decode stage is empty, rs1 has to be zero.");
        assert(rs2 == 0) else $error("When the decode stage is empty, rs2 has to be zero.");
        assert(wb_en == 0) else $error("When the decode stage is empty, wb_en has to be zero.");
        assert(wb_reg == 0) else $error("When the decode stage is empty, wb_reg has to be zero.");
    end
endtask;

task reset;
    begin
        wb_reg_i <= 0;
        wb_data_i <= 0;
        wb_en_i <= 0;
        inst <= 0;
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
    .operand_aclk(clk),
    .operand_aresetn(rst),
    .operand_tready(),
    .operand_tdata(inst),
    .operand_tvalid(),
    .data_aclk(clk),
    .data_aresetn(rst),
    .data_tready(),
    .data_tdata(),
    .data_tvalid(),
    .o_imm(imm),
    .o_rs1(rs1),
    .o_rs2(rs2),
    .o_wb_reg(wb_reg),
    .o_wb_enable(wb_en),
    .i_wb_reg(wb_reg_i),
    .i_wb_data(wb_data_i),
    .i_wb_write(wb_en_i)
);

initial begin
    reset;

    inst <= 32'b00000000000100010000000100010011; // addi x2, x2, 1
    wb_reg_i <= 0;
    wb_data_i <= 0;
    wb_en_i <= 0;
    repeat (1) @(posedge clk);
    inst <= 32'b00000000000000000000000000000000;
    repeat (1) @(posedge clk);
    assert(imm == 1) else $error("imm should be 1.");
    assert(rs1 == 0) else $error("rs1 should be 0.");
    assert(rs2 == 0) else $error("rs2 should be 0.");
    assert(wb_en == 1) else $error("wb_en should be 1.");
    assert(wb_reg == 2) else $error("wb_reg should be 2.");

    inst <= 32'b00000000001100010000000010110011; // add x1, x2, x3
    wb_reg_i <= 0;
    wb_data_i <= 0;
    wb_en_i <= 0;
    repeat (2) @(posedge clk);
    assert(imm == 0) else $error("imm should be 0.");
    assert(rs1 == 0) else $error("rs1 should be 2.");
    assert(rs2 == 0) else $error("rs2 should be 3.");
    assert(wb_en == 1) else $error("wb_en should be 1.");
    assert(wb_reg == 1) else $error("wb_reg should be 1.");

    inst <= 32'b00000000010100000000000110010011; // addi x3, x0, 5
    wb_reg_i <= 3;
    wb_data_i <= 5;
    wb_en_i <= 1;
    repeat (2) @(posedge clk);
    assert(imm == 5) else $error("imm should be 5.");
    assert(rs1 == 0) else $error("rs1 should be 0.");
    assert(rs2 == 0) else $error("rs2 should be 0.");
    assert(wb_en == 1) else $error("wb_en should be 1.");
    assert(wb_reg == 3) else $error("wb_reg should be 3.");

    inst <= 32'b00000000001100010000000010110011; // add x1, x2, x3
    wb_reg_i <= 0;
    wb_data_i <= 0;
    wb_en_i <= 0;
    repeat (2) @(posedge clk);
    assert(imm == 0) else $error("imm should be 0.");
    assert(rs1 == 0) else $error("rs1 should be 2.");
    assert(rs2 == 5) else $error("rs2 should be 3.");
    assert(wb_en == 1) else $error("wb_en should be 1.");
    assert(wb_reg == 1) else $error("wb_reg should be 1.");

    inst <= 32'b00000000001100000010001000100011; // sw x3, 4(x0)
    wb_reg_i <= 0;
    wb_data_i <= 0;
    wb_en_i <= 0;
    repeat (2) @(posedge clk);
    assert(imm == 4) else $error("imm should be 4.");
    assert(rs1 == 0) else $error("rs1 should be 0.");
    assert(rs2 == 5) else $error("rs2 should be 5.");
    assert(wb_en == 0) else $error("wb_en should be 0.");

    inst <= 32'b00000010101000011010001000000011; // lw x4, 42(x3)
    wb_reg_i <= 0;
    wb_data_i <= 0;
    wb_en_i <= 0;
    repeat (2) @(posedge clk);
    assert(imm == 42) else $error("imm should be 42.");
    assert(rs1 == 5) else $error("rs1 should be 5.");
    assert(rs2 == 0) else $error("rs2 should be 0.");
    assert(wb_en == 1) else $error("wb_en should be 1.");
    assert(wb_reg == 4) else $error("wb_reg should be 4.");

    // inst <= 32'b00000000001000100000000100110011; // add x2, x4, x2
    // wb_reg_i <= 0;
    // wb_data_i <= 0;
    // wb_en_i <= 0;
    // repeat (2) @(posedge clk);
    // assert(imm == 0) else $error("imm should be 42.");
    // assert(rs1 == 5) else $error("rs1 should be 5.");
    // assert(rs2 == 0) else $error("rs2 should be 0.");
    // assert(wb_en == 1) else $error("wb_en should be 1.");
    // assert(wb_reg == 4) else $error("wb_reg should be 4.");

    repeat (10) @(posedge clk);
    $finish;
end

endmodule