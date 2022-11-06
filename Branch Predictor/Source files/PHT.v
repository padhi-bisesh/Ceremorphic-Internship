module PHT #(
    parameter w_ind = 4)(
    input clk,rst,EN,
    input predict,resolve,
    input incr, decr,
    input [w_ind-1:0] index,
    output reg FINAL_PRED,
    output reg pred_valid
);
parameter L_pht = 2**w_ind;
reg [1:0] counter [0:L_pht-1];

wire [1:0] reg0;
assign reg0 = counter[0];
integer i;
    always @(posedge clk or negedge rst) begin
        pred_valid = 1'b0;
        FINAL_PRED = 1'b0;
        if(!rst) begin
            for (i = 0;i < L_pht;i++) begin
                counter[i] <= 2'b00;
            end
        end
        else if (EN) begin
            if(predict) begin
                    FINAL_PRED = counter[index][1];
                    pred_valid = 1'b1;
                end
            else if (resolve) begin
                if (incr) begin 
                    counter[index] = (counter[index] < 3) ? counter[index]+1 : counter[index];
                end
                else if (decr) begin
                    counter[index] = (counter[index] > 0) ? counter[index]-1 : counter[index];
                end
            end
        end
    end
    
endmodule