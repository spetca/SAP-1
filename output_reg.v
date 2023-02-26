module output_reg(
    input [7:0] dbus, 
    input n_lo, 
    input clk, 
    output [7:0] bdisp
);

reg [7:0] t_outputreg = 8'b0000000;
always @(posedge clk)
begin
    if(~n_lo) t_outputreg <= dbus; 
end
assign bdisp = t_outputreg; 

initial begin
$dumpfile("dump.vcd");
$dumpvars(1, output_reg);
end
endmodule