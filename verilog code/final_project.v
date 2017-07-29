module final_project
(
	input clk, 
	input reset,
	input ROT_A,
	input ROT_B,
	input button_west,
	input btn_center,
	input button_east,
	input button_north,
	output [7:0]led,
	output wire hsync, 
	output wire vsync, 
	output reg R,
	output reg G,
	output reg B 
);
reg [9:0] cnt;
wire visible;
reg [12:0] pixel_x, pixel_y;
reg [12:0] rect_x = 12'd500;
reg [12:0] rect_y;
reg [12:0] tr1_x = 12'd250;
reg [12:0] tr1_y;
reg [12:0] tr2_x = 12'd400;
reg [12:0] tr2_y;
reg [12:0] cir_x = 12'd87;
reg [12:0] cir_y;
reg [12:0] cir1_x = 12'd329;
reg [12:0] cir1_y;
reg [12:0] GP_x, GP_y; 
wire rotary_event,rotary_right;
wire [9:0] rand_num1, rand_num2, rand_num3, rand_num4, rand_num5;
wire [7:0] scores;
reg [7:0] tp1_score, tp2_score, tp3_score, tp4_score, tp5_score;
reg [5:0] tp1_num, tp2_num, tp3_num, tp4_num, tp5_num;
reg [7:0] less_numbers;
wire [7:0] less_number;
reg [5:0] less_num2;
reg [5:0] less_num1;
wire btn_west_out, btn_west_pressed; 
reg prev_btn_west_out;
wire btn_east_out, btn_east_pressed; 
reg prev_btn_east_out;
wire btn_center_out, btn_center_pressed; 
reg prev_btn_center_out;
wire btn_north_out, btn_north_pressed; 
reg prev_btn_north_out;
reg resume, start;
reg [6:0]GP_v;
/// score board
reg [7:0] tp11, tp22, tp33, tp44, tp55;
wire [7:0] cirr, rectt, trii;


///
assign cirr = (reset)? 0 : tp33+tp55;
assign rectt = (reset)? 0 : tp11;
assign trii = (reset)? 0 : tp22+tp44;
assign less_number = (reset)? 0 : (less_number==50)? 50 : tp1_num+ tp2_num+ tp3_num+ tp4_num+ tp5_num;
assign scores = tp1_score+ tp2_score+ tp3_score+ tp4_score+ tp5_score;
assign led = scores;
//assign led = cirr;

Rotation_direction rd(
	.CLK(clk),
	.ROT_A(ROT_A),
	.ROT_B(ROT_B),
	.rotary_event(rotary_event),
	.rotary_right(rotary_right)
);

// btn_west debounced
debounce btn_db0(
    .clk(clk),
    .btn_input(button_west),
    .btn_output(btn_west_out)
    );
	 
always @(posedge clk) begin
  if (reset)
    prev_btn_west_out <= 0;
  else
    prev_btn_west_out <= btn_west_out;
end

assign btn_west_pressed = (btn_west_out == 1 && prev_btn_west_out == 0)? 1 : 0;

// btn_north debounced
debounce btn_db3(
    .clk(clk),
    .btn_input(button_north),
    .btn_output(btn_north_out)
    );
	 
always @(posedge clk) begin
  if (reset)
    prev_btn_north_out <= 0;
  else
    prev_btn_north_out <= btn_north_out;
end

assign btn_north_pressed = (btn_north_out == 1 && prev_btn_north_out == 0)? 1 : 0;

// btn_east debounced
debounce btn_db2(
    .clk(clk),
    .btn_input(button_east),
    .btn_output(btn_east_out)
    );
	 
always @(posedge clk) begin
  if (reset)
    prev_btn_east_out <= 0;
  else
    prev_btn_east_out <= btn_east_out;
end

assign btn_east_pressed = (btn_east_out == 1 && prev_btn_east_out == 0)? 1 : 0;

// btn_center debounced
debounce btn_db1(
    .clk(clk),
    .btn_input(btn_center),
    .btn_output(btn_center_out)
    );
	 
always @(posedge clk) begin
  if (reset)
    prev_btn_center_out <= 0;
  else
    prev_btn_center_out <= btn_center_out;
end

assign btn_center_pressed = (btn_center_out == 1 && prev_btn_center_out == 0)? 1 : 0;

always@(posedge clk)begin
	if(reset)begin
		cnt<= 0;
		//led <= 0;
	end
	else begin
		if(btn_center_pressed) cnt <= cnt +1;
		else cnt <= (cnt!=0)? cnt+1:0;
		//led <= less_number;
	end
end


always @(posedge clk) begin
  if (reset)
    less_numbers <= 0;
  else
    less_numbers <= less_number;
end

always@(posedge clk) begin
	if(reset)begin
		less_num2<=2;
		less_num1<=0;
	end	else if(less_numbers != less_number)begin
		less_num2 <= (less_num2==0) ? 0 : (less_num1==0)? less_num2-1: less_num2;
		less_num1 <= (less_num1==0)? 9 : less_num1-1;
	end	
end

//random
lfsrr1 randdd(
	.clk(clk),
	.lfsr(rand_num1)
);

lfsrr2 randdfdd(
	.clk(clk),
	.lfsr(rand_num2)
);

lfsrr3 randddsd(
	.clk(clk),
	.lfsr(rand_num3)
);

lfsrr4 randdfdfd(
	.clk(clk),
	.lfsr(rand_num4)
);

lfsrr5 randsddd(
	.clk(clk),
	.lfsr(rand_num5)
);

//color
parameter DEFAULT = 3'b000;
parameter BLACK = 3'b000;
parameter RED   = 3'b100;
parameter GREEN = 3'b010;
parameter BLUE  = 3'b001;
parameter CYAN  = 3'b011;
parameter MAGEN = 3'b101;
parameter YELLOW= 3'b110;
parameter WHITE = 3'b111;

//VGA
always@(posedge clk)  //column
begin
	if(reset)
		pixel_x <=0;
	else if(pixel_x==1039)
		pixel_x <=0;
	else
		pixel_x <= pixel_x+1;
end

always@(posedge clk)  //row
begin
	if(reset)
		pixel_y <=0;
	else if(pixel_y==665)
		pixel_y <=0;
	else if(pixel_x==1039)
		pixel_y <= pixel_y+1;
	else
		pixel_y <= pixel_y;
end

assign hsync = ~((pixel_x>=919)&(pixel_x<1039));
assign vsync = ~((pixel_y>=659)&(pixel_y<665));
assign visible = ((pixel_x>=104)&(pixel_x<904)&(pixel_y>=23)&(pixel_y<623));
////


//rotary
reg flag;
always@(posedge clk) begin
	if(reset)
	begin
		GP_x <= 0;
		flag <= 0;
	end
	else if (rotary_event && rotary_right)  //right
	begin
		flag <= 0;
		if(GP_x <= 720)
			if(start)
				if(resume)
					GP_x <= GP_x+GP_v;
	end
	else if (rotary_event && !rotary_right)  //left
	begin
		flag <=1;
		if(GP_x >= 10)
			if(start)
				if(resume)
					GP_x <= GP_x-GP_v;
	end
	else
		GP_x <= GP_x;
end
reg rand;

//tp_counters
reg [31:0]counter1, counter2, counter3, counter4, counter5, counter6;
always@(posedge clk) begin
	if(reset) 
	begin
		counter1 <=0;
		rect_y <= 0;
		//rand <= 0;
		rect_x <= rand_num1;
		tp1_score <= 0;
		tp1_num <= 0;
		tp11 <= 0;
	end
	else if(counter1==500000)
	begin
		counter1 <= 0;
		if(rect_y==620)
		begin
			rect_y <= 0;
			//rand <= 1;
			rect_x <= rand_num1;
			tp1_num <= tp1_num+1;
		end
		else if( (rect_y<=530) && (rect_y>=500) && (104+30+GP_x -5<= 104+rect_x) && (104+62+GP_x+5 >= 104+20+rect_x) )
		begin
			rect_y <= 0;
			rect_x <= rand_num1;
			tp1_score <= tp1_score+1;
			tp1_num <= tp1_num+1;
			tp11 <= tp11+1;
		end
		else
		begin
			rect_y <= rect_y + 1;
			//rand <= 0;
		end
	end
	else 
		if(start)
			if(resume)
				if(less_number<20)
					counter1 <= counter1+1;
end 


always@(posedge clk) begin
	if(reset) 
	begin
		counter2 <=0;
		tr1_y <= 0;
		tr1_x <= rand_num2;
		tp2_score <= 0;
		tp2_num <= 0;
		tp22 <= 0;
	end
	else if(counter2==1000000)
	begin
		counter2 <= 0;
		if(tr1_y==620)
		begin
			tr1_y <= 0;
			//rand <= 1;
			tr1_x <= rand_num2;
			tp2_num <= tp2_num+1;
		end
		else if( (tr1_y<=530) && (tr1_y>=500) && (104+30+GP_x -5<= 104+tr1_x) && (104+62+GP_x+5 >= 104+20+tr1_x) )
		begin
			tr1_y <= 0;
			tr1_x <= rand_num2;
			tp2_score <= tp2_score+1;
			tp2_num <= tp2_num+1;
			tp22 <= tp22+1;
		end
		else
		begin
			tr1_y <= tr1_y + 1;
			//rand <= 0;
		end
	end
	else 
		if(start)
			if(resume)
				if(less_number<20)
					counter2 <= counter2+1;
end 

always@(posedge clk) begin
	if(reset) 
	begin
		counter3 <=0;
		cir_y <= 0;
		cir_x <= rand_num3;
		tp3_score <= 0;
		tp3_num <= 0;
		tp33<=0;
	end
	else if(counter3==700000)
	begin
		counter3 <= 0;
		if(cir_y==620)
		begin
			cir_y <= 0;
			//rand <= 1;
			cir_x <= rand_num3;
			tp3_num <= tp3_num+1;
		end
		else if( (cir_y<=530) && (cir_y>=500) && (104+30+GP_x-5 <= 104+cir_x) && (104+62+GP_x+5 >= 104+20+cir_x) )
		begin
			cir_y <= 0;
			cir_x <= rand_num3;
			tp3_score <= tp3_score+1;
			tp3_num <= tp3_num+1;
			tp33 <= tp33+1;
		end
		else
		begin
			cir_y <= cir_y + 1;
			//rand <= 0;
		end
	end
	else 
		if(start)
			if(resume)
				if(less_number<20)
					counter3 <= counter3+1;
end

always@(posedge clk) begin
	if(reset) 
	begin
		counter4 <=0;
		tr2_y <= 0;
		tr2_x <= rand_num4;
		tp4_score <= 0;
		tp4_num <= 0;
		tp44<=0;
	end
	else if(counter4==200000)
	begin
		counter4 <= 0;
		if(tr2_y==620)
		begin
			tr2_y <= 0;
			//rand <= 1;
			tr2_x <= rand_num4;
			tp4_num <= tp4_num+1;
		end
		else if( (tr2_y<=530) && (tr2_y>=500) && (104+30+GP_x-5 <= 104+tr2_x) && (104+62+GP_x+5 >= 104+20+tr2_x) )
		begin
			tr2_y <= 0;
			tr2_x <= rand_num4;
			tp4_score <= tp4_score+1;
			tp4_num <= tp4_num+1;
			tp44 <= tp44+1;
		end
		else
		begin
			tr2_y <= tr2_y + 1;
			//rand <= 0;
		end
	end
	else 
		if(start)
			if(resume)
				if(less_number<20)
					counter4 <= counter4+1;
end

always@(posedge clk) begin
	if(reset) 
	begin
		counter5 <=0;
		cir1_y <= 0;
		cir1_x <= rand_num5;
		tp5_score <= 0;
		tp5_num <= 0;
		tp55<=0;
	end
	else if(counter5==400000)
	begin
		counter5 <= 0;
		if(cir1_y==620)
		begin
			cir1_y <= 0;
			//rand <= 1;
			cir1_x <= rand_num5;
			tp5_num <= tp5_num+1;
		end
		else if( (cir1_y<=530) && (cir1_y>=500) && (104+30+GP_x-5 <= 104+cir1_x) && (104+62+GP_x+5 >= 104+20+cir1_x) )
		begin
			cir1_y <= 0;
			cir1_x <= rand_num5;
			tp5_score <= tp5_score+1;
			tp5_num <= tp5_num+1;
			tp55 <= tp55+1;
		end
		else
		begin
			if(start)
				if(resume)
					if(less_number<20)
						cir1_y <= cir1_y + 1;
			//rand <= 0;
		end
	end
	else 
		counter5 <= counter5+1;
end 

reg GPopen;
always@(posedge clk) begin
	if(reset)begin
		GPopen <= 0;
		counter6 <= 0;
	end
	else if(5000000<counter6 && counter6<=10000000)
	begin
		GPopen <= 1;
		counter6 <= counter6+1;
	end
	else if(0<=counter6 && counter6<=5000000)
	begin
		GPopen <= 0;
		counter6 <= counter6+1;
	end
	else
		counter6 <= 0;
end

reg [2:0]GP_color, BACKGROUND_color, tp1_color, tp2_color, tp3_color, tp4_color, tp5_color;
reg [2:0]sel, sell;

always@(posedge clk) begin
	if(reset)
	begin
		start <= 0;
		resume <= 1;
		sel <= 0;
		sell <= 0;
		GP_v <= 10;
		GP_color <= YELLOW;
		BACKGROUND_color <= WHITE;
		tp1_color <= BLACK;
		tp2_color <= CYAN;
		tp3_color <= RED;
		tp4_color <= MAGEN;
		tp5_color <= YELLOW;
	end
	else begin
		if(btn_west_pressed==1)
		begin
			if(resume==1)
				resume <= 0;
			else
				resume <= 1;
		end
		else if(btn_center_pressed==1)
			start <= 1;
		else if(btn_north_pressed==1)begin
			case(sell)
				0:GP_v <=5;
				1:GP_v <=25;
				2:GP_v <= 10;
			endcase
			if(sell==2)
				sell <= 0;
			else
				sell <= sell+1;
		end
		else if(btn_east_pressed==1)
		begin
			if(start)begin
				case(sel)
					0:begin
						GP_color <= WHITE;
						BACKGROUND_color <= MAGEN;
						tp1_color <= RED;
						tp2_color <= YELLOW;
						tp3_color <= BLACK;
						tp4_color <= GREEN;
						tp5_color <= WHITE;
					end
					1:begin
						GP_color <= GREEN;
						BACKGROUND_color <= BLACK;
						tp1_color <= MAGEN;
						tp2_color <= CYAN;
						tp3_color <= GREEN;
						tp4_color <= RED;
						tp5_color <= YELLOW;
					end
					2:begin
						GP_color <= BLACK;
						BACKGROUND_color <= RED;
						tp1_color <= WHITE;
						tp2_color <= YELLOW;
						tp3_color <= GREEN;
						tp4_color <= MAGEN;
						tp5_color <= CYAN;
					end
					3:begin
						GP_color <= YELLOW;
						BACKGROUND_color <= WHITE;
						tp1_color <= BLACK;
						tp2_color <= CYAN;
						tp3_color <= RED;
						tp4_color <= MAGEN;
						tp5_color <= YELLOW;
					end
				endcase
				if(sel==3)
					sel <= 0;
				else
					sel <= sel+1;
			end
		end
	end
end

always@(posedge clk) begin
	if(visible) begin
		if(!start)begin
			{R,G,B} <= WHITE;
			if( (pixel_x >= 104 + 100) && (pixel_x < 104+700) && (pixel_y >= 23 + 50) && (pixel_y < 623 -50) )
				{R,G,B} <= BLUE;
		end
		else begin
			if(resume)begin
				//TP1:rectangle
				if( (less_number<20) && (pixel_x >= rect_x + 104) && (pixel_x < rect_x + 104 + 20 ) && (pixel_y >= rect_y + 23)  && (pixel_y < rect_y + 23 + 20) ) 
					{R,G,B} <= tp1_color;
				//TP2:triangle1
				else if( (less_number<20) && (pixel_x >= tr1_x + 104 ) && (pixel_x < tr1_x + 104 +20 ) && (pixel_y >= tr1_y + 23) && (pixel_y < tr1_y + 23 + 20 ))
					{R,G,B} <= ((pixel_y - 23 -tr1_y<= 2*(pixel_x - 104 - tr1_x )) && (pixel_y - 23 - tr1_y <= -2*(pixel_x - 104 - tr1_x )+40) )? tp2_color : BACKGROUND_color;
				//TP2:triangle2
				else if( (less_number<20) && (pixel_x >= tr2_x + 104 ) && (pixel_x < tr2_x + 104 + 20 ) && (pixel_y >= tr2_y + 23) && (pixel_y < tr2_y + 23 + 20 ))
					{R,G,B} <= ((pixel_y - 23 -tr2_y<= 2*(pixel_x - 104 - tr2_x )) && (pixel_y - 23 - tr2_y <= -2*(pixel_x - 104 - tr2_x )+40) )? tp3_color : BACKGROUND_color;
				//TP3:circle1
				else if( (less_number<20) && (pixel_x >= cir_x + 104 ) && (pixel_x < cir_x + 104 + 20) && (pixel_y >= cir_y + 23) && (pixel_y < cir_y + 23 + 20 ))
					{R,G,B} <= ((pixel_x-cir_x-104 - 10 )*(pixel_x-cir_x-104 -10 )+(pixel_y-23-cir_y -10)*(pixel_y-23-cir_y -10)<=100)? tp4_color : BACKGROUND_color;
				//TP3:circle2
				else if( (less_number<20) && (pixel_x >= cir1_x + 104 ) && (pixel_x < cir1_x + 104 + 20 ) && (pixel_y >= cir1_y + 23) && (pixel_y < cir1_y + 23 + 20 ))
					{R,G,B} <= ((pixel_x-cir1_x-104 - 10)*(pixel_x-cir1_x-104 -10)+(pixel_y-23-cir1_y -10)*(pixel_y-23-cir1_y -10)<=100)? tp5_color : BACKGROUND_color;
				//end of game
				else if(less_number==20)
				begin
					if( (pixel_x >= 104 + 100) && (pixel_x < 104+700) && (pixel_y >= 23 + 50) && (pixel_y < 623 -50) )
						{R,G,B} <= WHITE;
					else
						{R,G,B} <= BLUE;
					if( (pixel_x >=  104 +375 ) && (pixel_x <  104 + 375 + 50) && (pixel_y >=  23 +175) && (pixel_y <  23 + 225 ))
						{R,G,B} <= ((pixel_x-104-375 - 25 )*(pixel_x-104-375 -25 )+(pixel_y-23-175 -25)*(pixel_y-23-175 -25)<=625)? BLACK : WHITE;
					else if( (pixel_x >=  104 +375) && (pixel_x <  104 + 375 +50 ) && (pixel_y >=  23 +275)  && (pixel_y <  + 23 + 325) ) 
						{R,G,B} <= BLACK;
					else if( (pixel_x >=  104 +375) && (pixel_x <  104 + 375 +50 ) && (pixel_y >=  23 +375)  && (pixel_y <  + 23 + 425) )
						{R,G,B} <= ((pixel_y - 23-375 <= 2*(pixel_x - 104 -375 )) && (pixel_y - 23 -375 <= -2*(pixel_x - 104 -375 )+100) )? BLACK : WHITE;
					if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +100)  && (pixel_y < 23 + 150 -15+100) )
					begin
						case(cirr)
							0:begin
								if((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100)  && (pixel_y < 23 + 150 -15 -10+100) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							1:begin
								if((pixel_x >= 104 + 600 +20 + 25) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100)  && (pixel_y < 23 + 150 -15+100 ) )
									{R,G,B} <= BLACK;
								else
									{R,G,B} <= WHITE;
							end
							2:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100)  && (pixel_y < 23 + 150 -15 -40+100)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15 -10+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							3:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100)  && (pixel_y < 23 + 150 -15 -40+100)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15 -10+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							4:begin
								if( ((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15+100)  && (pixel_y < 23 + 150 -15 - 40+100)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							5:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +10+100)  && (pixel_y < 23 + 150 -15 -40+100)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15 -10+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							6:begin
								if( ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100)  && (pixel_y < 23 + 150 -15 -40+100)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15 -10+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							7:begin
								if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +10+100)  && (pixel_y < 23 + 150 -15+100) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							8:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100)  && (pixel_y < 23 + 150 -15-40+100)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15 -10+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							9:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100)  && (pixel_y < 23 + 150 -15-40+100)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100)  && (pixel_y < 23 + 150 -15+100)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
						endcase
					end
					if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +100+50+50)  && (pixel_y < 23 + 150 -15+100+50+50) )
					begin
						case(rectt)
							0:begin
								if((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							1:begin
								if((pixel_x >= 104 + 600 +20 + 25) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100+50+50)  && (pixel_y < 23 + 150 -15+100+50+50 ) )
									{R,G,B} <= BLACK;
								else
									{R,G,B} <= WHITE;
							end
							2:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							3:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							4:begin
								if( ((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15+100+50+50)  && (pixel_y < 23 + 150 -15 - 40+100+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							5:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +10+100+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							6:begin
								if( ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							7:begin
								if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +10+100+50+50)  && (pixel_y < 23 + 150 -15+100+50+50) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							8:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50)  && (pixel_y < 23 + 150 -15-40+100+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							9:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50)  && (pixel_y < 23 + 150 -15-40+100+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50)  && (pixel_y < 23 + 150 -15+100+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
						endcase
					end
					if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +100+50+50+50+50)  && (pixel_y < 23 + 150 -15+100+50+50+50+50) )
					begin
						case(trii)
							0:begin
								if((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							1:begin
								if((pixel_x >= 104 + 600 +20 + 25) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100+50+50+50+50)  && (pixel_y < 23 + 150 -15+100+50+50+50+50 ) )
									{R,G,B} <= BLACK;
								else
									{R,G,B} <= WHITE;
							end
							2:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							3:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							4:begin
								if( ((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 - 40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							5:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							6:begin
								if( ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							7:begin
								if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15+100+50+50+50+50) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							8:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15-40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15 -10+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
							9:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10+100+50+50+50+50)  && (pixel_y < 23 + 150 -15-40+100+50+50+50+50)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40+100+50+50+50+50)  && (pixel_y < 23 + 150 -15+100+50+50+50+50)) )
									{R,G,B} <= WHITE;
								else
									{R,G,B} <= BLACK;
							end
						endcase
					end
				end
				//board
				else if((pixel_x >= 104 + 600) && (pixel_x < 104 + 750) && (pixel_y >= 23 + 50)  && (pixel_y < 23 + 150) )
				begin
					if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15) )
					begin
						case(less_num2)
							0:begin
								if((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15 -10) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							1:begin
								if((pixel_x >= 104 + 600 +20 + 25) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 ) )
									{R,G,B} <= BLACK;
								else
									{R,G,B} <= CYAN;
							end
							2:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							3:begin
								if( ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							4:begin
								if( ((pixel_x >= 104 + 600 +20 + 10) && (pixel_x < 104 + 600 +55 - 10) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 - 40)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							5:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							6:begin
								if( ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							7:begin
								if( (pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							8:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15-40)) || ((pixel_x >= 104 + 600 +20 +10) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							9:begin
								if( ((pixel_x >= 104 + 600 +20+10) && (pixel_x < 104 + 600 +55-10) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15-40)) || ((pixel_x >= 104 + 600 +20) && (pixel_x < 104 + 600 +55 -10) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
						endcase
					end
					else
						{R,G,B} <= CYAN;
					if((pixel_x >= 104 + 600 +95) && (pixel_x < 104 + 600 +130) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15) )
					begin
						case(less_num1)
							0:begin
								if((pixel_x >= 104 + 600 +95 + 10) && (pixel_x < 104 + 600 +130-10) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15 -10) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							1:begin
								if((pixel_x >= 104 + 600 +95 + 25) && (pixel_x < 104 + 600 +130) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 ) )
									{R,G,B} <= BLACK;
								else
									{R,G,B} <= CYAN;
							end
							2:begin
								if( ((pixel_x >= 104 + 600 +20 + 75) && (pixel_x < 104 + 600 +55 - 10 +75) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20 +10 +75) && (pixel_x < 104 + 600 +55 +75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							3:begin
								if( ((pixel_x >= 104 + 600 +20 +75) && (pixel_x < 104 + 600 +55 - 10 +75) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20 +75) && (pixel_x < 104 + 600 +55 -10 +75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							4:begin
								if( ((pixel_x >= 104 + 600 +20 + 10+75) && (pixel_x < 104 + 600 +55 - 10 +75) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 - 40)) || ((pixel_x >= 104 + 600 +20 +75) && (pixel_x < 104 + 600 +55 -10 +75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							5:begin
								if( ((pixel_x >= 104 + 600 +20+10+75) && (pixel_x < 104 + 600 +55+75) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20+75) && (pixel_x < 104 + 600 +55 -10+75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							6:begin
								if( ((pixel_x >= 104 + 600 +20 +10+75) && (pixel_x < 104 + 600 +55+75) && (pixel_y >= 23 + 50 +15)  && (pixel_y < 23 + 150 -15 -40)) || ((pixel_x >= 104 + 600 +20 +10+75) && (pixel_x < 104 + 600 +55 -10+75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							7:begin
								if( (pixel_x >= 104 + 600 +20+75) && (pixel_x < 104 + 600 +55 -10+75) && (pixel_y >= 23 + 50 +15 +10)  && (pixel_y < 23 + 150 -15) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							8:begin
								if( ((pixel_x >= 104 + 600 +20+10+75) && (pixel_x < 104 + 600 +55-10+75) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15-40)) || ((pixel_x >= 104 + 600 +20 +10+75) && (pixel_x < 104 + 600 +55 -10+75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15 -10)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
							9:begin
								if( ((pixel_x >= 104 + 600 +20+10+75) && (pixel_x < 104 + 600 +55-10+75) && (pixel_y >= 23 + 50 +15+10)  && (pixel_y < 23 + 150 -15-40)) || ((pixel_x >= 104 + 600 +20+75) && (pixel_x < 104 + 600 +55 -10+75) && (pixel_y >= 23 + 50 +15 +40)  && (pixel_y < 23 + 150 -15)) )
									{R,G,B} <= CYAN;
								else
									{R,G,B} <= BLACK;
							end
						endcase
					end
				end
				//GP
				else if((pixel_x >= 104 + 30 + GP_x) && (pixel_x < 104 + 62 + GP_x) && (pixel_y >= 23 + 518)  && (pixel_y < 23 + 550))
				begin
					if( (pixel_x-104-30-GP_x -16)*(pixel_x-104-30-GP_x -16)+(pixel_y-23-518 -16)*(pixel_y-23-518 -16) <= 256 )
					begin
						if( (pixel_y - 23 -518<= (pixel_x - 104 - 30 - GP_x)) && (pixel_y - 23 - 518)  <= -1*(pixel_x - 104 - 30 - GP_x)+32 )
						begin
							if(GPopen)
								{R,G,B} <= RED;
							else
								{R,G,B} <= GP_color;
						end
						else
							{R,G,B} <= GP_color;
					end
					else
						{R,G,B} <= BACKGROUND_color;
				end
				//background
				else 
					{R,G,B} <= BACKGROUND_color;
			end
			else
				{R,G,B} <= DEFAULT;
		end
	end
	else 
		{R,G,B} <= DEFAULT;
end


endmodule


