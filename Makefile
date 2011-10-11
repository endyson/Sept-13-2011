include Makefile.in
include ${TEST_DIR}/Makefile

build_tree:
	@if test ! -d ${OUT_DIR} ;then\
	mkdir -p ${OUT_DIR};fi
	@if test ! -d ${RUN_DIR};then\
	mkdir -p ${RUN_DIR};fi
	@if test ! -d ${LOG_DIR};then\
	mkdir -p ${LOG_DIR};fi
	@if test ! -d ${DB_DIR};then\
	mkdir -p ${DB_DIR};fi

dryrun:run

it:build_tree stage_1

dec:build_tree stage_2

thumb_expand:build_tree thumb_expand_imm run

reg_file:build_tree tb_reg_file run

inst_pattern_match:build_tree tb_inst_pattern_match run

.PHONEY: clean

clean:
	@echo "Cleaned up!"
	@rm -rf ${OUT_DIR}
