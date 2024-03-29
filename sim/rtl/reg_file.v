/* File:            reg_file.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/15/2011
 * Last Modified:   9/15/2011
 * Description:     Register file 
 * Copyright:       All right reserved by Xiao,Chang
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef REG_FILE_H
`define REG_FILE_H
`include "reg.v"

module reg_file(
input [3:0] rn_addr,
input [3:0] rm_addr,
input [3:0] rd_addr,
input w_en,
input clk,

output [31:0] rn_data,
output [31:0] rm_data,
output [31:0] rd_data
);

reg [15:0]en_reg_x;

wire [31:0]reg_data_ary[15:0];

assign rn_data = reg_data_ary[rn_addr];
assign rm_data = reg_data_ary[rm_addr];

generate
genvar i;
for(i=0;i<16;i++)
    reg_32_en u_reg_32_x(rd_data,clk,reg_en_x[i] & w_en,reg_data_ary[i]);
endgenerate

always @ * begin
    case(rd_addr)
        4'b0000:reg_en_x = 16'b0000_0000_0000_0001 & {{w_en}16};
        4'b0001:reg_en_x = 16'b0000_0000_0000_0010 & {{w_en}16};
        4'b0010:reg_en_x = 16'b0000_0000_0000_0100 & {{w_en}16};
        4'b0011:reg_en_x = 16'b0000_0000_0000_1000 & {{w_en}16};
        4'b0100:reg_en_x = 16'b0000_0000_0001_0000 & {{w_en}16};
        4'b0101:reg_en_x = 16'b0000_0000_0010_0000 & {{w_en}16};
        4'b0110:reg_en_x = 16'b0000_0000_0100_0000 & {{w_en}16};
        4'b0111:reg_en_x = 16'b0000_0000_1000_0000 & {{w_en}16};
        4'b1000:reg_en_x = 16'b0000_0001_0000_0000 & {{w_en}16};
        4'b1001:reg_en_x = 16'b0000_0010_0000_0000 & {{w_en}16};
        4'b1010:reg_en_x = 16'b0000_0100_0000_0000 & {{w_en}16};
        4'b1011:reg_en_x = 16'b0000_1000_0000_0000 & {{w_en}16};
        4'b1100:reg_en_x = 16'b0001_0000_0000_0000 & {{w_en}16};
        4'b1101:reg_en_x = 16'b0010_0000_0000_0000 & {{w_en}16};
        4'b1110:reg_en_x = 16'b0100_0000_0000_0000 & {{w_en}16};
        4'b1111:reg_en_x = 16'b1000_0000_0000_0000 & {{w_en}16};
    endcase
end

endmodule

`endif
