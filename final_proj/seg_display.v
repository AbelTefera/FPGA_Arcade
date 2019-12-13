module seg_display(led0, led1, led2, led3, led4, led5, led6, a, b, c, d);

input a, b, c, d;
output led0, led1, led2, led3, led4, led5, led6;

assign led0 = (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (a & ~b & c & d) | (a & b & ~c & d);

assign led1 = (~a & b & ~c & d) | (a & b & ~d) | (a & c & d) | (b & c & ~d);

assign led2 = (~a & ~b & c & ~d) | (a & b & ~d) | (a & b & c);

assign led3 = (~a & b & ~c & ~d) | (~b & ~c & d) | (b & c & d) | (a & ~b & c & ~d);

assign led4 = (~a & d) | (~a & b & ~c) | (~b & ~c & d);

assign led5 = (~a & ~b & d) | (~a & ~b & c) | (~a & c & d) | (a & b & ~c & d);

assign led6 = (~a & ~b & ~c) | (~a & b & c & d) | (a & b & ~c & ~d);

endmodule 