tb_ib: 
	cd ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_ib_chk.v && \
	${RUN_DIR}/simv

if_gen:
	@echo "Generating test instructions for inst_fetch module"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_gen.pl >inst.dat
it_gen:
	@echo "Generating test instructions for IT operation"
	@cd ${LOG_DIR} && perl ${TOOLS_DIR}/inst_it_gen.pl >inst_it.dat

run:
	@echo "Running the Simulation"
	@cd ${LOG_DIR} && ${RUN_DIR}/simv

it_verify:tb_arm_core
	@echo "Verifying the Output signal's Correctness!\n"
	@${TOOLS_DIR}/tab_chk.pl  ${LOG_DIR}/arm_core.log

tb_inst_fetch:if_gen 
	@echo "Entering into ${LOG_DIR}"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} ${TEST_DIR}/tb_inst_fetch.v && \

tb_cond_pass: 
	@echo "Entering into ${LOG_DIR}"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} ${TEST_DIR}/tb_cond_pass.v && \

tb_arm_core:it_gen
	@echo "Building tb_arm_core test"
	@cd ${LOG_DIR} && ${VCS} ${VCS_OPT} -P ${VERDI_TAB} ${VERDI_PLI} -psl ${TEST_DIR}/tb_arm_core.v  ${PSL_DIR}/xpsr_reg.psl
