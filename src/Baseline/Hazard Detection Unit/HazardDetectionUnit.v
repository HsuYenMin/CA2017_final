module HazardDetectionUnit(
	IdExMemRead,
	IdExRegRt,
	IfIdRegRt,
	IfIdRegRs,
	
	Branch,
	ExRegWrite,
	ExRegWriteAddr,
	MemRegWrite,
	MemRegWriteAddr,
	WbRegWrite,
	WbRegWriteAddr,
	
	Stall
);
input IdExMemRead;
input [4:0] IdExRegRt, IfIdRegRt, IfIdRegRs;

input Branch;
input ExRegWrite,MemRegWrite,WbRegWrite;
input [4:0] ExRegWriteAddr,MemRegWriteAddr,WbRegWriteAddr;

output Stall;


//	reg stall_r;
reg Counter_r, Counter_w;
reg Stall_out;
// branching: if branch, stall 2 clk

assign Stall = Stall_out;
	
always@(*) begin	
	if( IdExMemRead && ((IdExRegRt == IfIdRegRs) || (IdExRegRt == IfIdRegRt)))begin	// data hazard
		Stall_out = 1;
	end else if(branch) begin	// branch hazard
		if( ExRegWrite && ((ExRegWriteAddr == IfIdRegRs) || (ExRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else if( MemRegWrite && ((MemRegWriteAddr == IfIdRegRs) || (MemRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else if( WbRegWrite && ((WbRegWriteAddr == IfIdRegRs) || (WbRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else
			Stall_out = 0;
		end
	end else begin
		Stall_out = 0;
	end

end

endmodule
