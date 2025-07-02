///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t
import typedefs::*;
module control  (
                output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t   opcode  , // opcode type name must be opcode_t
                input             zero    ,
                input             clk     ,
                input             rst_   
                );
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

state_t [2:0]state, next_state;

always_ff @(posedge clk or negedge rst_)
  if (!rst_)
     state <= INST_ADDR;
  else
     state <= next_state;

always_comb begin
   unique case(state)
      INST_ADDR: next_state = INST_FETCH;
      INST_FETCH: next_state = INST_LOAD;
      INST_LOAD: next_state = IDLE;
      IDLE: next_state = OP_ADDR;
      OP_ADDR: next_state = OP_FETCH;
      OP_FETCH: next_state = ALU_OP;
      ALU_OP: next_state = STORE;
      STORE: next_state = INST_ADDR;
      default: next_state = INST_ADDR;
   endcase
end

always_comb begin
   unique if(state == INST_ADDR)begin
      mem_rd  = 0;
      load_ir = 0;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == INST_FETCH)begin
      mem_rd  = 1;
      load_ir = 0;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == INST_LOAD)begin
      mem_rd  = 1;
      load_ir = 1;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == IDLE)begin
      mem_rd  = 1;
      load_ir = 1;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == OP_ADDR)begin
      mem_rd  = 0;
      load_ir = 0;
      halt    = (opcode == HLT) ? 1 : 0;
      inc_pc  = 1;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == OP_FETCH)begin
      mem_rd  = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) ? 1 : 0;
      load_ir = 0;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end
   else if(state == ALU_OP)begin
      mem_rd  = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) ? 1 : 0;
      load_ir = 0;
      halt    = 0;
      inc_pc  = (opcode == SKZ && zero) ? 1 : 0;
      load_ac = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) ? 1 : 0;
      load_pc = (opcode == JMP) ? 1 : 0;
      mem_wr  = 0;
   end
   else if(state == STORE)begin
      mem_rd  = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) ? 1 : 0;
      load_ir = 0;
      halt    = 0;
      inc_pc  = (opcode == JMP) ? 1 : 0;
      load_ac = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) ? 1 : 0;
      load_pc = (opcode == JMP) ? 1 : 0;
      mem_wr  = (opcode == STO) ? 1 : 0;
   end
   else begin
      mem_rd  = 0;
      load_ir = 0;
      halt    = 0;
      inc_pc  = 0;
      load_ac = 0;
      load_pc = 0;
      mem_wr  = 0;
   end

end

endmodule
