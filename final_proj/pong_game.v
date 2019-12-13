module pong_game(clk, rst, x, y ,left1, right1, left2, right2, start, done, hex1, hex2, pg_vga_r, pg_vga_g, pg_vga_b);

input clk;
input rst;
input right1, left1, right2, left2, start;
input [9:0] x;
input [8:0] y;
output reg done;
wire [4:0] pong_ball;
wire p1_bar, p2_bar;
output [6:0] hex1, hex2;
output reg [3:0] pg_vga_r;
output reg [3:0] pg_vga_g;
output reg [3:0] pg_vga_b;

reg [2:0] s;
reg [2:0] ns;

reg [3:0] p1_score;
reg [3:0] p2_score;

parameter start_game = 2'd0,
				play_setup = 2'd1,
				playing = 2'd2,
				game_done = 2'd3;

seg_display p1_score_dis(hex1[0], hex1[1], hex1[2], hex1[3], hex1[4], hex1[5], hex1[6], p1_score[3], p1_score[2], p1_score[1], p1_score[0]);
seg_display p2_score_dis(hex2[0], hex2[1], hex2[2], hex2[3], hex2[4], hex2[5], hex2[6], p2_score[3], p2_score[2], p2_score[1], p2_score[0]);

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

// generate random vector for ball to bounce
always@(*)
begin
	case(s)
		start_game: begin
				ball_x_sp = 1;
				ball_y_sp = 1;
		end
		
		play_setup: begin
			ball_x_sp = 1;
			ball_y_sp = 1;
		end
		
		playing: begin
			   // ball bounces of p1 bar 
				if ((ball_x >= p1_bar_x) && (ball_x <= (p1_bar_x + bar_width)) && (ball_y >= (p1_bar_y - 10)) && (ball_y <= (p1_bar_y + bar_height - 10)))
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				// ball bounces of p2 bar 
				if ((ball_x >= p2_bar_x) && (ball_x <= (p2_bar_x + bar_width)) && (ball_y >= (p2_bar_y + 10)) && (ball_y <= (p2_bar_y + bar_height + 10)))
				begin
					if (~(count2 == 2'd0))
						ball_x_sp = count2;
					else
						ball_x_sp = 2'd1;
				end
				
				ball_y_sp = 8'd4 - ball_x_sp;
		end
	endcase
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
			if (left2 == 1'b0)
			begin   
				ns = playing;
			end
			else 
			begin
				ns = play_setup;
			end
			if (p1_score == 4'd5 || p2_score == 4'd5)
			begin
				ns = game_done;
			end
		end
		
		playing: begin
			if (ball_y >= 430 || ball_y <= 20) 
			begin
				ns = play_setup;
			end
			else
			begin
				ns = playing;
			end
		end
		
		game_done: begin
			if (right1 == 1'b0)
			begin
				done = 1'b0;
				ns = start;
			end
			else if (right2 == 1'b0)
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
	p1_bar_y = 430;
	p2_bar_y = 20;
	bar_x_sp = 8;
end
			
reg [9:0] p1_bar_x;
reg [8:0] p1_bar_y;

reg [9:0] p2_bar_x;
reg [8:0] p2_bar_y;

reg [9:0] bar_width;
reg [8:0] bar_height;

reg [7:0] bar_x_sp;

reg [9:0] ball_x;
reg [8:0] ball_y;

reg ball_x_dir;
reg ball_y_dir;

reg [1:0] ball_x_sp;
reg [1:0] ball_y_sp;

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

wire sq_b = (x > 0 && x < 480 && y > 0 && y < 640);
wire sq_a = (x > 0 && x < 480 && y > 0 && y < 640);

// vga output
always@(*)
begin
	case(s)
		play_setup: begin
			pg_vga_r[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];		
		end
		
		playing: begin
			pg_vga_r[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[3] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[2] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[1] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			
			pg_vga_r[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_g[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];
			pg_vga_b[0] = p1_bar | p2_bar | pong_ball[0] | pong_ball[1] | pong_ball[2] | pong_ball[3] | pong_ball[4];	
		end
		
		game_done: begin
			if (p1_score == 4'd5)
			begin
				pg_vga_b[3] = sq_a;
			end
			else if (p2_score == 4'd5)
			begin
				pg_vga_r[3] = sq_a;
			end
		end
	endcase
end

// game logic
always@(posedge clk)
begin
	case(s)
		start_game: begin
			p1_bar_x <= 272;
			p2_bar_x <= 272;
			
			ball_x <= 300;
			ball_y <= 200;
			
			ball_y_dir <= 1'b1;
			ball_x_dir <= 1'b1;
			
			p1_score <= 4'd0;
			p2_score <= 4'd0;
		end
		
		play_setup: begin
			p1_bar_x <= 272;
			p2_bar_x <= 272;
			
			ball_x <= 300;
			ball_y <= 200;
			
			ball_y_dir <= 1'b1;
			ball_x_dir <= 1'b1;
		end
		
		playing: begin
			if (count == 20'd500_000)
			begin
				// p1 bar movement
				if (right1 == 1'b0 && (p1_bar_x + bar_width) <= 639)
				begin
					p1_bar_x <= p1_bar_x + bar_x_sp;
				end
				
				if (left1 == 1'b0 && p1_bar_x >= 2)
				begin
					p1_bar_x <= p1_bar_x - bar_x_sp;
				end
				
				// p2 bar movement
				if (right2 == 1'b0 && (p2_bar_x + bar_width) <= 639)
				begin
					p2_bar_x <= p2_bar_x + bar_x_sp;
				end
				
				if (left2 == 1'b0 && p2_bar_x >= 2)
				begin
					p2_bar_x <= p2_bar_x - bar_x_sp;
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
			end
			
			// ball direction
			if (ball_x >= 639)
			begin
				ball_x_dir <= 1'b0;
			end
			if (ball_x <= 3)
			begin
				ball_x_dir <= 1'b1;
			end
				
			// ball bounces of p1 bar 
			if ((ball_x >= p1_bar_x) && (ball_x <= (p1_bar_x + bar_width)) && (ball_y >= (p1_bar_y - 10)) && (ball_y <= (p1_bar_y + bar_height - 10)))
			begin
				ball_y_dir <= 1'b0;
			end
			
			// ball bounces of p2 bar 
			if ((ball_x >= p2_bar_x) && (ball_x <= (p2_bar_x + bar_width)) && (ball_y >= (p2_bar_y + 10)) && (ball_y <= (p2_bar_y + bar_height + 10)))
			begin
				ball_y_dir <= 1'b1;
			end
			
			if (ball_y <= 20)
			begin
				p1_score <= p1_score + 1'b1;
			end
			
			if (ball_y >= 430)
			begin
				p2_score <= p2_score + 1'b1;
			end
		end
	endcase
end

assign p1_bar = ((x > p1_bar_x) && (x < p1_bar_x + bar_width) && (y > p1_bar_y) && (y < (p1_bar_y + bar_height))) ? 1 : 0;
assign p2_bar = ((x > p2_bar_x) && (x < p2_bar_x + bar_width) && (y > p2_bar_y) && (y < (p2_bar_y + bar_height))) ? 1 : 0;

assign pong_ball[0] = ((x > ball_x + 3) && (x < (ball_x + 10 - 3)) && (y > (ball_y + 0)) && (y < (ball_y + 2))) ? 1 : 0;
assign pong_ball[1] = ((x > ball_x + 2) && (x < (ball_x + 10 - 2)) && (y > (ball_y + 2)) && (y < (ball_y + 4))) ? 1 : 0;
assign pong_ball[2] = ((x > ball_x) && (x < (ball_x + 10)) && (y > (ball_y + 4)) && (y < (ball_y + 6))) ? 1 : 0;
assign pong_ball[3] = ((x > ball_x + 2) && (x < (ball_x + 10 - 2)) && (y > (ball_y + 6)) && (y < (ball_y + 8))) ? 1 : 0;
assign pong_ball[4] = ((x > ball_x + 3) && (x < (ball_x + 10 - 3)) && (y > (ball_y + 8)) && (y < (ball_y + 10))) ? 1 : 0;

endmodule
