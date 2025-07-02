///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////



module counterclass;

// add counter class here    
class counter;
    int count;
    int max;
    int min;

    function new(int val, int max, int min);
        this.check_limit(this.max, this.min);
        this.check_set(count);

    endfunction

    function void load(int val);
        this.check_set(val);
    endfunction

    function int getcount();
        return count;
    endfunction

    function void check_limit(int max, min);
        if(max < min) begin
            this.max = min;
            this.min = max;
        end
        else begin
            this.max = max;
            this.min = min;
        end
    endfunction

    function void check_set(int set);
        if(set >= min && set <= max) begin
            count = set; 
        end
        else begin 
            count = min;
            $display("Warning!!! the set number isn't within the range of the maximum and minimum.");
        end
    endfunction

endclass : counter 

class upcounter extends counter;
    function new(int val, int max, int min);
        super.new(val, max, min);
    endfunction

    function void next();
        if(count < max)count++;
        else count = min;
        check_set(count);
        $display("using upcounter: %d", count);
    endfunction
endclass : upcounter 

class downcounter extends counter;

    function new(int val, int max, int min);
        super.new(val, max, min);
    endfunction

    function void next();
        count--;
        if(count > min) count--;
        else count = max;
        check_set(count);
        $display("using downcounter: %d", count);
    endfunction


endclass : downcounter 

counter c1;
upcounter c2;

downcounter c3;
int cnt;
initial begin
    c1 = new(5, 8, 10);
    cnt = c1.getcount();
    $display("cnt = %d", cnt);

    $display("\n=========================");
    c2 = new(6, 4, 15);
    $display("cnt = %d", c2.getcount());
    $display("Aftering using upcounter");
    c2.next();
    c2.next();
    c2.next();
    c2.next();
   
   
    $display("\n=========================");
    c3 = new(8, 1, 20);
    $display("cnt = %d", c3.getcount());
    $display("Aftering using downcounter");
    c3.next();
    c3.next();
    c3.next();
    c3.next();
    c3.next();
    

end


endmodule
