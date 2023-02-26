# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotb.binary import BinaryRepresentation, BinaryValue

@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.n_en.value = 1
   
    dut.n_load.value = 1
    dut.clr.value = 0
    await RisingEdge(dut.clk) # toggle clock to latch it

    # load a, b, and ins
    dut.dbus.value = 7  # put 7 on the dbus
    dut.n_load.value = 0 # enable a to read it
    await RisingEdge(dut.clk) # toggle clock to latch it
    dut.n_load.value = 1 # enable a to read it
    # load a, b, and ins
    dut.dbus.value = 6  # put 7 on the dbus
    dut.n_load.value = 0 # enable a to read it
    await RisingEdge(dut.clk) # toggle clock
    dut.dbus.value = BinaryValue('zzzzzzzz', 8)
    dut.n_load.value = 1 # enable a to read it
    await RisingEdge(dut.clk) # toggle clock
    dut.n_en.value = 0 # read out from a
    await RisingEdge(dut.clk) # toggle clock
    dut.n_en.value = 1 # read out from a
    await RisingEdge(dut.clk) # toggle clock
    await RisingEdge(dut.clk) # toggle clock


