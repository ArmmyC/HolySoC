`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 10:31:40 PM
// Design Name:
// Module Name: DebounceController
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

module DebounceController(
    input clk_in,
    input reset,
    input [3:0] button_in_raw,

    output [3:0] button_out_debounced
  );
  Debouncer debouncer0 (
              // Input
              .clk_in(clk_in),
              .reset(reset),
              .button_in_raw(button_in_raw[0]),

              // Output
              .button_out_debounced(button_out_debounced[0])
            );

  Debouncer debouncer1 (
              // Input
              .clk_in(clk_in),
              .reset(reset),
              .button_in_raw(button_in_raw[1]),

              // Output
              .button_out_debounced(button_out_debounced[1])
            );

  Debouncer debouncer2 (
              // Input
              .clk_in(clk_in),
              .reset(reset),
              .button_in_raw(button_in_raw[2]),

              // Output
              .button_out_debounced(button_out_debounced[2])
            );

  Debouncer debouncer3 (
              // Input
              .clk_in(clk_in),
              .reset(reset),
              .button_in_raw(button_in_raw[3]),

              // Output
              .button_out_debounced(button_out_debounced[3])
            );

endmodule
