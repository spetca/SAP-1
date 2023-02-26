# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotb.binary import BinaryRepresentation, BinaryValue

@cocotb.test()
async def controller_test(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.iclr.value = 0
    dut.instruction.value = 0
   
  
    await RisingEdge(dut.clk) # toggle clock to latch it
 
    await RisingEdge(dut.clk) # toggle clock to latch it
    await RisingEdge(dut.clk) # toggle clock to latch it


