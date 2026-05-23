TOP      := alu4
DEVICE   := GW1NR-LV9QN88PC6/I5
BOARD    := tangnano9k

RTL      := rtl/alu4.sv
TB       := tb/tb_alu4.sv
VVP      := sim/$(TOP).vvp
VCD      := sim/$(TOP).vcd

.PHONY: sim wave clean

sim:
	mkdir -p sim
	iverilog -g2012 -o $(VVP) $(RTL) $(TB)
	vvp $(VVP)

wave:
	gtkwave $(VCD)

clean-sim:
	rm -rf sim/*.vvp sim/*.vcd build/*

TOP      := counter_led
DEVICE   := GW1NR-LV9QN88PC6/I5
FAMILY   := GW1N-9C
CST      := constraints/tangnano9k.cst

RTL      := rtl/$(TOP).sv
BUILD    := build

.PHONY: synth pnr pack prog clean

synth:
	mkdir -p $(BUILD)
	yosys -p "read_verilog -sv $(RTL); synth_gowin -top $(TOP) -json $(BUILD)/$(TOP).json"

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
	openFPGALoader -b tangnano9k $(BUILD)/$(TOP).fs

clean:
	rm -rf $(BUILD)

.PHONY: fmt

fmt:
	verible-verilog-format --flagfile=.verible-format --inplace rtl/*.sv tb/*.sv