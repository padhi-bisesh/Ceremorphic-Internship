module PHT_tb;
parameter W = 32;
parameter w_ind = 4;
reg clk,rst;
reg predict,resolve;
reg incr, decr;
reg [w_ind-1:0] index;
output FINAL_PRED;
output pred_valid;
parameter L_pht = 2**w_ind;
integer i;


PHT dut (.clk(clk) , .rst(rst) , .predict(predict) , .resolve(resolve),
    .incr(incr) , .decr(decr) , .index(index) , .FINAL_PRED(FINAL_PRED) , .pred_valid(pred_valid));

initial begin
    clk = 1;
    rst = 1;
    predict = 0;
    resolve = 0;
    incr = 0;
    decr = 0;
    $monitor($time," Predcition = %b, pred_valid = %b",FINAL_PRED,pred_valid);
end

always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("PHT.vcd");
    $dumpvars(0,PHT_tb);
    
    #1 rst = 0;
    #1 rst = 1;
    #5;
    resolve = 1'b1; 
    for (i = 0 ; i < L_pht ; i = i+2) begin
        index = i;
        incr = 1;
        decr = 0;
        #10;
    end

    for (i = 0 ; i < L_pht ; i = i+4) begin
        index = i;
        incr = 1;
        decr = 0;
        #10;
    end

resolve = 0;
predict = 1;
    for (i = 0 ; i < L_pht ; i++) begin
        index = i;
        #10;
    end
    resolve = 1;
    predict = 0;
    index = 12; decr = 1; incr = 0;
    #10

    resolve = 0;
    predict = 1;
    index = 12;
    #10;
    #20;
    $finish;
end
endmodule