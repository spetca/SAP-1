module regfile(
    input clk, 
    inout [7:0] dbus,
    input n_load,
    input n_en, 
    output reg [7:0] regout
);
//regfile is an abstraction for A and B reg 

reg [7:0] t_regout = 8'b0000000; 

always @(posedge clk)
begin
    if(~n_load) t_regout <= dbus;
end 
// assign dbus based on enables
assign dbus = n_en ? regout : 8'bZZZZZZZZ;
assign regout = t_regout; 


// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, regfile);
end

endmodule