`timescale 1 ns/10 ps
`define	TestPort	30'h40      // r30
`define	BeginSymbol	32'h00000932
`define	EndSymbol	32'h00000D5D
`define	CheckNum	6'd10       // modify1 for number*2+1(CheckNum)

module	TestBed(
	clk,
	rst,
	addr,
	data,
	wen,
	error_num,
	duration,
	finish
);
	input			clk, rst;
	input	[29:0]	addr;
	input	[31:0]	data;
	input			wen;

	output	[7:0]	error_num;
	output	[15:0]	duration;
	output			finish;
	reg		[7:0]	error_num;
	reg		[15:0]	duration;
	reg				finish;
	
	reg		[31:0]	answer;

	reg		[1:0]	curstate;
	reg		[1:0]	nxtstate;
	reg		[5:0]	curaddr;
	reg		[5:0]	nxtaddr;
	reg		[7:0]	nxt_error_num;
	reg		[15:0]	nxtduration;
	reg		[100:0] total_cycles;
	reg				state,state_next;
		
	parameter	state_idle 	= 2'b00;
	parameter	state_check = 2'b01;
	parameter	state_report= 2'b10;	
		
	always@( posedge clk or negedge rst )						// State-DFF
	begin
		if( ~rst )
		begin
			curstate <= state_idle;
		total_cycles<=0;
			curaddr  <= 0;
			duration <= 0;
			error_num <= 8'd255;
			
			state <= 0;
		end
		else
		begin
			curstate <= nxtstate;
total_cycles<=total_cycles+1;
			curaddr  <= nxtaddr;
			duration <= nxtduration;
			error_num <= nxt_error_num;
			
			state <= state_next;
		end
	end
			
	always@( curstate or curaddr or addr or data or wen or duration or error_num  )	// FSM for test
	begin
		finish = 1'b0;
		case( curstate )
		state_idle: 	begin
							nxtaddr = 0;
							nxtduration = 0;
							nxt_error_num = 255;	
							if( addr==`TestPort && data==`BeginSymbol && wen )
							begin
								nxt_error_num = 0;
								nxtstate = state_check;
$display("total cycles = %d",total_cycles);
							end	 	
							else nxtstate = state_idle;
						end
		state_check:	begin
							nxtduration = duration + 1;
							nxtaddr = curaddr;						
							nxt_error_num = error_num;	
//$display("addr=%d,curaddr=%d,data=%d,answer=%d",addr,curaddr,data,answer);
							if( addr==`TestPort && wen && state==0 )
							begin
								nxtaddr = curaddr + 1;
								if( data != answer )
									nxt_error_num = error_num + 8'd1;
							end
							nxtstate = curstate;
							if( curaddr==`CheckNum )	
								nxtstate = state_report;
						end
		state_report:	begin
							finish = 1'b1;
							nxtaddr = curaddr;
							nxtstate = curstate;		
							nxtduration = duration;
							nxt_error_num = error_num;	
						end				
		endcase	
	end

	always@( negedge clk )						
	begin
		if(curstate == state_report) begin
			$display("--------------------------- Simulation FINISH !!---------------------------");
			if (error_num) begin 
				$display("============================================================================");
				$display("\n (T_T) FAIL!! The simulation result is FAIL!!! there were %d errors at all.\n", error_num);
				$display("============================================================================");
			end
			 else begin 
				$display("============================================================================");
				$display("\n \\(^o^)/ CONGRATULATIONS!!  The simulation result is PASS!!!\n");
				$display("============================================================================");
			end
		end
	end
	
	always@(*)begin//sub-FSM (avoid the Dcache stall condition)
		case(state)
			1'b0:begin
				if(wen)
					state_next=1;
				else
					state_next=state;				
			end
			1'b1:begin
				if(!wen)
					state_next=0;
				else
					state_next=state;	
			end
		endcase
	end
	
	
	always@( curstate  or curaddr)	// ROM for correct result
	begin
		answer = 0;
		case( curaddr )
		// modify2 for 0-xxx, xxx-0, `EndSymbol
		6'd0 :	answer = 32'd1;
		6'd1 :	answer = 32'd2;
		6'd2 :	answer = 32'd3;
		6'd3 :	answer = 32'd4;
		6'd4 :	answer = 32'd5;
		6'd5 :	answer = 32'd6;
		6'd6 :	answer = 32'd7;
		6'd7 :	answer = 32'd8;
		6'd8 :	answer = 32'd9;
		6'd9 :	answer = 32'd10;
		6'd10:	answer = 32'd11;
		6'd11:	answer = 32'd12;
		6'd12:	answer = 32'd13;
		6'd13:	answer = 32'd14;
		6'd14:	answer = 32'd15;
		6'd15:	answer = 32'd16;
		6'd16:	answer = 32'd17;
		6'd17:	answer = 32'd18;
		6'd18:	answer = 32'd19;
		6'd19:	answer = 32'd20;
		6'd20:	answer = 32'd21;
		6'd21:	answer = 32'd22;
		6'd22:	answer = 32'd23;
		6'd23:	answer = 32'd24;
		6'd24:	answer = 32'd25;
		6'd25:	answer = 32'd26;
		6'd26:	answer = 32'd27;
		6'd27:	answer = 32'd28;
		6'd28:	answer = 32'd29;
		6'd29:	answer = 32'd30;
		6'd30:	answer = 32'd31;
		6'd31:	answer = 32'd32;
		6'd32:	answer = 32'd33;
		6'd33:	answer = 32'd34;
		6'd34:	answer = 32'd35;
		6'd35:	answer = 32'd36;
		6'd36:	answer = 32'd37;
		6'd37:	answer = 32'd38;
		6'd38:	answer = 32'd39;
		6'd39:	answer = 32'd40;
		6'd40:	answer = 32'd41;
		6'd41:	answer = 32'd42;
		6'd42:	answer = 32'd43;
		6'd43:	answer = 32'd44;
		6'd44:	answer = 32'd45;
		6'd45:	answer = 32'd46;
		6'd46:	answer = 32'd47;
		6'd47:	answer = 32'd48;
		6'd48:	answer = 32'd49;
		6'd49:	answer = 32'd50;
		6'd50:	answer = `EndSymbol;
		endcase			
	end

endmodule

