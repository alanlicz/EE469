# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./SSCPU.sv"
vlog "./controller.sv"
vlog "./regfile.sv"
vlog "./mux32_1.sv"
vlog "./mux16_1.sv"
vlog "./mux8_1.sv"
vlog "./mux4_1.sv"
vlog "./mux2_1.sv"
vlog "./mux2_1p.sv"
vlog "./Decoder32_5.sv"
vlog "./Decoder8_3.sv"
vlog "./D_FF.sv"
vlog "./oneRegister.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./Adder32.sv"
vlog "./full_Adder.sv"
vlog "./adder_subtracter.sv"
vlog "./alu.sv"
vlog "./ZE12_64.sv"
vlog "./SE9_64.sv"
vlog "./condCheck.sv"
vlog "./shifterP.sv"
vlog "./reg_p.sv"
vlog "./SSAPUstim.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work SSAPUstim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
