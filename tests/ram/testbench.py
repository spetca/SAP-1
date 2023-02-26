# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryRepresentation, BinaryValue


@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    block_delay = 1
    cnt = 1
    dut.n_ce.value = 0
    for i in range(16*2+2):
        await RisingEdge(dut.clk); 
        #if(i>35):
            #dut.n_ce = 1
        if(i>=16):
            dut.prog_mode.value = 0
        else:
            dut.prog_mode.value = 1
            dut.din.value = i + 1

        dut.address.value = i % 16

        if(i>=18):
            assert dut.dout.value.integer == cnt , "ram result is incorrect: %s != %s" % (str(dut.dout.value.integer), cnt)
            cnt = cnt+1
  

@cocotb.test()
async def preload_count(dut):
    # write ram, confirmed this works
    dut.mem[0].value = BinaryValue('00011110',8)
    dut.mem[1].value = BinaryValue('00101111',8)
    dut.mem[2].value = BinaryValue('11100000',8)
    for i in range(3,16):
        dut.mem[i].value = BinaryValue('00000000',8)

    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    for i in range(16):
        dut.address.value = i

        if(i==2):
            assert dut.dout.value.integer == 30 , "ram result is incorrect: %s != %s" % (str(dut.dout.value.integer), 30)
        if(i==3):
            assert dut.dout.value.integer == 47 , "ram result is incorrect: %s != %s" % (str(dut.dout.value.integer), 47)
        if(i==4):
            assert dut.dout.value.integer == 224 , "ram result is incorrect: %s != %s" % (str(dut.dout.value.integer), 224)
        await RisingEdge(dut.clk); 

   