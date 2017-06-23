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
    reg [31:0]  cache[127:0][3:0];
    reg [20:0]  tag  [127:0];
    reg         valid[127:0];
    reg         dirty[127:0];
    reg         target_valid;
    reg         target_dirty;
    reg [31:0]  target_cache[3:0];
    reg [20:0]  target_tag;
    reg [1:0]   state;
    reg [1:0]   next_state;
    reg [20:0]  next_tag;
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
    // target_vallid = valid[L1_addr[6:0]]
    case(L1_addr[6:0])
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
        64: target_valid = valid[64];
        65: target_valid = valid[65];
        66: target_valid = valid[66];
        67: target_valid = valid[67];
        68: target_valid = valid[68];
        69: target_valid = valid[69];
        70: target_valid = valid[70];
        71: target_valid = valid[71];
        72: target_valid = valid[72];
        73: target_valid = valid[73];
        74: target_valid = valid[74];
        75: target_valid = valid[75];
        76: target_valid = valid[76];
        77: target_valid = valid[77];
        78: target_valid = valid[78];
        79: target_valid = valid[79];
        80: target_valid = valid[80];
        81: target_valid = valid[81];
        82: target_valid = valid[82];
        83: target_valid = valid[83];
        84: target_valid = valid[84];
        85: target_valid = valid[85];
        86: target_valid = valid[86];
        87: target_valid = valid[87];
        88: target_valid = valid[88];
        89: target_valid = valid[89];
        90: target_valid = valid[90];
        91: target_valid = valid[91];
        92: target_valid = valid[92];
        93: target_valid = valid[93];
        94: target_valid = valid[94];
        95: target_valid = valid[95];
        96: target_valid = valid[96];
        97: target_valid = valid[97];
        98: target_valid = valid[98];
        99: target_valid = valid[99];
        100: target_valid = valid[100];
        101: target_valid = valid[101];
        102: target_valid = valid[102];
        103: target_valid = valid[103];
        104: target_valid = valid[104];
        105: target_valid = valid[105];
        106: target_valid = valid[106];
        107: target_valid = valid[107];
        108: target_valid = valid[108];
        109: target_valid = valid[109];
        110: target_valid = valid[110];
        111: target_valid = valid[111];
        112: target_valid = valid[112];
        113: target_valid = valid[113];
        114: target_valid = valid[114];
        115: target_valid = valid[115];
        116: target_valid = valid[116];
        117: target_valid = valid[117];
        118: target_valid = valid[118];
        119: target_valid = valid[119];
        120: target_valid = valid[120];
        121: target_valid = valid[121];
        122: target_valid = valid[122];
        123: target_valid = valid[123];
        124: target_valid = valid[124];
        125: target_valid = valid[125];
        126: target_valid = valid[126];
        127: target_valid = valid[127];
    endcase
    // target_dirty = dirty[L1_addr[6:0]]
    case(L1_addr[6:0])
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
        64: target_dirty = dirty[64];
        65: target_dirty = dirty[65];
        66: target_dirty = dirty[66];
        67: target_dirty = dirty[67];
        68: target_dirty = dirty[68];
        69: target_dirty = dirty[69];
        70: target_dirty = dirty[70];
        71: target_dirty = dirty[71];
        72: target_dirty = dirty[72];
        73: target_dirty = dirty[73];
        74: target_dirty = dirty[74];
        75: target_dirty = dirty[75];
        76: target_dirty = dirty[76];
        77: target_dirty = dirty[77];
        78: target_dirty = dirty[78];
        79: target_dirty = dirty[79];
        80: target_dirty = dirty[80];
        81: target_dirty = dirty[81];
        82: target_dirty = dirty[82];
        83: target_dirty = dirty[83];
        84: target_dirty = dirty[84];
        85: target_dirty = dirty[85];
        86: target_dirty = dirty[86];
        87: target_dirty = dirty[87];
        88: target_dirty = dirty[88];
        89: target_dirty = dirty[89];
        90: target_dirty = dirty[90];
        91: target_dirty = dirty[91];
        92: target_dirty = dirty[92];
        93: target_dirty = dirty[93];
        94: target_dirty = dirty[94];
        95: target_dirty = dirty[95];
        96: target_dirty = dirty[96];
        97: target_dirty = dirty[97];
        98: target_dirty = dirty[98];
        99: target_dirty = dirty[99];
        100: target_dirty = dirty[100];
        101: target_dirty = dirty[101];
        102: target_dirty = dirty[102];
        103: target_dirty = dirty[103];
        104: target_dirty = dirty[104];
        105: target_dirty = dirty[105];
        106: target_dirty = dirty[106];
        107: target_dirty = dirty[107];
        108: target_dirty = dirty[108];
        109: target_dirty = dirty[109];
        110: target_dirty = dirty[110];
        111: target_dirty = dirty[111];
        112: target_dirty = dirty[112];
        113: target_dirty = dirty[113];
        114: target_dirty = dirty[114];
        115: target_dirty = dirty[115];
        116: target_dirty = dirty[116];
        117: target_dirty = dirty[117];
        118: target_dirty = dirty[118];
        119: target_dirty = dirty[119];
        120: target_dirty = dirty[120];
        121: target_dirty = dirty[121];
        122: target_dirty = dirty[122];
        123: target_dirty = dirty[123];
        124: target_dirty = dirty[124];
        125: target_dirty = dirty[125];
        126: target_dirty = dirty[126];
        127: target_dirty = dirty[127];
    endcase
    // target_tag = tag[L1_addr[6:0]]
    case(L1_addr[6:0])
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
        64: target_tag = tag[64];
        65: target_tag = tag[65];
        66: target_tag = tag[66];
        67: target_tag = tag[67];
        68: target_tag = tag[68];
        69: target_tag = tag[69];
        70: target_tag = tag[70];
        71: target_tag = tag[71];
        72: target_tag = tag[72];
        73: target_tag = tag[73];
        74: target_tag = tag[74];
        75: target_tag = tag[75];
        76: target_tag = tag[76];
        77: target_tag = tag[77];
        78: target_tag = tag[78];
        79: target_tag = tag[79];
        80: target_tag = tag[80];
        81: target_tag = tag[81];
        82: target_tag = tag[82];
        83: target_tag = tag[83];
        84: target_tag = tag[84];
        85: target_tag = tag[85];
        86: target_tag = tag[86];
        87: target_tag = tag[87];
        88: target_tag = tag[88];
        89: target_tag = tag[89];
        90: target_tag = tag[90];
        91: target_tag = tag[91];
        92: target_tag = tag[92];
        93: target_tag = tag[93];
        94: target_tag = tag[94];
        95: target_tag = tag[95];
        96: target_tag = tag[96];
        97: target_tag = tag[97];
        98: target_tag = tag[98];
        99: target_tag = tag[99];
        100: target_tag = tag[100];
        101: target_tag = tag[101];
        102: target_tag = tag[102];
        103: target_tag = tag[103];
        104: target_tag = tag[104];
        105: target_tag = tag[105];
        106: target_tag = tag[106];
        107: target_tag = tag[107];
        108: target_tag = tag[108];
        109: target_tag = tag[109];
        110: target_tag = tag[110];
        111: target_tag = tag[111];
        112: target_tag = tag[112];
        113: target_tag = tag[113];
        114: target_tag = tag[114];
        115: target_tag = tag[115];
        116: target_tag = tag[116];
        117: target_tag = tag[117];
        118: target_tag = tag[118];
        119: target_tag = tag[119];
        120: target_tag = tag[120];
        121: target_tag = tag[121];
        122: target_tag = tag[122];
        123: target_tag = tag[123];
        124: target_tag = tag[124];
        125: target_tag = tag[125];
        126: target_tag = tag[126];
        127: target_tag = tag[127];
    endcase
    next_state = 0;
    ready      = 0;
    read       = 0;
    write      = 0;
    rdata      = 0;
    addr       = 0;
    wdata      = 0;
    next_tag   = L1_addr[27:7];
    case(state) // state machine
        HIT:// hit state
            if (L1_read ^ L1_write == 0) begin end
            else if (L1_read ^ L1_write == 1) begin
                if(L1_addr[27:7] == target_tag && target_valid) begin// hit
                    rdata = {cache[L1_addr[6:0]][3],cache[L1_addr[6:0]][2],cache[L1_addr[6:0]][1],cache[L1_addr[6:0]][0]};
                    ready = 1;
                end
                else if(L1_addr[27:7] != target_tag && target_valid && target_dirty) begin// miss (need write back)
                    next_state = 1;
                    write  = 1;
                    addr   = {target_tag, L1_addr[6:0]};
                    // mem_wdata = cache[L1_addr[4:2]]
                    wdata  = {cache[L1_addr[6:0]][3],cache[L1_addr[6:0]][2],cache[L1_addr[6:0]][1],cache[L1_addr[6:0]][0]};
                end
                else if(!target_valid || (L1_addr[27:7] != target_tag && !target_dirty))begin// miss (need read)
                    next_state = 2;
                    read   = 1;
                    addr   = L1_addr;
                end
            end
        MISS_1:// miss state (write back)
            if(mem_ready == 0)begin// wait for write back
                next_state = 1;
                write      = 1;
                addr       = {target_tag, L1_addr[6:0]};
                wdata  = {cache[L1_addr[6:0]][3],cache[L1_addr[6:0]][2],cache[L1_addr[6:0]][1],cache[L1_addr[6:0]][0]};
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
        valid[64] <= 0;
        valid[65] <= 0;
        valid[66] <= 0;
        valid[67] <= 0;
        valid[68] <= 0;
        valid[69] <= 0;
        valid[70] <= 0;
        valid[71] <= 0;
        valid[72] <= 0;
        valid[73] <= 0;
        valid[74] <= 0;
        valid[75] <= 0;
        valid[76] <= 0;
        valid[77] <= 0;
        valid[78] <= 0;
        valid[79] <= 0;
        valid[80] <= 0;
        valid[81] <= 0;
        valid[82] <= 0;
        valid[83] <= 0;
        valid[84] <= 0;
        valid[85] <= 0;
        valid[86] <= 0;
        valid[87] <= 0;
        valid[88] <= 0;
        valid[89] <= 0;
        valid[90] <= 0;
        valid[91] <= 0;
        valid[92] <= 0;
        valid[93] <= 0;
        valid[94] <= 0;
        valid[95] <= 0;
        valid[96] <= 0;
        valid[97] <= 0;
        valid[98] <= 0;
        valid[99] <= 0;
        valid[100] <= 0;
        valid[101] <= 0;
        valid[102] <= 0;
        valid[103] <= 0;
        valid[104] <= 0;
        valid[105] <= 0;
        valid[106] <= 0;
        valid[107] <= 0;
        valid[108] <= 0;
        valid[109] <= 0;
        valid[110] <= 0;
        valid[111] <= 0;
        valid[112] <= 0;
        valid[113] <= 0;
        valid[114] <= 0;
        valid[115] <= 0;
        valid[116] <= 0;
        valid[117] <= 0;
        valid[118] <= 0;
        valid[119] <= 0;
        valid[120] <= 0;
        valid[121] <= 0;
        valid[122] <= 0;
        valid[123] <= 0;
        valid[124] <= 0;
        valid[125] <= 0;
        valid[126] <= 0;
        valid[127] <= 0;
        state[1:0] <= 2'b0;
    end
    else begin
        state <= next_state;
        L1_rdata_r <= rdata;
        L1_ready_r <= ready;
        case(state)
            HIT:
                // cache[L1_addr[6:0]] <= cache[L1_addr[6:0]];
                // dirty[L1_addr[6:0]] <= dirty[L1_addr[6:0]];
                if(L1_addr[27:7] == target_tag && target_valid) begin// hit
                    if (L1_write && ~L1_read)begin
                        cache[L1_addr[6:0]][0] <= L1_wdata[31:0];
                        cache[L1_addr[6:0]][1] <= L1_wdata[63:32];
                        cache[L1_addr[6:0]][2] <= L1_wdata[95:64];
                        cache[L1_addr[6:0]][3] <= L1_wdata[127:96];
                        dirty[L1_addr[6:0]]    <= 1;
                    end
                end
            1: begin end
            2:
                if(mem_ready == 1)begin// miss (read)
                    valid[L1_addr[6:0]]    <= 1;
                    dirty[L1_addr[6:0]]    <= 0;
                    tag  [L1_addr[6:0]]    <= next_tag;
                    cache[L1_addr[6:0]][0] <= mem_rdata[31:0];
                    cache[L1_addr[6:0]][1] <= mem_rdata[63:32];
                    cache[L1_addr[6:0]][2] <= mem_rdata[95:64];
                    cache[L1_addr[6:0]][3] <= mem_rdata[127:96];
                end
            3: begin end
        endcase
    end
end
endmodule
