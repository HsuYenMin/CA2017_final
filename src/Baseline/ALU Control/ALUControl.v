module ALUControler(
    Op,
    FuncField,
    ALUctrl
);
	
	input  [5:0] ALUOp;
	input  [5:0] FuncField;
	output [3:0] ALUctrl;

// TODO  //////////////////////////////////////////////////////////////////////////////////
wire ADD, SUB, AND, OR, XOR, NOR, SLL, SRL, SRA, SLT;
reg [3:0] Out;

assign ADD = ((Op == 6'b001000) || (Op == 6'b100011) || (Op == 6'b101011) || ({Op,FuncField} == 12'b000000100000)) ? 1 : 0;
assign SUB = ((Op == 6'b000100) || ({Op,FuncField} == 12'b000000100010)) ? 1 : 0;
assign AND = ((Op == 6'b001100) || ({Op,FuncField} == 12'b000000100100)) ? 1 : 0;
assign OR  = ((Op == 6'b001101) || ({Op,FuncField} == 12'b000000100101)) ? 1 : 0;
assign XOR = ((Op == 6'b001110) || ({Op,FuncField} == 12'b000000100110)) ? 1 : 0;
assign NOR = (({Op,FuncField} == 12'b000000100111)) ? 1 : 0;
assign SLL = (({Op,FuncField} == 12'b000000000000)) ? 1 : 0;
assign SRL = (({Op,FuncField} == 12'b000000000011)) ? 1 : 0;
assign SRA = (({Op,FuncField} == 12'b000000000010)) ? 1 : 0;
assign SLT = ((Op == 6'b001010) || ({Op,FuncField} == 12'b000000101010)) ? 1 : 0;

assign ALUctrl = Out;

always@(*) begin
	if(ADD)      Out = 4'b0000; 
	else if(SUB) Out = 4'b0001; 
	else if(AND) Out = 4'b0010; 
	else if(OR ) Out = 4'b0011; 
	else if(XOR) Out = 4'b0101; 
	else if(NOR) Out = 4'b0110; 
	else if(SLL) Out = 4'b0111; 
	else if(SRL) Out = 4'b1000; 
	else if(SRA) Out = 4'b1001; 
	else if(SLT) Out = 4'b1100; 
	else         Out = 4'b1111;

end


///////////////////////////////////////////////////////////////////////////////////////////   

endmodule



