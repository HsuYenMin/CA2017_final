`include "./L1Cache.v"
// `include "./L2Cache/L2Cache.v"
module cache(
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
    wire   L1_read, L1_write;
    wire   [27:0]   L1_addr;
    wire   [127:0]  L1_wdata;
    wire   [127:0]  L1_rdata;
    wire   L1_ready;
//==== SubModules =========================================
    L1Cache L1cache(.clk(clk),
        .proc_reset(proc_reset),
        .proc_read(proc_read),
        .proc_write(proc_write),
        .proc_addr(proc_addr),
        .proc_wdata(proc_wdata),
        .proc_stall(proc_stall),
        .proc_rdata(proc_rdata),
        .mem_read(L1_read),
        .mem_write(L1_write),
        .mem_addr(L1_addr),
        .mem_rdata(L1_rdata),
        .mem_wdata(L1_wdata),
        .mem_ready(L1_ready));

    L2Cache L2cache(.clk(clk),
        .n_reset(proc_reset),
        .L1_read(L1_read),
        .L1_write(L1_write),
        .L1_addr(L1_addr),
        .L1_wdata(L1_wdata),
        .L1_ready(L1_ready),
        .L1_rdata(L1_rdata),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),
        .mem_wdata(mem_wdata),
        .mem_ready(mem_ready));

endmodule
