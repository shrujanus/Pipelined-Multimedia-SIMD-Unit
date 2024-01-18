`timescale 1ns / 1ps

module ALU_unit(

    input logic[127:0] Rs1,
    input logic[127:0] Rs2,
    input logic[127:0] Rs3,
    input logic[24:0] OPCODE,
    output logic[127:0] Rd

    );
    
    bit[1:0] InputCase;
    
    assign InputCase = OPCODE[24:23];
    
    localparam OP_LOAD = 2'b00; // Condition for Load Function.
    localparam OP_R4 = 2'b10;   // Condition for R4 Function.
    localparam OP_R3 = 2'b11;   // Condition for R3 Funtion.
    
    
    //For Load
    logic [2:0] LoadIndex; 
    logic [15:0] Immediate;
    logic [127:0] tmp_rd;
    assign LoadIndex = OPCODE[23:21];
    assign Immediate = OPCODE[20:5];
    
    //For R3
    logic [3:0] OpCodeR3;
    longint result, shift_amount;
    assign OpCodeR3 = OPCODE[15+:4];


    //For R4
    logic [2:0] OpcodeR4;
    longint result_64;
    int result;
    assign OpcodeR4 = OPCODE[22:20];

    
    
    always_comb begin
    case(InputCase)
        OP_LOAD,2'b01:
        begin
            // logic for Load Immidiate\
            tmp_rd = Rs1;
            tmp_rd[LoadIndex*16 +: 16] = Immediate;
         end
         OP_R4:
         begin
            // logic for R4
            case(OpcodeR4)
            3'b000:
            begin
                //Signed Integer Multiply-Add Low with Saturation
                for(int i = 0; i < 4; i++) begin
                    result = $signed(Rs3[i*32 +: 16]) * $signed(Rs2[i*32 +: 16]) + $signed(Rs1[i*32 +: 32]);
                    if((result) > 2147483647) begin 
                        $display((result));
                         result = 2147483647;
                     end
                    else if($signed(result) < $signed(32'h80000000)) begin 
                        
                         result = $signed(32'h80000000);
                         $display($signed(result));
                   end
                   
                    tmp_rd[i*32 +: 32] = result;
                end                
            end
            3'b001:
            begin
                //Signed Integer Multiply-Add High with Saturation
                for(int i = 0; i < 4; i++) begin
                    result = $signed(Rs3[i*32 + 16 +: 16]) * $signed(Rs2[i*32 + 16 +: 16]) + $signed(Rs1[i*32 +: 32]);
                    if(result > $signed(32'h7FFFFFFF)) begin 
                        result = $signed(32'h7FFFFFFF);
                    end
                    else if(result < $signed(32'h80000000)) begin 
                        result = $signed(32'h80000000);
                       end
                    $display(result);
                    tmp_rd[i*32 +: 32] = result;
                end                
            end
            3'b010:
            begin
                //Signed Integer Multiply-Subtract Low with Saturation
                for(int i = 0; i < 4; i++) begin
                    result = $signed(Rs1[i*32 +: 32]) - ($signed(Rs3[i*32 +: 16]) * $signed(Rs2[i*32 +: 16]));
                    if(result > $signed(32'h7FFFFFFF)) result = $signed(32'h7FFFFFFF);
                    else if(result < $signed(32'h80000000)) result = $signed(32'h80000000);
                    tmp_rd[i*32 +: 32] = result;
                end                
            end
            3'b011:
            begin
                //Signed Integer Multiply-Subtract High with Saturation
                for(int i = 0; i < 4; i++) begin
                    result = $signed(Rs1[i*32 +: 32]) - ($signed(Rs3[i*32 + 16 +: 16]) * $signed(Rs2[i*32 + 16 +: 16]));
                    if(result > $signed(32'h7FFFFFFF)) result = $signed(32'h7FFFFFFF);
                    else if(result < $signed(32'h80000000)) result = $signed(32'h80000000);
                    tmp_rd[i*32 +: 32] = result;
                end                
            end
            3'b100:
            begin
                //Signed Long Integer Multiply-Add Low with Saturation
                for(int i = 0; i < 2; i++) begin
                    result_64 = $signed(Rs3[i*64 +: 32]) * $signed(Rs2[i*64 +: 32]) + $signed(Rs1[i*64 +: 64]);
                    if(result_64 > $signed(64'h7FFFFFFFFFFFFFFF)) result_64 = $signed(64'h7FFFFFFFFFFFFFFF);
                    else if(result_64 < $signed(64'h8000000000000000)) result_64 = $signed(64'h8000000000000000);
                    tmp_rd[i*64 +: 64] = result_64;
                end               
            end
            3'b101:
            begin
                //Signed Long Integer Multiply-Add High with Saturation
                for(int i = 0; i < 2; i++) begin
                    result_64 = $signed(Rs3[i*64 + 32 +: 32]) * $signed(Rs2[i*64 + 32 +: 32]) + $signed(Rs1[i*64 +: 64]);
                    if(result_64 > $signed(64'h7FFFFFFFFFFFFFFF)) result_64 = $signed(64'h7FFFFFFFFFFFFFFF);
                    else if(result_64 < $signed(64'h8000000000000000)) result_64 = $signed(64'h8000000000000000);
                    tmp_rd[i*64 +: 64] = result_64;
                end               
            end
            3'b110:
            begin
                //Signed Long Integer Multiply-Subtract Low with Saturation
                for(int i = 0; i < 2; i++) begin
                    result_64 = $signed(Rs1[i*64 +: 64]) - ($signed(Rs3[i*64 +: 32]) * $signed(Rs2[i*64 +: 32]));
                    if(result_64 > $signed(64'h7FFFFFFFFFFFFFFF)) result_64 = $signed(64'h7FFFFFFFFFFFFFFF);
                    else if(result_64 < $signed(64'h8000000000000000)) result_64 = $signed(64'h8000000000000000);
                    tmp_rd[i*64 +: 64] = result_64;
                end                
            end
            3'b111:
            begin
                // Signed Long Integer Multiply-Subtract High with Saturation
                for(int i = 0; i < 2; i++) begin
                    result_64 = $signed(Rs1[i*64 +: 64]) - ($signed(Rs3[i*64 + 32 +: 32]) * $signed(Rs2[i*64 + 32 +: 32]));
                    if(result_64 > $signed(64'h7FFFFFFFFFFFFFFF)) result_64 = $signed(64'h7FFFFFFFFFFFFFFF);
                    else if(result_64 < $signed(64'h8000000000000000)) result_64 = $signed(64'h8000000000000000);
                    tmp_rd[i*64 +: 64] = result_64;
                end                
            end
                                                
           endcase
         end
         OP_R3:
         begin
            // logic for R3
            case(OpCodeR3)
            4'b0000:
                begin
                    //NOP
                    tmp_rd = 128'b0;
                end
            4'b0001:
                begin
                    //shift right halfword immediate
                    for(int i = 0; i < 8; i++) begin
                        tmp_rd[i*16 +: 16] = Rs1[i*16 +: 16] >>> Rs2[0 +: 4];
                    end                    
                end
             4'b0010:
                begin
                    //AU: add word unsigned
                    for(int i = 0; i < 4; i++) begin
                        tmp_rd[i*32 +: 32] = Rs1[i*32 +: 32] + Rs2[i*32 +: 32];
                    end
                end
            4'b0011:
                begin
                    //CNT1H: count 1s in halfword
                    for(int i = 0; i < 8; i++) begin
                        tmp_rd[i*16 +: 16] = $countones(Rs1[i*16 +: 16]);
                    end
                end
            4'b0100:
                begin
                    //AHS: add halfword saturated
                    for(int i = 0; i < 8; i++) begin
                        result = $signed(Rs1[i*16 +: 16]) + $signed(Rs2[i*16 +: 16]);
                        if(result > 32767) result = 32767;
                        else if(result < -32768) result = -32768;
                        tmp_rd[i*16 +: 16] = result;
                    end 
                end
             4'b0101:
                begin
                    // OR: bitwise logical or
                    tmp_rd = Rs1 | Rs2;
                end
             4'b0110:
                begin
                    //BCW: broadcast word
                    tmp_rd = {4{Rs1[0 +: 32]}};
                end
            4'b0111:
                begin
                     //MAXWS: max signed word
                    for(int i = 0; i < 4; i++) begin
                        tmp_rd[i*32 +: 32] = ($signed(Rs1[i*32 +: 32]) > $signed(Rs2[i*32 +: 32])) ? Rs1[i*32 +: 32] : Rs2[i*32 +: 32];
                    end                   
                end
            4'b1000:
                begin
                   //MINWS: min signed word
                    for(int i = 0; i < 4; i++) begin
                        tmp_rd[i*32 +: 32] = ($signed(Rs1[i*32 +: 32]) < $signed(Rs2[i*32 +: 32])) ? Rs1[i*32 +: 32] : Rs2[i*32 +: 32];
                    end
                end
             4'b1001:
                begin
                    //MLHU: multiply low unsigned
                    for(int i = 0; i < 4; i++) begin
                        tmp_rd[i*32 +: 32] = (Rs1[i*32 +: 16]) * (Rs2[i*32 +: 16]);
                    end
                end
            4'b1010:
                begin
                    //MLHSS: multiply by sign saturated
                    for(int i = 0; i < 8; i++) begin
                        if(Rs2[i*16 +: 16] < 0) tmp_rd[i*16 +: 16] = -Rs1[i*16 +: 16];
                        else if(Rs2[i*16 +: 16] > 0) tmp_rd[i*16 +: 16] = Rs1[i*16 +: 16];
                        else tmp_rd[i*16 +: 16] = 0;
                    end
                end
            4'b1011:
                begin
                    //AND: bitwise logical and
                    tmp_rd = Rs1 & Rs2;
                end
             4'b1100:
                begin
                    //INVB: invert (flip) bits
                    tmp_rd = ~Rs1;
                end
            4'b1101:
                begin
                    //ROTW: rotate bits in word
                    for(int i = 0; i < 4; i++) begin
                        shift_amount = Rs2[i*32 +: 5];
                        tmp_rd[i*32 +: 32] = (Rs1[i*32 +: 32] >>> shift_amount) | (Rs1[i*32 +: 32] << (32-shift_amount));
                    end
                end
            4'b1110:
                begin
                    //SFWU: subtract from word unsigned
                    for(int i = 0; i < 4; i++) begin
                        tmp_rd[i*32 +: 32] = Rs2[i*32 +: 32] - Rs1[i*32 +: 32];
                    end
                end
             4'b1111:
                begin
                    //SFHS: subtract from halfword saturated
                    for(int i = 0; i < 8; i++) begin
                        result = $signed(Rs2[i*16 +: 16]) - $signed(Rs1[i*16 +: 16]);
                        if(result > 32767) result = 32767;
                        else if(result < -32768) result = -32768;
                        tmp_rd[i*16 +: 16] = result;
                    end
                end                                                                
            endcase
           
         end
        endcase
        Rd = tmp_rd;
        end
endmodule
