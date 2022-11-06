module GshareDatapath
#(parameter W = 32,
parameter L_pht = 16,
parameter ways = 4,
parameter L_btb = 16)
(   //General signals
    input clk,rst,
    
    //from external logic
    input [W-1:0] PC,
    input start_pred,
    input [W-1:0] actual_target,
    input start_resolve,
    input pr_hit,

    //from control path
    input PC_EN,
    input GBHR_EN,
    input PHT_EN,
    input BTB_EN,
    input PHT_incr,
    input PHT_decr,

    //to control path
    output pr_br_taken,

    //to external logic
    output BR_PRED,
    output [W-1:0] TARGET


);
parameter w_pht_addr = $clog2(L_pht);
parameter w_btb_addr = $clog2(L_btb);
parameter w_tag = W - 2 - w_btb_addr;

wire [W-1:0] PC_out;
wire br_taken_out;
wire [w_pht_addr-1:0] gbhr_out;
wire pht_pred_out;
wire pht_pred_valid_out;
wire pred_out;
wire BTB_hit_out;
wire [W-1:0] BTB_target_out;
wire BTB_valid_out;
wire [W-1:0] PCplus4;

ED_FF PC0 (
    .clk(clk),
    .rst(rst),
    .EN(PC_EN),
    .D(PC),
    .Q(PC_out)
);

br_taken i0 (
    .PC(PC_out),
    .pr_TARGET(actual_target),
    .taken(br_taken_out)
);

GBHR gbhr0 (
    .clk(clk),
    .rst(rst),
    .EN(GBHR_EN),
    .predict(start_pred),
    .resolve(start_resolve),
    .pr_br_taken(br_taken_out),
    .gbhr(gbhr_out)
);

PHT pht0 (
    .clk(clk),
    .rst(rst),
    .EN(PHT_EN),
    .predict(start_pred),
    .resolve(start_resolve),
    .incr(PHT_incr), 
    .decr(PHT_decr),
    .index(gbhr_out ^ (PC_out[w_pht_addr-1:0])),
    .FINAL_PRED(pht_pred_out),
    .pred_valid(pht_pred_valid_out)
);

BTB btb0 (
    .clk(clk),
    .rst(rst),
    .EN(BTB_EN),
    .predict(start_pred),
    .resolve(start_resolve),
    .pr_br_taken(br_taken_out),
    .pr_hit(pr_hit),
    .pr_TARGET(actual_target),
    .PC_addr(PC_out),
    .HIT(BTB_hit_out),
    .TARGET(BTB_target_out),
    .out_valid(BTB_valid_out)
);

ADD a0 (
    .in1(PC_out),
    .in2(4),
    .out(PCplus4)
);

assign pred_out = (pht_pred_out)&(BTB_hit_out);

MUX2to1 mx0 (
    .I0(PCplus4),
    .I1(BTB_target_out),
    .sel(pred_out),
    .out(TARGET)
);

assign BR_PRED = pred_out;
assign pr_br_taken = br_taken_out;
endmodule