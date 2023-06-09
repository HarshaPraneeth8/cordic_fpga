`timescale 1ns / 1ps

module sepe(input [15:0] inp1, output [7:0] sin, cos);
assign cos = inp1[7:0]+128;
assign sin = inp1[15:8]+128;
endmodule
