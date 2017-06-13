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
	
	
	assign BrPre = state_r[1];
	// combinational
	always@(*) begin
		if(stall) state_w = state_r;
		else begin
			case(state_r)
				Taken1: begin
					state_w = state_r;
					if(PreRight) state_w = Taken2;
					if(PreWrong) state_w = NonTaken1;
				end
				Taken2: begin
					state_w = state_r;
					if(PreRight) state_w = Taken2;
					if(PreWrong) state_w = Taken1;
				end
				NonTaken1: begin
					state_w = state_r;
					if(PreRight) state_w = NonTaken2;
					if(PreWrong) state_w = Taken1;
				end
				NonTaken2: begin
					state_w = state_r;
					if(PreRight) state_w = NonTaken2;
					if(PreWrong) state_w = NonTaken1;
				end
			endcase
		end
	end
	
	// sequential
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state_r <= 0;
		end else begin
			state_r <= state_w;
		end
	end



endmodule