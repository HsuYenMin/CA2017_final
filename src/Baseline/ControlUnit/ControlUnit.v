module Control(
    Op,
	FuncField,
    Jump,
	Jr,
	RegDst,
    ALUsrc,
    MemRead,
    MemWrite,
    Branch,
    MemtoReg,
    RegWrite,
    Jal
);
	
	input [5:0] Op;
	input [5:0] FuncField;
	output Jump;
	output Jr;
	output RegDst;
	output ALUsrc;
	output MemRead;
	output MemWrite;
	output Branch;
	output MemtoReg;
	output RegWrite;
	output Jal;

///////////////////////////////////////////////////////////////////////////////////////////

	reg [9:0] Out;
	assign {Jump,Jr,RegDst,ALUsrc,MemRead,MemWrite,Branch,MemtoReg,RegWrite,Jal} = Out;
	wire I_type;
	assign I_Type = ((Op == 6'b001000) || (Op == 6'b001100) || (Op == 6'b001101) || (Op == 6'b001110) || (Op == 6'b001010)) ? 1 : 0;

	always@ (*) begin
		if(Op == 6'b000000) begin
			if(FuncField == 6'b001000) Out = 10'b1100000000;	// Jr
			else if(FuncField == 6'b001001)	Out = 10'b1110000011;	// Jalr ; if (PC <- rd) Jal = 0;
			else                 Out = 10'b0010000010;	// r-type
		end 
		else if( I_Type )        Out = 10'b0001000010;
		else if(Op == 6'b000100) Out = 10'b0000001000;	// beq
		else if(Op == 6'b000010) Out = 10'b1000000000;	// j jump
		else if(Op == 6'b000011) Out = 10'b1000000011;	// jal
		else if(Op == 6'b100011) Out = 10'b0001100110;	// lw
		else if(Op == 6'b101011) Out = 10'b0001010000;	// sw
		else Out = 0;
	end

///////////////////////////////////////////////////////////////////////////////////////////   

endmodule
