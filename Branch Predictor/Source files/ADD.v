module ADD #(parameter W = 32)(
    input [W-1:0] in1,in2,
    output [W-1:0] out
);
    assign out = in1 + in2;
endmodule