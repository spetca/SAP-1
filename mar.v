module mar(
    input n_lm, 
    input clk, 
    input [7:0] dbus, 
    output [3:0] ram0 
);

reg [3:0] t_reg; 
// MARlite always in run mode just transfer 
// from wbus to the ram input
always @(posedge clk)
begin
    if(!n_lm) t_reg <= dbus[3:0];
end

assign ram0 = t_reg; 
// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, mar);
end
endmodule