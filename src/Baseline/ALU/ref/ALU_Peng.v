module ALU(
    ctrl,
    x,
    y,
    Zero,
    out 
);
    
    input  [3:0] ctrl;
    input  signed [31:0] x;
    input  signed [31:0] y;
    output       Zero;
    output signed [31:0] out;
///////////////////////////////////////////////////////////////////////////////////////////

	reg signed [31:0] Out_r;
	reg Carry_r;

	assign out = Out_r;
	assign Zero = (Out_r == 0)? 1 : 0;
	
	always@ (*) begin
		if(ctrl == 4'b0000) 	 Out_r = x & y;
		else if(ctrl == 4'b0001) Out_r = x | y;
		else if(ctrl == 4'b0010) Out_r = x + y;
		else if(ctrl == 4'b0110) Out_r = x - y;
		else if(ctrl == 4'b0111) Out_r = (x < y)? 1 : 0;
		else Out_r = 0;
	end

///////////////////////////////////////////////////////////////////////////////////////////   

endmodule


///////////////////////////////////////////////////////////////////////////////////////////
/*	
	always@ (*) begin
		if(ctrl == 4'b0000) {Carry_r,Out_r} = x_s + y_s;
		else if(ctrl == 4'b0001) {Carry_r,Out_r} = x_s - y_s;
		else if(ctrl == 4'b0010) Out_r = x & y;		// and(x,y);
		else if(ctrl == 4'b0011) Out_r = x | y;		// or(x,y);
		else if(ctrl == 4'b0100) Out_r = ~x;	 		// not(x);
		else if(ctrl == 4'b0101) Out_r = x ^ y; 	// xor(x,y);
		else if(ctrl == 4'b0110) Out_r = ~(x|y); 	//nor(x,y);
		else if(ctrl == 4'b0111) Out_r = y << x[2:0];
		else if(ctrl == 4'b1000) Out_r = y >> x[2:0];
		else if(ctrl == 4'b1001) Out_r = {x[7],x[7:1]};
		else if(ctrl == 4'b1010) Out_r = {x[6:0],x[7]};
		else if(ctrl == 4'b1011) Out_r = {x[0],x[7:1]};
		else if(ctrl == 4'b1100) Out_r = (x==y)?1:0;
		else Out_r = 0;
	end
*/
////////////////////////////////////////////////////////////////////////////////////////////