module GBHR_tb;
    parameter w_pht = 4;
    reg clk,rst,EN;
    reg predict,resolve;
    reg pr_br_taken;
    output [w_pht-1:0] gbhr;

    GBHR dut (.clk(clk) , .rst(rst) , .EN(EN) , .predict(predict) , .resolve(resolve) ,
             .pr_br_taken(pr_br_taken) , .gbhr(gbhr));
    
    initial begin
        clk = 1;
        rst = 1;
        EN = 0;
        predict = 0;
        resolve = 0;
        pr_br_taken = 0;
        $monitor($time," GBHR = %b",gbhr);
    end
    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("GBHR.vcd");
        $dumpvars(0,GBHR_tb);
        
        #1 rst = 0;
        #1 rst = 1; EN = 1;
        #5;
        resolve = 1'b1; 
        pr_br_taken = 1;
        #10
        pr_br_taken = 0;
        #20
        pr_br_taken = 1;
        #10
        resolve = 0;predict = 1;
        #30
        $finish;
    end
endmodule