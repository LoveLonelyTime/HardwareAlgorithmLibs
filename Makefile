VERILATOR = verilator
SV_SRCS := DUT.sv common/common.sv carry-lookahead-adders/carry-lookahead-adder.sv
CPP_SRCS := DUT.cpp

all:
	$(VERILATOR) -Wno-UNOPTFLAT -cc --exe --trace --build -j --top-module DUT $(CPP_SRCS) $(SV_SRCS)
	./obj_dir/VDUT

clean:
	rm -rf obj_dir
