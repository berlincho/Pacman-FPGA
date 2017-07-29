module lfsrr1(
    input clk,
    output reg [9:0] lfsr
);
reg [31:0]counter;
always @(posedge clk) begin
	counter <= counter+1;
	if(counter == 5000000000)
		counter <= 0;
	case(counter[3:0])
		0: lfsr <= 320;
		1: lfsr <= 577;
		2: lfsr <= 345;
		3: lfsr <= 123;
		4: lfsr <= 653;
		5: lfsr <= 46;
		6: lfsr <= 523;
		7: lfsr <= 78;
		8: lfsr <= 378;
		9: lfsr <= 537;
		10: lfsr <= 130;
		11: lfsr <= 577;
		12: lfsr <= 395;
		13: lfsr <= 523;
		14: lfsr <= 353;
		15: lfsr <= 75;
	endcase
		
end
endmodule

module lfsrr2(
    input clk,
    output reg [9:0] lfsr
);
reg [31:0]counter1;
always @(posedge clk) begin
	counter1 <= counter1+1;
	if(counter1 == 5000000000)
		counter1 <= 0;
	case(counter1[3:0])
		0: lfsr <= 320;
		1: lfsr <= 477;
		2: lfsr <= 45;
		3: lfsr <= 623;
		4: lfsr <= 353;
		5: lfsr <= 66;
		6: lfsr <= 123;
		7: lfsr <= 48;
		8: lfsr <= 708;
		9: lfsr <= 437;
		10: lfsr <= 70;
		11: lfsr <= 677;
		12: lfsr <= 295;
		13: lfsr <= 243;
		14: lfsr <= 353;
		15: lfsr <= 325;
	endcase
		
end
endmodule

module lfsrr3(
    input clk,
    output reg [9:0] lfsr
);
reg [31:0]counter2;
always @(posedge clk) begin
	counter2 <= counter2+1;
	if(counter2 == 5000000000)
		counter2 <= 0;
	case(counter2[3:0])
		0: lfsr <= 520;
		1: lfsr <= 417;
		2: lfsr <= 145;
		3: lfsr <= 423;
		4: lfsr <= 253;
		5: lfsr <= 56;
		6: lfsr <= 623;
		7: lfsr <= 58;
		8: lfsr <= 408;
		9: lfsr <= 137;
		10: lfsr <= 90;
		11: lfsr <= 60;
		12: lfsr <= 495;
		13: lfsr <= 163;
		14: lfsr <= 153;
		15: lfsr <= 315;
	endcase
		
end
endmodule

module lfsrr4(
    input clk,
    output reg [9:0] lfsr
);
reg [31:0]counter3;
always @(posedge clk) begin
	counter3 <= counter3+1;
	if(counter3 == 5000000000)
		counter3 <= 0;
	case(counter3[3:0])
		0: lfsr <= 220;
		1: lfsr <= 577;
		2: lfsr <= 65;
		3: lfsr <= 723;
		4: lfsr <= 53;
		5: lfsr <= 76;
		6: lfsr <= 123;
		7: lfsr <= 248;
		8: lfsr <= 408;
		9: lfsr <= 337;
		10: lfsr <= 250;
		11: lfsr <= 177;
		12: lfsr <= 595;
		13: lfsr <= 413;
		14: lfsr <= 553;
		15: lfsr <= 345;
	endcase
		
end
endmodule

module lfsrr5(
    input clk,
    output reg [9:0] lfsr
);
reg [31:0]counter4;
always @(posedge clk) begin
	counter4 <= counter4+1;
	if(counter4 == 5000000000)
		counter4 <= 0;
	case(counter4[3:0])
		0: lfsr <= 70;
		1: lfsr <= 457;
		2: lfsr <= 445;
		3: lfsr <= 613;
		4: lfsr <= 453;
		5: lfsr <= 366;
		6: lfsr <= 223;
		7: lfsr <= 48;
		8: lfsr <= 308;
		9: lfsr <= 537;
		10: lfsr <= 0;
		11: lfsr <= 277;
		12: lfsr <= 595;
		13: lfsr <= 23;
		14: lfsr <= 720;
		15: lfsr <= 25;
	endcase
		
end
endmodule