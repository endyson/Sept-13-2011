module inst_pattern_match(
    input [31:0] inst,
    input clk,

    output [3:0] rd,
    output [3:0] rn,
    output [3:0] rm,
    output imm_or_reg,
    output [31:0]imm32
);

always @ (posedge clk)begin
    casex(inst[31:15])
        //pattern 1:
        17'b11110?01010?????0://ADC(imm) T1
        17'b11110?01000?????0://ADD(imm) T3
        17'b11110?01000?11010://ADD(SP plus imm) T3
        begin
            rd = inst[11:8];
            rm = inst[19:16];
            imm32 = thumb_expand_imm({inst[26],inst[14:12],inst[7:0]});
            imm_or_reg = 1'b1;
        end
        //pattern 2:
        17'b11110?100000????0://ADD(imm) T4
        17'b11110?10000011010://ADD(SP plus imm) T4
        17'b11110?10101011110://ADR T2
        17'b11110?10000011110://ADR T3
        begin
             rd = inst[11:8];
            rm = inst[19:16];
            imm32 = {20'b0,inst[26],inst[14:12],inst[7:0]};
            imm_or_reg = 1'b1;
        end
        //pattern 3:
        17'b11101011010?????0://ADC(reg) T2
        17'b11101011000?????0://ADD(reg) T3
        17'b11101011000?11010://ADD(SP plus reg) T3
        begin
            rd = inst[11:8];
            rn = inst[19:16];
            rm = inst[3:0];
            imm5 = {inst[14:12],inst[7:6]};
            imm_or_reg = 1'b0;
            //shift
        end
        //pattern 4:
        17'b0100000101???????://ADC(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            rn = {1'b0,inst[18:16]};
            rm = {1'b0,inst[21:19]};
            imm_or_reg = 1'b0;
        end
        //pattern 5:
        17'b0001110??????????://ADD(imm) T1
        begin
            rd = {1'b0,inst[18:16]};
            rm = {1'b0,inst[21:19]};
            imm32 = {29'b0,inst[24:22];
            imm_or_reg = 1'b1;
        end
        //pattern 6:
        17'b00110????????????://ADD(imm) T2
        17'b10101????????????://ADD(SP plus imm) T1
        17'b10100????????????://ADR T1
        begin
            rd = {1'b0,inst[26:24]};
            rm = {1'b0,inst[26:24]};
            imm32 = {24'b0,inst[23:16]};
            imm_or_reg = 1'b1;
        end
        //pattern 7:
        17'b101100000????????://ADD(SP plus imm) T2
        begin
            rd = 4'b1101;
            rm = 4'b1101;
            imm32 = {23'b0,inst[22:16],2'b0};
            imm_or_reg = 1'b1;
        end
        //pattern 8:
        17'b0001100??????????://ADD(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            rn = {1'b0,inst[21:19]};
            rm = {1'b0,inst[24:22]};
            imm_or_reg = 1'b0;
        end
        //pattern 9:
        17'b01000100?????????://ADD(reg) T2
        17'b010001001????101?://ADD(SP plus reg) T2
        begin
            rd = {inst[23],inst[18:16]};
            rn = inst[22:19];
            rm = {inst[23],inst[18:16]};
            imm_or_reg = 1'b0;
        end
    endcase
end
endmodule 

