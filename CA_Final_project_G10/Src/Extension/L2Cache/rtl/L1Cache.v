module L1Cache(
    clk,
    proc_reset,
    proc_read,
    proc_write,
    proc_addr,
    proc_wdata,
    proc_stall,
    proc_rdata,
    mem_read,
    mem_write,
    mem_addr,
    mem_rdata,
    mem_wdata,
    mem_ready
);
    
//==== input/output definition ============================
    input          clk;
    // processor interface
    input          proc_reset;
    input          proc_read, proc_write;
    input   [29:0] proc_addr;
    input   [31:0] proc_wdata;
    output         proc_stall;
    output  [31:0] proc_rdata;
    // memory interface
    input  [127:0] mem_rdata;
    input          mem_ready;
    output         mem_read, mem_write;
    output  [27:0] mem_addr;
    output [127:0] mem_wdata;
    
//==== wire/reg definition ================================
    parameter IDLE = 2'd0; 
    parameter WAIT = 2'd1; 
    parameter WRITEBACK = 2'd2; 
    parameter ALLOCATE = 2'd3; 
	
	integer i;
	
	// ---- signals -----------
	wire		Hit, Dirty; 
	wire [2:0]	SetNum;
	wire [1:0]	OffSet;
	
	reg			stall_out, mem_read_out, mem_write_out, mem_ready_r;
	reg [1:0]	state_r, state_w;
	
	// ---- datas -------------
	reg [31:0]	proc_data_out, proc_wdata_r;
	reg [29:0]	proc_addr_r;
	reg [127:0] mem_wdata_out, mem_wdata_r, mem_rdata_r;
	
	reg [154:0] CacheMem_r [7:0]; // [valid:154][dirty:153][Tag:152:128][4words:127:0]
	reg [154:0] CacheMem_w [7:0];
	
	
	
//==== combinational circuit ==============================
assign SetNum = proc_addr_r[4:2];
assign OffSet = proc_addr_r[1:0];

assign Hit = (CacheMem_r[SetNum][152:128] == proc_addr[29:5] && CacheMem_r[SetNum][154]) ? 1'b1 : 1'b0;
assign Dirty = (CacheMem_r[SetNum][153]) ? 1'b1 : 1'b0;
assign proc_stall = stall_out; //(state_r == WRITEBACK || state_r == ALLOCATE) ? 1'b1 : 1'b0;
assign mem_read = mem_read_out; //(state_r == ALLOCATE) ? 1'b1 : 1'b0;
assign mem_write = mem_write_out; //(state_r == WRITEBACK) ? 1'b1 : 1'b0;

assign mem_addr = (mem_write_out)? {CacheMem_r[SetNum][152:128],SetNum} : proc_addr_r[29:2];
assign mem_wdata  = mem_wdata_out;
assign proc_rdata = proc_data_out;


// signal path; Finite State Machine
always@(*) begin

	case(state_r)
		IDLE: begin
			stall_out = 1'b0;
			mem_read_out = 1'b0;
			mem_write_out = 1'b0;
			if(proc_read || proc_write) begin
				if(Hit) begin
					state_w = IDLE;
					stall_out = 1'b0;
				end else if (Dirty) begin
					state_w = WRITEBACK;
					stall_out = 1'b1;
					mem_write_out = 1'b1;
				end else begin
					state_w = ALLOCATE;
					stall_out = 1'b1;
					mem_read_out = 1'b1;
				end
			end else begin
				state_w = IDLE;
			end
		end
		WRITEBACK: begin
			stall_out = 1'b1;
			mem_read_out = 1'b0;
			mem_write_out = 1'b1;
			if(mem_ready_r) begin
				state_w = WAIT;
				mem_write_out = 1'b0;
			end else begin
				state_w = WRITEBACK;
			end
		end
		WAIT: begin
			stall_out = 1'b1;
			mem_read_out = 1'b1;
			mem_write_out = 1'b0;
            state_w = ALLOCATE;
		end
		ALLOCATE: begin
			stall_out = 1'b1;
			mem_read_out = 1'b1;
			mem_write_out = 1'b0;
			if(mem_ready_r) begin
				state_w = IDLE;
				mem_read_out = 1'b0;
			end else begin
				state_w = ALLOCATE;
			end
		end
		default: begin
			stall_out = 1'b0;
			mem_read_out = 1'b0;
			mem_write_out = 1'b0;
			state_w = IDLE;
		end
	endcase
end

// data path
always@(*) begin
	proc_addr_r = proc_addr;
	proc_wdata_r = proc_wdata;
	for(i=0;i<8;i=i+1) begin CacheMem_w[i] = CacheMem_r[i]; end
	case(OffSet)
		2'd0: begin proc_data_out = CacheMem_r[SetNum][31:0]; end
		2'd1: begin proc_data_out = CacheMem_r[SetNum][63:32]; end
		2'd2: begin proc_data_out = CacheMem_r[SetNum][95:64]; end
		2'd3: begin proc_data_out = CacheMem_r[SetNum][127:96]; end
	endcase
	mem_wdata_r = CacheMem_r[SetNum][127:0];
	if(Hit && proc_write) begin
		CacheMem_w[SetNum][153] = 1'b1;
		case(OffSet)
			2'd0: begin CacheMem_w[SetNum][31:0]   = proc_wdata_r ; end
			2'd1: begin CacheMem_w[SetNum][63:32]  = proc_wdata_r ; end
			2'd2: begin CacheMem_w[SetNum][95:64]  = proc_wdata_r ; end
			2'd3: begin CacheMem_w[SetNum][127:96] = proc_wdata_r ; end
		endcase
	end else if(mem_ready_r && state_r == ALLOCATE) begin
		CacheMem_w[SetNum][127:0]   = mem_rdata;				// get data from mem
		CacheMem_w[SetNum][152:128] = proc_addr_r[29:5];		// update Tag
		CacheMem_w[SetNum][154:153] = 2'b10;					// valid && ~Dirty
	end
end

//==== sequential circuit =================================

always@( posedge clk or posedge proc_reset ) begin
    if( proc_reset ) begin
		state_r <= 0;
		for(i=0;i<8;i=i+1) begin CacheMem_r[i] <= 0; end
		
		mem_ready_r <= 0;
		mem_rdata_r <= 0;
		mem_wdata_out <= 0;
    end
    else begin
		state_r <= state_w;
		for(i=0;i<8;i=i+1) begin CacheMem_r[i] <= CacheMem_w[i]; end
		
		mem_ready_r <= mem_ready;
		mem_rdata_r <= mem_rdata;
		mem_wdata_out <= mem_wdata_r;
    end
end

endmodule
