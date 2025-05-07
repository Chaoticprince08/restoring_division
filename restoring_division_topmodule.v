
`include "restoring_division_datapath.v"
`include "restoring_division_controlpath.v"
`include "lcd_module.v"
`timescale 1ns/1ps

module restoring_division_topmodule (
    input clk,
    input rst,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    //output [3:0] quotient,
    output [4:0] remainder,
    output [6:0] seg,
    output [3:0] digit,
    output done
);

//Internal signals
wire [3:0] quotient;
wire select_A;
wire select_Q;
wire ld_A;
wire ld_Q;
wire shift_left_enable_a;
wire select_add;
wire select_mux_2;
wire shift_left_enable_q;
wire count_enable;
wire ld_rem_quotient;
wire negative_flag;
wire [1:0] count;
wire status;

//Datapath instantiation
restoring_division_datapath datapath(
    .clk(clk),
    .rst(rst),
    .dividend(dividend),
    .divisor(divisor),
    .select_A(select_A),
    .select_Q(select_Q),
    .ld_A(ld_A),
    .ld_Q(ld_Q),
    .shift_left_enable_a(shift_left_enable_a),
    .select_add(select_add),
    .select_mux_2(select_mux_2),
    .shift_left_enable_q(shift_left_enable_q),
    .count_enable(count_enable),
    .ld_rem_quotient(ld_rem_quotient),
    .negative_flag(negative_flag),
    .quotient(quotient),
    .remainder(remainder),
    .count(count),
    .status(status)
);

restoring_division_controlpath controlpath(
    .clk(clk),
    .rst(rst),
    .start(start),
    .negative_flag(negative_flag),
    .count(count),
    .status(status),
    .select_A(select_A),
    .select_Q(select_Q),
    .ld_A(ld_A),
    .ld_Q(ld_Q),
    .shift_left_enable_a(shift_left_enable_a),
    .select_add(select_add),
    .select_mux_2(select_mux_2),
    .shift_left_enable_q(shift_left_enable_q),
    .count_enable(count_enable),
    .ld_rem_quotient(ld_rem_quotient),
    .done(done)
);

//Instantiate the LCD module
lcd_module ssd(
    .clk(clk),
    .rst(rst),
    .quotient(quotient),
    .seg(seg),
    .digit(digit)
);

endmodule