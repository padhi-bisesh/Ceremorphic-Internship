module BTB_tb;
parameter W = 32;
parameter w_ind = 4;
parameter ways = 4;
reg clk,rst,EN;
reg predict,resolve;
reg pr_br_taken, pr_hit;
reg [W-1:0] pr_TARGET;
reg [W-1:0] PC_addr;
output HIT;
output [W-1:0] TARGET;
output out_valid;
output [0:3] test;
reg [3:0] temp;

BTB dut (.clk(clk) , .rst(rst) , .EN(EN), .predict(predict) , .resolve(resolve),
    .pr_br_taken(pr_br_taken) , .pr_hit(pr_hit) , .pr_TARGET(pr_TARGET) , .PC_addr(PC_addr) , .HIT(HIT) ,
    .TARGET(TARGET) , .out_valid(out_valid));

initial begin
    clk = 1;
    rst = 1;
    EN = 0;
    predict = 0;
    resolve = 0;
    pr_br_taken = 0;
    pr_hit = 0;
    PC_addr = 32'h00000000;
    //$monitor($time," Predcition = %b, pred_valid = %b",FINAL_PRED,pred_valid);
end

always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("BTB.vcd");
    $dumpvars(0,BTB_tb);
    
    #1 rst = 0;
    #1 rst = 1; EN = 1;
    #5;
    resolve = 1'b1; pr_br_taken = 1; pr_hit = 0;
    PC_addr = 32'h00000120; pr_TARGET = 32'haaaaaaaa;
    #10
    PC_addr = 32'h00000220; pr_TARGET = 32'hbbbbbbbb;
    #10
    PC_addr = 32'h00000320; pr_TARGET = 32'hcccccccc;
    #10
    PC_addr = 32'h00000420; pr_TARGET = 32'hdddddddd;
    #10
    PC_addr = 32'h00000520; pr_TARGET = 32'heeeeeeee;
    #10
    resolve = 1'b0; predict = 1'b1;
    PC_addr = 32'h00000120;
    #10
    PC_addr = 32'h00000220;
    #10
    PC_addr = 32'h00000320;
    #10
    PC_addr = 32'h00000420;
    #10
    PC_addr = 32'h00000520;
    #10
    resolve = 1'b1; predict = 1'b0; pr_br_taken = 1; pr_hit = 0;
    PC_addr = 32'h00000130; pr_TARGET = 32'haaaaaaaa;
    #10
    PC_addr = 32'h00000230; pr_TARGET = 32'hbbbbbbbb;
    #10
    PC_addr = 32'h00000330; pr_TARGET = 32'hcccccccc;
    #10
    PC_addr = 32'h00000430; pr_TARGET = 32'hdddddddd;
    #10
    PC_addr = 32'h00000530; pr_TARGET = 32'heeeeeeee;
    #10
    PC_addr = 32'h00000630; pr_TARGET = 32'heeeeffff;
    #10
    PC_addr = 32'h00000730; pr_TARGET = 32'hffffeeee;
    #10
    PC_addr = 32'h00000830; pr_TARGET = 32'hffffffff;
    #10
    resolve = 1'b0; predict = 1'b1;
    PC_addr = 32'h00000530;
    #10
    PC_addr = 32'h00000630;
    #10
    PC_addr = 32'h00000730;
    #10
    PC_addr = 32'h00000830;
    #10
    PC_addr = 32'h00000320;
    #10
    // temp = 4'd1;
    // temp = ~(temp);
    // $display("%b",temp>>1);

    #30;
    $finish;
end
endmodule