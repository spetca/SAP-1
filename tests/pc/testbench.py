# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotb.binary import BinaryRepresentation, BinaryValue

@cocotb.test()
async def controller_test(dut):
   
    dut.cp.value = 0
    dut.ep.value = 1
    dut.n_clr = 0
  
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    await RisingEdge(dut.clk) # toggle clock to latch it
    dut.n_clr = 0
    dut.ep.value = 1

    dut.cp.value = 1
    await RisingEdge(dut.clk) # toggle clock to latch it
    dut.n_clr = 1
    dut.ep.value = 0

    await RisingEdge(dut.clk) # toggle clock to latch it
    await RisingEdge(dut.clk) # toggle clock to latch it

    await RisingEdge(dut.clk) # toggle clock to latch it
    dut.cp.value = 0
    dut.ep.value = 1
    await RisingEdge(dut.clk) # toggle clock to latch it
    dut.ep.value = 0

    await RisingEdge(dut.clk) # toggle clock to latch it
    await RisingEdge(dut.clk) # toggle clock to latch it

