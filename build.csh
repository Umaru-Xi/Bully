#! /bin/csh
# This script for auto building Bully.

set BBT_VERSION = "v0.1a"

set INFO = "INFO: "
set WARN = "WARN: "
set ERRO = "ERRO: "

echo "Bully Build Tools(BBT) ${BBT_VERSION}"

set pass = "n"
while( "${pass}" == "n" )
    echo "${INFO}BBT can build Bully modules for many uses, module name can be found in verilog_src."
    echo "Module name and press ENTER:"
    set module_name = $<
    if( -f ./verilog_src/${module_name}.v ) then
        echo "${INFO}Module is found."
        set pass = "y"
    else
        echo "${WARN}Module does not exist, retry."
        set pass = "n"
    endif
end

set pass = "n"
while( "${pass}" == "n" )
    echo "${INFO}BBT can build Bully modules with many different method, such as build / simulate / generate."
    echo "Build method and press ENTER:"
    set build_method = $<
    if( "${build_method}" == "build" ) then
        mkdir -p ./build/build
        iverilog ./verilog_src/${module_name}.v -o ./build/build/${module_name}.o
        echo "${INFO}Build success."
        set pass = "y"
    else if( "${build_method}" == "simulate" ) then
        if( -f ./verilog_sim/${module_name}_sim.v ) then
            mkdir -p ./build/simulate
            iverilog ./verilog_src/${module_name}.v ./verilog_sim/${module_name}_sim.v -o ./build/simulate/${module_name}_sim.o
            chmod +x ./build/simulate/${module_name}_sim.o
            ./build/simulate/${module_name}_sim.o
            mv ./wave.vcd ./build/simulate/${module_name}_sim.vcd
            gtkwave ./build/simulate/${module_name}_sim.vcd
            rm -rf ./build
        else
            echo "${ERRO}Simulate source does not exist, sorry."
        endif
        set pass = "y"
    else
        echo "${WARN}Method is not supported, retry."
        set pass = "n"
    endif
end

exit 0
