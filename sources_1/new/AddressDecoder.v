`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 09:49:14 PM
// Design Name:
// Module Name: AddressDecoder
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

module AddressDecoder(
    input [31:0] mem_address,       // address จาก ALU_result
    input mem_write,                // เขียน mem หรือไม่
    input mem_read,                 // อ่าน mem หรือไม่

    output reg ram_read_en,         // สั่ง RAM ให้อ่าน
    output reg ram_write_en,        // สั่ง RAM ให้เขียน
    output reg sw_read_en,          // สั่ง MUX ให้เลือก Switch
    output reg led_write_en,        // สั่ง LED Register ให้เขียน
    output reg btn_read_en,         // สั่ง Button Controller ให้อ่าน
    output reg btn_write_en,        // สั่ง Button Controller ให้เคลียร์ Flag
    output reg seg_write_en,        // ส่ง 7Seg ให้เขียน
    output reg seg_digit_write_en,  // ส่ง 7Seg digit ให้เขียน
    output reg uart_rx_read_en,     // ส่งให้อ่านค่าจาก UART
    output reg uart_tx_write_en,    // ส่งให้เขียนค่าออกไป UART
    output reg uart_status_read_en  // อ่านสถานะ (Busy/Ready)
  );

  // Address Map
  // ทำแบบ MMIO ดังนั้นต้องกำหนดตำแหน่งของ Memory แต่ละ Input
  // 0x10000000 : Switches
  // 0x10000004 : LEDs
  // 0x10000008 : Buttons
  // 0x1000000C : 7-Segment Data
  // 0x10000010 : 7-Segment Digit
  // 0x10000014 : UART Status (Read Only)
  // 0x10000018 : UART Data (Read/Write)
  wire is_ram    = (mem_address < 32'h10000000);
  wire is_switch = (mem_address == 32'h10000000);
  wire is_led    = (mem_address == 32'h10000004);
  wire is_button = (mem_address == 32'h10000008);
  wire is_seg = (mem_address == 32'h1000000c);
  wire is_seg_digit = (mem_address == 32'h10000010);
  wire is_uart_status = (mem_address == 32'h10000014);
  wire is_uart_data   = (mem_address == 32'h10000018);

  always @(*)
  begin
    ram_read_en  = 1'b0;
    ram_write_en = 1'b0;
    sw_read_en   = 1'b0;
    led_write_en = 1'b0;
    btn_read_en  = 1'b0;
    btn_write_en = 1'b0;
    seg_write_en = 1'b0;
    seg_digit_write_en = 1'b0;
    uart_rx_read_en = 1'b0;
    uart_tx_write_en = 1'b0;
    uart_status_read_en = 1'b0;

    if (is_ram)
    begin
      // ถ้า CPU ส่ง Address โซน RAM มา
      // ให้ทำ lw sw เหมือนปกติ
      ram_read_en  = mem_read;      // ส่งต่อสัญญาณ Read
      ram_write_en = mem_write;     // ส่งต่อสัญญาณ Write
    end
    else if (is_switch)
    begin
      // ถ้า CPU ส่ง Address โซน Switch มา
      // สามารถ read ได้อย่างเดียว ไม่สามารถ write ลง switch ได้
      sw_read_en = mem_read;        // เปิดแค่ Read
    end
    else if (is_led)
    begin
      // ถ้า CPU ส่ง Address โซน LED มา
      // สามารถ write ได้อย่างเดียว ไม่สามารถ read จาก led ได้
      led_write_en = mem_write;     // เปิดแค่ Write
    end
    else if (is_button)
    begin
      // ถ้า CPU ส่ง Address โซน Button มา
      // read เพื่ออ่านค่า button ที่ค้างไว้จาก flag
      // write เพื่อเขียนทับ flag กลับไปเป็น 0
      btn_read_en  = mem_read;      // เปิด Read เพื่อเช็ก Flag
      btn_write_en = mem_write;     // เปิด Write เพื่อเคลียร์ Flag
    end
    else if (is_seg)
    begin
      // ถ้า CPU ส่ง Address โซน 7seg มา
      seg_write_en = mem_write;     // เปิดแค่ Write
    end
    else if (is_seg_digit)
    begin
      // ถ้า CPU ส่ง Address โซน 7seg digit มา
      seg_digit_write_en = mem_write;     // เปิดแค่ Write
    end
    else if (is_uart_status)
    begin
      // ถ้า CPU ส่ง Address โซน UART Status มา
      // สำหรับอ่านสถานะ UART ว่าทำไรอยู่
      uart_status_read_en = mem_read;
    end
    else if (is_uart_data)
    begin
      // ถ้า CPU ส่ง Address โซน UART มา
      // ถ้าอ่าน สำหรับ RX Receiver
      uart_rx_read_en  = mem_read;
      // ถ้าเขียน สำหรับ Transmitter
      uart_tx_write_en = mem_write;
    end
  end
endmodule
