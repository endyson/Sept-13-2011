include Makefile.in
include ${TEST_DIR}/Makefile

ib: tb_ib 

if:  tb_inst_fetch 

cp:  tb_cond_pass

build_tree:
	@if test ! -d ${OUT_DIR} ;then\
	mkdir -p ${OUT_DIR};fi
	@if test ! -d ${RUN_DIR};then\
	mkdir -p ${RUN_DIR};fi
	@if test ! -d ${LOG_DIR};then\
	mkdir -p ${LOG_DIR};fi
	@if test ! -d ${DB_DIR};then\
	mkdir -p ${DB_DIR};fi
run:run
#it:	build_tree tb_arm_core run
it:build_tree tb_arm_core run it_verify
clean:
	@echo "Cleaned up!"
	@rm -rf ${OUT_DIR}
