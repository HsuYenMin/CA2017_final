module HazardDetectionUnit(
	IdExMemRead,
	IdExRegRt,
	IfIdRegRt,
	IfIdRegRs,
	Stall
);
input IdExMemRead;
input [4:0] IdExRegRt, IfIdRegRt, IfIdRegRs;
output Stall;

//	reg stall_r;
	
	
assign Stall = ( IdExMemRead && ((IdExRegRt == IfIdRegRs) || (IdExRegRt == IfIdRegRt))) ? 1 : 0;

endmodule
