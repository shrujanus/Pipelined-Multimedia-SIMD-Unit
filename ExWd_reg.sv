`timescale 1ns / 1ps

module ex_wb_stage_reg (
    input  logic clk,
    input  logic [24:0] func,
    input  logic [127:0] dataEX,
    output logic [24:0] field,
    output logic [127:0] dataWB,
    output logic WE,
    output logic [4:0] rd
);

    always_ff @(posedge clk) begin
        field <= func;
        rd <= func[4:0];
        dataWB <= dataEX;
        WE <= 1'b0;
        
        if (func[24:0] == 25'b1100000000000000000000000) begin
            WE<= 1'b0;
        end
        else if (func[24] == 1'b0 || func[24:23] == 2'b10 || func[24:23] == 2'b11) begin
            WE <= 1'b1;
        end

        
        
    end

endmodule


