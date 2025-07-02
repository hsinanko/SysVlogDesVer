module counter #(WIDTH=5)
                (output logic [WIDTH-1:0]count,
                 input  logic [WIDTH-1:0]data,
                 input  logic load,
                 input  logic enable,
                 input  logic clk,
                 input  logic rst_);
    timeunit 1ns;
    timeprecision 100ps;

    always_ff@(posedge clk or negedge rst_)begin
        if(~rst_) count <= '0;
        else if(load) count <= data;
        else if(enable) count <= count + 1;
        else count <= count;
    end



endmodule
