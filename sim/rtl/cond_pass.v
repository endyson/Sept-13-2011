module cond_pass(
    input [3:0]cond,
    input [3:0]apsr_reg_nzcv,
    output passed);
reg pass_tmp;

always @ (cond or apsr_reg_nzcv)begin
    case(cond[3:1])
        3'b000:pass_tmp = (apsr_reg_nzcv[2]);   //EQ or NE
        3'b001:pass_tmp = (apsr_reg_nzcv[1]);   //CS or CC
        3'b010:pass_tmp = (apsr_reg_nzcv[3]);   //MI or PL
        3'b011:pass_tmp = (apsr_reg_nzcv[0]);   //VS or VC
        3'b100:pass_tmp = (apsr_reg_nzcv[1] & ~apsr_reg_nzcv[2]);   //HI or LS
        3'b101:pass_tmp = (apsr_reg_nzcv[3] == apsr_reg_nzcv[0]);   //GE or LT
        3'b110:pass_tmp = (apsr_reg_nzcv[3] == apsr_reg_nzcv[0]) & ~apsr_reg_nzcv[2];   //GT or LE
        3'b111:pass_tmp = 1'b1; //AL
    endcase
end
assign passed = ( (cond[0] == 1'b1) && (cond != 4'b1111) ) ? ~pass_tmp : pass_tmp;

endmodule 
