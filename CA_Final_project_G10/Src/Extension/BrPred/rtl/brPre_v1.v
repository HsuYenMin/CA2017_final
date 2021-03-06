module PredictionUnit(
	BrPre,
	clk,
	rst_n,
	stall,
	PreWrong,
	PreRight
);
	
	output BrPre;
	input clk, rst_n;
	input stall;
	input PreWrong;
	input PreRight;
	
	// reg, wire
	parameter Taken1 = 2'b10; 
	parameter Taken2 = 2'b11; 
	parameter NonTaken1 = 2'b00; 
	parameter NonTaken2 = 2'b01; 
	
	reg [1:0] state_r, state_w;
	reg last_PreRight_r, last_preWrong_r, last_stall_r;
	wire Change;
	
	assign Change = ((last_PreRight_r^PreRight) || (last_preWrong_r^PreWrong) || (last_stall_r^stall)) ? 1'b1 : 1'b0 ;
	
	assign BrPre = state_r[1];
//	assign BrPre = 0;
	
	// combinational
	always@(*) begin
		//if(stall) state_w = state_r;
		if(Change && ~stall && (PreRight|PreWrong)) begin
			case(state_r)
				Taken1: begin
					if(PreRight) state_w = Taken2;
					else state_w = NonTaken1;
				end
				Taken2: begin
					if(PreRight) state_w = Taken2;
					else state_w = Taken1;
				end
				NonTaken1: begin
					if(PreRight) state_w = NonTaken2;
					else state_w = Taken1;
				end
				NonTaken2: begin
					if(PreRight) state_w = NonTaken2;
					else state_w = NonTaken1;
				end
			endcase
		end else state_w = state_r;
	end
	
	// sequential
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state_r <= 0;
			last_PreRight_r <= 0;
			last_preWrong_r <= 0;
			last_stall_r <= 0;
		end else begin
			state_r <= state_w;
			last_PreRight_r <= PreRight;
			last_preWrong_r <= PreWrong;
			last_stall_r <= stall;
		end
	end



endmodule
