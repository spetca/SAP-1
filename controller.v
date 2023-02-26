module controller(
    input [3:0] instruction,
    input clk,
    output n_lo, cp, ep, n_lm, n_ce, n_li, n_ei, n_la, ea, su, eu, n_lb
);

reg [11:0] regmap;  // maps output ports of controllers to 1 12-bit word

// STATE MACHINE, just verilog so no enum
// 1. put PC on bus (EP=1), load MAR (lm = 0) "load pc into mar"
// 2. put RAM on bus (n_ce=0), load ireg (n_li = 0) "load instruction"
parameter FETCH0   = 3'b000; // 1
parameter FETCH1   = 3'b001; // 2
parameter FETCH2   = 3'b010;
parameter DECODE   = 3'b011; 
parameter EXECUTE0 = 3'b100; 
parameter EXECUTE1 = 3'b101; 
parameter IDLE     = 3'b111; 
reg [2:0] current_state = IDLE;
reg [2:0] next_state    = FETCH0;
reg ins_complete=1'b0;

always @(*)
begin
    case(current_state)
    FETCH0 : next_state = FETCH1; 
    FETCH1 : next_state = FETCH2; 
    FETCH2 : next_state = DECODE;
    DECODE : next_state = EXECUTE0;
    EXECUTE0 : 
    begin
        if(ins_complete)
        begin
            next_state   = FETCH0;
            ins_complete = 0; 
        end 
        else begin
            next_state = EXECUTE1; 
        end
    end
    EXECUTE1 : next_state = FETCH0; 
    endcase
end

// propogate state synchronous with system
always @(posedge clk)
begin
    current_state = next_state; 
end

// change control word between clock cycles 
always @(negedge clk)
begin
    case (current_state)
        // ep = 1, lm = 0 r
        // load pc into mar
        FETCH0: regmap = 12'b010000111111; 
        
        // n_ce = ram contents on bus
        // n_li = load ireg from bus
        // increment cp
        FETCH1: regmap = 12'b000001001111; 

        // increment pc
        FETCH2  : regmap = 12'b100001111111; 
        DECODE  : regmap = regmap & 12'b01111111111; 
        EXECUTE0: regmap = regmap & 12'b01111111111; 
        EXECUTE1: regmap = regmap & 12'b01111111111; 

    endcase 
end


always @(negedge clk)
begin
    case(instruction)
        4'b0001: 
        begin
        //lda, 
            if(current_state == DECODE) begin
                regmap =  12'b000000110111; // put ireg address on bus, mar read bus
                ins_complete = 1; 
            end
            if(current_state == EXECUTE0) begin 
                regmap = 12'b000001011011; // ram on bus, load A reg   
            end    
        end

        4'b0010: 
        begin
        //add
            if(current_state == DECODE)   regmap = 12'b000000110111; // put ireg address on bus, mar read bus
            if(current_state == EXECUTE0) regmap = 12'b000001011101; // ram on bus, load B reg , add  (eu=1)  
            if(current_state == EXECUTE1) regmap = 12'b000101111011; // alu on bus, load A    
        end

        4'b0011:
        //sub
        begin
            if(current_state == DECODE)   regmap = 12'b000000110111; // put ireg address on bus, mar read bus
            if(current_state == EXECUTE0) regmap = 12'b000011011101; // ram on bus, load B reg , subtract (eu=1)    
            if(current_state == EXECUTE1) regmap = 12'b000101111011; // alu on bus, load A     
        end

        4'b1110: begin
        //out
            if(current_state == DECODE) regmap = 12'b001001111110; // enable A, load Output
        end

        4'b1111: begin
        //hlt
        end
    endcase
end

// asignmentss
assign cp = regmap[11];  
assign ep = regmap[10]; 
assign ea  = regmap[9]; 
assign su = regmap[8]; 
assign eu  = regmap[7]; 
assign n_lm  = regmap[6]; 
assign n_ce  = regmap[5]; 
assign n_li = regmap[4]; 
assign n_ei = regmap[3]; 
assign n_la = regmap[2]; 
assign n_lb = regmap[1]; 
assign n_lo = regmap[0]; 


initial begin
$dumpfile("dump.vcd");
$dumpvars(1, controller);
end
endmodule