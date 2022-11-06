module br_taken #(parameter W = 32)(
    input [W-1:0] PC,pr_TARGET,
    output taken
);
    assign taken = ((pr_TARGET - PC) != 4); 
endmodule