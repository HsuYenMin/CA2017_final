module HazardDetectionUnit(
	IdExMemRead,
	IdExRegRt,
	IfIdRegRt,
	IfIdRegRs,
	
	Branch,
	Jr,
	Jal_Ex, Jal_Mem, Jal_Wb,
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

input Branch, Jr, Jal_Ex, Jal_Mem, Jal_Wb;
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
	end else if(Branch) begin	// branch hazard
		if( ExRegWrite && ((ExRegWriteAddr == IfIdRegRs) || (ExRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else if( MemRegWrite && ((MemRegWriteAddr == IfIdRegRs) || (MemRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else if( WbRegWrite && ((WbRegWriteAddr == IfIdRegRs) || (WbRegWriteAddr == IfIdRegRt)))begin
			Stall_out = 1;
		end else begin
			Stall_out = 0;
		end
	end else if(Jr) begin
		if( ExRegWrite && ((ExRegWriteAddr == IfIdRegRs)))begin
			Stall_out = 1;
		end else if( MemRegWrite && ((MemRegWriteAddr == IfIdRegRs)))begin
			Stall_out = 1;
		end else if( WbRegWrite && ((WbRegWriteAddr == IfIdRegRs)))begin
			Stall_out = 1;
		end else begin
			Stall_out = 0;
		end
	end else begin
		if( Jal_Ex)begin
			Stall_out = 1;
		end else if( Jal_Mem)begin
			Stall_out = 1;
		end else if( Jal_Wb)begin
			Stall_out = 1;
		end else begin
			Stall_out = 0;
		end
	end

end

endmodule
