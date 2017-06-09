module register_file(
    Clk  ,
	rst_n,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY
);
    input        Clk, WEN, rst_n;
    input  [4:0] RW, RX, RY;
    input  [31:0] busW;
    output [31:0] busX, busY;
    
    // write your design here
/////////////////////////////////////////////////////////////////////////////////
	reg [31:0] Register_r [31:0];
	reg [31:0] Register_w [31:0];
	reg [31:0] busX_r, busY_r;

	assign busX = busX_r;
	assign busY = busY_r;

	// combinational
	always@ (*) begin
		busX_r = Register_r[RX];
		busY_r = Register_r[RY];
		if(WEN) begin
			Register_w[0] = 0;
			Register_w[1] = Register_r[1];
			Register_w[2] = Register_r[2];
			Register_w[3] = Register_r[3];
			Register_w[4] = Register_r[4];
			Register_w[5] = Register_r[5];
			Register_w[6] = Register_r[6];
			Register_w[7] = Register_r[7];
			Register_w[8] = Register_r[8];
			Register_w[9] = Register_r[9];
			Register_w[10] = Register_r[10];
			Register_w[11] = Register_r[11];
			Register_w[12] = Register_r[12];
			Register_w[13] = Register_r[13];
			Register_w[14] = Register_r[14];
			Register_w[15] = Register_r[15];
			Register_w[16] = Register_r[16];
			Register_w[17] = Register_r[17];
			Register_w[18] = Register_r[18];
			Register_w[19] = Register_r[19];
			Register_w[20] = Register_r[20];
			Register_w[21] = Register_r[21];
			Register_w[22] = Register_r[22];
			Register_w[23] = Register_r[23];
			Register_w[24] = Register_r[24];
			Register_w[25] = Register_r[25];
			Register_w[26] = Register_r[26];
			Register_w[27] = Register_r[27];
			Register_w[28] = Register_r[28];
			Register_w[29] = Register_r[29];
			Register_w[30] = Register_r[30];
			Register_w[31] = Register_r[31];
			case(RW)
				0: begin Register_w[0] = 0; end
				1: begin Register_w[1] =   busW; end
				2: begin Register_w[2] =   busW; end
				3: begin Register_w[3] =   busW; end
				4: begin Register_w[4] =   busW; end
				5: begin Register_w[5] =   busW; end
				6: begin Register_w[6] =   busW; end
				7: begin Register_w[7] =   busW; end
				8: begin Register_w[8] =   busW; end
				9: begin Register_w[9] =   busW; end
				10: begin Register_w[10] = busW; end
				11: begin Register_w[11] = busW; end
				12: begin Register_w[12] = busW; end
				13: begin Register_w[13] = busW; end
				14: begin Register_w[14] = busW; end
				15: begin Register_w[15] = busW; end
				16: begin Register_w[16] = busW; end
				17: begin Register_w[17] = busW; end
				18: begin Register_w[18] = busW; end
				19: begin Register_w[19] = busW; end
				20: begin Register_w[20] = busW; end
				21: begin Register_w[21] = busW; end
				22: begin Register_w[22] = busW; end
				23: begin Register_w[23] = busW; end
				24: begin Register_w[24] = busW; end
				25: begin Register_w[25] = busW; end
				26: begin Register_w[26] = busW; end
				27: begin Register_w[27] = busW; end
				28: begin Register_w[28] = busW; end
				29: begin Register_w[29] = busW; end
				30: begin Register_w[30] = busW; end
				31: begin Register_w[31] = busW; end
			endcase
		end else begin
			Register_w[0] = 0;
			Register_w[1] = Register_r[1];
			Register_w[2] = Register_r[2];
			Register_w[3] = Register_r[3];
			Register_w[4] = Register_r[4];
			Register_w[5] = Register_r[5];
			Register_w[6] = Register_r[6];
			Register_w[7] = Register_r[7];
			Register_w[8] = Register_r[8];
			Register_w[9] = Register_r[9];
			Register_w[10] = Register_r[10];
			Register_w[11] = Register_r[11];
			Register_w[12] = Register_r[12];
			Register_w[13] = Register_r[13];
			Register_w[14] = Register_r[14];
			Register_w[15] = Register_r[15];
			Register_w[16] = Register_r[16];
			Register_w[17] = Register_r[17];
			Register_w[18] = Register_r[18];
			Register_w[19] = Register_r[19];
			Register_w[20] = Register_r[20];
			Register_w[21] = Register_r[21];
			Register_w[22] = Register_r[22];
			Register_w[23] = Register_r[23];
			Register_w[24] = Register_r[24];
			Register_w[25] = Register_r[25];
			Register_w[26] = Register_r[26];
			Register_w[27] = Register_r[27];
			Register_w[28] = Register_r[28];
			Register_w[29] = Register_r[29];
			Register_w[30] = Register_r[30];
			Register_w[31] = Register_r[31];
		end
	
	end

	// sequential
	always@ (posedge Clk or negedge rst_n) begin
		if(~rst_n) begin
			Register_r[0]  <= 0;
			Register_r[1]  <= 0;
			Register_r[2]  <= 0;
			Register_r[3]  <= 0;
			Register_r[4]  <= 0;
			Register_r[5]  <= 0;
			Register_r[6]  <= 0;
			Register_r[7]  <= 0;
			Register_r[8]  <= 0;
			Register_r[9]  <= 0;
			Register_r[10] <= 0;
			Register_r[11] <= 0;
			Register_r[12] <= 0;
			Register_r[13] <= 0;
			Register_r[14] <= 0;
			Register_r[15] <= 0;
			Register_r[16] <= 0;
			Register_r[17] <= 0;
			Register_r[18] <= 0;
			Register_r[19] <= 0;
			Register_r[20] <= 0;
			Register_r[21] <= 0;
			Register_r[22] <= 0;
			Register_r[23] <= 0;
			Register_r[24] <= 0;
			Register_r[25] <= 0;
			Register_r[26] <= 0;
			Register_r[27] <= 0;
			Register_r[28] <= 0;
			Register_r[29] <= 0;
			Register_r[30] <= 0;
			Register_r[31] <= 0;
		end else begin
			Register_r[0]  <= 0;
			Register_r[1]  <= Register_w[1];
			Register_r[2]  <= Register_w[2];
			Register_r[3]  <= Register_w[3];
			Register_r[4]  <= Register_w[4];
			Register_r[5]  <= Register_w[5];
			Register_r[6]  <= Register_w[6];
			Register_r[7]  <= Register_w[7];
			Register_r[8]  <= Register_w[8];
			Register_r[9]  <= Register_w[9];
			Register_r[10] <= Register_w[10];
			Register_r[11] <= Register_w[11];
			Register_r[12] <= Register_w[12];
			Register_r[13] <= Register_w[13];
			Register_r[14] <= Register_w[14];
			Register_r[15] <= Register_w[15];
			Register_r[16] <= Register_w[16];
			Register_r[17] <= Register_w[17];
			Register_r[18] <= Register_w[18];
			Register_r[19] <= Register_w[19];
			Register_r[20] <= Register_w[20];
			Register_r[21] <= Register_w[21];
			Register_r[22] <= Register_w[22];
			Register_r[23] <= Register_w[23];
			Register_r[24] <= Register_w[24];
			Register_r[25] <= Register_w[25];
			Register_r[26] <= Register_w[26];
			Register_r[27] <= Register_w[27];
			Register_r[28] <= Register_w[28];
			Register_r[29] <= Register_w[29];
			Register_r[30] <= Register_w[30];
			Register_r[31] <= Register_w[31];
		end
	end
	
/////////////////////////////////////////////////////////////////////////////////
endmodule