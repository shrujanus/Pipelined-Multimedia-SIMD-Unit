`timescale 1ns / 1ps

module the_CPU (
    input  logic clk,
    input  string filename
);

    logic [24:0] InstructionBuff_Out,  twelve, seventeen,IfOpcode_out;
    logic [127:0] three, four, five, six, seven, eight, nine, ten, eleven, thirteen, sixteen;
    logic fourteen, s1, s2, s3;
    logic [4:0] fifteen;

    // Instantiate the sub-modules
    InstructionBuffer U1 (
        .clk(clk), 
        .asmfile(filename),
        .instruction(InstructionBuff_Out)
    );

    IfId_reg U2 (
        .clk(clk), 
        .instr(InstructionBuff_Out),
        .opcode(IfOpcode_out)
    );

    reg_file U3 (
        .opcode(IfOpcode_out), 
        .WE(fourteen), 
        .rd(fifteen), 
        .data(sixteen),
        .data1(three), 
        .data2(four), 
        .data3(five)
    );

    IdEx_reg U4 (
        .clk(clk), 
        .opcode(IfOpcode_out), 
        .d1in(three), 
        .d2in(four), 
        .d3in(five),
        .func(twelve), 
        .d1out(six), 
        .d2out(seven), 
        .d3out(eight)
    );

    mux U5 (
        .s1(s1), 
        .s2(s2), 
        .s3(s3), 
        .d1m(six), 
        .d2m(seven), 
        .d3m(eight), 
        .data(sixteen),
        .rs1(nine), 
        .rs2(ten), 
        .rs3(eleven)
    );

       ALU_unit U6 (
        .Rs1(nine), 
        .Rs2(ten), 
        .Rs3(eleven), 
        .OPCODE(twelve),
        .Rd(thirteen)
    );

    ex_wb_stage_reg U7 (
        .clk(clk), 
        .func(twelve), 
        .dataEX(thirteen),
        .field(seventeen), 
        .dataWB(sixteen), 
        .WE(fourteen), 
        .rd(fifteen)
    );

    forward_unit U8 (
        .instr(twelve), 
        .opcode(seventeen),
        .s1(s1), 
        .s2(s2), 
        .s3(s3)
    );

endmodule

