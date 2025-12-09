`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 10:11:57 PM
// Design Name:
// Module Name: MUXMMIO
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

// MUX สำหรับเลือกข้อมูลที่จะส่งเข้า CPU
module MUXMMIO(
    input ram_read_en,
    input sw_read_en,
    input btn_read_en,
    input uart_status_read_en,
    input uart_rx_read_en,
    input [31:0] ram_read_data,
    input [31:0] sw_read_data,
    input [31:0] btn_read_data,
    input [31:0] uart_status_read_data,
    input [31:0] uart_rx_read_data,

    output [31:0] chosen_data
  );

  assign chosen_data = (sw_read_en) ? sw_read_data : (btn_read_en) ? btn_read_data : (ram_read_en) ? ram_read_data : (uart_rx_read_en) ? uart_rx_read_data : (uart_status_read_en) ? uart_status_read_data : 32'd0;
endmodule
