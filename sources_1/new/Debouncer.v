`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 10:44:48 PM
// Design Name:
// Module Name: Debouncer
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

// Debouncer สำหรับการรอปุ่ม stable
module Debouncer(
    input clk_in,                   // 100MHz Clock
    input reset,                    // ปุ่ม reset
    input button_in_raw,            // ค่าของปุ่มที่กดเข้ามา
    output reg button_out_debounced // ปุ่มหลังจาก debounced แล้ว
  );
  reg sync_reg_1; // Synchronizer 1 เพิ่มความเสถียร
  reg sync_reg_2; // Synchronizer 2 เพิ่มความเสถียร

  // รอประมาณ 10ms โดยใช้ 100MHz Clock)
  // หาจาก 10ms / 10ns = 1,000,000 cycles
  parameter MAX_COUNT = 1_000_000 - 1;
  reg [19:0] debounce_counter = 20'd0;

  initial
  begin
    button_out_debounced = 1'b0;
  end

  always @(posedge clk_in or posedge reset)
  begin
    if (reset)
    begin
      sync_reg_1 <= 1'b0;
      sync_reg_2 <= 1'b0;
      debounce_counter <= 20'd0;
      button_out_debounced <= 1'b0;
    end
    else
    begin
      sync_reg_1 <= button_in_raw;
      sync_reg_2 <= sync_reg_1;
      if (sync_reg_2 == button_out_debounced)
      begin
        debounce_counter <= 20'd0;
      end
      else
      begin
        if (debounce_counter == MAX_COUNT)
        begin
          button_out_debounced <= sync_reg_2;
          debounce_counter <= 20'd0;
        end
        else
        begin
          debounce_counter <= debounce_counter + 1'b1;
        end
      end
    end
  end
endmodule
