//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 02:54:03 AM
// Design Name: 
// Module Name: InstructionBuffer
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

`timescale 1ns / 1ps

module InstructionBuffer (
    input  logic clk,
    input  string asmfile,
    output logic [24:0] instruction
);

    integer read_finish = 0;
    integer PC = 0;
    logic [24:0] instruction_field [0:63];
    integer i = 0;
    integer file_descriptor;
    string line;

    initial begin
        if (read_finish == 0) begin
            file_descriptor = $fopen(asmfile, "r");
            if (file_descriptor) begin
                while (!$feof(file_descriptor)) begin
                    $fgets(line, file_descriptor);
                    instruction_field[i] = line.atobin();
                    i = i + 1;
                end
                read_finish = 1;
                $fclose(file_descriptor);
            end
        end
    end

    always_ff @(posedge clk) begin
        if (read_finish == 1 && PC < 64) begin
             instruction <= instruction_field[PC];
              PC <= PC + 1;
        end
    end
    
    

endmodule




