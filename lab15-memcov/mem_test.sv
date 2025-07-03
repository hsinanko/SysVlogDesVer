
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
int ok;
typedef enum {ascii, lowercase, uppercase, weightedcase} control_t;

class random_data;
  rand bit [4:0]addr;
  rand bit [7:0]data;
  control_t control; 

  function new(input bit [4:0] addr = 0, [7:0] data = 0);
    this.addr = addr;
    this.data = data;
  endfunction
  constraint different {
    control == ascii -> data inside {[8'h20:8'h7F]};
    control == lowercase -> data inside {[8'h61:8'h7a]};
    control == uppercase -> data inside {[8'h41:8'h5a]};
    control == weightedcase -> data dist {[8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20};
  }
  // constraint charactor { data inside {[8'h20:8'h7F]};}
  // constraint english { data inside {[8'h41:8'h5a], [8'h61:8'h7a]};}
  // constraint weighted {data dist {[8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20};}

endclass : random_data

random_data mem;

covergroup cg;
  indata: coverpoint mbus.data_in {
    bins upper = {[8'h41:8'h5a]};
    bins lower = {[8'h61:8'h7a]};
    bins other = default;}
  
  outdata: coverpoint mbus.data_out {
    bins upper = {[8'h41:8'h5a]};
    bins lower = {[8'h61:8'h7a]};
    bins other = default;
  }

endgroup

cg cg1 = new();


// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

  initial begin: memtest
    int error_status;
    mem = new(2, 8);
    

    for(int i = 0; i < 32; i++)begin
      ok = mem.randomize();
      if(!ok) $display("Wrong!! There is an error about randomization");
      mbus.write_mem(mem.addr, mem.data, debug);
      mbus.read_mem(mem.addr, rdata, debug);
    end
    // print results of test
      printstatus(error_status);
      $finish;
  end

// add result print function
function int checkdata(input [4:0]addr, 
                   input [7:0]observed, input [7:0]expected);
  static int error = 0;
  if(observed != expected)begin
    error++;
    $display("ERROR: Memory[%d] = %c, EXCEPTED: %c", addr, observed, expected);
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
