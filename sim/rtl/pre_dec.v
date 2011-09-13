module pre_dec(
    input [31:0] inst_in,
    input [3:0] it_cond,
    input [4:0] apsr,
    input in_it_blk,
    
    output [31:0] inst_out,
//    output hint_or_exc,
    output reg it_flag,
    output reg [7:0] it_status
);

reg [3:0] cur_cond;
reg unpred;
//reg it_flag;
reg pass_tmp;
//test block begin
//always @(cur_cond[0])begin
//$display ("cur_cond[0] changed to %b at %d",cur_cond[0], $time);
//$display ("cur_cond is %b",cur_cond);
//end
//test block end
assign passed = ( (cur_cond[0] == 1'b1) && (cur_cond != 4'b1111) ) ? ~pass_tmp: pass_tmp;

assign hint_or_exc = unpred | in_it_blk & ~passed | it_flag;

assign inst_out = hint_or_exc ? 32'b0: inst_in;


//cur_cond[7:4] branch condition
//cur_cond[7:0] it first cond and  mask

//IT or Branch check logical
always @ */*inst_in[31:24]*/ begin
    casex(inst_in[31:24])
        8'b1101????:begin
            cur_cond    <=  inst_in[27:24];
            //b           <=  1'b1;
            it_flag     <=  1'b0;
            it_status   <=  8'b0;
            unpred      <=  in_it_blk;
        end
        8'b11110???:begin
            cur_cond    <=  inst_in[25:22];
            //b           <=  1'b1;
            it_flag     <=  1'b0;
            it_status   <=  8'b0;
            unpred      <=  in_it_blk;
        end
        8'b10111111:begin
            cur_cond    <=  4'b0;
            //b           <=  1'b0;
            it_flag     <=  1'b1;
            it_status   <=  inst_in[23:16];
            unpred       <=  in_it_blk;
        end
        default:begin
            cur_cond    <=  it_cond;
            //b           <=  1'b0;
            it_flag     <=  1'b0;
            it_status   <=  8'b0;
            unpred       <=  0;
        end
    endcase
end

//condition pass logical
always @ (cur_cond or apsr)begin
    case(cur_cond[3:1])
        3'b000:pass_tmp = (apsr[3]);   //EQ or NE
        3'b001:pass_tmp = (apsr[2]);   //CS or CC
        3'b010:pass_tmp = (apsr[4]);   //MI or PL
        3'b011:pass_tmp = (apsr[1]);   //VS or VC
        3'b100:pass_tmp = (apsr[2] & ~apsr[3]);   //HI or LS
        3'b101:pass_tmp = (apsr[4] == apsr[1]);   //GE or LT
        3'b110:pass_tmp = (apsr[4] == apsr[1]) & ~apsr[3];   //GT or LE
        3'b111:pass_tmp = 1'b1; //AL
    endcase
end
endmodule

