`include "SPFP_ALU.sv"

module SPFP_ALU_tb;

	logic [31:0] n1;
	logic [31:0] n2;
	logic [1:0] s; // 00:sub, 01:add, 10:mul, 11:div
	logic [31:0] z;

	SPFP_ALU dut(.*);
	
	initial begin
		#5 n1 = 32'hcaf236e7; n2 = 32'hcb0735c7;
        #5 s = 2'b00;
        #5 s = 2'b01;
        #5 s = 2'b10;
        #5 s = 2'b11;
	end

endmodule

