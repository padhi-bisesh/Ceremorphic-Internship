module Gsharetop #(
    parameter W = 32,
parameter L_pht = 16,
parameter ways = 4,
parameter L_btb = 16
)
(
    input clk,rst,

    input start_pred,
    input start_resolve,
    input [W-1:0] PC,
    input [W-1:0] actual_target,
    input pr_hit,

    output BR_PRED,
    output [W-1:0] TARGET,
    output DONE
);

wire PC_EN;
wire GBHR_EN;
wire PHT_EN;
wire BTB_EN;
wire PHT_incr;
wire PHT_decr;
wire pr_br_taken;

GshareDatapath DUT0 (
    .clk(clk),
    .rst(rst),
    .PC(PC),
    .start_pred(start_pred),
    .actual_target(actual_target),
    .start_resolve(start_resolve),
    .pr_hit(pr_hit),
    .PC_EN(PC_EN),
    .GBHR_EN(GBHR_EN),
    .PHT_EN(PHT_EN),
    .BTB_EN(BTB_EN),
    .PHT_incr(PHT_incr),
    .PHT_decr(PHT_decr),
    .pr_br_taken(pr_br_taken),
    .BR_PRED(BR_PRED),
    .TARGET(TARGET)
);

GshareControlpath DUT1 (
    .clk(clk),
    .rst(rst),
    .start_pred(start_pred),
    .start_resolve(start_resolve),
    .pr_br_taken(pr_br_taken),
    .PC_EN(PC_EN),
    .GBHR_EN(GBHR_EN),
    .PHT_EN(PHT_EN),
    .BTB_EN(BTB_EN),
    .PHT_incr(PHT_incr),
    .PHT_decr(PHT_decr),
    .done(DONE)
);

endmodule