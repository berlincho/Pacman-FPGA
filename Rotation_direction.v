`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:06:24 05/08/2011 
// Design Name: 
// Module Name:    Rotation_direction 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Rotation_direction(
    input CLK,
    input ROT_A,
    input ROT_B,
    output reg rotary_event,
    output reg rotary_right
    );
	
reg rotary_q1,rotary_q2;
reg delay_rotary_q1;
reg ROT_A_TEMP,ROT_B_TEMP;

always @(posedge CLK)
begin
	ROT_A_TEMP<=ROT_A;
	ROT_B_TEMP<=ROT_B;	
end

always @(posedge CLK)// filter
begin
	case ({ROT_B_TEMP,ROT_A_TEMP})
	2'b00:begin
		rotary_q1 <= 1'b0;
		rotary_q2 <= rotary_q2;
		end
	2'b01:begin
		rotary_q1 <= rotary_q1;
		rotary_q2 <= 1'b0;
		end
	2'b10:begin
		rotary_q1 <= rotary_q1;
		rotary_q2 <= 1'b1;
		end
	2'b11:begin
		rotary_q1 <= 1'b1;
		rotary_q2 <= rotary_q2;
		end
	default:	begin
				rotary_q1 <= rotary_q1;
			   rotary_q2 <= rotary_q2;
				end
	endcase
end

always @(posedge CLK)//dorectopm
begin
	delay_rotary_q1 <= rotary_q1;
	if( (rotary_q1==1'b1) && (delay_rotary_q1==1'b0) )//rotary_q1 == 1 and delay_rotary_q1 == 0
	begin
		rotary_event <= 1'b1;
		rotary_right  <= rotary_q2;
	end else begin
		rotary_event <= 1'b0;
		rotary_right  <= rotary_right;
	end
end
	
endmodule
