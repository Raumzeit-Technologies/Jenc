/*
 * Authored by: Robert Metchev / Chips & Scripts (rmetchev@ieee.org)
 *
 * CERN Open Hardware Licence Version 2 - Permissive
 *
 * Copyright (C) 2024 Robert Metchev
 */
`include "jpeg_encoder.vh"
module quant_tables #(
    parameter N = 2,        // Read data size in entries
    parameter AW = 6,       // Address size
    parameter DW = 13       // Data width
)(
    input   logic               clk,
    input   logic[1:0]          qf_select, // select one of the 4 possible QF
    input   logic [AW-1:0]      ra,
    input   logic               re,
    output  logic [DW-1:0]      rd[N-1:0]
);
// Autogenerated code containing zig zag ordered, AAN weighted quanization factors for QF=1..100, included below
// m = 4096/q(AAN)
`ifdef INFER_QUANTIZATION_TABLES_ROM
`include "quant_tables.vh"
logic[25:0] qt_mem[3:0][63:0]; /* synthesis syn_ramstyle="Block_RAM" */
generate
    for(genvar i=0; i<2; i++) begin : I
        for(genvar j=0; j<32; j++) begin : J
            always_comb qt_mem[0][32*i + j] = `QT(50, i, j); // QF0 =  50 // FIXME - parametrize
            always_comb qt_mem[1][32*i + j] = `QT(100, i, j); // QF1 = 100 // FIXME - parametrize
            always_comb qt_mem[2][32*i + j] = `QT(10, i, j); // QF2 =  10 // FIXME - parametrize
            always_comb qt_mem[3][32*i + j] = `QT(25, i, j); // QF3 =  25 // FIXME - parametrize
        end
    end
endgenerate

always @(posedge clk) if (re) begin
    rd[0] <= qt_mem[qf_select][ra][12:0];
    rd[1] <= qt_mem[qf_select][ra][25:13];
end

`else
`include "quant_tables_EBR.vh"

wire VDD, VSS;
VLO INST1( .Z(VSS));
VHI INST2( .Z(VDD));
PDP16K_MODE EBR_inst(
        .DI0    (VSS),
        .DI1    (VSS),
        .DI2    (VSS),
        .DI3    (VSS),
        .DI4    (VSS),
        .DI5    (VSS),
        .DI6    (VSS),
        .DI7    (VSS),
        .DI8    (VSS),
        .DI9    (VSS),
        .DI10   (VSS),
        .DI11   (VSS),
        .DI12   (VSS),
        .DI13   (VSS),
        .DI14   (VSS),
        .DI15   (VSS),
        .DI16   (VSS),
        .DI17   (VSS),
        .DI18   (VSS),
        .DI19   (VSS),
        .DI20   (VSS),
        .DI21   (VSS),
        .DI22   (VSS),
        .DI23   (VSS),
        .DI24   (VSS),
        .DI25   (VSS),
        .DI26   (VSS),
        .DI27   (VSS),
        .DI28   (VSS),
        .DI29   (VSS),
        .DI30   (VSS),
        .DI31   (VSS),
        .DI32   (VSS),
        .DI33   (VSS),
        .DI34   (VSS),
        .DI35   (VSS),
        .ADW0   (VSS),
        .ADW1   (VSS),
        .ADW2   (VSS),
        .ADW3   (VSS),
        .ADW4   (VSS),
        .ADW5   (VSS),
        .ADW6   (VSS),
        .ADW7   (VSS),
        .ADW8   (VSS),
        .ADW9   (VSS),
        .ADW10  (VSS),
        .ADW11  (VSS),
        .ADW12  (VSS),
        .ADW13  (VSS),
        .ADR0   (VDD),
        .ADR1   (VDD),
        .ADR2   (VDD),
        .ADR3   (VDD),
        .ADR4   (VDD),
        .ADR5   (ra[0]),
        .ADR6   (ra[1]),
        .ADR7   (ra[2]),
        .ADR8   (ra[3]),
        .ADR9   (ra[4]),
        .ADR10  (ra[5]),
        .ADR11  (qf_select[0]),
        .ADR12  (qf_select[1]),
        .ADR13  (VSS),
        .CLKW   (VSS),
        .CLKR   (clk),
        .CEW    (VSS),
        .CER    (re),
        .CSW0   (VSS),
        .CSW1   (VSS),
        .CSW2   (VSS),
        .CSR0   (re),
        .CSR1   (re),
        .CSR2   (re),
        .RST    (VSS),
        .DO0    (rd[0][0]),
        .DO1    (rd[0][1]),
        .DO2    (rd[0][2]),
        .DO3    (rd[0][3]),
        .DO4    (rd[0][4]),
        .DO5    (rd[0][5]),
        .DO6    (rd[0][6]),
        .DO7    (rd[0][7]),
        .DO8    (rd[0][8]),
        .DO9    (rd[0][9]),
        .DO10   (rd[0][10]),
        .DO11   (rd[0][11]),
        .DO12   (rd[0][12]),
        .DO13   ( ),
        .DO14   ( ),
        .DO15   ( ),
        .DO16   ( ),
        .DO17   ( ),
        .DO18   (rd[1][0]),
        .DO19   (rd[1][1]),
        .DO20   (rd[1][2]),
        .DO21   (rd[1][3]),
        .DO22   (rd[1][4]),
        .DO23   (rd[1][5]),
        .DO24   (rd[1][6]),
        .DO25   (rd[1][7]),
        .DO26   (rd[1][8]),
        .DO27   (rd[1][9]),
        .DO28   (rd[1][10]),
        .DO29   (rd[1][11]),
        .DO30   (rd[1][12]),
        .DO31   ( ),
        .DO32   ( ),
        .DO33   ( ),
        .DO34   ( ),
        .DO35   ( ),
        .ONEBITERR ( ),
        .TWOBITERR ( )
    );

defparam EBR_inst.DATA_WIDTH_W = "X36";
defparam EBR_inst.DATA_WIDTH_R = "X36";
defparam EBR_inst.OUTREG = "BYPASSED";
defparam EBR_inst.RESETMODE = "SYNC";
defparam EBR_inst.GSR = "DISABLED";
defparam EBR_inst.ECC = "DISABLED";
defparam EBR_inst.CSDECODE_W = "000";
defparam EBR_inst.CSDECODE_R = "000";
defparam EBR_inst.ASYNC_RST_RELEASE = "SYNC";
// autogenerated
// QF0 = 50
defparam EBR_inst.INITVAL_00 = QT50_INITVAL_0; // FIXME - parametrize
defparam EBR_inst.INITVAL_01 = QT50_INITVAL_1;
defparam EBR_inst.INITVAL_02 = QT50_INITVAL_2;
defparam EBR_inst.INITVAL_03 = QT50_INITVAL_3;
defparam EBR_inst.INITVAL_04 = QT50_INITVAL_4;
defparam EBR_inst.INITVAL_05 = QT50_INITVAL_5;
defparam EBR_inst.INITVAL_06 = QT50_INITVAL_6;
defparam EBR_inst.INITVAL_07 = QT50_INITVAL_7;
// QF1 = 100
defparam EBR_inst.INITVAL_08 = QT100_INITVAL_0; // FIXME - parametrize
defparam EBR_inst.INITVAL_09 = QT100_INITVAL_1;
defparam EBR_inst.INITVAL_0A = QT100_INITVAL_2;
defparam EBR_inst.INITVAL_0B = QT100_INITVAL_3;
defparam EBR_inst.INITVAL_0C = QT100_INITVAL_4;
defparam EBR_inst.INITVAL_0D = QT100_INITVAL_5;
defparam EBR_inst.INITVAL_0E = QT100_INITVAL_6;
defparam EBR_inst.INITVAL_0F = QT100_INITVAL_7;
// QF2 = 10
defparam EBR_inst.INITVAL_10 = QT10_INITVAL_0; // FIXME - parametrize
defparam EBR_inst.INITVAL_11 = QT10_INITVAL_1;
defparam EBR_inst.INITVAL_12 = QT10_INITVAL_2;
defparam EBR_inst.INITVAL_13 = QT10_INITVAL_3;
defparam EBR_inst.INITVAL_14 = QT10_INITVAL_4;
defparam EBR_inst.INITVAL_15 = QT10_INITVAL_5;
defparam EBR_inst.INITVAL_16 = QT10_INITVAL_6;
defparam EBR_inst.INITVAL_17 = QT10_INITVAL_7;
// QF3 = 25
defparam EBR_inst.INITVAL_18 = QT25_INITVAL_0; // FIXME - parametrize
defparam EBR_inst.INITVAL_19 = QT25_INITVAL_1;
defparam EBR_inst.INITVAL_1A = QT25_INITVAL_2;
defparam EBR_inst.INITVAL_1B = QT25_INITVAL_3;
defparam EBR_inst.INITVAL_1C = QT25_INITVAL_4;
defparam EBR_inst.INITVAL_1D = QT25_INITVAL_5;
defparam EBR_inst.INITVAL_1E = QT25_INITVAL_6;
defparam EBR_inst.INITVAL_1F = QT25_INITVAL_7;

`endif //INFER_QUANTIZATION_TABLES_ROM

endmodule

// chroma + luma ROMs autogenerated by jquant.py
/*
always_comb mem = {
// Chroma
   68,   35,   24,   19,   16,   14,   14,   19,
   35,   18,   12,   10,    8,    7,    7,   10,
   24,   12,    8,    7,    6,    5,    5,    7,
   19,   10,    7,    5,    4,    4,    4,    5,
   16,    8,    6,    4,    4,    3,    5,    9,
   14,    7,    5,    4,    3,    5,   11,   16,
   14,    7,    5,    4,    5,   11,   13,   21,
   19,   10,    7,    5,    9,   16,   21,   30,
// Luma
   68,   33,   24,   17,   16,   15,   15,   26,
   34,   15,   10,    9,    9,    9,   11,   19,
   26,   11,    8,    8,    9,    9,   13,   27,
   24,    9,    6,    8,    8,   11,   17,   28,
   26,   10,    6,    9,   13,   15,   18,   31,
   25,   10,    9,   10,   14,   19,   22,   28,
   24,   11,   10,   14,   17,   20,   22,   31,
   30,   19,   16,   21,   27,   39,   34,   32
};
*/

/*
// zig zag ordered, AAN weighted quanization factors
always_comb begin
// Luma
    mem[ 0][
    mem[ 0] = {6'd 34, 6'd 32};
    mem[ 1] = {6'd 28, 6'd 31};
    mem[ 2] = {6'd 39, 6'd 22};
    mem[ 3] = {6'd 20, 6'd 27};
    mem[ 4] = {6'd 31, 6'd 22};
    mem[ 5] = {6'd 18, 6'd 28};
    mem[ 6] = {6'd 17, 6'd 19};
    mem[ 7] = {6'd 16, 6'd 21};
    mem[ 8] = {6'd 14, 6'd 14};
    mem[ 9] = {6'd 17, 6'd 15};
    mem[10] = {6'd 19, 6'd 27};
    mem[11] = {6'd 11, 6'd 13};
    mem[12] = {6'd 10, 6'd 13};
    mem[13] = {6'd 19, 6'd 10};
    mem[14] = {6'd 11, 6'd 30};
    mem[15] = {6'd  9, 6'd  9};
    mem[16] = {6'd  9, 6'd  8};
    mem[17] = {6'd 26, 6'd 11};
    mem[18] = {6'd  9, 6'd 15};
    mem[19] = {6'd  8, 6'd  9};
    mem[20] = {6'd 10, 6'd  6};
    mem[21] = {6'd 25, 6'd 24};
    mem[22] = {6'd  6, 6'd 10};
    mem[23] = {6'd  9, 6'd  8};
    mem[24] = {6'd 16, 6'd 15};
    mem[25] = {6'd  8, 6'd  9};
    mem[26] = {6'd 26, 6'd  9};
    mem[27] = {6'd 11, 6'd 24};
    mem[28] = {6'd 17, 6'd 10};
    mem[29] = {6'd 15, 6'd 24};
    mem[30] = {6'd 34, 6'd 26};
    mem[31] = {6'd 68, 6'd 33};
// Chroma
    mem[32] = {6'd 21, 6'd 30};
    mem[33] = {6'd 16, 6'd 21};
    mem[34] = {6'd 16, 6'd 13};
    mem[35] = {6'd 11, 6'd  9};
    mem[36] = {6'd  9, 6'd 11};
    mem[37] = {6'd  5, 6'd  5};
    mem[38] = {6'd  5, 6'd  5};
    mem[39] = {6'd  7, 6'd  5};
    mem[40] = {6'd  3, 6'd  4};
    mem[41] = {6'd  4, 6'd  3};
    mem[42] = {6'd 10, 6'd  7};
    mem[43] = {6'd  4, 6'd  5};
    mem[44] = {6'd  4, 6'd  4};
    mem[45] = {6'd 10, 6'd  5};
    mem[46] = {6'd  7, 6'd 19};
    mem[47] = {6'd  4, 6'd  5};
    mem[48] = {6'd  5, 6'd  4};
    mem[49] = {6'd 19, 6'd  7};
    mem[50] = {6'd  7, 6'd 14};
    mem[51] = {6'd  5, 6'd  6};
    mem[52] = {6'd  7, 6'd  6};
    mem[53] = {6'd 14, 6'd 14};
    mem[54] = {6'd  7, 6'd  8};
    mem[55] = {6'd  8, 6'd  7};
    mem[56] = {6'd 16, 6'd 14};
    mem[57] = {6'd  8, 6'd 10};
    mem[58] = {6'd 16, 6'd 10};
    mem[59] = {6'd 12, 6'd 19};
    mem[60] = {6'd 19, 6'd 12};
    mem[61] = {6'd 18, 6'd 24};
    mem[62] = {6'd 35, 6'd 24};
    mem[63] = {6'd 68, 6'd 35};
end
endmodule
*/
/*
-------------------------------------------------------------------------------
Luma AAN scaling =
[[0.125      0.09011095 0.09567509 0.10631261 0.125      0.15906517
  0.23091034 0.45421377]
 [0.09011095 0.06495987 0.06897099 0.07663944 0.09011095 0.11466811
  0.1664604  0.32743708]
 [0.09567509 0.06897099 0.07322978 0.08137175 0.09567509 0.1217486
  0.17673894 0.34765555]
 [0.10631261 0.07663944 0.08137175 0.09041897 0.10631261 0.13528507
  0.19638944 0.38630921]
 [0.125      0.09011095 0.09567509 0.10631261 0.125      0.15906517
  0.23091034 0.45421377]
 [0.15906517 0.11466811 0.1217486  0.13528507 0.15906517 0.20241383
  0.29383834 0.57799673]
 [0.23091034 0.1664604  0.17673894 0.19638944 0.23091034 0.29383834
  0.42655667 0.83906123]
 [0.45421377 0.32743708 0.34765555 0.38630921 0.45421377 0.57799673
  0.83906123 1.65048118]]

-------------------------------------------------------------------------------
QF = 50
Bits = 13

-------------------------------------------------------------------------------
Luma Q-table =
[[ 16  11  10  16  24  40  51  61]
 [ 12  12  14  19  26  48  60  55]
 [ 14  13  16  24  40  57  69  56]
 [ 14  17  22  29  51  87  80  62]
 [ 18  22  37  56  68 109 103  77]
 [ 24  35  55  64  81 104 113  92]
 [ 49  64  78  87 103 121 120 101]
 [ 72  92  95  98 112 100 103  99]]

Luma Q-table scaled =
[[ 16.  11.  10.  16.  24.  40.  51.  61.]
 [ 12.  12.  14.  19.  26.  48.  60.  55.]
 [ 14.  13.  16.  24.  40.  57.  69.  56.]
 [ 14.  17.  22.  29.  51.  87.  80.  62.]
 [ 18.  22.  37.  56.  68. 109. 103.  77.]
 [ 24.  35.  55.  64.  81. 104. 113.  92.]
 [ 49.  64.  78.  87. 103. 121. 120. 101.]
 [ 72.  92.  95.  98. 112. 100. 103.  99.]]

Luma Q-table AAN adjusted =
[[128.         122.07173424 104.52041246 150.49955083 192.
  251.46925393 220.86495074 134.29799832]
 [133.16916462 184.72944173 202.9839002  247.91412093 288.53319002
  418.59938092 360.4460905  167.9712045 ]
 [146.32857745 188.48505019 218.49033244 294.94265867 418.08164986
  468.17787442 390.40632519 161.07897581]
 [131.68710698 221.81789768 270.36410378 320.72916466 479.71731828
  643.08649404 407.35387109 160.49319702]
 [144.         244.14346848 386.72552612 526.74842792 544.
  685.25371695 446.06058679 169.5237028 ]
 [150.88155236 305.22871526 451.75058058 473.07512206 509.2252392
  513.79888357 384.56520313 159.17045105]
 [212.20358012 384.47582986 441.32888935 442.99733482 446.06058679
  411.79105822 281.32252864 120.37262131]
 [158.51567015 280.9700148  273.25897681 253.68279529 246.57993134
  173.01135984 122.75623757  59.98250749]]

Luma Q-table AAN factors =
[[0.0078125  0.0081919  0.00956751 0.00664454 0.00520833 0.00397663
  0.00452765 0.00744613]
 [0.00750925 0.00541332 0.0049265  0.00403365 0.00346581 0.00238892
  0.00277434 0.0059534 ]
 [0.00683394 0.00530546 0.00457686 0.00339049 0.00239188 0.00213594
  0.00256143 0.00620813]
 [0.00759376 0.0045082  0.00369872 0.0031179  0.00208456 0.001555
  0.00245487 0.00623079]
 [0.00694444 0.00409595 0.00258581 0.00189844 0.00183824 0.00145931
  0.00224185 0.00589888]
 [0.00662772 0.00327623 0.00221361 0.00211383 0.00196377 0.00194629
  0.00260034 0.00628257]
 [0.00471246 0.00260094 0.00226588 0.00225735 0.00224185 0.00242842
  0.00355464 0.00830754]
 [0.00630852 0.0035591  0.00365953 0.00394193 0.00405548 0.00577997
  0.00814623 0.01667153]]

Luma Q-table AAN factors, 13-bit =
[[32 34 39 27 21 16 19 30]
 [31 22 20 17 14 10 11 24]
 [28 22 19 14 10  9 10 25]
 [31 18 15 13  9  6 10 26]
 [28 17 11  8  8  6  9 24]
 [27 13  9  9  8  8 11 26]
 [19 11  9  9  9 10 15 34]
 [26 15 15 16 17 24 33 68]]

-------------------------------------------------------------------------------
Chroma Q-table =
[[17 18 24 47 99 99 99 99]
 [18 21 26 66 99 99 99 99]
 [24 26 56 99 99 99 99 99]
 [47 66 99 99 99 99 99 99]
 [99 99 99 99 99 99 99 99]
 [99 99 99 99 99 99 99 99]
 [99 99 99 99 99 99 99 99]
 [99 99 99 99 99 99 99 99]]

Chroma Q-table scaled =
[[17. 18. 24. 47. 99. 99. 99. 99.]
 [18. 21. 26. 66. 99. 99. 99. 99.]
 [24. 26. 56. 99. 99. 99. 99. 99.]
 [47. 66. 99. 99. 99. 99. 99. 99.]
 [99. 99. 99. 99. 99. 99. 99. 99.]
 [99. 99. 99. 99. 99. 99. 99. 99.]
 [99. 99. 99. 99. 99. 99. 99. 99.]
 [99. 99. 99. 99. 99. 99. 99. 99.]]

Chroma Q-table AAN adjusted =
[[ 136.          199.75374693  250.84898992  442.09243057  792.
   622.38640347  428.73784556  217.95904645]
 [ 199.75374693  323.27652303  376.97010038  861.17536745 1098.64560814
   863.36122315  594.73604932  302.3481681 ]
 [ 250.84898992  376.97010038  764.71616353 1216.638467   1034.7520834
   813.15104504  560.14820571  284.76461794]
 [ 442.09243057  861.17536745 1216.638467   1094.9030104   931.21597078
   731.78807943  504.10041548  256.27139524]
 [ 792.         1098.64560814 1034.7520834   931.21597078  792.
   622.38640347  428.73784556  217.95904645]
 [ 622.38640347  863.36122315  813.15104504  731.78807943  622.38640347
   489.09701417  336.91995673  171.28124624]
 [ 428.73784556  594.73604932  560.14820571  504.10041548  428.73784556
   336.91995673  232.09108613  117.98900504]
 [ 217.95904645  302.3481681   284.76461794  256.27139524  217.95904645
   171.28124624  117.98900504   59.98250749]]

Chroma Q-table AAN factors =
[[0.00735294 0.00500616 0.00398646 0.00226197 0.00126263 0.00160672
  0.00233243 0.00458802]
 [0.00500616 0.00309333 0.00265273 0.0011612  0.00091021 0.00115826
  0.00168142 0.00330745]
 [0.00398646 0.00265273 0.00130767 0.00082194 0.00096642 0.00122978
  0.00178524 0.00351167]
 [0.00226197 0.0011612  0.00082194 0.00091332 0.00107386 0.00136652
  0.00198373 0.00390211]
 [0.00126263 0.00091021 0.00096642 0.00107386 0.00126263 0.00160672
  0.00233243 0.00458802]
 [0.00160672 0.00115826 0.00122978 0.00136652 0.00160672 0.00204458
  0.00296806 0.00583835]
 [0.00233243 0.00168142 0.00178524 0.00198373 0.00233243 0.00296806
  0.00430865 0.00847537]
 [0.00458802 0.00330745 0.00351167 0.00390211 0.00458802 0.00583835
  0.00847537 0.01667153]]

Chroma Q-table AAN factors, 13-bit =
[[30 21 16  9  5  7 10 19]
 [21 13 11  5  4  5  7 14]
 [16 11  5  3  4  5  7 14]
 [ 9  5  3  4  4  6  8 16]
 [ 5  4  4  4  5  7 10 19]
 [ 7  5  5  6  7  8 12 24]
 [10  7  7  8 10 12 18 35]
 [19 14 14 16 19 24 35 68]]

*/
