`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/16/2025 01:33:59 AM
// Design Name:
// Module Name: tb_HolySoC
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb_HolySoC(
  );

  reg clk;
  reg reset;
  reg [3:0] btn;
  reg [15:0] sw;

  wire [15:0] led;
  wire [6:0] seg;
  wire [3:0] digit;

  HolySoC soc (
            .clk(clk),
            .reset(reset),
            .btn(btn),
            .sw(sw),
            .led(led),
            .seg(seg),
            .digit(digit)
          );

  initial
  begin
    btn = 4'd0;
    sw = 16'd0;
    clk = 1'b0;
  end
  always #5 clk = ~clk;

  initial
  begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_HolySoC);

    reset = 1'b1;
    #50;
    reset = 1'b0;

    #200000000;
    $finish;
  end
endmodule
