 // context from the textbook:
 // if (MEM/WB.RegWrite
 //   and (MEM/WB.RegisterRd ≠  0)
 //   and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠  0)
 //          and (EX/MEM.RegisterRd ≠  ID/EX.RegisterRs))
 //   and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01
 //  if (MEM/WB.RegWrite
 //  and (MEM/WB.RegisterRd ≠  0)
 //  and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠  0)
 //         and (EX/MEM.RegisterRd ≠  ID/EX.RegisterRt))
 //  and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01
module ForwardingUnit(
    MemWbRegWrite,
    MemWbRegRd,
    ExMemRegWrite,
    ExMemRegRd,
    IdExRegRs,
    IdExRegRt,
    ForwardA,
    ForwardB
);

input MemWbRegWrite, ExMemRegWrite;
input [4:0] MemWbRegRd, ExMemRegRd, IdExRegRs, IdExRegRt;
output ForwardA, ForwardB;

assign ForwardA = (MemWbRegWrite && MemWbRegRd != 0 && ~(ExMemRegWrite && ExMemRegRd != 0
          &&  ExMemRegRd != IdExRegRs) && MemWbRegRd == IdExRegRs)?1:0;
assign ForwardB = (MemWbRegWrite && MemWbRegRd != 0 && !(ExMemRegWrite && ExMemRegRd != 0
                 && ExMEemRegRd != IdExRegRt) && MemWbRegRd == IdExRegRt)?1:0;

endmodule
