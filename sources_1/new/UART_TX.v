`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2025 02:58:24 PM
// Design Name:
// Module Name: UART_TX
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

module UART_TX(
    input clk,
    input reset,
    input tx_start,       // คำสั่งจาก cpu บอกว่าส่ง tx
    input [7:0] tx_data,  // ข้อมูลที่จะส่ง

    output reg tx_out,    // ส่งออกที่ละ bit
    output reg tx_busy    // สถานะบอกว่ากำลังส่งอยู่
  );

  // Divisor = 100,000,000 Hz / 115,200 Baud = 868
  parameter CLKS_PER_BIT = 868;

  localparam STATE_IDLE = 0;
  localparam STATE_START = 1;
  localparam STATE_DATA = 2;
  localparam STATE_STOP = 3;

  reg [2:0] state = STATE_IDLE;
  reg [3:0] clk_counter = 0;
  reg [2:0] bit_counter = 0;
  reg [9:0] tx_buffer = 0; // (10 bits = 1 Start + 8 Data + 1 Stop)

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      state <= STATE_IDLE;
      tx_out <= 1'b1;
      tx_busy <= 1'b0;
    end
    else
    begin
      case (state)
        STATE_IDLE:
        begin
          tx_out <= 1'b1;
          tx_busy <= 1'b0;

          if (tx_start)
          begin
            // สร้าง format ที่จะส่ง
            // stop bit + data + start bit เนื่องจากข้อมูลจะส่งจ่าก ขวาไปซ้าย
            tx_buffer <= {1'b1, tx_data, 1'b0};
            state <= STATE_START;
            clk_counter <= 0;
            tx_busy <= 1'b1;
          end
        end

        STATE_START:
        begin
          tx_out <= tx_buffer[0]; // ส่ง start bit

          if (clk_counter == CLKS_PER_BIT - 1)
          begin
            clk_counter <= 0;
            state <= STATE_DATA;
            bit_counter <= 0;
          end
          else
          begin
            clk_counter <= clk_counter + 1'b1;
          end
        end

        STATE_DATA:
        begin
          // เริ่มส่ง bit จาก LSB
          tx_out <= tx_buffer[bit_counter + 1];

          if (clk_counter == CLKS_PER_BIT - 1)
          begin
            clk_counter <= 0;

            // เช็คว่าส่งครบ 8 bit หรือยัง
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
          tx_out <= tx_buffer[9]; // ส่ง stop bit

          if (clk_counter == CLKS_PER_BIT - 1)
          begin
            state <= STATE_IDLE;
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
