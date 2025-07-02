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

    function new(input int val, max, min);
        this.check_limit(max, min);
        this.check_set(val);
    endfunction

    function void load(input int val);
        this.check_set(val);
    endfunction

    function int getcount();
        return count;
    endfunction

    function void check_limit(input int max, min);
        if(max < min) begin
            this.max = min;
            this.min = max;
        end
        else begin
            this.max = max;
            this.min = min;
        end
       
    endfunction

    function void check_set(input int set);
        if(set >= min && set <= max) begin
            count = set; 
            $display("count = %d, max = %d, min = %d", count, max, min);
        end
        else begin 
            count = min;
            $display("Warning!!! the set number isn't within the range of the maximum and minimum.");
        end
    endfunction

endclass : counter 

class upcounter extends counter;
    bit carry;
    static int num = 0;
    function new(input int val, max, min);
        super.new(val, max, min);
        carry = 0;
        num++;
    endfunction

    function void next();
        if(count == max)begin
            count = min;
            carry = 1;
        end
        else begin
            count++;
            carry = 0;
        end
        $display("using upcounter: carry = %d, count = %d", carry, count);
    endfunction

    static function int total_num();
        return num;
    endfunction
endclass : upcounter 

class downcounter extends counter;
    bit borrow;
    static int num = 0;
    function new(input int val, max, min);
        super.new(val, max, min);
        borrow = 0;
        num++;
    endfunction

    function void next();
        if(count == min)begin
            count = max;
            borrow = 1;
        end
        else begin
            count--;
            borrow = 0;
        end
        $display("using downcounter: borrow = %d, count = %d", borrow, count);
    endfunction

    static function int total_num();
        return num;
    endfunction
endclass : downcounter 

class timer;
    upcounter hours, minutes, seconds;
    function new(input int hr, min, sec);
        hours   = new(hr, 23, 0);
        minutes = new(min, 59, 0);
        seconds = new(sec, 59, 0);

    endfunction

    function void load(input int hr=0, min=0, sec=0);
        hours.load(hr);
        minutes.load(min);
        seconds.load(sec);
    endfunction

    function void showval();
        $display("Time: %d hr %d min %d sec", hours.count, minutes.count, seconds.count);
    endfunction

    function void next();
        seconds.next();
        if(seconds.carry)begin
            minutes.next();
            if(minutes.carry) hours.next();
        end
        showval();
    endfunction

endclass : timer

// counter c1;
// upcounter c2;

// downcounter c3;
// int cnt;

timer clock;

initial begin

    clock = new(10, 21, 45);
    repeat(17) clock.next();
    // c1 = new(5, 8, 10);
    // cnt = c1.getcount();

    // $display("\n=========================");
    // c2 = new(6, 4, 10);
    // $display("Aftering using upcounter");
    // c2.next();
    // c2.next();
    // c2.next();
    // c2.next();
    // c2.next();
    // c2.next();
   
   
    // $display("\n=========================");
    // c3 = new(8, 1, 20);
    // $display("Aftering using downcounter");
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();
    // c3.next();

end


endmodule
