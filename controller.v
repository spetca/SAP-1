module controller(
    input [3:0] instruction,
    input clk,
    output n_lo, cp, ep, n_lm, n_ce, n_li, n_ei, n_la, ea, su, eu, n_lb
);

reg [11:0] regmap;  // maps output ports of controllers to 1 12-bit word

// 0,1,2 fetch clocks
// 3,4 execute clocks
reg [2:0] state = 3'b000; 

// increment state every negedge clk 
// so on posedge clk we take the next state
// fetch cycle
always @(negedge clk)
begin
    state <= state + 1; 
    case (state)
        // ep = 1, lm = 0 r
        // load pc into mar
        3'b000: regmap <= 12'b010000111111; 
        
        // n_ce = ram contents on bus
        // n_li = load ireg from bus
        3'b001: regmap <= 12'b000001001111; 

        // cp = increment pc
        3'b010: regmap   <= 12'b100001111111;

        default : regmap <= 12'b000001111111;
    endcase 
end

always @(negedge clk)
begin
    case(instruction)
        4'b0001: 
        begin
        //lda, 
            if(state == 3'b011) regmap <= regmap & 12'b000000110111; // put ireg address on bus, mar read bus
            if(state == 3'b100) begin 
                regmap <= regmap & 12'b000001011011; // ram on bus, load A reg   
                state <= 3'b000; 
            end    
        end

        4'b0010: 
        begin
        //add
            if(state == 3'b011) regmap <= regmap & 12'b000000110111; // put ireg address on bus, mar read bus
            if(state == 3'b100) regmap <= regmap & 12'b000001011101; // ram on bus, load B reg , add  (eu=1)  
            if(state == 3'b101) begin 
                regmap <= regmap & 12'b000101111011; // alu on bus, load A    
                state <= 3'b000; 
            end 
        end

        4'b0011:
        begin
            if(state == 3'b011) regmap <= regmap & 12'b000000110111; // put ireg address on bus, mar read bus
            if(state == 3'b100) regmap <= regmap & 12'b000011011101; // ram on bus, load B reg , subtract (eu=1)    
            if(state == 3'b101) begin 
                regmap <= regmap & 12'b000101111011; // alu on bus, load A     
                state <= 3'b000; 
            end
        end
        //sub

        4'b1110: begin
        //out
            if(state == 3'b011) begin 
                regmap <= regmap & 12'b001001111111; // enable A, load Output
                state <= 3'b000; 
            end
        end

        4'b1111: begin
        //hlt

        end
        default :  begin
            //regmap <= {1'b0, regmap[10:0]}; // advance pc?
            //state <= 3'b000;
        end

    endcase
end
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