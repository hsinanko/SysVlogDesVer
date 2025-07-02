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
    task write_mem(input logic[4:0]waddr, input logic [7:0]wdata, input debug);
    @(negedge clk)
        write   <= 1;
        read    <= 0;
        addr    <= waddr;
        data_in <= wdata;
    @(negedge clk)
        write   <= 0;
        read    <= 0;
        if(debug) $display("addr: %d, data: %d", addr, data_in);

    endtask

    task read_mem(input logic[4:0]raddr, output [7:0]rdata, input debug);
    @(negedge clk)
        write  <= 0;
        read   <= 1;
        addr    <= raddr;
    @(negedge clk)
        read   <= 0;
        rdata = data_out;
    if(debug) $display("addr: %d, data: %d", addr, rdata);

    endtask
endinterface