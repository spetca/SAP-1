module pc(
    input cp,
    input clk, 
    input n_clr,
    input ep,
    output [7:0] pcout
);
wire const_out; 
reg [3:0] t_pc =4'b0000;
always @(*)
begin
    if(!n_clr) t_pc <= 4'b0000; 
end

always @(posedge clk)
begin
        if(cp) t_pc <= t_pc + 1; 
end
assign const_out = {4'b0000, t_pc} ;

assign pcout = ep ? const_out : 8'bZZZZZZZZ; 
// Dump waves
initial begin
$dumpfile("dump.vcd");
$dumpvars(1, pc);
end
endmodule