tb_ib: 
	cd ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_ib_chk.v && \
	${RUN_DIR}/simv

if_gen:
	@echo "Generating test instructions for inst_fetch module"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_gen.pl >inst.dat
it_gen:
	@echo "Generating test instructions for IT operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_it_gen.pl >inst.dat

run:
	@echo "Running the Simulation"
	@cd ${LOG_DIR} && ${RUN_DIR}/simv

it_verify:tb_arm_core
	@echo "Verifying the Output signal's Correctness!\n"
	@cd ${LOG_DIR} && ${TOOLS_DIR}/stage_1_output_chk.pl  ${LOG_DIR}/stage_1_output.log | grep next_ >stage_1_chk_failed.log

tb_inst_fetch:if_gen 
	@echo "Entering into ${LOG_DIR}"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} ${TEST_DIR}/tb_inst_fetch.v && \

tb_cond_pass: 
	@echo "Entering into ${LOG_DIR}"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_cond_pass.v && \

tb_arm_core:it_gen
	@echo "Building tb_arm_core test"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} -psl ${TEST_DIR}/tb_arm_core.v  ${PSL_DIR}/xpsr_reg.psl
