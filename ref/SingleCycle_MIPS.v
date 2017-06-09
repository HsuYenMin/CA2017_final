// Single Cycle MIPS
//=========================================================
// Input/Output Signals:
// positive-edge triggered         clk
// active low asynchronous reset   rst_n
// instruction memory interface    IR_addr, IR
// output for testing purposes     RF_writedata  
//=========================================================
// Wire/Reg Specifications:
// control signals             MemToReg, MemRead, MemWrite, 
//                             RegDST, RegWrite, Branch, 
//                             Jump, ALUSrc, ALUOp
// ALU control signals         ALUctrl
// ALU input signals           ALUin1, ALUin2
// ALU output signals          ALUresult, ALUzero
// instruction specifications  r, j, jal, jr, lw, sw, beq
// sign-extended signal        SignExtend
// MUX output signals          MUX_RegDST, MUX_MemToReg, 
//                             MUX_Src, MUX_Branch, MUX_Jump
// registers input signals     Reg_R1, Reg_R2, Reg_W, WriteData 
// registers                   Register
// registers output signals    ReadData1, ReadData2
// data memory contral signals CEN, OEN, WEN
// data memory output signals  ReadDataMem
// program counter/address     PCin, PCnext, JumpAddr, BranchAddr
//=========================================================

`include "Registers.v"
`include "ALU.v"
`include "ALUControl.v"
`include "ControlUnit.v"

module SingleCycle_MIPS( 
    clk,
    rst_n,
    IR_addr,
    IR,
    RF_writedata,
    ReadDataMem,
    CEN,
    WEN,
    A,
    ReadData2,
    OEN
);

//==== in/out declaration =================================
    //-------- processor ----------------------------------
    input         clk, rst_n;
    input  [31:0] IR;
    output [31:0] IR_addr, RF_writedata;
    //-------- data memory --------------------------------
    input  [31:0] ReadDataMem;  // read_data from memory
    output        CEN;  // chip_enable, 0 when you read/write data from/to memory
    output        WEN;  // write_enable, 0 when you write data into SRAM & 1 when you read data from SRAM
    output  [6:0] A;  // address
    output [31:0] ReadData2;  // write_data to memory
    output        OEN;  // output_enable, 0

//==== reg/wire declaration ===============================
	reg [31:0] PC, PC_4, JumpAddr, BranchAddr, PCnext;
	reg [31:0]	Instruction;
	reg [4:0]	Reg_R1, Reg_R2, Reg_W;
	reg [31:0] ALUin1, ALUin2, WriteData;
	reg [31:0] SignExtend, MUX_Branch, MUX_Jump;
	
	wire 		MemToReg, MemRead, MemWrite, RegDST, RegWrite, Branch, Jump, Jal, Jr, ALUSrc;
	wire [1:0]	ALUOp;
	wire [31:0] ReadData1_w, ReadData2_w;
	wire [31:0] ALUresult, ReadDataMem_w;
	wire [3:0] 	ALUctrl;
	wire 		ALUzero;

	
//==== submodules =========================================
Control ctrl1( .Op(Instruction[31:26]), .RegDst(RegDST), .Jump(Jump), .Jal(Jal), .ALUsrc(ALUSrc), .MemtoReg(MemToReg),
         .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .ALUOp(ALUOp));

register_file Regfile1(.Clk(clk), .WEN(RegWrite), .RW(Reg_W), .busW(WriteData), .RX(Reg_R1),
                       .RY(Reg_R2), .busX(ReadData1_w), .busY(ReadData2_w), .Reset(rst_n));
					   
ALUControler aluctrl1( .ALUOp(ALUOp), .FuncField(Instruction[5:0]), .ALUctrl(ALUctrl), .jr(Jr));

ALU alu1(.ctrl(ALUctrl), .x(ALUin1), .y(ALUin2), .Zero(ALUzero), .out(ALUresult));
	
	
	
//==== combinational part =================================
	assign IR_addr = PC; //
	assign RF_writedata = WriteData; //
	assign ReadDataMem_w = ReadDataMem;
	assign ReadData2 = ReadData2_w;
	assign CEN = (MemRead | MemWrite) ? 0 : 1; //
	assign WEN = (MemRead & ~MemWrite) ? 1 : 0; //
	assign OEN = 0; //
	assign A = ALUresult[8:2]; //
	//assign  //
	
/*
	assign Instruction = IR;
	assign PC_4 = PC + 4;
	assign JumpAddr = {PC_4[31:28],Instruction[25:0],2'b00};
	assign Reg_R1 = Instruction[25:21];
	assign Reg_R2 = Instruction[20:16];
	assign Reg_W = (RegDST) ? Instruction[15:11] : Instruction[20:16];
	assign ALUin1 = ReadData1;
	assign SignExtend = {16{Instruction[15]}, Instruction[15:0]};
	assign ALUin2 = (ALUSrc) ? SignExtend : ReadData2;
	assign BranchAddr = PC_4 + (SignExtend << 2);
	assign MUX_Branch = (Branch & ALUzero) ? BranchAddr : PC_4;
	assign MUX_Jump = (Jump) ? JumpAddr : MUX_Branch;
	assign PCnext = MUX_Jump;
	assign WriteData = (MemToReg) ? ReadDataMem : ALUresult;
*/
	
	always@(*) begin

		Instruction = IR;
		PC_4 = PC + 4;
		JumpAddr = {PC_4[31:28],Instruction[25:0],2'b00};
		Reg_R1 = Instruction[25:21];
		Reg_R2 = Instruction[20:16];
		if(Jal) Reg_W = 31;
		else Reg_W = (RegDST) ? Instruction[15:11] : Instruction[20:16];
		ALUin1 = ReadData1_w;
		SignExtend = {{16{Instruction[15]}}, Instruction[15:0]};
		ALUin2 = (ALUSrc) ? SignExtend : ReadData2_w;
		BranchAddr = PC_4 + (SignExtend << 2);
		MUX_Branch = (Branch & ALUzero) ? BranchAddr : PC_4;
		MUX_Jump = (Jump) ? JumpAddr : MUX_Branch;
		PCnext = (Jr) ? ALUresult : MUX_Jump;
		if(Jal) WriteData = PC_4;
		else WriteData = (MemToReg) ? ReadDataMem : ALUresult;
	end
	
	

//==== sequential part ====================================
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) PC <= 0;
		else PC <= PCnext;
	end

//=========================================================
endmodule
