stage_1_gen:
	@echo "Generating test instructions for IT operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_stage_1_gen.pl >inst.dat

stage_2_gen:
	@echo "Generating test instructions for Decode operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_stage_2_gen.pl  | grep @ >inst.dat

run:
	@echo "Running the Simulation"
	@cd ${LOG_DIR} && ${RUN_DIR}/simv

stage_1_verify:build_test
	@echo "Verifying the Output signals of Stage One!"
	@cd ${LOG_DIR} && ${TOOLS_DIR}/stage_1_output_chk.pl  ${LOG_DIR}/stage_1_output.log | grep next_ >stage_1_chk_failed_signals.log

stage_2_verify:build_test
	@echo "Verifying the Output signals of Stage two!"
	@cd ${LOG_DIR} && ${TOOLS_DIR}/stage_2_output_chk.pl ${LOG_DIR}/stage_2_output.log > stage_2_chk_failed_signals.log

build_test:
	@echo "Building tb_arm_core testbench"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} -psl ${TEST_DIR}/tb_arm_core.v  ${PSL_DIR}/xpsr_reg.psl

stage_1:stage_1_gen build_test run stage_1_verify
stage_2:stage_2_gen build_test run stage_2_verify
