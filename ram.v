// 16 Byte memory
module ram(
    input clk, 
    input n_ce, 
    input prog_mode,
    input [7:0] din,
    input [3:0] address,
    output [7:0] dout
);

reg [7:0] mem [16]; 
reg [7:0] t_ramreg = 8'b00000000; 
always @(posedge clk)
begin
    if(prog_mode) mem[address] <= din;
end
always @(*)
begin
    t_ramreg <= mem[address]; 
end

assign dout = ~n_ce ? t_ramreg : 8'bZZZZZZZZ;

// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, ram);
end
endmodule