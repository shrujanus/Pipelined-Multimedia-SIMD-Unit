`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 02:55:15 AM
// Design Name: 
// Module Name: mux
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


module mux (
    input  logic s1, s2, s3,
    input  logic [127:0] d1m, d2m, d3m,
    input  logic [127:0] data,
    output logic [127:0] rs1, rs2, rs3
);

    always_comb begin
        // Default assignments
        rs1 = d1m;
        rs2 = d2m;
        rs3 = d3m;

        // Conditional assignments based on select signals
        if (s1) rs1 = data;
        if (s2) rs2 = data;
        if (s3) rs3 = data;
    end

endmodule

