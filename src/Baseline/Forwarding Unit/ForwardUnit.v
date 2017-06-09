module ForwardUnit(
	IdExRs,
	IdExRt,
	ExMemRegW,
	ExMemRd,
	MemWbRegW,
	MemWbRd,
	ForwardA,
	ForwardB
);
input  [4:0] IdExRs;
input  [4:0] IdExRt;
input        ExMemRegW;
input  [4:0] ExMemRd;
input        MemWbRegW;
input  [4:0] MemWbRd;
output [1:0] ForwardA;
output [1:0] ForwardB;

always@(*) begin
	
	if( ExMemRegW && (ExMemRd != 0) && (ExMemRd == IdExRs)) ForwardA = 2'b10;
	else if( MemWbRegW && (MemWbRd != 0) && (MemWbRd == IdExRs)) ForwardA = 2'b10;
	else ForwardA = 2'b00;

	if( ExMemRegW && (ExMemRd != 0) && (ExMemRd == IdExRt)) ForwardB = 2'b10;
	else if( MemWbRegW && (MemWbRd != 0) && (MemWbRd == IdExRt)) ForwardB = 2'b10;
	else ForwardB = 2'b00;
end



endmodule
