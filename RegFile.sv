`timescale 1ns / 1ps
module reg_file (
    input  logic [24:0] opcode,
    input  logic WE,
    input  logic [4:0] rd,
    input  logic [127:0] data,
    output logic [127:0] data1, data2, data3
);
    //int file_handle;
        int file_handle = $fopen("/home/shrujan/Desktop/VHDL_files/asmFile/register_values.txt", "w");

    // Define the registers array
    logic [127:0] registerfile[0:31];

    // Initialize the registers array to zero
    initial begin
        for (int i = 0; i < 32; i++) begin
            registerfile[i] = 128'b0;
        end
    end

    // Write process
    always_comb begin
        if (WE) begin
            registerfile[rd] = data;
        end
    end

    // Read process
    always_comb begin
        data1 = registerfile[opcode[9:5]];
        data2 = registerfile[opcode[14:10]];
        data3 = registerfile[opcode[19:15]];

        // If load instruction, then read address is different
        if (opcode[24] == 1'b0) begin
            data1 = registerfile[opcode[4:0]];
        end
    end
    
    // Output register values to a text file
    initial begin
        // Open a file in write mode
        

        if (file_handle) begin
            // Iterate through the register file and write each value
            for (int i = 0; i < 32; i++) begin
                $fwrite(file_handle, "registerfile[%0d] = %0h\n", i, registerfile[i]);
            end
            // Close the file
            $fclose(file_handle);
        end
        else begin
            $display("Error: File could not be opened.");
        end
    end


endmodule
