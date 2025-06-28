VERILOG_SOURCES := $(wildcard *.v) $(wildcard *.sv) \
		   ../common/uart_tx_V2.v \
                   ../common/hid_printer.v \
		   ../../src/usb_hid_host.v \
		   ../../src/usb_hid_host_rom.v

OUTPUT := bitstream
PACKAGE := CABGA256

all: debug

clean:
	rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json

%.json: $(VERILOG_SOURCES)
	yosys build.ys

%.config: %.json icepi-zero.lpf
	nextpnr-ecp5 --25k --package $(PACKAGE) --lpf icepi-zero.lpf --json $< --textcfg $@ --freq 65

%.bit: %.config
	ecppack $< $@

build: clean $(OUTPUT).bit

debug: build
	openFPGALoader -cft231X --pins=7:3:5:6 $(OUTPUT).bit

install: build
	openFPGALoader -cft231X --pins=7:3:5:6 $(OUTPUT).bit --write-flash

install-bitstream: 
	openFPGALoader -cft231X --pins=7:3:5:6 $(OUTPUT).bit --write-flash

lint:
	verilator --lint-only -Wall -Wno-DECLFILENAME -Wno-WIDTHEXPAND $(VERILOG_SOURCES)

help: 
	echo "Usage: make [option]"
	echo "Options:"
	echo "- install: install to flash"
	echo "- debug: install to chip's temp memory (bitstream lost on power loss)"
	echo "- build: builds the bitstream"
	echo "- clean: delete all temparary files"

.PHONY: build clean install
