module RAS #(
    parameter W = 32,
    parameter L_stack = 4;
) (
    input clk,rst,
    input [4:0] rd,rs,
    input [W-1:0] DATA_IN,

    output reg [W-1:0] DATA_OUT,
);
integer i;
[W-1:0] Stack [0:L_stack-1];

assign push = ((rd==5'd1)|(rd==5'd5)) && ((rs==5'd6)|(rs==5'd7));

assign pop = ((rd == 5'd0) && (rs==5'd1)|(rs==5'd5));

always @(posedge clk or negedge reset) begin
    if(!rst) begin
        for(i=0;i<L_stack;i++) begin
            Stack[i] <= 0;
        end
        DATA_OUT <= 0;
    else begin
        if(push) begin
            Stack[0] <= DATA_IN;
            for (i = 1; i< L_stack ; i++ ) begin
                Stack[i] <= Stack[i-1];
            end
        end
        else if (pop) begin
            DATA_OUT <= Stack[0];
            for (i = 1; i< L_stack ; i++ ) begin
                Stack[i-1] <= Stack[i];
            end
        end
    end
    end
end
endmodule