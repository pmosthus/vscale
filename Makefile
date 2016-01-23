include Makefrag

TOPLEVEL = vscale_hex_tb

V_SRC_DIR = src/main/verilog

V_TEST_DIR = src/test/verilog

CXX_TEST_DIR = src/test/cxx

SIM_DIR = sim

MEM_DIR = src/test/inputs

OUT_DIR = output

IVERILOG = iverilog 

IVERILOG_OPTS = -s $(TOPLEVEL) -Wall -tvvp -I$(V_SRC_DIR)
MAX_CYCLES = 1000000


DESIGN_SRCS = $(addprefix $(V_SRC_DIR)/, \
vscale_core.v \
vscale_hasti_bridge.v \
vscale_pipeline.v \
vscale_ctrl.v \
vscale_regfile.v \
vscale_src_a_mux.v \
vscale_src_b_mux.v \
vscale_imm_gen.v \
vscale_alu.v \
vscale_mul_div.v \
vscale_csr_file.v \
vscale_PC_mux.v \
)

SIM_SRCS = $(addprefix $(V_TEST_DIR)/, \
vscale_hex_tb.v \
vscale_sim_top.v \
vscale_dp_hasti_sram.v \
)



HDRS = $(addprefix $(V_SRC_DIR)/, \
vscale_ctrl_constants.vh \
rv32_opcodes.vh \
vscale_alu_ops.vh \
vscale_md_constants.vh \
vscale_hasti_constants.vh \
vscale_csr_addr_map.vh \
)

TEST_LXT_FILES = $(addprefix $(OUT_DIR)/,$(addsuffix .lxt,$(RV32_TESTS)))

default: $(SIM_DIR)/vvp

run-asm-tests: $(TEST_LXT_FILES)

$(OUT_DIR)/%.lxt: $(MEM_DIR)/%.hex $(SIM_DIR)/vvp
	mkdir -p output
	$(SIM_DIR)/vvp -lxt2 +loadmem=$< +vpdfile=$@ +max-cycles=$(MAX_CYCLES) 


$(SIM_DIR)/vvp: $(SIM_SRCS) $(DESIGN_SRCS) $(HDRS)
	mkdir -p sim
	$(IVERILOG) $(IVERILOG_OPTS) $(SIM_SRCS) $(DESIGN_SRCS) -o $@


clean:
	rm -rf $(SIM_DIR)/* $(OUT_DIR)/*

.PHONY: clean run-asm-tests 
