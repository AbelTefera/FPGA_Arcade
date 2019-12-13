module breakout_game(clk, rst, x, y, left, right, start, done, KEY3, KEY2, br_vga_r, br_vga_g, br_vga_b);

input clk;
input rst;
input right, left, start, KEY3, KEY2;
input [9:0] x;
input [8:0] y;
output reg done;
wire [17:0] block;
wire [4:0] ball;
wire player_bar;

reg [2:0] s;
reg [2:0] ns;

output reg [3:0] br_vga_r;
output reg [3:0] br_vga_g;
output reg [3:0] br_vga_b;
				 
parameter start_game = 3'd0,
				play_setup = 3'd1,
				playing = 3'd2,
				game_done = 3'd3;

wire sq_a = (x > 0 && x < 640 && y > 0 && y < 480);

reg [1:0] count2;

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		s <= start_game;
	end
	else
	begin
		s <= ns;
	end
end

// ball bounce, ball_sp
always@(posedge clk)
begin
	case(s)
		start: begin
			// ball
			ball_x_sp = 1;
			ball_y_sp = 2;
		end
		
		play_setup: begin
			ball_x_sp = 1;
			ball_y_sp = 2;
		end
		
		playing: begin
			// row 3
			if (ball_y >= 110 && ball_y + 10 <= 165)
			begin
				if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[12])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[13])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[14])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[15])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[16])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[17])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
			end
			
			// row 2
			if (ball_y >= 55 && ball_y + 10 <= 105)
			begin
				if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[6])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[7])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[8])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[9])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[10])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[11])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
			end
				
			// row 1
			if (ball_y >= 0 && ball_y + 10 <= 50)
			begin
				if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[0])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[1])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[2])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[3])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[4])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[5])
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
			end
		end // playing
	endcase
	
	ball_y_sp = 8'd4 - ball_x_sp;
end

// state transition
always@(*)
begin
	case(s)
		start_game: begin
			done = 1'b0;
			if (start == 1'b1)
			begin	
				ns = play_setup;
			end  
			else 
			begin
				ns = start;
			end
		end
		
		play_setup: begin
			if (KEY3 == 1'b0)
			begin   
				ns = playing;
			end
			else 
			begin
				ns = play_setup;
			end
		end 
		
		playing: begin
			if (ball_y >= 475 && ball_y <= 480) 
			begin
				ns = game_done;
			end
			else if (~(block_on[0] || block_on[1] || block_on[2] || block_on[3] || block_on[4] || block_on[5] || block_on[6] || block_on[7] || block_on[8] || block_on[9] || block_on[10] || block_on[12] || block_on[13] || block_on[14] || block_on[15] || block_on[16] || block_on[17] || block_on[11]))
			begin
				ns = game_done;
			end
			else
			begin
				ns = playing;
			end
		end
		
		game_done: begin
			if (right == 1'b0)
			begin
				done = 1'b0;
				ns = start;
			end
			else if (KEY2 == 1'b0)
			begin
				done = 1'b1;
				ns = start;
			end
			else
			begin
				done = 1'b0;
				ns = game_done;
			end
		end
		
		default: begin
			ns = start;
		end
	endcase
	
	// player_bar
	bar_height = 25;
	bar_width = 96;
	bar_y = 450;
	bar_x_sp = 3;
end
			
reg [9:0] bar_x;
reg [8:0] bar_y;

reg [9:0] bar_width;
reg [8:0] bar_height;

reg [7:0] bar_x_sp;

reg [9:0] ball_x;
reg [8:0] ball_y;

reg ball_x_dir;
reg ball_y_dir;

reg [7:0] ball_x_sp;
reg [7:0] ball_y_sp;

reg [17:0] block_on;

reg [19:0] count;

always@(posedge clk)
begin
	if (count == 20'd500_000)
	begin
		count <= 20'd0;
	end
	else
	begin
		count <= count + 20'd1;
	end
	
	count2 <= count2 + 1'b1;
end

// display logic
always@(*)
begin
	case(s)
		play_setup: begin
				br_vga_r[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];        
				br_vga_g[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14]; 
				br_vga_b[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14];
				br_vga_b[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14];  
				br_vga_b[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14]; 
				br_vga_b[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 			
		end

		playing: begin
				br_vga_r[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];        
				br_vga_g[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14]; 
				br_vga_b[3] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14];
				br_vga_b[2] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14];  
				br_vga_b[1] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 

				br_vga_r[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[0] | block[6] | block[12] | block[1] | block[7] | block[13] | block[5] | block[11] | block[17];         
				br_vga_g[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[3] | block[9] | block[15] | block[1] | block[7] | block[13] | block[2] | block[8] | block[14]; 
				br_vga_b[0] = ball[0] | ball[1] | ball[2] | ball[3] | ball[4] | player_bar | block[4] | block[10] | block[16] | block[2] | block[8] | block[14] | block[5] | block[11] | block[17]; 			
		end
		
		game_done: begin
			// lose
			if ((block_on[0] || block_on[1] || block_on[2] || block_on[3] || block_on[4] || block_on[5] || block_on[6] || block_on[7] || block_on[8] || block_on[9] || block_on[10] || block_on[12] || block_on[13] || block_on[14] || block_on[15] || block_on[16] || block_on[17] || block_on[11]))
			begin
				br_vga_r[3] = sq_a;
				
				br_vga_r[2] = sq_a;
				
				br_vga_r[1] = sq_a;
				
				br_vga_r[0] = sq_a;
			end
			// win
			else
			begin
				br_vga_g[3] = sq_a;
				
				br_vga_g[2] = sq_a;
				
				br_vga_g[1] = sq_a;
				
				br_vga_g[0] = sq_a;
			end
		end
	endcase
end
			
// game logic and controls.
always@(posedge clk)
begin
	case(s)
		start_game: begin
			bar_x <= 272;
			
			ball_x <= 300;
			ball_y <= 200;
			
			ball_y_dir <= 1'b1;
			ball_x_dir <= 1'b1;
			
			block_on <= 18'b111111111111111111;
		end
		
		play_setup: begin
			bar_x <= 272;
			
			ball_x <= 300;
			ball_y <= 200;
			
			ball_y_dir <= 1'b1;
			ball_x_dir <= 1'b1;
			
			block_on <= 18'b111111111111111111;
		end
		
		playing: begin
			if (count == 20'd500_000)
			begin
				// player move right
				if (right == 1'b0 && (bar_x + bar_width) <= 639)
				begin
					bar_x <= bar_x + bar_x_sp;
				end
				
				// player move left
				if (left == 1'b0 && bar_x >= 4)
				begin
					bar_x <= bar_x - bar_x_sp;
				end
				
				// ball movement
				if (ball_x_dir == 1'b1)
				begin
					ball_x <= ball_x + ball_x_sp;
				end
				else if (ball_x_dir == 1'b0)
				begin
					ball_x <= ball_x - ball_x_sp;
				end
				
				if (ball_y_dir == 1'b1) 
				begin
					ball_y <= ball_y + ball_y_sp;
				end
				else if (ball_y_dir == 1'b0)
				begin
					ball_y <= ball_y - ball_y_sp;
				end
				
				// ball x direction
				if (((ball_x + 10) >= 636) && ((ball_x + 10) <= 640))
				begin
					ball_x_dir <= 1'b0;
				end
				else if (ball_x >= 0 && ball_x <= 4)
				begin
					ball_x_dir <= 1'b1;
				end
				
				// ball bounces of player bar 
				if ((ball_x >= bar_x) && (ball_x <= (bar_x + bar_width)) && (ball_y >= (bar_y - 10)) && (ball_y <= (bar_y + bar_height - 10)))
				begin
					ball_y_dir <= 1'b0;
				end
				// bounce of top of screen
				if (ball_y >= 0 && ball_y <= 1)
				begin
					ball_y_dir <= 1'b1;
				end
				
				// row 3
				if (ball_y >= 110 && ball_y + 10 <= 165)
				begin
					if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[12])
					begin
						block_on[12] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[13])
					begin
						block_on[13] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[14])
					begin
						block_on[14] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[15])
					begin
						block_on[15] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[16])
					begin
						block_on[16] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[17])
					begin
						block_on[17] = 1'b0;
						ball_y_dir <= 1'b1;
					end
				end
				
				// row 2
				if (ball_y >= 55 && ball_y + 10 <= 105)
				begin
					if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[6])
					begin
						block_on[6] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[7])
					begin
						block_on[7] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[8])
					begin
						block_on[8] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[9])
					begin
						block_on[9] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[10])
					begin
						block_on[10] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[11])
					begin
						block_on[11] = 1'b0;
						ball_y_dir <= 1'b1;
					end
				end
				
				// row 1
				if (ball_y >= 0 && ball_y + 10 <= 50)
				begin
					if (ball_x >= 0 && ball_x + 10 <= 104 && block_on[0])
					begin
						block_on[0] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 107 && ball_x + 10 <= 211 && block_on[1])
					begin
						block_on[1] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 214 && ball_x + 10 <= 318 && block_on[2])
					begin
						block_on[2] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 321 && ball_x + 10 <= 425 && block_on[3])
					begin
						block_on[3] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 428 && ball_x + 10 <= 532 && block_on[4])
					begin
						block_on[4] = 1'b0;
						ball_y_dir <= 1'b1;
					end
					
					if (ball_x >= 535 && ball_x + 10 <= 640 && block_on[5])
					begin
						block_on[5] = 1'b0;
						ball_y_dir <= 1'b1;
					end
				end
			end
			
		end // playing
	endcase
end

assign player_bar = ((x > bar_x) & (x < bar_x + bar_width) & (y > bar_y) & (y < (bar_y + bar_height))) ? 1 : 0;

assign ball[0] = ((x > (ball_x + 3)) & (x < (ball_x + 10 - 3)) & (y > (ball_y + 0)) & (y < (ball_y + 2))) ? 1 : 0;
assign ball[1] = ((x > (ball_x + 2)) & (x < (ball_x + 10 - 2)) & (y > (ball_y + 2)) & (y < (ball_y + 4))) ? 1 : 0;
assign ball[2] = ((x > ball_x) & (x < (ball_x + 10)) & (y > (ball_y + 4)) & (y < (ball_y + 6))) ? 1 : 0;
assign ball[3] = ((x > (ball_x + 2)) & (x < (ball_x + 10 - 2)) & (y > (ball_y + 6)) & (y < (ball_y + 8))) ? 1 : 0;
assign ball[4] = ((x > (ball_x + 3)) & (x < (ball_x + 10 - 3)) & (y > (ball_y + 8)) & (y < (ball_y + 10))) ? 1 : 0;

// row 1
assign block[0] = ((x > 0) & (x < 104) & (y > 0) & (y < 50)) ? (1 & block_on[0]) : 0;
assign block[1] = ((x > 107) & (x < 211) & (y > 0) & (y < 50)) ? (1 & block_on[1]) : 0;
assign block[2] = ((x > 214) & (x < 318) & (y > 0) & (y < 50)) ? (1 & block_on[2]) : 0;
assign block[3] = ((x > 321) & (x < 425) & (y > 0) & (y < 50)) ? (1 & block_on[3]) : 0;
assign block[4] = ((x > 428) & (x < 532) & (y > 0) & (y < 50)) ? (1 & block_on[4]) : 0;
assign block[5] = ((x > 535) & (x < 640) & (y > 0) & (y < 50)) ? (1 & block_on[5]) : 0;

// row 2
assign block[6] = ((x > 0) & (x < 104) & (y > 55) & (y < 105)) ? (1 & block_on[6]) : 0;
assign block[7] = ((x > 107) & (x < 211) & (y > 55) & (y < 105)) ? (1 & block_on[7]) : 0;
assign block[8] = ((x > 214) & (x < 318) & (y > 55) & (y < 105)) ? (1 & block_on[8]) : 0;
assign block[9] = ((x > 321) & (x < 425) & (y > 55) & (y < 105)) ? (1 & block_on[9]) : 0;
assign block[10] = ((x > 428) & (x < 532) & (y > 55) & (y < 105)) ? (1 & block_on[10]) : 0;
assign block[11] = ((x > 535) & (x < 640) & (y > 55) & (y < 105)) ? (1 & block_on[11]) : 0;

// row 3
assign block[12] = ((x > 0) & (x < 104) & (y > 110) & (y < 165)) ? (1 & block_on[12]) : 0;
assign block[13] = ((x > 107) & (x < 211) & (y > 110) & (y < 165)) ? (1 & block_on[13]) : 0;
assign block[14] = ((x > 214) & (x < 318) & (y > 110) & (y < 165)) ? (1 & block_on[14]) : 0;
assign block[15] = ((x > 321) & (x < 425) & (y > 110) & (y < 165)) ? (1 & block_on[15]) : 0;
assign block[16] = ((x > 428) & (x < 532) & (y > 110) & (y < 165)) ? (1 & block_on[16]) : 0;
assign block[17] = ((x > 535) & (x < 640) & (y > 110) & (y < 165)) ? (1 & block_on[17]) : 0;

endmodule
