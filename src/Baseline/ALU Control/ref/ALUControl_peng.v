module ALUControler(
    ALUOp,
    FuncField,
    ALUctrl,
	jr
);
	
	input  [1:0] ALUOp;
	input  [5:0] FuncField;
	output [3:0] ALUctrl;
	output		 jr;

///////////////////////////////////////////////////////////////////////////////////////////

	reg [3:0] Out;
	wire [7:0] In;
	assign In = {ALUOp,FuncField};
	assign ALUctrl = Out;
	assign jr = (In == 8'b10001000)? 1 : 0;

	always@ (*) begin
		if(In[7:6] == 2'b00 || In == 8'b10100000) Out = 4'b0010;	// add
		else if(In[7:6] == 2'b01 || In == 8'b10100010) Out = 4'b0110;	// sub
		else if(In == 8'b10100100) Out = 4'b0000;	// and
		else if(In == 8'b10100101) Out = 4'b0001;	// or
		else if(In == 8'b10101010) Out = 4'b0111;	// slt; set on less than
		else if(In == 8'b10001000) Out = 4'b0001;// jr use or
		else Out = 4'b0000;
	end

///////////////////////////////////////////////////////////////////////////////////////////   

endmodule



