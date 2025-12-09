`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2025 02:59:30 PM
// Design Name:
// Module Name: UART_RX
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

module UART_RX(
    input clk,
    input reset,
    input rx_in,
    input rx_data_clear,      // บอกว่า อ่านข้อมูลหรือยัง

    output reg [7:0] rx_data, // ส่งข้อมูลออก
    output reg rx_data_ready  // บอกว่า ข้อมูล พร้อมอ่านหรือยัง
  );

  // กำหนด Baud Rate
  // 100,000,000 Hz / 115,200 Baud = 868
  parameter CLKS_PER_BIT = 868;

  localparam STATE_IDLE = 0;
  localparam STATE_START = 1;
  localparam STATE_DATA = 2;
  localparam STATE_STOP = 3;

  reg [2:0] state = STATE_IDLE;
  reg [3:0] clk_counter = 0;
  reg [2:0] bit_counter = 0;
  reg [7:0] data_buffer = 0;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      state <= STATE_IDLE;
      rx_data_ready <= 1'b0;
    end
    else
    begin
      // ุถ้า CPU อ่านข้อมูลไปแล้ว
      if (rx_data_clear)
      begin
        rx_data_ready <= 1'b0; // ข้อมูลว่าง
      end

      case (state)
        STATE_IDLE:
        begin
          // ปกติ rx_in จะเป็น 1 ตลอดเวลา
          // รอ Start bit = 0
          if (rx_in == 1'b0)
          begin
            state <= STATE_START;
            clk_counter <= 0;
          end
        end

        STATE_START:
        begin
          // รอจนสัญญาณเสถียรแล้วค่อยอ่าน
          if (clk_counter == (CLKS_PER_BIT / 2) - 1)
          begin
            state <= STATE_DATA;
            clk_counter <= 0;
            bit_counter <= 0;
          end
          else
          begin
            clk_counter <= clk_counter + 1'b1;
          end
        end

        STATE_DATA:
        begin
          // เริ่มนับตั้งแต่จุดกึ่งกลางของ bit แรก ไปจนถึงจุดกึ่งกลางของ bit สอง
          if (clk_counter == CLKS_PER_BIT - 1)
          begin
            clk_counter <= 0;

            // รับ bit เข้ามา แล้ว shift ไปทางขวา
            data_buffer <= {rx_in, data_buffer[7:1]};

            // เช็คว่ารับครบ 8 bit หรือยัง
            if (bit_counter == 7)
            begin
              state <= STATE_STOP;
            end
            else
            begin
              bit_counter <= bit_counter + 1'b1;
            end
          end
          else
          begin
            clk_counter <= clk_counter + 1'b1;
          end
        end

        STATE_STOP:
        begin
          // รอจนถึง stop bit
          if (clk_counter == CLKS_PER_BIT - 1)
          begin
            state <= STATE_IDLE;
            rx_data_ready <= 1'b1;  // บอกว่า data พร้อมแล้ว
            rx_data <= data_buffer; // ส่ง data ออก
          end
          else
          begin
            clk_counter <= clk_counter + 1'b1;
          end
        end

        default:
          state <= STATE_IDLE;

      endcase
    end
  end
endmodule
