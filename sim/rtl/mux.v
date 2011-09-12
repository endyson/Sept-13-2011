`ifndef MUX_V
`define MUX_V
module mux_16_32(
    input [15:0] in_16,
    input sel,
    output  [31:0]out_32,
    output  [1:0]en_2
);

assign out_32[31:16] = in_16; 
assign en_2 = sel ?2'b01: 2'b10;
assign out_32[15:0]	= in_16;

endmodule

module mux_32_32(
    input [31:0]a,
    input [31:0]b,
    input sel,
    output [31:0]out);

assign out = sel ? a : b;

endmodule

module mux_4_4(
    input [3:0]a,
    input [3:0]b,
    input sel,
    output [3:0]out);
assign out = sel ? a : b;
endmodule
`endif
