module GshareControlpath 
#(parameter W = 32,
parameter L_pht = 16,
parameter ways = 4,
parameter L_btb = 16)
(   //General signals
    input clk,rst,

    //from external logic
    input start_pred,
    input start_resolve,

    //from datapath
    input pr_br_taken,

    //to datapath
    output reg  PC_EN,
    output reg  GBHR_EN,
    output reg  PHT_EN,
    output reg  BTB_EN,
    output reg  PHT_incr,
    output reg  PHT_decr,

    //to external logic
    output reg done
);
parameter w_pht_addr = $clog2(L_pht);
parameter w_btb_addr = $clog2(L_btb);
parameter w_tag = W - 2 - w_btb_addr;

parameter IDLE = 2'b00;
parameter CALC = 2'b01;
parameter DONE = 2'b10;

reg [1:0] curr_state,next_state;

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        curr_state <= IDLE;
    end
    else begin
        curr_state <= next_state;
    end
end

always @(curr_state or start_pred or start_resolve) begin
    case (curr_state)
        IDLE : begin   
                if(start_pred || start_resolve) begin
                    next_state = CALC;
                end
                else begin
                    next_state = IDLE;
                end
                end
        CALC : next_state = DONE;
        DONE : next_state = IDLE;
    endcase
end

always @(curr_state or start_pred or start_resolve) begin
    PC_EN = 1'b0;
    GBHR_EN = 1'b0;
    PHT_EN = 1'b0;
    BTB_EN = 1'b0;
    PHT_incr = 1'b0;
    PHT_decr = 1'b0;
    done = 1'b0;
    case(curr_state)
        IDLE: begin
            PC_EN = 1;
        end
        CALC: begin
            GBHR_EN = 1;
            PHT_EN = 1;
            BTB_EN = 1;
            if(start_resolve) begin
                if(pr_br_taken) begin
                    PHT_incr = 1'b1;
                end
                else begin
                    PHT_decr = 1'b1;
                end
            end
        end
        DONE: done = 1'b1;
    endcase
end
endmodule