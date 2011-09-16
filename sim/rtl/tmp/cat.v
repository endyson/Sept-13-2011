/*
 * Author:  Xiao, Chang
 * Data:     8/3/2011
 * verison:    0.0
 * File:       cat.v
 */
/*1 6 b i t    T h u m b     i n s t r u s t i o n e n     c o d i n g*/
/*
* opcode Instruction or instruction class
* 00xxxx Shift (immediate), add, subtract, move, and compare on page A5-6
* 010000 Data processing on page A5-7
* 010001 Special data instructions and branch and exchange on page A5-8
* 01001x Load from Literal Pool, see LDR (literal) on page A6-90
* 0101xx Load/store single data item on page A5-9
* 011xxx
* 100xxx
* 10100x Generate PC-relative address, see ADR on page A6-30
* 10101x Generate SP-relative address, see ADD (SP plus immediate) on page
* A6-26
* 1011xx Miscellaneous 16-bit instructions on page A5-10
* 11000x Store multiple registers, see STM / STMIA / STMEA on page A6-218
* 11001x Load multiple registers, see LDM / LDMIA / LDMFD on page A6-84
* 1101xx Conditional branch, and supervisor call on page A5-12
* 11100x Unconditional Branch, see B on page A6-40
* */
module cat (
    input [31:0]inst,
    input inst_16,
    input clk,

    output arith,   //Shift (immediate), add, subtract, move, and compare on page A5-6
    output dp,      //Data processing on page A5-7
    output sdibe,   //Special data instructions and branch and exchange on page A5-8
    output llp,     //Load from Literal Pool, see LDR (literal) on page A6-90
    output lssd,    //Load/Store single data item on page A5-9
    output gpca,    //Generate PC-relative address, see ADR on page A6-30
    output gspa,    //Generate SP-relative address, see ADD (SP plus immediate) on page A6-26
    output misc,    //Miscellaneous 16-bit instructions on page A5-10
    output smr,     //Store multiple registers, see STM / STMIA / STMEA on page A6-218
    output lmr,     //Load multiple registers, see LDM / LDMIA / LDMFD on page A6-84
    output cbsc,    //Conditional branch, and supervisor call on page A5-12
    output ucb      //Unconditional Branch, see B on page A6-40
);
reg [11:0]  flag_bench;

assign {arith,dp,sdibe,llp,lssd,gpca,gspa,misc,smr,lmr,cbsc,ucb}=flag_bench;

always @ (posedge clk)begin
    if(inst_16)begin 
        casex(inst[31:26])
            6'b00????:flag_bench <= 12'b1000_0000_0000;
            6'b010000:flag_bench <= 12'b0100_0000_0000;
            6'b010001:flag_bench <= 12'b0010_0000_0000;
            6'b01001?:flag_bench <= 12'b0001_0000_0000;

            6'b0101??:flag_bench <= 12'b0000_1000_0000;
            6'b011???:flag_bench <= 12'b0000_1000_0000;
            6'b100???:flag_bench <= 12'b0000_1000_0000;

            6'b10100?:flag_bench <= 12'b0000_0100_0000;
            6'b10101?:flag_bench <= 12'b0000_0010_0000;
            6'b1011??:flag_bench <= 12'b0000_0001_0000;
            6'b11000?:flag_bench <= 12'b0000_0000_1000;
            6'b11001?:flag_bench <= 12'b0000_0000_0100;
            6'b1101?:flag_bench <= 12'b0000_0000_0010;
            6'b11100?:flag_bench <= 12'b0000_0000_0001;
        endcase
    end
end

endmodule 



