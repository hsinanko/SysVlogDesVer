import typedefs::*;
module alu(output logic [7:0]out,
           output logic      zero,
           input  logic [7:0]accum,
           input  logic [7:0]data,
           input  opcode_t   opcode,
           input             clk);
    timeunit 1ns;
    timeprecision 100ps;

    always_ff@(negedge clk)begin
        zero <= (accum == 0) ? 1 : 0;
        unique case(opcode)
            HLT: out <= accum;
            SKZ: out <= accum;
            ADD: out <= data + accum;
            AND: out <= data & accum;
            XOR: out <= data ^ accum;
            LDA: out <= data;
            STO: out <= accum;
            JMP: out <= accum;
            default: out <= '0;
        endcase
    end

endmodule