// Code your testbench here
// or browse Examples
///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : top.sv
// Title       : top module for Memory labs 
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the top module for memory labs
// Notes       :
// Memory Lab - top-level 
// A top-level module which instantiates the memory and mem_test modules
// 
///////////////////////////////////////////////////////////////////////////
module mem_test ( // input logic clk, 
                  // output logic read, 
                  // output logic write, 
                  // output logic [4:0] addr, 
                  // output logic [7:0] data_in,     // data TO memory
                  // input  wire [7:0] data_out     // data FROM memory
                  mem_intf.tb mbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");


    for (int i = 0; i< 32; i++)begin
       // Write zero data to every address location
        mbus.write_mem(i, 0, debug);
    end
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
        mbus.read_mem(i, rdata, debug);
       // check each memory location for data = 'h00
        error_status = checkdata(i, rdata, 0);
      end

   // print results of test

    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       mbus.write_mem(i, i, debug);
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
        mbus.read_mem(i, rdata, debug);
       // check each memory location for data = address
		    error_status = checkdata(i, rdata, i);
      end

   // print results of test
    printstatus(error_status);
    $finish;
  end

// add result print function
function checkdata(input [4:0]addr, 
                   input [7:0]observed, input [7:0]expected);
  static int error = 0;
  if(observed != expected)begin
    $display("ERROR: Memory[%d] = %d, EXCEPTED: %d", addr, observed, expected);
  end
  return error;
endfunction

function void printstatus(input int status);
  if(status == 0)
    $display("TEST PASSED - NO ERRORS");
  else
    $display("There are %d ERRORS", status);
endfunction


endmodule