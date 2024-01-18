`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 04:30:13 AM
// Design Name: 
// Module Name: IfId_reg
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

module IfId_reg (
    input  logic clk,
    input  logic [24:0] instr,
    output logic [24:0] opcode
);

    always_ff @(posedge clk) begin
        opcode <= instr;
    end

endmodule

