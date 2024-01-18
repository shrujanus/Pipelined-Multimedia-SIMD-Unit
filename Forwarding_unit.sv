`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 03:04:42 AM
// Design Name: 
// Module Name: Forwarding_unit
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


module forward_unit (
    input  logic [24:0] instr,
    input  logic [24:0] opcode,
    output logic s1,
    output logic s2,
    output logic s3
);

    always_comb begin
        // Initialize outputs to 0
        {s1, s2, s3} = 3'b000;

        // Check the opcode and make decisions
        if (opcode[24:15] == 10'b1100000000) begin
            // Do nothing
        end else if ((opcode[24] == 1'b0) || (opcode[24] == 1'b1)) begin
            // For going into load
            if (instr[24] == 1'b0) begin
                if (opcode[4:0] == instr[4:0]) begin
                    s1 = 1'b1;
                end
            end else begin
                // For going into R3/R4 instructions
                if (opcode[4:0] == instr[9:5]) begin  // For rd = rs1
                    s1 = 1'b1;
                end
                if (opcode[4:0] == instr[14:10]) begin // For rd = rs2
                    s2 = 1'b1;
                end
                if (opcode[4:0] == instr[19:15]) begin // For rd = rs3 (only in R4 instructions, R3 ignores rs3 values)
                    s3 = 1'b1;
                end
            end
        end
    end

endmodule

