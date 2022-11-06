module ED_FF #(parameter W = 32) (
    input clk,rst,EN,
    input [W-1:0] D,
    output reg [W-1:0] Q);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q <= 0;
        end
        else if (EN) begin
            Q <= D;
        end
    end
endmodule