//Behavior level (event-driven) 
module alu(
    ctrl,
    x,
    y,
	sa,
	Zero,
    out 
);
    
    input         [3:0]  ctrl;
    input  signed [31:0] x;
    input  signed [31:0] y;
	input         [4:0]  sa;
    output               Zero;
    output signed [31:0] out;
///////////////////////////////////////////////////////////////////////////////////////////

	//wire signed [7:0] x_s, y_s;
	reg signed [31:0] Out_r;
	
	assign out = Out_r;
	assign Zero = (Out_r == 0)? 1 : 0;
	
	always@ (*) begin
		if(ctrl == 4'b0000)      Out_r = x + y;		// add
		else if(ctrl == 4'b0001) Out_r = x - y;		// sub
		else if(ctrl == 4'b0010) Out_r = x & y;		// and(x,y);
		else if(ctrl == 4'b0011) Out_r = x | y;		// or(x,y);
//		else if(ctrl == 4'b0100) Out_r = ~x;	 	// not(x);
		else if(ctrl == 4'b0101) Out_r = x ^ y; 	// xor(x,y);
		else if(ctrl == 4'b0110) Out_r = ~(x|y); 	// nor(x,y);
		else if(ctrl == 4'b0111) Out_r = y << sa;	// SLL
		else if(ctrl == 4'b1000) Out_r = y >> sa;	// SRL
		else if(ctrl == 4'b1001) Out_r = y >>> sa;	// SRA
//		else if(ctrl == 4'b1010) Out_r = {x[6:0],x[7]};	// Rotate Left
//		else if(ctrl == 4'b1011) Out_r = {x[0],x[7:1]};	// Rotate right
		else if(ctrl == 4'b1100) Out_r = (x < y) ?1:0;	// SLT
		else if(ctrl == 4'b1101) Out_r = (x == y)?1:0;	// Equal
		else Out_r = 0;
	end


///////////////////////////////////////////////////////////////////////////////////////////   

endmodule
