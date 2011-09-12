module ib_chk(
    input [15:0] inst,
    output reg [7:0] cond_itstatus,
    output reg b,
    output reg it);

always @(inst)begin
    casex(inst[15:8])
        8'b1101????:begin
            cond_itstatus      <= {4'b0,inst[11:8]};
            b                   <= 1'b1;
            it                  <= 1'b0;
        end
        8'b11110???:begin
            cond_itstatus       <= {4'b0,inst[9:6]};
            b                   <= 1'b1;
            it                  <= 1'b0;
        end
        8'b10111111:begin
            b                   <=  1'b0;
            it                  <=  1'b1;
            cond_itstatus       <=  inst[7:0];
        end
        default:begin
            cond_itstatus       <=  8'b0;
            b                   <=  1'b0;
            it                  <=  1'b0;
        end
    endcase
end
endmodule 
