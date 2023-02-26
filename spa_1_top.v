module spa_1_top(
    input clk,
    input clr,
    input prog_mode,
    input [7:0] ram_din
);

// the main bus
wire [7:0] wbus; 

wire [7:0] a_out_wire;
wire [7:0] b_out_wire; 

wire [3:0] wire_ram_address; 
wire [3:0] wire_ins_to_control; 

reg [7:0] bdisp; 
// controller sequencers
wire clk, n_clk, n_lo, n_clr, cp, ep, n_lm, n_ce, n_li, n_ei, n_la,n_lb, ea, su, eu; 
assign n_clear = ~clr; 
// LHS of WBUS
/**************************
***          PC         ***
***************************/
pc u_pc(.cp(cp), 
        .clk(clk), 
        .n_clr(n_clr), 
        .ep(ep),
        .pcout(wbus));

/**************************
***         MAR         ***
***************************/
mar u_mar(.n_lm(n_lm), 
          .clk(clk), 
          .dbus(wbus), 
          .o_marnibble(wire_ram_address));

/**************************
***         RAM         ***
***************************/
ram u_ram(.clk(clk), 
          .n_ce(n_ce), 
          .prog_mode(prog_mode),
          .din(ram_din), 
          .address(wire_ram_address), 
          .dout(wbus));

                
 /**************************
***        I REG        ***
**********************(*****/
iregfile u_ireg(.clk(clk), 
                .iregdbus(wbus),
                .n_load(n_li),
                .n_en(n_ei),
                .clr(clr),
                .iregout(wire_ins_to_control));

 /**************************
***      CONTROLLER      ***
**********************(*****/
controller u_controller(.instruction(wire_ins_to_control), 
                        .clk(clk),
                        .cp(cp),
                        .ep(ep),
                        .n_lm(n_lm),
                        .n_ce(n_ce),
                        .n_li(n_li),
                        .n_ei(n_ei),
                        .n_la(n_la),
                        .ea(ea),
                        .su(su),
                        .eu(eu),
                        .n_lo(n_lo),
                        .n_lb(n_lb));
// RHS OF WBUS 
// RHS OF WBUS
/**************************
***        A REG        ***
***************************/
regfile u_areg (.clk(clk), 
                .dbus(wbus),
                .n_load(n_la),
                .n_en(ea),
                .regout(a_out_wire));
 /**************************
***          ALU         ***
****************************/              
alu u_alu0(.clk(clk),
           .dbus(wbus),
           .eu(eu),
           .su(su), 
           .areg(a_out_wire), 
           .breg(b_out_wire));
/**************************
***        B REG        ***
***************************/
regfile u_breg (.clk(clk), 
                .dbus(wbus),
                .n_load(n_lb),
                .n_en('0),
                .regout(b_out_wire));
 /**************************
***      OUTPUT REG      ***
****************************/

output_reg u_oreg(.dbus(wbus),
                  .n_lo(n_lo),
                  .clk(clk),
                  .bdisp(bdisp));

initial begin
$dumpfile("dump.vcd");
$dumpvars(1, spa_1_top);
end
endmodule 