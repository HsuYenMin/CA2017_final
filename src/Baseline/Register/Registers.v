module register_file(
    Clk  ,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY ,
	rst_n
);
    input        Clk, WEN, rst_n;
    input  [4:0] RW, RX, RY;
    input  [31:0] busW;
    output [31:0] busX, busY;
    
    // write your design here
/////////////////////////////////////////////////////////////////////////////////
	integer i;
	
	reg [31:0] Register_r [31:0];
	reg [31:0] Register_w [31:0];
	reg [31:0] busX_r, busY_r;

	assign busX = busX_r;
	assign busY = busY_r;

	// combinational
	always@ (*) begin
		for(i=0;i<32;i=i+1) begin Register_w[i] = Register_r[i]; end
		if(WEN) Register_w[RW] = busW;
		busX_r = Register_r[RX];
		busY_r = Register_r[RY];
	end

	// sequential
	always@ (posedge Clk or negedge rst_n) begin
		if(~rst_n) begin
			for(i=0;i<32;i=i+1) begin Register_r[i] <= 0; end
		end else begin
			Register_r[0] <= 0;
			for(i=1;i<32;i=i+1) begin Register_r[i] <= Register_w[i]; end
		end
	end
	
/////////////////////////////////////////////////////////////////////////////////
endmodule