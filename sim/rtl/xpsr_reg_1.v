`include "reg.v"
module reg_xpsr(
input [31:0] set_data;
    //input [4:0] apsr_in,
//input [7:0] epsr_in,
    input clk,
    input rst,

    input en_apsr,
    input en_ipsr,
    input en_epsr,
input  en_carry,

//    input ici_or_it;
    input inst_valid,

    output [4:0] apsr,
    output reg [8:0] ipsr,
    output reg [9:0] epsr
);

/*
*A P S R    b i t s     f l a g     p a t t e r n  
**************************************************
* -------------------------------------------
*|  N  |  Z  |  C  |  V  |  Q  | ...
* -------------------------------------------
*/

/*
* E P S R       b i t s     f l a g s       p a t t e r n
**********************************************************
* 31 ...  26    25 24 ... ..  15 14 13 12 11 10   9 ... 
* ------------------------------------------------------
*|  ...  | ICI/IT | T | ...   |     ICI/IT     |  a  |  
* ------------------------------------------------------
* EPSR[9:0]      = {xPSR[26:25], T, xPSR[15:10],a} 
* IT_STATUS[7:0] = {xPSR[15:12],xPSR[11:10],xPSR[26:25]}
* ICI[7:0]       = {xPSR[26:25],xPSR[15:12],xPSR[11:10]}
* */
//wire [7:0] ici_it;
//wire [7:0] epsr_tmp_out;
//wire [7:0] ici;
wire [7:0] it;

//reg_8_en    u_epsr(ici_it, clk, en_epsr, epsr_tmp_out);
//dff_en      u_T(T_in, t_en, clk, T_out); 
//dff_en      u_a(a_in, a_en, clk, a_out);

//assign ici_it = {epsr_in[9:8],epsr_in[6:1]};
assign it = {epsr[6:3],epsr[2:1],epsr[9:8]};
//assign ici = {epsr_in[9:8],epsr_in[6:1]};
//assign T_in = epsr_in[7];
//assign a_in = epsr_in[0];

//assign ici_it = ici_or_it ? ici: {it[1:0],it[7:4],it[3:2]};
//assign epsr = {epsr_tmp_out[7:6],T_out,epsr_tmp_out[5:0],a_out};


/*
* I P S R       b i t s     f l a g s       p a t t e r n
* */


/*
* I n p u t     C o n n e c t i o n 
*/

always @ (posedge clk)begin
    if(rst == 1'b1)begin
        apsr <= 5'b0;
        ipsr <= 9'b0;
        epsr <= 10'b0010000000;
    end
    else begin
        case({en_apsr,en_ipsr,en_epsr,en_carry})
            4'b1000:begin
                apsr <=  set_data[31:27];
            end
            4'b0100:begin
                ipsr   <=  set_data[8:0];
            end
            4'b0010:begin
                epsr  <=  set_data[26:9];
            end
            4'b???1:begin
                apsr[2] <= set_data[29];//carry
            end
            default:begin
                if(inst_valid)begin//IT STATUS operation
                    if(it[2:0] == 3'b000)   it <= 8'b0;
                    else                    it[4:0] <= it[4:0]<<1;
                end
            end
        endcase
    end
end
endmodule

