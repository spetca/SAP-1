# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryRepresentation, BinaryValue

@cocotb.test()
async def basic_count(dut):
    # generate a clock
    dut.clr.value =  1
    
    # write ram, confirmed this works
    # initialize all ram locations
    for i in range(16):
        dut.u_ram.mem[i].value = BinaryValue('00000000',8)
    # initialize specifics
    dut.u_ram.mem[0].value = BinaryValue('00011110',8)
    dut.u_ram.mem[1].value = BinaryValue('00101111',8)
    dut.u_ram.mem[2].value = BinaryValue('11100000',8)
    dut.u_ram.mem[14].value = 2
    dut.u_ram.mem[15].value = 2

    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    await RisingEdge(dut.clk)
    for i in range(18):
       await RisingEdge(dut.clk) # toggle clock to latch it

  
