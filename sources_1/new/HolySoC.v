`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 02:41:51 PM
// Design Name:
// Module Name: HolySoC
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

module HolySoC(
    input clk,
    input reset,
    input [3:0] btn,
    input [15:0] sw,
    input uart_rx_in,   // รับข้อมูล

    output uart_tx_out, // ส่งข้อมูล
    output [15:0] led,
    output [6:0] seg,
    output [3:0] digit
  );

  wire [31:0] ram_read_data;
  wire [31:0] sw_read_data = {16'b0, sw}; // ขยาย 16-bit sw เป็น 32-bit
  wire [31:0] btn_read_data;

  // Wires สำหรับ UART
  wire [31:0] uart_status_read_data;
  wire [31:0] uart_rx_read_data;
  wire uart_tx_busy;
  wire uart_rx_ready;
  wire [7:0] uart_rx_byte;
  wire uart_read_clear;   // สัญญาณบอกว่า CPU อ่าน RX แล้ว
  wire uart_write_start;  // สัญญาณบอกให้ TX เริ่มส่ง

  reg [15:0] led_reg;
  reg [6:0] seg_reg;
  reg [3:0] seg_digit_reg;
  assign led = led_reg;
  assign seg = seg_reg;
  assign digit = seg_digit_reg;

  // Clock Divider
  wire clk_1mhz;
  wire clk_1hz;

  // RV32I Core
  wire [31:0] cpu_mem_address;
  wire cpu_mem_read;
  wire cpu_mem_write;
  wire [31:0] cpu_mem_data_write;
  wire [2:0] cpu_funct3;

  // AddressDecoder
  wire ram_read_en;
  wire ram_write_en;
  wire sw_read_en;
  wire led_write_en;
  wire btn_read_en;
  wire btn_write_en;
  wire seg_write_en;
  wire seg_digit_wire_en;
  wire uart_rx_read_en;
  wire uart_tx_write_en;
  wire uart_status_read_en;

  // DebounceController
  wire [3:0] button_out_debounced;

  // UART RX
  wire [7:0] rx_data;

  // MUX MMIO
  wire [31:0] mmio_data;


  ClockDivider clk_div (
                 // Input
                 .clk_in(clk),
                 .reset(reset),

                 // Output
                 .clk_out_1mhz(clk_1mhz),
                 .clk_out_1hz(clk_1hz)
               );

  RV32I_Core CPU(
               // Input
               .clk_in(clk_1mhz),
               .reset(reset),
               .chosen_read_data(mmio_data),

               // Output
               .mem_address(cpu_mem_address),
               .mem_read(cpu_mem_read),
               .mem_write(cpu_mem_write),
               .mem_data_write(cpu_mem_data_write),
               .funct3(cpu_funct3)
             );

  AddressDecoder ad(
                   // Input
                   .mem_address(cpu_mem_address),
                   .mem_read(cpu_mem_read),
                   .mem_write(cpu_mem_write),

                   // Output
                   .ram_read_en(ram_read_en),
                   .ram_write_en(ram_write_en),
                   .sw_read_en(sw_read_en),
                   .led_write_en(led_write_en),
                   .btn_read_en(btn_read_en),
                   .btn_write_en(btn_write_en),
                   .seg_write_en(seg_write_en),
                   .seg_digit_write_en(seg_digit_write_en),
                   .uart_rx_read_en(uart_rx_read_en),
                   .uart_tx_write_en(uart_tx_write_en),
                   .uart_status_read_en(uart_status_read_en)
                 );

  DataMemory ram (
               // Input
               .clk_in(clk_1mhz),
               .memory_address(cpu_mem_address),
               .mem_read(ram_read_en),
               .mem_write(ram_write_en),
               .data_to_write(cpu_mem_data_write),
               .StoreSel(cpu_funct3),

               // Output
               .read_data(ram_read_data)
             );

  DebounceController dbc (
                       // Input
                       .clk_in(clk),
                       .reset(reset),
                       .button_in_raw(btn),

                       // Output
                       .button_out_debounced(button_out_debounced)
                     );


  ButtonController btn_controller (
                     // Input
                     .clk_in(clk_1mhz),
                     .reset(reset),
                     .btn_in(button_out_debounced),
                     .btn_read_en(btn_read_en),
                     .btn_write_en(btn_write_en),

                     // Output
                     .data_to_cpu(btn_read_data)
                   );

  UART_RX uart_rx (
            // Input
            .clk(clk),
            .reset(reset),
            .rx_in(uart_rx_in),
            .rx_data_clear(uart_read_clear),

            // Output
            .rx_data(rx_data),
            .rx_data_ready(uart_rx_ready)
          );

  UART_TX uart_tx (
            // Input
            .clk(clk),
            .reset(reset),
            .tx_start(uart_write_start),
            .tx_data(cpu_mem_data_write[7:0]),

            // Output
            .tx_out(uart_tx_out),
            .tx_busy(uart_tx_busy)
          );

  // ถ้า CPU อ่าน Address RX Data ให้เคลียร์ Flag ทันที
  assign uart_read_clear = uart_rx_read_en;
  // ถ้า CPU เขียน Address TX Data ให้เริ่มส่งทันที
  assign uart_write_start = uart_tx_write_en;

  // นำ 2 bit ที่บอกสถานะ ของ uart มา extend เป็น 32 bit
  assign uart_status_read_data = {30'b0, uart_tx_busy, uart_rx_ready};

  // นำ 1 byte จาก rx มา extend เป็น 32 bit
  assign uart_rx_read_data = {24'b0, rx_data};

  MUXMMIO mux_mmio(
            // Input
            .ram_read_en(ram_read_en),
            .sw_read_en(sw_read_en),
            .btn_read_en(btn_read_en),
            .uart_status_read_en(uart_status_read_en),
            .uart_rx_read_en(uart_rx_read_en),
            .ram_read_data(ram_read_data),
            .sw_read_data(sw_read_data),
            .btn_read_data(btn_read_data),
            .uart_status_read_data(uart_status_read_data),
            .uart_rx_read_data(uart_rx_read_data),

            // Output
            .chosen_data(mmio_data)
          );


  always @(posedge clk_1mhz or posedge reset)
  begin
    if (reset)
    begin
      led_reg <= 16'd0;
      seg_reg <= 7'b1111111;
      seg_digit_reg <= 4'b1111;
    end
    else
    begin
      if (led_write_en)
      begin
        led_reg <= cpu_mem_data_write[15:0];
      end
      if (seg_write_en)
      begin
        seg_reg <= cpu_mem_data_write[6:0];
      end
      if (seg_digit_write_en)
      begin
        seg_digit_reg <= cpu_mem_data_write[3:0];
      end
    end
  end
endmodule
