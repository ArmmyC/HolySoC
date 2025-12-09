`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 10:30:56 PM
// Design Name:
// Module Name: ButtonController
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

module ButtonController(
    input clk_in,
    input reset,
    input [3:0] btn_in,
    input btn_read_en,
    input btn_write_en,

    output reg [31:0] data_to_cpu
  );

  reg [3:0] button_flags;

  reg [3:0] btn_prev_state;

  wire [3:0] btn_posedge = (~btn_prev_state) & btn_in;

  always @(posedge clk_in or posedge reset)
  begin
    if (reset)
    begin
      button_flags <= 4'b0;
      btn_prev_state <= 4'b0;
    end
    else
    begin
      btn_prev_state <= btn_in;

      if (btn_write_en)
      begin
        button_flags <= 4'b0;
      end
      else if (btn_posedge != 4'b0)
      begin
        button_flags <= button_flags | btn_posedge;
      end
    end
  end

  always @(*)
  begin
    if (btn_read_en)
      data_to_cpu = {28'b0, button_flags};
    else
      data_to_cpu = 32'd0;
  end
endmodule
