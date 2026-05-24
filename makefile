# デフォルトのターゲット
TOP      ?= button_led
DEVICE   := GW1NR-LV9QN88PC6/I5
BOARD    := tangnano9k
FAMILY   := GW1N-9C
CST      := constraints/tangnano9k.cst

RTL      := rtl/$(TOP).sv
TB       := tb/tb_$(TOP).sv
BUILD    := build
SIM      := sim
VVP      := $(SIM)/$(TOP).vvp
VCD      := $(SIM)/$(TOP).vcd

.PHONY: all sim wave synth pnr pack prog clean fmt

all: sim

sim:
	mkdir -p $(SIM)
	iverilog -g2012 -o $(VVP) rtl/*.sv $(TB)
	vvp $(VVP)

wave:
	gtkwave $(VCD)

synth:
	mkdir -p $(BUILD)
	yosys -p "read_verilog -sv rtl/*.sv; synth_gowin -top $(TOP) -json $(BUILD)/$(TOP).json"

pnr: synth
	nextpnr-himbaechel \
		--json $(BUILD)/$(TOP).json \
		--write $(BUILD)/$(TOP)_pnr.json \
		--device $(DEVICE) \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

pack: pnr
	gowin_pack -d $(FAMILY) -o $(BUILD)/$(TOP).fs $(BUILD)/$(TOP)_pnr.json

prog: pack
	openFPGALoader -b $(BOARD) $(BUILD)/$(TOP).fs

clean:
	rm -rf $(BUILD) $(SIM)

fmt:
	verible-verilog-format --flagfile=.verible-format --inplace rtl/*.sv tb/*.sv