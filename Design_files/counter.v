
module counter (
  input wire DAC_clk,
  input wire done,
  output reg rst,
  output reg signed [7:0] X_reg
);
  reg [7:0] waveform_output_reg;
  reg [7:0] counter_reg;
  reg [7:0] counter_next;
  reg [1:0] state;

  // Initialize the state and registers
  initial begin
    state <= 0;
    X_reg <= 0;
    waveform_output_reg <= 0;//01100100;
    counter_reg <= 0;//01100100;
    counter_next <= 0;//01100100;
  end

  // State machine logic
  always @(posedge DAC_clk) begin
    case(state)
      0: begin // Wait for done signal to go high
        if (done) begin
          state <= 1;
          waveform_output_reg <= X_reg;
//          Chan0 <= waveform_output_reg;
//          Chan1 <= waveform_output_reg;
        end
      end
      1: begin // Increment X counter and check for reset
        if (counter_reg == 8'b01111111 ) begin //10011100
          counter_next <= 8'b10110110; //01100100
        end else begin
          counter_next <= counter_reg + 1;
        end
        state <= 2;
      end
      2: begin // Start DAC write process
        rst <= 1;
        state <= 3;
      end
      3: begin // Clear rst and wait for done signal to go high
        rst <= 0;
        if (done) begin
          state <= 0;
          counter_reg <= counter_next;
          X_reg <= counter_reg;
        end
      end
      default: state <= 0;
    endcase
  end
endmodule
