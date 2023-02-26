module alu(
    input clk, 
    inout [7:0] dbus, 
    input eu, 
    input su, 
    input signed [7:0] areg,
    input signed [7:0] breg
);

reg [7:0] t_dbus = 8'b00000000;

always @(*)
begin
    if(!eu) 
        t_dbus <= areg+breg; 
    else 
        t_dbus <= areg-breg; 
end

// if we are su enabled drive the bus 
// otherwise high z from this modu
assign dbus = su ? t_dbus : 8'bZZZZZZZZ; 


// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, alu);
end
endmodule