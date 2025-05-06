
`timescale 1ns/1ps
module restoring_division_controlpath (
    input clk,
    input rst,
    input start,
    input negative_flag,
    input [1:0] count,
    input status,
    output reg select_A,
    output reg select_Q,
    output reg ld_A,
    output reg ld_Q,
    output reg shift_left_enable_a,
    output reg select_add,
    output reg select_mux_2,
    output reg shift_left_enable_q,
    output reg count_enable,
    output reg ld_rem_quotient,
    output reg done
);

//States
reg [3:0] next_state, present_state;

//State Encoding
parameter [3:0] idle = 4'b0000;
parameter [3:0] load = 4'b0001;
parameter [3:0] shift_a = 4'b0010;
parameter [3:0] wait_a = 4'b0011;
parameter [3:0] subtract = 4'b0100;
parameter [3:0] shift_q = 4'b0101;
parameter [3:0] wait_q = 4'b0110;
parameter [3:0] wait_load = 4'b0111;
parameter wait_extra_debug = 4'b1000;
parameter [3:0] adder = 4'b1001;
parameter [3:0] check = 4'b1010;
parameter [3:0] iter = 4'b1011;
parameter [3:0] display = 4'b1100;

//Reset and state updation logic
always @(posedge(clk) or posedge(rst)) begin
    if(rst) begin
        present_state <= idle;
    end
    else begin
        present_state <= next_state;
    end
end

//Next State Logic
always @(present_state or start) begin
    case (present_state)
        idle : begin
            next_state = (start == 1'b1) ? load : idle;
        end 

        load : begin
            next_state = shift_a;
        end

        shift_a : begin
            next_state = wait_a;
        end

        wait_a : begin
            next_state = subtract;
        end

        subtract : begin
            next_state = shift_q;
        end

        shift_q : begin
            next_state = wait_q;
        end

        wait_q : begin
            next_state = wait_load;
        end
        
        wait_load : begin
            next_state = wait_extra_debug;
        end

        wait_extra_debug : begin
            next_state = (negative_flag == 1'b1) ? adder : check;
        end

        adder : begin
            next_state = check;
        end

        check : begin
            next_state = (status == 1'b1) ? display : iter;
        end
        
        iter : begin
            next_state = shift_a;
        end

        display : begin
            next_state = idle;
        end

        default: next_state = idle;
    endcase
end

//Output Logic
always @(present_state) begin
    case (present_state)
        idle : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        load : begin
            select_A = 1'b1;
            select_Q = 1'b1;
            ld_A = 1'b1;
            ld_Q = 1'b1;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        shift_a : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b1;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        wait_a : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        subtract : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        shift_q : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b1;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        wait_q : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b1;
            ld_Q = 1'b1;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        wait_load : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        wait_extra_debug : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        adder : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b1;
            select_mux_2 = 1'b1;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        check : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b1;
            ld_Q = 1'b1;
            shift_left_enable_a = 1'b0;
            //select_add = 1'b0;
            //select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b1;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
        display : begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            //select_add = 1'b0;
            //select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b1;
            done = 1'b1;
        end
        default: begin
            select_A = 1'b0;
            select_Q = 1'b0;
            ld_A = 1'b0;
            ld_Q = 1'b0;
            shift_left_enable_a = 1'b0;
            select_add = 1'b0;
            select_mux_2 = 1'b0;
            shift_left_enable_q = 1'b0;
            count_enable = 1'b0;
            ld_rem_quotient = 1'b0;
            done = 1'b0;
        end
    endcase
end
    
endmodule