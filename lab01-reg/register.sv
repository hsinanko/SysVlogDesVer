module register #(WIDTH = 8)
                 (output logic [WIDTH-1:0] out,
                  input  logic [WIDTH-1:0] data,
                  input  logic enable,
                  input  logic clk,
                  input  logic rst_);
    timeunit        1ns;
    timeprecision 100ps;  

    always_ff@(posedge clk or negedge rst_)begin
      if(~rst_) out <= '0;
        else if(enable) out <= data;
        else out <= out;
    end
endmodule
