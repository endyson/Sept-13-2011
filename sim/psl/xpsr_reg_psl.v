vuint xpsr_reg_psl(xpsr_reg){
default clock = (posedge clk);
UNEXPECTED_SIGNAL_PATTERN: assert never{en_apsr != 5'b0 && (en_ipsr | en_epsr) || (en_ipsr & en_epsr)};
}

