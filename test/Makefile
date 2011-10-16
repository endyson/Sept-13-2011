stage_1_gen:
	@echo "Generating test instructions for IT operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_stage_1_gen.pl >inst_stage_1_gen.dat
	@cd ${LOG_DIR} && grep @ inst_stage_1_gen.dat > inst.dat

stage_2_gen:
	@echo "Generating test instructions for Decode operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_stage_2_gen.pl >inst_stage_2_gen.dat
	@cd ${LOG_DIR} && grep @ inst_stage_2_gen.dat >inst.dat
	@cd ${LOG_DIR} && grep EMU inst_stage_2_gen.dat > stage_2_output_emu.vec

inst_depth_chk:
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_depth_chk.pl inst.dat >inst_depth.dat

run:
	@echo "Running the Simulation"
	@cd ${LOG_DIR} && ${RUN_DIR}/simv

stage_1_verify:build_test
	@echo "Verifying the Output signals of Stage One!"
	@cd ${LOG_DIR} && ${TOOLS_DIR}/stage_1_output_chk.pl  ${LOG_DIR}/stage_1_output_sim.vec >stage_1_sim_emu.diff

stage_2_verify:build_test
	@echo "Verifying the Output signals of Stage two!"
	@cd ${LOG_DIR} && ${TOOLS_DIR}/stage_2_output_chk.pl ${LOG_DIR}/stage_2_output_sim.vec  ${LOG_DIR}/stage_2_output_emu.vec > stage_2_sim_emu.diff

all_stage_verify:stage_1_verify stage_2_verify

stage_1_failed:
	@cd ${LOG_DIR} && ${TOOLS_DIR}/failed_or_not.pl ${LOG_DIR}/stage_1_sim_emu.diff

stage_2_failed:
	@cd ${LOG_DIR} && ${TOOLS_DIR}/failed_or_not.pl ${LOG_DIR}/stage_2_sim_emu.diff

build_test: inst_depth_chk
	@echo "Building tb_arm_core testbench"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} -psl ${TEST_DIR}/tb_arm_core.v  ${PSL_DIR}/xpsr_reg.psl
thumb_expand_imm:
	@echo "Building tb_thumb_expand_imm testbench"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_thumb_expand_imm.v

tb_reg_file:
	@echo "Building tb_reg_file testbench"
	@echo ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_reg_file.v

tb_inst_pattern_match:
	@echo "Bulding tb_inst_pattern_match"
	@echo ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} ${TEST_DIR}/tb_inst_pattern_match.v

stage_1:stage_1_gen build_test run stage_1_verify 
stage_2:stage_2_gen build_test run all_stage_verify 
