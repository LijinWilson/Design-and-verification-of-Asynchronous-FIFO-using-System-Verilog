`timescale 1ns/1ps
`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

module top;
  parameter data_width=8;
  parameter addr_width=4;

  logic wr_clk=0, rd_clk=0;

  //enviornment
  environment #(data_width) env;

  //instantiate interface
  fifo_if #(data_width) intf(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk)
  );

  //clock generation
  always #5 wr_clk=~wr_clk; //100 mhz
  always #7 rd_clk=~rd_clk; //71 mhz

  //connect to dut
  async_fifo #(
    .data_width(data_width),
    .addr_width(addr_width)
  ) dut (
    .data_in(intf.data_in),
    .wr_en(intf.wr_en),
    .wr_clk(intf.wr_clk),
    .wr_rst(intf.wr_rst),
    .full(intf.full),
    .data_out(intf.data_out),
    .rd_en(intf.rd_en),
    .rd_clk(intf.rd_clk),
    .rd_rst(intf.rd_rst),
    .empty(intf.empty)
  );

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0,top);
  end
endmodule