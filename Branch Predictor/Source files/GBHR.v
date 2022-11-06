module GBHR #(parameter w_pht = 4)(
    input clk,rst,EN,
    input predict,resolve,
    input pr_br_taken,
    output reg [w_pht-1:0] gbhr
);
integer i;
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        gbhr <= 0;
    end
    else if (EN) begin
        if (resolve) begin
            gbhr[w_pht-1] <= pr_br_taken; 
            for (i=w_pht-2;i>=0;i--) begin
                gbhr[i] <= gbhr[i+1];
            end
        end
    end
end
endmodule