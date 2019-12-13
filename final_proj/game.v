module game(
	 input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,// vertical sync output
    output reg [3:0] VGA_R,    // 4-bit VGA red output
    output reg [3:0] VGA_G,    // 4-bit VGA green output
    output reg [3:0] VGA_B,    // 4-bit VGA blue output
	 input KEY0,
	 input KEY1,
	 input KEY2,
	 input KEY3,
	 output [6:0] hex1,
	 output [6:0] hex2,
	 input PS2_DAT,
	 input PS2_CLK
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    // wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h8000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );
	 
	 wire makeBreak, valid;
	 wire [7:0] outCode;
	 keyboard_press_driver(
		 CLK, 
		 valid, 
		 makeBreak,
		 outCode,
		 PS2_DAT, // PS2 data line
		 PS2_CLK, // PS2 clock line
		 rst
	 );
	 
	 reg breakout_start;
	 wire breakout_done;
	 wire [3:0] br_vga_r;
	 wire [3:0] br_vga_g;
	 wire [3:0] br_vga_b;
	 breakout_game game1(CLK, RST_BTN, x, y, KEY1, KEY0, breakout_start, breakout_done, KEY3, KEY2, br_vga_r, br_vga_g, br_vga_b);

	 reg pong_start;
	 wire pong_done;
	 wire [3:0] pg_vga_r;
	 wire [3:0] pg_vga_g;
	 wire [3:0] pg_vga_b;
	 pong_game	game2(CLK, RST_BTN, x, y, KEY1, KEY0, KEY3, KEY2, pong_start, pong_done, hex1, hex2, pg_vga_r, pg_vga_g, pg_vga_b);

    wire sq_a, sq_b, sq_c, sq_d;
    assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
    assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
    assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
    assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;
 
	parameter menu = 2'd0,
					breakout = 2'd1,
					pong = 2'd2;
	
	reg [2:0] s;
	reg [2:0] ns;
	
	always@(posedge CLK or negedge RST_BTN)
	begin
		if(RST_BTN == 1'b0)
		begin
			s <= menu;
		end
		else 
		begin
			s <= ns;
		end
	end

 // state transition
 always@(*)
 begin
	case(s)
		menu: begin
					if (KEY0 == 1'b0)
					begin
						ns = breakout;
					end
					else if (KEY1 == 1'b0)
					begin
						ns = pong;
					end
					else
					begin
						ns = menu;
					end
		end
		
		breakout: begin
						if (breakout_done == 1'b0)
						begin
							ns = breakout;
							breakout_start = 1'b1;
						end
						else 
						begin
							ns = menu;
							breakout_start = 1'b0;
						end
		end
					 
		pong: begin
					if (pong_done == 1'b0)
					begin
						ns = pong;
						pong_start = 1'b1;
					end 
					else  
					begin
						ns = menu;
						pong_start = 1'b0;
					end
		end
	endcase
 end
 
 // vga output assignment
 always@(*) 
	begin 
		case(s)
			menu: begin
						VGA_R[3] = sq_a;         // square b is red
						VGA_G[3] = sq_b | sq_c;  // squares a and d are green
						VGA_B[3] = sq_d;  
						
						VGA_R[2] = sq_a;         // square b is red
						VGA_G[2] = sq_b | sq_c;  // squares a and d are green
						VGA_B[2] = sq_d;  
						
						VGA_R[1] = sq_a;         // square b is red
						VGA_G[1] = sq_b | sq_c;  // squares a and d are green
						VGA_B[1] = sq_d;  
						
						VGA_R[0] = sq_a;         // square b is red
						VGA_G[0] = sq_b | sq_c;  // squares a and d are green
						VGA_B[0] = sq_d;  
			end
				
			breakout: begin
							VGA_R[3] = br_vga_r[3];
							VGA_G[3] = br_vga_g[3];
							VGA_B[3] = br_vga_b[3];
							
							VGA_R[2] = br_vga_r[2];
							VGA_G[2] = br_vga_g[2];
							VGA_B[2] = br_vga_b[2];
						
							VGA_R[1] = br_vga_r[1];
							VGA_G[1] = br_vga_g[1];
							VGA_B[1] = br_vga_b[1];
							
							VGA_R[0] = br_vga_r[0];
							VGA_G[0] = br_vga_g[0];
							VGA_B[0] = br_vga_b[0];
			end
			
			pong: begin
						VGA_R[3] = pg_vga_r[3];
						VGA_G[3] = pg_vga_g[3];
						VGA_B[3] = pg_vga_b[3];
						
						VGA_R[2] = pg_vga_r[2];
						VGA_G[2] = pg_vga_g[2];
						VGA_B[2] = pg_vga_b[2];
					
						VGA_R[1] = pg_vga_r[1];
						VGA_G[1] = pg_vga_g[1];
						VGA_B[1] = pg_vga_b[1];
						
						VGA_R[0] = pg_vga_r[0];
						VGA_G[0] = pg_vga_g[0];
						VGA_B[0] = pg_vga_b[0];
			end
		endcase
	end		 
endmodule
