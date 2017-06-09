module Control(
    Op,
    RegDst,
	Jump,
	Jal,
    ALUsrc,
    MemtoReg,
    RegWrite,
    MemRead,
    MemWrite,
    Branch,
    ALUOp
);
	
	input [5:0] Op;
	output RegDst;
	output Jump;
	output Jal;
	output ALUsrc;
	output MemtoReg;
	output RegWrite;
	output MemRead;
	output MemWrite;
	output Branch;
	output [1:0] ALUOp;

///////////////////////////////////////////////////////////////////////////////////////////

	reg [10:0] Out;
	assign {RegDst,Jump,Jal,ALUsrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = Out;

	always@ (*) begin
		if(Op == 6'b000000) 	 Out = 11'b10000100010;	// r-type
		else if(Op == 6'b100011) Out = 11'b00011110000;  // lw
		else if(Op == 6'b101011) Out = 11'b00010001000;	// sw
		else if(Op == 6'b000100) Out = 11'b00000000101;	// beq
		else if(Op == 6'b000010) Out = 11'b01000000000;	// j jump
		else if(Op == 6'b000011) Out = 11'b01100100000;	// jal
		else Out = 0;
	end

///////////////////////////////////////////////////////////////////////////////////////////   

endmodule
/*
//  (Op == 6'b000000)&(Op == 6'b100011)&(6'b101011)&(6'b000100)
    RegDst = 	 (Op == 6'b000000) & ~(Op == 6'b100011);
    ALUsrc = 	~(Op == 6'b000000) & ((Op == 6'b100011) |  (Op == 6'b101011))& ~(Op == 6'b000100);
    MemtoReg = 	~(Op == 6'b000000) &  (Op == 6'b100011);
    RegWrite = 	((Op == 6'b000000) |  (Op == 6'b100011))& ~(Op == 6'b101011) & ~(Op == 6'b000100);
    MemRead = 	~(Op == 6'b000000) &  (Op == 6'b100011) & ~(Op == 6'b101011) & ~(Op == 6'b000100);
    MemWrite = 	~(Op == 6'b000000) & ~(Op == 6'b100011) &  (Op == 6'b101011) & ~(Op == 6'b000100);
    Branch = 	~(Op == 6'b000000) & ~(Op == 6'b100011) & ~(Op == 6'b101011) &  (Op == 6'b000100);
    ALUOp[1] = 	 (Op == 6'b000000) & ~(Op == 6'b100011) & ~(Op == 6'b101011) & ~(Op == 6'b000100);
    ALUOp[0] = 	~(Op == 6'b000000) & ~(Op == 6'b100011) & ~(Op == 6'b101011) &  (Op == 6'b000100);
*/
///////////////////////////////////////////////////////////////////////////////////////////

