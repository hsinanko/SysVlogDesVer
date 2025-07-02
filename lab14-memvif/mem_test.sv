
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
typedef enum bit[1:0]{ascii, lowercase, uppercase, weightedcase} control_t;



class random_data;
  rand bit [4:0]addr;
  rand bit [7:0]data;
  control_t control; 
  virtual interface mem_intf vif;
  bit [7:0]rdata;

  function new(input bit [4:0] addr = 0, [7:0] data = 0);
    this.addr = addr;
    this.data = data;
  endfunction
  constraint different {
    control == ascii -> data inside {[8'h20:8'h7F]};
    control == lowercase -> data inside {[8'h41:8'h5a], [8'h61:8'h7a]};
    control == uppercase -> data inside {[8'h41:8'h5a], [8'h61:8'h7a]};
    control == weightedcase -> data dist {[8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20};
  }
  // constraint charactor { data inside {[8'h20:8'h7F]};}
  // constraint english { data inside {[8'h41:8'h5a], [8'h61:8'h7a]};}
  // constraint weighted {data dist {[8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20};}
  function void configure(input virtual interface mem_intf intf);
    this.vif = intf;
  endfunction

  task write_mem(input debug);
    @(negedge vif.clk)
        vif.write   <= 1;
        vif.read    <= 0;
        vif.addr    <= this.addr;
        vif.data_in <= this.data;
    @(negedge vif.clk)
        vif.write   <= 0;
        vif.read    <= 0;
        if(debug) $display("addr: %d, data: %c", vif.addr, vif.data_in);

  endtask

  task read_mem(input debug);
    @(negedge vif.clk)
        vif.write  <= 0;
        vif.read   <= 1;
        vif.addr   <= this.addr;
    @(negedge vif.clk)
        vif.read   <= 0;
        rdata = vif.data_out;
    if(debug) $display("addr: %d, data: %c", vif.addr, rdata);

  endtask

endclass : random_data


/*=================== Test =========================*/

random_data mem;
// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
  end

  initial begin: memtest
    int error_status;

  
    mem = new;
    mem.configure(mbus);
    mem.control = weightedcase;
    for(int i = 0; i < 32; i++)begin
      ok = mem.randomize();
      if(!ok) $display("Wrong!! There is an error about randomization");
      mem.write_mem(debug);
      mem.read_mem(debug);
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
