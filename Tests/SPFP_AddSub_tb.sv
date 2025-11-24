module SPFP_AddSub_tb;

	logic [31:0] n1;
	logic [31:0] n2;
	logic add_or_sub; // 1:add, 0:sub
	logic [31:0] z	;

	SPFP_AddSub dut(.*);
	
	initial begin
		#5 n1 = 32'hfe15062d; n2 = 32'h7df35783; add_or_sub = 1;
	end

endmodule