`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 02:47:47 AM
// Design Name: 
// Module Name: IdEx_reg
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

module IdEx_reg (
    input  logic clk,
    input  logic [24:0] opcode,
    input  logic [127:0] d1in, d2in, d3in,
    output logic [24:0] func,
    output logic [127:0] d1out, d2out, d3out
);

    always_ff @(posedge clk) begin
        func <= opcode;
        d1out <= d1in;
        d2out <= d2in;
        d3out <= d3in;
    end

endmodule

