module mar(
    input n_lm, 
    input clk, 
    input [7:0] dbus, 
    output [3:0] o_marnibble 
);

reg [3:0] t_marreg; 
// MARlite always in run mode just transfer 
// from wbus to the ram input
always @(posedge clk)
begin
    if(!n_lm) t_marreg <= dbus[3:0];
end

assign o_marnibble = t_marreg; 
// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, mar);
end
endmodule