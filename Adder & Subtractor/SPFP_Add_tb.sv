`define N_TESTS 100000

module SPFP_Add_tb;

	logic clk = 0;
	
	logic [31:0] n1;
	logic [31:0] n2;
	logic [31:0] z;
	logic add_or_sub;

	logic [31:0] Expected_result;
	logic [95:0] testVector [`N_TESTS-1:0];
	logic test_stop_enable;

	integer mcd;
	integer test_n = 0;
	integer pass   = 0;
	integer error  = 0;

	SPFP_AddSub dut(.*);

	always #5 clk = ~clk;

	initial begin
		add_or_sub = 1'b1;
		$readmemh("C:/Users/Jazoolee/Desktop/Quartus/SPFP_ALU/TestVectorAddition", testVector);
		mcd = $fopen("C:/Users/Jazoolee/Desktop/Quartus/SPFP_ALU/ResultsAdd.txt");
	end 

	always @(posedge clk) begin
			{n1,n2,Expected_result} = testVector[test_n];
			test_n = test_n + 1'b1;

			#2;
			if (z[31:11] == Expected_result[31:11])
				begin
					$display ("TestPassed Test Number -> %d",test_n);
					pass = pass + 1'b1;
				end

			if (z[31:11] != Expected_result[31:11])
				begin
					$fdisplay (mcd,"Test Failed Expected Result = %h, Obtained result = %h, Test Number -> %d",Expected_result,z,test_n);
					error = error + 1'b1;
				end
			
			if (test_n >= `N_TESTS) 
			begin
				$fdisplay(mcd,"Completed %d tests, %d passed and %d fails.", test_n, pass, error);
				test_stop_enable = 1'b1;
			end
	end

	always @(posedge test_stop_enable) begin
		$fclose(mcd);
		$finish;
	end

endmodule