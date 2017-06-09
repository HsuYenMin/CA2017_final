module register_file(
    Clk  ,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY ,
	Reset
);
    input        Clk, WEN, Reset;
    input  [4:0] RW, RX, RY;
    input  [31:0] busW;
    output [31:0] busX, busY;
    
    // write your design here
/////////////////////////////////////////////////////////////////////////////////
	reg [31:0] Register [31:0];
	reg [31:0] busX_r, busY_r;

	assign busX = busX_r;
	assign busY = busY_r;

	// combinational
	always@ (*) begin
		Register[RW] = (RW == 0) ? 0 : busW;
		busX_r = Register[RX];
		busY_r = Register[RY];
	end

	// sequential
	always@ (posedge Clk or negedge Reset) begin
		if(~Reset) begin
			Register[0]  <= 0;
			Register[1]  <= 0;
			Register[2]  <= 0;
			Register[3]  <= 0;
			Register[4]  <= 0;
			Register[5]  <= 0;
			Register[6]  <= 0;
			Register[7]  <= 0;
			Register[8]  <= 0;
			Register[9]  <= 0;
			Register[10] <= 0;
			Register[11] <= 0;
			Register[12] <= 0;
			Register[13] <= 0;
			Register[14] <= 0;
			Register[15] <= 0;
			Register[16] <= 0;
			Register[17] <= 0;
			Register[18] <= 0;
			Register[19] <= 0;
			Register[20] <= 0;
			Register[21] <= 0;
			Register[22] <= 0;
			Register[23] <= 0;
			Register[24] <= 0;
			Register[25] <= 0;
			Register[26] <= 0;
			Register[27] <= 0;
			Register[28] <= 0;
			Register[29] <= 0;
			Register[30] <= 0;
			Register[31] <= 0;
		end else begin
			Register[0]  <= 0;
			Register[1]  <= Register[1];
			Register[2]  <= Register[2];
			Register[3]  <= Register[3];
			Register[4]  <= Register[4];
			Register[5]  <= Register[5];
			Register[6]  <= Register[6];
			Register[7]  <= Register[7];
			Register[8]  <= Register[8];
			Register[9]  <= Register[9];
			Register[10] <= Register[10];
			Register[11] <= Register[11];
			Register[12] <= Register[12];
			Register[13] <= Register[13];
			Register[14] <= Register[14];
			Register[15] <= Register[15];
			Register[16] <= Register[16];
			Register[17] <= Register[17];
			Register[18] <= Register[18];
			Register[19] <= Register[19];
			Register[20] <= Register[20];
			Register[21] <= Register[21];
			Register[22] <= Register[22];
			Register[23] <= Register[23];
			Register[24] <= Register[24];
			Register[25] <= Register[25];
			Register[26] <= Register[26];
			Register[27] <= Register[27];
			Register[28] <= Register[28];
			Register[29] <= Register[29];
			Register[30] <= Register[30];
			Register[31] <= Register[31];
		end
	end
	
/////////////////////////////////////////////////////////////////////////////////
endmodule