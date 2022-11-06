module BTB #(parameter W = 32,
    parameter w_ind = 4,
    parameter ways = 4)(
    input clk,rst,EN,
    input predict,resolve,
    input pr_br_taken, pr_hit,
    input [W-1:0] pr_TARGET,
    input [W-1:0] PC_addr,
    output reg HIT,
    output reg [W-1:0] TARGET,
    output reg out_valid
);
wire [w_ind-1:0] index;
wire [w_tag-1:0] tag;
integer i;
integer j;
parameter L_btb = 2**w_ind;
parameter w_tag = W - w_ind - 2;
reg [w_tag-1:0] BTB_metadata [0:L_btb][0:ways-1];
reg [W-1:0] BTB_target [0:L_btb][0:ways-1];
reg [0:ways-1] BTB_LRU [0:L_btb];
reg [ways-1:0] curr;
reg flag;


assign index = PC_addr[2+:w_ind];
assign tag = PC_addr[(W-1)-:w_tag];
//assign test = BTB_LRU[4'b1100];
wire [w_tag-1:0] reg00,reg01,reg02,reg03;
assign reg00 = BTB_metadata[0][0];
assign reg01 = BTB_metadata[0][1];
assign reg02 = BTB_metadata[0][2];
assign reg03 = BTB_metadata[0][3];

always @(posedge clk or negedge rst)begin
    out_valid = 1'b0;
    HIT = 1'b0;
    TARGET = 0;
    if(!rst) begin    
        for (i=0; i < L_btb;i++) begin
            BTB_LRU[i] <= 0;
            for(j = 0 ; j< ways ;j++) begin
                BTB_metadata[i][j] <= 0;
                BTB_target[i][j] <= 0;
            end
        end
    end
    else if(EN) begin
        if (predict) begin
            for (j = 0;j < ways;j++) begin 
                if ( tag == BTB_metadata[index][j]) begin
                    HIT = 1'b1;
                    TARGET = BTB_target[index][j];
                    out_valid = 1'b1;
                end
            end
            out_valid = 1;
        end
        else if (resolve) begin
            if (pr_br_taken) begin
                if(!pr_hit) begin
                    flag = 0;
                    curr = (1<<(ways-1)) & {ways{1'b1}};
                    for (j = 0 ; j < ways ; j++) begin 
                        if ( BTB_LRU[index][j] == 1'b0 && (!flag)) begin
                            BTB_LRU[index][j] = 1'b1; 
                            BTB_metadata[index][j] = tag;
                            BTB_target[index][j] = pr_TARGET;
                            if (BTB_LRU [index] == {ways{1'b1}}) begin
                                BTB_LRU[index] = curr; 
                            end
                            flag = 1;
                        end
                        else
                            curr = curr>>1;
                    end                
                end
                else begin
                    flag = 0;
                    curr = 1<<ways-1;
                    for (j = 0 ; j < ways ; j++) begin 
                        if ( tag == BTB_metadata[index][j]) begin
                            BTB_LRU[index][j] = 1'b1;
                            if (BTB_LRU [index] == {ways{1'b1}}) begin
                                BTB_LRU[index] = curr; 
                            end
                            flag = 1;
                        end
                        else
                            curr = curr>>1;
                    end
                end
            end
        end
    end
end

endmodule