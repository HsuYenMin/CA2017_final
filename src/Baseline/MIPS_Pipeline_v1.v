//`include "./ALU/ALU.v"
//`include "./ALUControl/ALUControl.v"
//`include "./ControlUnit/ControlUnit.v"
//`include "./ForwardUnit/ForwardUnit.v"
//`include "./HazardDetectionUnit/HazardDetectionUnit.v"
//`include "./Register/Registers.v"
`include "./ALU.v"
`include "./ALUControl.v"
`include "./ControlUnit.v"
`include "./ForwardUnit.v"
`include "./HazardDetectionUnit.v"
`include "./Registers.v"

module MIPS_Pipeline(
// control interface
	clk, 
	rst_n,
//----------I cache interface-------		
	ICACHE_ren,
	ICACHE_wen,
	ICACHE_addr,
	ICACHE_wdata,
	ICACHE_stall,
	ICACHE_rdata,
//----------D cache interface-------
	DCACHE_ren,
	DCACHE_wen,
	DCACHE_addr,
	DCACHE_wdata,
	DCACHE_stall,
	DCACHE_rdata,
);
input  		clk;
input  		rst_n;
       
output 			ICACHE_ren;
output 			ICACHE_wen;
output [29:0] 	ICACHE_addr;
output [31:0] 	ICACHE_wdata;
input  			ICACHE_stall;
input  [31:0]	ICACHE_rdata;
       
output 			DCACHE_ren;
output 			DCACHE_wen;
output [29:0] 	DCACHE_addr;
output [31:0] 	DCACHE_wdata;
input  			DCACHE_stall;
input  [31:0]	DCACHE_rdata;
//-------------------------------------------------------------------------	

//-- Register Declaire -----------------------------
//-- IF stage --------------------------
reg [31:0] PC4_If;
reg [63:0] IfId_n, IfId;
reg IfIdflush;
//--	 ID Stage --------------------------
reg [31:0] PC4_Id, BranchAddr_Id;
reg [31:0] Instruction_Id;
wire        Jump_Id, Jr_Id, Stall;
wire [7:0]  ctrl_Id;
reg [4:0]  WriteReg;
wire [31:0] ReadData1, ReadData2;
reg [31:0] Writedata, SignExtend_Id;
wire [3:0]  ALUctrl_Id;
reg [149:0] IdEx_n, IdEx;
//--	 Ex Stage --------------------------
reg [31:0] PC4_Ex;
reg        RegDst_Ex, ALUSrc_Ex;
wire [1:0]  ForwardA_Ex, ForwardB_Ex;
reg [5:0]  ctrl_Ex;
reg [31:0] ReadData1_Ex, ReadData2_Ex, A_Ex, MemData_Ex, B_Ex, SignExtend_Ex;
wire [31:0] Writedata_Ex;
reg [3:0]  ALUctrl_Ex;
reg [4:0]  Rs_Ex, Rt_Ex, Rd_Ex, WriteReg_Ex;
reg [106:0] ExMem_n, ExMem;
//--	 Mem Stage --------------------------
reg [31:0] PC4_Mem;
reg        MemRead_Mem, MemWrite_Mem, Branch_Mem;
reg [2:0]  ctrl_Mem;
reg [31:0] ALUOut_Mem, MemWriteData_Mem, MemReadData_Mem;
reg [4:0]  WriteReg_Mem;
reg [103:0] MemWb_n, MemWb;
//--	 Wb Stage --------------------------
reg [31:0] PC4_Wb;
reg        MemtoReg_Wb, RegWrite_Wb, Jal_Wb;
reg [31:0] Writedata_Wb, MemReadData_Wb, ALUOut_Wb;
reg [4:0]  WriteReg_Wb;
reg [31:0] PC_n, PC, PCnext, MUX_Branch, MUX_Jump;



//-- IN/OUT Assignment -----------------------------
assign ICACHE_addr = PC[31:2];
assign {ICACHE_ren, ICACHE_wen} = 2'b10;
assign ICACHE_wdata = 0;
assign DCACHE_ren = MemRead_Mem;
assign DCACHE_wen = MemWrite_Mem;
assign DCACHE_addr = ALUOut_Mem[31:2];
assign DCACHE_wdata = MemWriteData_Mem;

//-- SubModules ------------------------------------
HazardDetectionUnit Hazard1(.IdExMemRead(ctrl_Ex[5]), .IdExRegRt(Rt_Ex), .IfIdRegRt(Instruction_Id[20:16]),
                            .IfIdRegRs(Instruction_Id[25:21]), .Branch(ctrl_Id[3]), .Jr(Jr_Id), 
							.Jal_Ex(ctrl_Ex[0]), .Jal_Mem(ctrl_Mem[0]), .Jal_Wb(Jal_Wb),
							.ExRegWrite(ctrl_Ex[1]),
                            .ExRegWriteAddr(WriteReg_Ex), .MemRegWrite(ctrl_Mem[1]), .MemRegWriteAddr(WriteReg_Mem),
                            .WbRegWrite(RegWrite_Wb), .WbRegWriteAddr(WriteReg_Wb), .Stall(Stall)
                            );

Control Ctrl1(.Op(Instruction_Id[31:26]), .FuncField(Instruction_Id[5:0]), .Jump(Jump_Id), .Jr(Jr_Id),
              .RegDst(ctrl_Id[7]), .ALUsrc(ctrl_Id[6]), .MemRead(ctrl_Id[5]), .MemWrite(ctrl_Id[4]),
              .Branch(ctrl_Id[3]), .MemtoReg(ctrl_Id[2]), .RegWrite(ctrl_Id[1]), .Jal(ctrl_Id[0])
              );

register_file Reg1(.Clk(clk), .rst_n(rst_n), .WEN(RegWrite_Wb), .RW(WriteReg), .busW(Writedata),
                   .RX(Instruction_Id[25:21]), .RY(Instruction_Id[20:16]), .busX(ReadData1), .busY(ReadData2)
                   );

ALUControler AluCtrl1(.Op(Instruction_Id[31:26]), .FuncField(Instruction_Id[5:0]), .ALUctrl(ALUctrl_Id));

ALU Alu1(.ctrl(ALUctrl_Ex), .x(A_Ex), .y(B_Ex), .sa(SignExtend_Ex[10:6]), .out(Writedata_Ex));

ForwardUnit Forward1(.IdExRs(Rs_Ex), .IdExRt(Rt_Ex), .ExMemRegW(ctrl_Mem[1]), .ExMemRd(WriteReg_Mem),
                     .MemWbRegW(RegWrite_Wb), .MemWbRd(WriteReg_Wb), .ForwardA(ForwardA_Ex), .ForwardB(ForwardB_Ex)
                     );

//-- Comb/Seq ---------------------------------------
//-- IF stage --------------------------

always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		PC <= 0;
	end else begin
		PC <= PC_n;
	end
end

always@(*) begin
	PC4_If = PC + 4;
	IfId_n = (Stall || ICACHE_stall || DCACHE_stall) ? IfId : 
	         (IfIdflush) ? {PC4_If,32'd0} : {PC4_If,ICACHE_rdata};
end

always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		IfId <= 0;
	end else begin
		IfId <= IfId_n;
	end
end

//--	 ID Stage --------------------------

always@(*) begin
	PC4_Id = IfId[63:32];
	Instruction_Id = IfId[31:0];
	WriteReg = (Jal_Wb) ? 31 : WriteReg_Wb ;
	Writedata = (Jal_Wb) ? PC4_Wb : Writedata_Wb ;
	SignExtend_Id = {{16{Instruction_Id[15]}}, Instruction_Id[15:0]};
	BranchAddr_Id = PC4_Id + (SignExtend_Id << 2);
	IfIdflush = ((ctrl_Id[3] && (ReadData1 == ReadData2) && ~Stall) || Jump_Id) ? 1 : 0;
	IdEx_n = (Stall||ICACHE_stall) ? {PC4_Id, 8'b00000000, ReadData1, ReadData2, ALUctrl_Id, SignExtend_Id, Instruction_Id[25:16]} :
             (DCACHE_stall) ? IdEx :
			 {PC4_Id, ctrl_Id, ReadData1, ReadData2, ALUctrl_Id, SignExtend_Id, Instruction_Id[25:16]};
end

always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		IdEx <= 0;
	end else begin
		IdEx <= IdEx_n;
	end
end

//--	 Ex Stage --------------------------

always@(*) begin
	{PC4_Ex, RegDst_Ex, ALUSrc_Ex, ctrl_Ex} = IdEx[149:110];
	{ReadData1_Ex, ReadData2_Ex} = IdEx[109:46];
	{ALUctrl_Ex, SignExtend_Ex, Rs_Ex, Rt_Ex} = IdEx[45:0];
	Rd_Ex = SignExtend_Ex[15:11];
	if(ForwardA_Ex == 2'b10) A_Ex = ALUOut_Mem;
	else if(ForwardA_Ex == 2'b01) A_Ex = Writedata_Wb;
	else A_Ex = ReadData1_Ex;
	
	if(ForwardB_Ex == 2'b10) MemData_Ex = ALUOut_Mem;
	else if(ForwardB_Ex == 2'b01) MemData_Ex = Writedata_Wb;
	else MemData_Ex = ReadData2_Ex;
	B_Ex = (ALUSrc_Ex) ? SignExtend_Ex : MemData_Ex;

	WriteReg_Ex = (RegDst_Ex) ? Rd_Ex : Rt_Ex;
	
	ExMem_n = (DCACHE_stall) ? ExMem : {PC4_Ex, ctrl_Ex, Writedata_Ex, MemData_Ex, WriteReg_Ex};
end

always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		ExMem <= 0;
	end else begin
		ExMem <= ExMem_n;
	end
end

//--	 Mem Stage --------------------------

always@(*) begin
	{PC4_Mem, MemRead_Mem, MemWrite_Mem, Branch_Mem, ctrl_Mem, ALUOut_Mem, MemWriteData_Mem, WriteReg_Mem} = ExMem;
	MemReadData_Mem = DCACHE_rdata;
	MemWb_n = (DCACHE_stall) ? MemWb : {PC4_Mem, ctrl_Mem, MemReadData_Mem, ALUOut_Mem, WriteReg_Mem};
end

always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		MemWb <= 0;
	end else begin
		MemWb <= MemWb_n;
	end
end

//--	 Wb Stage --------------------------

always@(*) begin
	{PC4_Wb, MemtoReg_Wb, RegWrite_Wb, Jal_Wb, MemReadData_Wb, ALUOut_Wb, WriteReg_Wb} = MemWb;
	Writedata_Wb = (MemtoReg_Wb) ? MemReadData_Wb : ALUOut_Wb;
	
	MUX_Branch = (ctrl_Id[3] && (ReadData1 == ReadData2) && ~Stall) ? BranchAddr_Id : PC4_If;
	MUX_Jump = (Jump_Id) ? {PC4_If[31:28],Instruction_Id[25:0],2'b00} : MUX_Branch;
	PCnext = (Jr_Id) ? ReadData1 : MUX_Jump;	
	PC_n = (Stall || ICACHE_stall || DCACHE_stall) ? PC : PCnext;
end

//--------------------------------------------------------------------------
endmodule







