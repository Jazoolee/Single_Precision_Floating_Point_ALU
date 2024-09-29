module SPFP_AddSub_tb;

	logic [31:0] n1;
	logic [31:0] n2;
	logic add_or_sub; // 1:add, 0:sub
	logic [31:0] z	;
	//logic clk = 0;
	
	//always begin
	//	#10 clk = ~clk;
	//end

	SPFP_AddSub dut(.*);
	
	initial begin
		#5 n1 = 32'hcaf236e7; n2 = 32'hcb0735c7; add_or_sub = 0;
	end

endmodule