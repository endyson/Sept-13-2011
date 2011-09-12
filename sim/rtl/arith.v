module arith(
    input enable,
    input [4:0]opcode,

    output lsl,
    output lsr,
    output asr,
    output add_r,
    output sub_r,
    output add_3b,
    output sub_3b,
    output mov,
    output comp,
    output add_8b,
    output sub_8b
);

reg [10:0] output_reg;
assign  {lsl,lsr,asr,add_r,sub_r,add_3b,sub_3b,mov,comp,add_8b,add_8b} = output_reg;

always @(enable or opcode)begin
    if( !enable )   output_reg=0;
    else begin
        casex(opcode)
            5'b000??:output_reg = 11'b1000_0000_000;
            5'b001??:output_reg = 11'b0100_0000_000;
            5'b010??:output_reg = 11'b0010_0000_000;
            5'b01100:output_reg = 11'b0001_0000_000;
            5'b01101:output_reg = 11'b0000_1000_000;
            5'b01110:output_reg = 11'b0000_0100_000;
            5'b01111:output_reg = 11'b0000_0010_000;
            5'b100??:output_reg = 11'b0000_0001_000;
            5'b101??:output_reg = 11'b0000_0000_100;
            5'b110??:output_reg = 11'b0000_0000_010;
            5'b111??:output_reg = 11'b0000_0000_001;
            default:output_reg = 11'b0;
        endcase 
    end

endmodule

module alu(
    input [31:0] m,
    input [31:0] n,
    input carry_in,
    input [1:0] opcode,
    
    output [31:0] d,
    output carry_out
);

always @ ( m or n or carry_in or opcode)begin
    case(opcode)
        //ADD: Add with Carry
        2'b0:begin
            {carry_out,d} = m + n + carry_in;
        end
        //The following is supposed to be done before it passed into ALU.
        //LSL: Logical Shift Left.
        2'b1:
        //LSR: Logical Shift Right.
        2'b2:
        //ASR: Arithmetic Shift Right.
        2'b3:begin
            d = m;
        end
    endcase 
end
endmodule

module alu_m(
    input [1:0]s_type,
    input [4:0]offset,
    input [31:0]op_m,
    input carry_in

    output reg [31:0]result,
    output reg carry,
);

always @ ( s_type or offset)begin
    case(s_type)
        //SRTYPE_LSL
        2'b00:begin
            result  = offset == 5'b0 ? 32'b0 : {op_m[31-offset:0],offset{1'b0}};
            carry   = offset == 5'b0 ? op_m[0] : op_m[31-offset +1];
        end
        //SRTYPE_LSR
        2'b01:begin
            result  = offset == 5'b0 ? 32'b0 : {offset{1'b0},op_m[31:offset]};
            carry   = offset == 5'b0 ? op_m[31] : op_m[offset-1];
        end
        //SRTYPE_ASR
        2'b10:begin
            result  = offset == 5'b0 ? {32{op_m[31]}} : {offset[op_m[31],op_m[31:offset]};
            carry   = offset == 5'b0 ? op_m[31] : op_m[offset-1];
        end
        //SRTYPE_RRX & SRTYPE_ROR
        2'b11:begin
            result  = offset == 0 ? {carry_in,op_m[31:1]} : {op_m[offset-1:0],op_m[31:offset]};
            carry   = offset == 0 ? op_m[0] : op_m[offset-1];
        end
    endcase
end
endmodule 

module decoder(
    input[10:0]inst_type 













