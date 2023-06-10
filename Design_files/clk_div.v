module fcd(clock_in,clock_out
    );
input clock_in; 
output reg clock_out; 
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd470;
// The frequency of the output clk_out = The frequency of the input clk_in divided by DIVISOR
// For example, Fclk_in = 100Mhz, if you want to get 212.77KHz signal to blink LEDs
// The DIVISOR parameter value will be 28'd470
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule
