module GshareTestbench;
parameter W = 32;
parameter L_pht = 16;
parameter ways = 4;
parameter L_btb = 16;

reg clk;
reg rst;
reg start_pred;
reg start_resolve;
reg [W-1:0] PC;
reg [W-1:0] actual_target;
reg pr_hit;

output BR_PRED;
output [W-1:0] TARGET;
output DONE;

Gsharetop i0 (
    .clk(clk),
    .rst(rst),
    .PC(PC),
    .start_pred(start_pred),
    .actual_target(actual_target),
    .start_resolve(start_resolve),
    .pr_hit(pr_hit),
    .BR_PRED(BR_PRED),
    .TARGET(TARGET),
    .DONE(DONE)
);
integer i;
always #5 clk = ~clk;

initial begin
    clk = 1'b1;
    rst = 1'b1;
    #1 rst = 1'b0;
    #1 rst = 1'b1;
    start_pred = 0;
    start_resolve = 0;
end

initial begin
    $dumpfile("GshareTestbench.vcd");
    $dumpvars(0,GshareTestbench);
    #2;
    #0
    start_pred = 1; start_resolve = 0; PC = 32'h00001000;
    #30 start_pred = 0; start_resolve = 1; PC = 32'h00001000; actual_target = 32'h10000000;pr_hit = 0;
    
    for(i = 0;i < 7;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = 32'h00001000;
        #30 start_pred = 0; start_resolve = 1; PC = 32'h00001000; actual_target = 32'h10000000;pr_hit = 1;
    end

    for(i = 0;i < 7;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = 32'h00002000;
        #30 start_pred = 0; start_resolve = 1; PC = 32'h00002000; actual_target = 32'h20000000;pr_hit = ((i==0) ? 0 : 1);
    end

    for(i = 0;i < 7;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = 32'h00003000;
        #30 start_pred = 0; start_resolve = 1; PC = 32'h00003000; actual_target = 32'h30000000;pr_hit = ((i==0) ? 0 : 1);
    end

    for(i = 0;i < 7;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = 32'h00004000;
        #30 start_pred = 0; start_resolve = 1; PC = 32'h00004000; actual_target = 32'h40000000;pr_hit = ((i==0) ? 0 : 1);
    end

    for(i = 0;i < 7;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = 32'h00005000;
        #30 start_pred = 0; start_resolve = 1; PC = 32'h00005000; actual_target = 32'h50000000;pr_hit = ((i==0) ? 0 : 1);
    end

    for(i = 0;i < 3;i++)begin
        #30
        start_pred = 1; start_resolve = 0; PC = (i+1)*4096;
        //#30 start_pred = 0; start_resolve = 1; PC = (i+1)*4096; actual_target = (i+1)<<28;pr_hit = 0;
    end

    // for(i = 0;i < 3;i++)begin
    //     #30
    //     start_pred = 1; start_resolve = 0; PC = (i+1)*4096;
    //     #30 start_pred = 0; start_resolve = 1; PC = (i+1)*4096; actual_target = (i+1)<<28;pr_hit = 1;
    // end

    #30 $finish;
end
endmodule