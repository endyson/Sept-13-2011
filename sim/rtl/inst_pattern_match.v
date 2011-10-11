//File:             inst_pattern_match.v
//Author:           Xiao,Chang
//Email:            chngxiao@gmail.com
//Original Date:    9/14/2011 
//Description:      Dectect the patterns of the current instruction and establish the input for next stage.
//Copyright:        All right reserved by Xiao,Chang.
//Notice:           Please do me a favor to NOT remove the content above;
//                  If you have any modification and description on this, please add it anywhere you like;
//                  This is all I need when I do this;
//                  Thank you very much for concernning and Welcome to join into my work;
//                  Please Feel free to email me by the email address above.

module inst_pattern_match(
    input [31:0] inst,
    input carry_in,

    output reg [3:0] rd,
    output reg [3:0] rd2,
    output reg [3:0] ra,
    output reg [3:0] rb,

    output reg imm_or_reg,
    output reg shift_or_not,
    output reg thumb_or_not,

    output reg [31:0]imm32,
    output  [11:0]imm12,
    output reg [1:0]s_type,
    output reg [4:0] s_offset,
    output reg index,
    output reg add,
    output reg wback,
    output reg [15:0]reg_mask
);

integer fd;
initial fd = $fopen("./inst_pattern_match.log","w");

//assign {s_type,s_offset} = shift_or_not ? {inst[5:4], {inst[14:12],inst[7:6]}} : 7'b0;
assign imm12 = thumb_or_not ==1'b0 ? 12'b0: {inst[26],inst[14:12],inst[7:0]};


//Instructions Pattern match Logical.Please refer to instructions_pattern_specification.docx for details
//a>,Mainly used to fetch register addresses or immediate numbers for later operands access.
//b>,Certain register address (mainly SP or PC) or immediate number fetch are not achieved within this module, and these will marked out in the following.

always @ ( inst[31:15] or inst[13] or inst[11]) begin
    casex({inst[31:15],inst[13],inst[11]})

        //pattera 1:
        19'b1111_0?01_010?_????_0??,//ADC(imm) T1
        19'b1111_0?01_000?_????_0??://ADD(imm) T3
        //19'b1111_0?01_000?_1101_0??://ADD(SP imm) T3 :Intergrated into the "ADD(imm) T3"
        begin
            rd <= inst[11:8];
            ra <= inst[19:16];
            {imm_or_reg, thumb_or_not,shift_or_not} <= 3'b110;
            {s_type,s_offset} <= 7'b0;
            $fdisplay(fd,"Currently in pattern 1, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern 2:
        19'b1111_0?10_1010_1111_0??,//ADR T2
        //19'b1111_0?10_0000_1111_0??,//ADR T3  :Intergrated into "ADD(imm) T4"
        //19'b1111_0?10_0000_1101_0??,//ADD(SP imm) T4:Intergrated into "ADD(imm) T4"
        19'b1111_0?10_0000_????_0??://ADD(imm) T4
        begin
            rd <= inst[11:8];
            ra <= inst[19:16];
            imm32 <= {20'b0,inst[26],inst[14:12],inst[7:0]};
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
            {s_type,s_offset} <= 7'b0;
            $fdisplay(fd,"Currently in pattern 2, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern
        19'b1111_1000_0101_????_??1,//LDR(imm) T4
        19'b1111_1000_0001_????_??1,//LDRB(imm) T3
        //19'b1111_1000_0001_????_??1,//LDRBT    :Intergrated into "LDRB(imm) T3"
        19'b1111_1000_0011_????_??1,//LDRH(imm) T3
        19'b1111_1001_0001_????_??1,//LDRSB(imm) T2
        19'b1111_1001_0011_????_??1://LDRSH(imm) T2
        begin
            ra <= inst[19:16];
            imm32 <= {24'b0,inst[7:0]};
            rd <= inst[15:12];
            {index,add,wback} <= inst[10:8];//P U W
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
            {s_type,s_offset} <= 7'b0;
            $fdisplay(fd,"Currently in pattern 3, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern
        19'b1110_100?_?1?1_????_???,//LDRD(imm)
        //19'b1110_100?_?1?1_1111_???,//LDRD(literal)   :Intergrated into "LDRD(imm)"
        19'b1110_1000_0101_????_???,//LDREX
        19'b1110_1000_1101_????_???,//LDREXB
        //19'b1110_1000_1101_????_???,//LDREXH  :Intergrated into "LDREXB"
        19'b1111_1000_0011_????_??1,//LDRHT
        19'b1111_1001_0001_????_??1,//LDRSBT
        19'b1111_1001_0011_????_??1,//LDRSHT
        19'b1111_1000_0101_????_??1://LDRT
        begin
            ra <= inst[19:16];
            rd <= inst[15:12];
            imm32 <= {24'b0,inst[7:0]};
            rd2 <= inst[11:8];
            {index,add,wback} <= {inst[24:23],inst[21]};//P U W
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
            {s_type,s_offset} <= 7'b0;
            $fdisplay(fd,"Currently in pattern 4, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattera 3:
        19'b1110_1011_010?_????_0??,//ADC(reg) T2
        //19'b11101011000?11010??://ADD(SP reg) T3 :Intergrated into "ADD(reg) T3"
        19'b1110_1011_000?_????_0??://ADD(reg) T3
        begin
            rd <= inst[11:8];
            ra <= inst[19:16];
            rb <= inst[3:0];
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b001;
            {s_type,s_offset} <= {inst[5:4],inst[14:12],inst[7:6]};
            $fdisplay(fd,"Currently in pattern 5, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern 
        19'b1111_1000_0101_????_?0?,//LDR(reg) T2
        19'b1111_1000_0001_????_?0?,//LDRB(reg) T2
        19'b1111_1000_0011_????_?0?,//LDRH(reg) T2
        19'b1111_1001_0001_????_?0?,//LDRSB(reg) T2
        19'b1111_1001_0011_????_?0?://LDRSH(reg) T2
        begin
            ra <= inst[19:16];
            rb <= inst[3:0];
            rd <= inst[15:12];
            {s_type,s_offset} <= {2'b0,3'b0,inst[5:4]};//LSL
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b001;
            $fdisplay(fd,"Currently in pattern 6, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern 
        19'b1110_1000_10?1_????_?0?,//LDM/LDMIA/LDMFD T2
        19'b1110100100?1?????0?://LDMDB/LDMEA
        begin
            ra <= inst[19:16];
            reg_mask <= inst[15:0];
            wback <= inst[21];
            {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b000;
            {s_type,s_offset} <= 7'b0;
            $fdisplay(fd,"Currently in pattern 7, time is %t\tinstruction:[%x]\n",$time,inst);
        end
        //pattern
        19'b1111_1000_1101_????_???,//LDR(imm) T3
        19'b111110001001???????,//LDRB(imm) T2
        19'b111110001011???????,//LDRH(imm) T2
        19'b111110011001???????,//LDRSB(imm) T1
        19'b111110011011???????,//LDRSH(imm) T1
        19'b11111000?1011111???,//LDR(literal) T2
        19'b11111000?0011111???,//LDRB(literal) T1
        19'b11111000?0111111???,//LDRH(literal)
        19'b11111001?0011111???,//LDRSB(literal)
        19'b11111001?0111111???://LDRSH(literal)
    begin
        ra <= inst[19:16];
        rd <= inst[15:12];
        imm32 <= {20'b0,inst[11:0]};
        {index,add,wback} <= {1'b1,inst[23],1'b0};//P U W
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 8, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 4:
    19'b0100_0001_01??_????_???://ADC(reg) T1
    begin
        rd <= {1'b0,inst[18:16]};
        ra <= {1'b0, inst[18:16]};
        rb <= {1'b0, inst[21:19]};
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b000;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 9, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 9:
    //19'b01000100?1101?????,//ADD(SP reg) T1 :Intergrated into "ADD(reg) T2"
    //19'b010001001????101??://ADD(SP reg) T2 :Intergrated into "ADD(reg) T2"  *ra here refers to rm and rb refers to rn in ARMv7-M reference
    19'b0100_0100_????_????_???://ADD(reg) T2     *ra here refers to rm and rb refers to rn in ARMv7-M reference
    begin
        rd <= {inst[23],inst[18:16]};
        ra <= inst[22:19];
        rb <= {inst[23],inst[18:16]};
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b000;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 10, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 8:
    19'b0001_100?_????_????_???,//ADD(reg) T1
    19'b0101_100?_????_????_???,//LDR(reg) T1
    19'b0101_110?_????_????_???,//LDRB(reg) T1
    19'b0101_101?_????_????_???,//LDRH(reg)
    19'b0101_011?_????_????_???,//LDRSB(reg) T1
    19'b0101_111?_????_????_???://LDRSH(reg) T1
    begin
        rd <= {1'b0,inst[18:16]};
        ra <= {1'b0,inst[21:19]};
        rb <= {1'b0,inst[24:22]};
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b000;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 11, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 5:
    19'b0001_110?_????_????_???://ADD(imm) T1
    begin
        rd <= {1'b0,inst[18:16]};
        ra <= {1'b0,inst[21:19]};
        imm32 <= {29'b0,inst[24:22]};
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 12, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 6:
    19'b0011_0???_????_????_???,//ADD(imm) T2
    19'b1010_1???_????_????_???,//ADD(SP imm) T1  *ra here is meanless, it will be muxed to SP later
    19'b1010_0???_????_????_???,//ADR T1          *ra here is meanless, it will be muxed to PC later
    19'b1001_1???_????_????_???,//LDR(imm) T2
    19'b0100_1???_????_????_???://LDR(literal) T1
    begin
        rd <= {1'b0,inst[26:24]};
        ra <= {1'b0,inst[26:24]};
        imm32 <= {24'b0,inst[23:16]};
        {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
        {s_type,s_offset} <= 7'b0;
        $fdisplay(fd,"Currently in pattern 13, time is %t\tinstruction:[%x]\n",$time,inst);
    end
    //pattern 7:
    19'b1011_0000_0???_????_???://ADD(SP imm) T2  *rd & ra are assigned to 13 (SP) 
begin
    rd <= 4'b1101;
    ra <= 4'b1101;
    imm32 <= {23'b0,inst[22:16],2'b0};
    {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
    {s_type,s_offset} <= 7'b0;
    $fdisplay(fd,"Currently in pattern 14, time is %t\tinstruction:[%x]\n",$time,inst);
end
//patern
19'b1100_1???_????_????_???://LDM/LDMIA/LDMFD T1
begin
    ra <= {1'b0,inst[26:24]};
    reg_mask <= {8'b0,inst[23:16]};
    wback <= reg_mask & (1<<ra) ? 1'b0 : 1'b1;
    {s_type,s_offset} <= 7'b0;
    $fdisplay(fd,"Currently in pattern 15, time is %t\tinstruction:[%x]\n",$time,inst);
end
//pattern
19'b0110_1???_????_????_???,//LDR(imm) T1
19'b0111_1???_????_????_???,//LDRB(imm) T1
19'b1000_1???_????_????_???://LDRH(imm) T1
begin
    ra <= {1'b0,inst[21:19]};
    rd <= {1'b0,inst[18:16]};
    imm32 <= {27'b0,inst[26:22]};
    {index,add,wback} <= 3'b110;//P U W
    {imm_or_reg,thumb_or_not,shift_or_not} <= 3'b100;
    {s_type,s_offset} <= 7'b0;
    $fdisplay(fd,"Currently in pattern 16, time is %t\tinstruction:[%x]\n",$time,inst);
end
    endcase
end
endmodule 

