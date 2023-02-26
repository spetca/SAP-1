module iregfile(
    input clk, 
    inout [7:0] dbus,
    input n_load,
    input n_en, 
    input clr,
    output [3:0] regout
);
/* 
regfile contains the controls for: 
    - A register (a_reg)
    - B register (b_reg)
    - Instruction register (i_reg)
    - loads/enables for each
    - dbus connection
*/
reg [7:0] t_regout = 8'b00000000;

always @(clr)
begin
    if(clr) begin
        t_regout <= 8'b0;
    end
end

always @(posedge clk)
begin

    if(!n_load) begin
         t_regout <= dbus;
    end
end 
// assign dbus based on enables
assign dbus   = !n_en ?  {4'b0000, regout[3:0]} : 8'bZZZZZZZZ;
assign regout = t_regout;
// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, iregfile);
end
endmodule