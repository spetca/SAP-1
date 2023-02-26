# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.areg.value = 2
    dut.breg.value = 1
    dut.eu.value = 0
    dut.su.value = 0
    await RisingEdge(dut.clk); 
    dut.eu.value = 1
    await RisingEdge(dut.clk); 
    dut.areg.value = 2
    dut.eu.value = 0
    dut.su.value = 1
    await RisingEdge(dut.clk); 
    dut.su.value = 1
    await RisingEdge(dut.clk); 
    dut.su.value = 1
    await RisingEdge(dut.clk); 
    dut.su.value = 0
    await RisingEdge(dut.clk); 
