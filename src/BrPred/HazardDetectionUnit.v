module HazardDetectionUnit(
	IdExMemRead,
	IdExRegRt,
	IfIdRegRt,
	IfIdRegRs,
	IfIdRegRd,
	
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
input [4:0] IdExRegRt, IfIdRegRt, IfIdRegRs, IfIdRegRd;

input Branch, Jr, Jal_Ex, Jal_Mem, Jal_Wb;
input ExRegWrite,MemRegWrite,WbRegWrite;
input [4:0] ExRegWriteAddr,MemRegWriteAddr,WbRegWriteAddr;

output Stall;


reg Counter_r, Counter_w;
reg Stall_out;

assign Stall = Stall_out;
	
always@(*) begin	
	if( IdExMemRead && ((IdExRegRt == IfIdRegRs) || (IdExRegRt == IfIdRegRt)))begin	// data hazard
		Stall_out = 1;
	end else if(WbRegWrite && ((IfIdRegRd == IfIdRegRs) || (IfIdRegRd == IfIdRegRt))) begin
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
	end else if(Jal_Ex | Jal_Mem | Jal_Wb)begin
			Stall_out = 1;
	end else begin
			Stall_out = 0;
	end

end

endmodule
