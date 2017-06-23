module L2Cache(
    clk,
    n_reset,
    L1_read,
    L1_write,
    L1_addr,
    L1_wdata,
    L1_ready,
    L1_rdata,
    mem_read,
    mem_write,
    mem_addr,
    mem_rdata,
    mem_wdata,
    mem_ready
);

parameter HIT    = 0;
parameter MISS_1 = 1;
parameter MISS_2 = 2;
//==== input/output definition ============================
    input          clk;
    // processor interface
    input          n_reset;
    input          L1_read, L1_write;
    input   [27:0] L1_addr;
    input  [127:0] L1_wdata;
    output         L1_ready;
    output [127:0] L1_rdata;
    // memory interface
    input  [127:0] mem_rdata;
    input          mem_ready;
    output         mem_read, mem_write;
    output  [27:0] mem_addr;
    output [127:0] mem_wdata;

//==== wire/reg definition ================================
    reg [31:0]  cache[63:0][3:0];
    reg [21:0]  tag  [63:0];
    reg         valid[63:0];
    reg         dirty[63:0];
    reg         target_valid;
    reg         target_dirty;
    reg [31:0]  target_cache[3:0];
    reg [21:0]  target_tag;
    reg [1:0]   state;
    reg [1:0]   next_state;
    reg [21:0]  next_tag;
    reg         L1_ready_r;
    reg         ready;
    reg [127:0] L1_rdata_r;
    reg [127:0] rdata;
    reg         read;
    reg         write;
    reg [27:0]  addr;
    reg [127:0] wdata;
    assign      L1_ready = L1_ready_r;
    assign      L1_rdata = L1_rdata_r;
    assign      mem_read   = read;
    assign      mem_write  = write;
    assign      mem_addr   = addr;
    assign      mem_wdata  = wdata;
//==== combinational circuit ==============================
always@(*) begin
    // target_vallid = valid[L1_addr[5:0]]
    case(L1_addr[5:0])
        0: target_valid = valid[0];
        1: target_valid = valid[1];
        2: target_valid = valid[2];
        3: target_valid = valid[3];
        4: target_valid = valid[4];
        5: target_valid = valid[5];
        6: target_valid = valid[6];
        7: target_valid = valid[7];
        8: target_valid = valid[8];
        9: target_valid = valid[9];
        10: target_valid = valid[10];
        11: target_valid = valid[11];
        12: target_valid = valid[12];
        13: target_valid = valid[13];
        14: target_valid = valid[14];
        15: target_valid = valid[15];
        16: target_valid = valid[16];
        17: target_valid = valid[17];
        18: target_valid = valid[18];
        19: target_valid = valid[19];
        20: target_valid = valid[20];
        21: target_valid = valid[21];
        22: target_valid = valid[22];
        23: target_valid = valid[23];
        24: target_valid = valid[24];
        25: target_valid = valid[25];
        26: target_valid = valid[26];
        27: target_valid = valid[27];
        28: target_valid = valid[28];
        29: target_valid = valid[29];
        30: target_valid = valid[30];
        31: target_valid = valid[31];
        32: target_valid = valid[32];
        33: target_valid = valid[33];
        34: target_valid = valid[34];
        35: target_valid = valid[35];
        36: target_valid = valid[36];
        37: target_valid = valid[37];
        38: target_valid = valid[38];
        39: target_valid = valid[39];
        40: target_valid = valid[40];
        41: target_valid = valid[41];
        42: target_valid = valid[42];
        43: target_valid = valid[43];
        44: target_valid = valid[44];
        45: target_valid = valid[45];
        46: target_valid = valid[46];
        47: target_valid = valid[47];
        48: target_valid = valid[48];
        49: target_valid = valid[49];
        50: target_valid = valid[50];
        51: target_valid = valid[51];
        52: target_valid = valid[52];
        53: target_valid = valid[53];
        54: target_valid = valid[54];
        55: target_valid = valid[55];
        56: target_valid = valid[56];
        57: target_valid = valid[57];
        58: target_valid = valid[58];
        59: target_valid = valid[59];
        60: target_valid = valid[60];
        61: target_valid = valid[61];
        62: target_valid = valid[62];
        63: target_valid = valid[63];
    endcase
    // target_dirty = dirty[L1_addr[5:0]]
    case(L1_addr[5:0])
        0: target_dirty = dirty[0];
        1: target_dirty = dirty[1];
        2: target_dirty = dirty[2];
        3: target_dirty = dirty[3];
        4: target_dirty = dirty[4];
        5: target_dirty = dirty[5];
        6: target_dirty = dirty[6];
        7: target_dirty = dirty[7];
        8: target_dirty = dirty[8];
        9: target_dirty = dirty[9];
        10: target_dirty = dirty[10];
        11: target_dirty = dirty[11];
        12: target_dirty = dirty[12];
        13: target_dirty = dirty[13];
        14: target_dirty = dirty[14];
        15: target_dirty = dirty[15];
        16: target_dirty = dirty[16];
        17: target_dirty = dirty[17];
        18: target_dirty = dirty[18];
        19: target_dirty = dirty[19];
        20: target_dirty = dirty[20];
        21: target_dirty = dirty[21];
        22: target_dirty = dirty[22];
        23: target_dirty = dirty[23];
        24: target_dirty = dirty[24];
        25: target_dirty = dirty[25];
        26: target_dirty = dirty[26];
        27: target_dirty = dirty[27];
        28: target_dirty = dirty[28];
        29: target_dirty = dirty[29];
        30: target_dirty = dirty[30];
        31: target_dirty = dirty[31];
        32: target_dirty = dirty[32];
        33: target_dirty = dirty[33];
        34: target_dirty = dirty[34];
        35: target_dirty = dirty[35];
        36: target_dirty = dirty[36];
        37: target_dirty = dirty[37];
        38: target_dirty = dirty[38];
        39: target_dirty = dirty[39];
        40: target_dirty = dirty[40];
        41: target_dirty = dirty[41];
        42: target_dirty = dirty[42];
        43: target_dirty = dirty[43];
        44: target_dirty = dirty[44];
        45: target_dirty = dirty[45];
        46: target_dirty = dirty[46];
        47: target_dirty = dirty[47];
        48: target_dirty = dirty[48];
        49: target_dirty = dirty[49];
        50: target_dirty = dirty[50];
        51: target_dirty = dirty[51];
        52: target_dirty = dirty[52];
        53: target_dirty = dirty[53];
        54: target_dirty = dirty[54];
        55: target_dirty = dirty[55];
        56: target_dirty = dirty[56];
        57: target_dirty = dirty[57];
        58: target_dirty = dirty[58];
        59: target_dirty = dirty[59];
        60: target_dirty = dirty[60];
        61: target_dirty = dirty[61];
        62: target_dirty = dirty[62];
        63: target_dirty = dirty[63];
    endcase
    // target_tag = tag[L1_addr[5:0]]
    case(L1_addr[5:0])
        0: target_tag = tag[0];
        1: target_tag = tag[1];
        2: target_tag = tag[2];
        3: target_tag = tag[3];
        4: target_tag = tag[4];
        5: target_tag = tag[5];
        6: target_tag = tag[6];
        7: target_tag = tag[7];
        8: target_tag = tag[8];
        9: target_tag = tag[9];
        10: target_tag = tag[10];
        11: target_tag = tag[11];
        12: target_tag = tag[12];
        13: target_tag = tag[13];
        14: target_tag = tag[14];
        15: target_tag = tag[15];
        16: target_tag = tag[16];
        17: target_tag = tag[17];
        18: target_tag = tag[18];
        19: target_tag = tag[19];
        20: target_tag = tag[20];
        21: target_tag = tag[21];
        22: target_tag = tag[22];
        23: target_tag = tag[23];
        24: target_tag = tag[24];
        25: target_tag = tag[25];
        26: target_tag = tag[26];
        27: target_tag = tag[27];
        28: target_tag = tag[28];
        29: target_tag = tag[29];
        30: target_tag = tag[30];
        31: target_tag = tag[31];
        32: target_tag = tag[32];
        33: target_tag = tag[33];
        34: target_tag = tag[34];
        35: target_tag = tag[35];
        36: target_tag = tag[36];
        37: target_tag = tag[37];
        38: target_tag = tag[38];
        39: target_tag = tag[39];
        40: target_tag = tag[40];
        41: target_tag = tag[41];
        42: target_tag = tag[42];
        43: target_tag = tag[43];
        44: target_tag = tag[44];
        45: target_tag = tag[45];
        46: target_tag = tag[46];
        47: target_tag = tag[47];
        48: target_tag = tag[48];
        49: target_tag = tag[49];
        50: target_tag = tag[50];
        51: target_tag = tag[51];
        52: target_tag = tag[52];
        53: target_tag = tag[53];
        54: target_tag = tag[54];
        55: target_tag = tag[55];
        56: target_tag = tag[56];
        57: target_tag = tag[57];
        58: target_tag = tag[58];
        59: target_tag = tag[59];
        60: target_tag = tag[60];
        61: target_tag = tag[61];
        62: target_tag = tag[62];
        63: target_tag = tag[63];
    endcase
    next_state = 0;
    ready      = 0;
    read       = 0;
    write      = 0;
    rdata      = 0;
    addr       = 0;
    wdata      = 0;
    next_tag   = L1_addr[27:6];
    case(state) // state machine
        HIT:// hit state
            if (L1_read ^ L1_write == 0) begin end
            else if (L1_read ^ L1_write == 1) begin
                if(L1_addr[27:6] == target_tag && target_valid) begin// hit
                    rdata = {cache[L1_addr[5:0]][3],cache[L1_addr[5:0]][2],cache[L1_addr[5:0]][1],cache[L1_addr[5:0]][0]};
                    ready = 1;
                end
                else if(L1_addr[27:6] != target_tag && target_valid && target_dirty) begin// miss (need write back)
                    next_state = 1;
                    write  = 1;
                    addr   = {target_tag, L1_addr[5:0]};
                    // mem_wdata = cache[L1_addr[4:2]]
                    wdata  = {cache[L1_addr[5:0]][3],cache[L1_addr[5:0]][2],cache[L1_addr[5:0]][1],cache[L1_addr[5:0]][0]};
                end
                else if(!target_valid || (L1_addr[27:6] != target_tag && !target_dirty))begin// miss (need read)
                    next_state = 2;
                    read   = 1;
                    addr   = L1_addr;
                end
            end
        MISS_1:// miss state (write back)
            if(mem_ready == 0)begin// wait for write back
                next_state = 1;
                write      = 1;
                addr       = {target_tag, L1_addr[5:0]};
                wdata  = {cache[L1_addr[5:0]][3],cache[L1_addr[5:0]][2],cache[L1_addr[5:0]][1],cache[L1_addr[5:0]][0]};
            end
            else if(mem_ready == 1)begin // need read
                next_state = 2;
                read       = 1;
                addr       = L1_addr;
            end
        MISS_2:// miss state (read/write)
            if(mem_ready == 0)begin//wait for read
                next_state = 2;
                read       = 1;
                addr       = L1_addr;
            end
            else if(mem_ready == 1)begin// miss (read)
                next_state = 0;
            end
        3:begin end
    endcase
end
//==== sequential circuit =================================
always@( posedge clk or posedge n_reset ) begin
    if( n_reset ) begin
        valid[0] <= 0;
        valid[1] <= 0;
        valid[2] <= 0;
        valid[3] <= 0;
        valid[4] <= 0;
        valid[5] <= 0;
        valid[6] <= 0;
        valid[7] <= 0;
        valid[8] <= 0;
        valid[9] <= 0;
        valid[10] <= 0;
        valid[11] <= 0;
        valid[12] <= 0;
        valid[13] <= 0;
        valid[14] <= 0;
        valid[15] <= 0;
        valid[16] <= 0;
        valid[17] <= 0;
        valid[18] <= 0;
        valid[19] <= 0;
        valid[20] <= 0;
        valid[21] <= 0;
        valid[22] <= 0;
        valid[23] <= 0;
        valid[24] <= 0;
        valid[25] <= 0;
        valid[26] <= 0;
        valid[27] <= 0;
        valid[28] <= 0;
        valid[29] <= 0;
        valid[30] <= 0;
        valid[31] <= 0;
        valid[32] <= 0;
        valid[33] <= 0;
        valid[34] <= 0;
        valid[35] <= 0;
        valid[36] <= 0;
        valid[37] <= 0;
        valid[38] <= 0;
        valid[39] <= 0;
        valid[40] <= 0;
        valid[41] <= 0;
        valid[42] <= 0;
        valid[43] <= 0;
        valid[44] <= 0;
        valid[45] <= 0;
        valid[46] <= 0;
        valid[47] <= 0;
        valid[48] <= 0;
        valid[49] <= 0;
        valid[50] <= 0;
        valid[51] <= 0;
        valid[52] <= 0;
        valid[53] <= 0;
        valid[54] <= 0;
        valid[55] <= 0;
        valid[56] <= 0;
        valid[57] <= 0;
        valid[58] <= 0;
        valid[59] <= 0;
        valid[60] <= 0;
        valid[61] <= 0;
        valid[62] <= 0;
        valid[63] <= 0;
        state[1:0] <= 2'b0;
    end
    else begin
        state <= next_state;
        L1_rdata_r <= rdata;
        L1_ready_r <= ready;
        case(state)
            HIT:
                // cache[L1_addr[5:0]] <= cache[L1_addr[5:0]];
                // dirty[L1_addr[5:0]] <= dirty[L1_addr[5:0]];
                if(L1_addr[27:6] == target_tag && target_valid) begin// hit
                    if (L1_write && ~L1_read)begin
                        cache[L1_addr[5:0]][0] <= L1_wdata[31:0];
                        cache[L1_addr[5:0]][1] <= L1_wdata[63:32];
                        cache[L1_addr[5:0]][2] <= L1_wdata[95:64];
                        cache[L1_addr[5:0]][3] <= L1_wdata[127:96];
                        dirty[L1_addr[5:0]]    <= 1;
                    end
                end
            1: begin end
            2:
                if(mem_ready == 1)begin// miss (read)
                    valid[L1_addr[5:0]]    <= 1;
                    dirty[L1_addr[5:0]]    <= 0;
                    tag  [L1_addr[5:0]]    <= next_tag;
                    cache[L1_addr[5:0]][0] <= mem_rdata[31:0];
                    cache[L1_addr[5:0]][1] <= mem_rdata[63:32];
                    cache[L1_addr[5:0]][2] <= mem_rdata[95:64];
                    cache[L1_addr[5:0]][3] <= mem_rdata[127:96];
                end
            3: begin end
        endcase
    end
end
endmodule
