interface mem_intf #(AddrWidth = 5, DataWidth = 8) (input logic clk);
    timeunit 1ns;
    timeprecision 100ps;

    logic [AddrWidth-1:0]addr;
    logic [DataWidth-1:0]data_in;
    logic [DataWidth-1:0]data_out;
    logic read;
    logic write;

    modport mem(input addr, data_in, read, write, clk, 
                output data_out);

    modport tb(output addr, data_in, read, write, clk, 
                input data_out);
    // add read_mem and write_mem tasks

endinterface