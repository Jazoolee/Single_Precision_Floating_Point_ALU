module SPFP_AddSub(
	input logic [31:0] n1,
	input logic [31:0] n2,
	input logic add_or_sub, // 1:add, 0:sub
	output logic [31:0] z	
	);

	logic operation, sign_bit;
	logic [7:0] exp_diff, big_exp;
	logic [31:0] small_no, big_no;
	logic [24:0] sig_add_sub;
	logic [24:0] shifted_sig_add_sub;
	integer i;
	
	//Determines the operation and the sign bit
	always_comb begin
		//Add funtion is selected
		if (add_or_sub) begin
			if (n1[31] == n2[31]) begin
				operation = 1;
				sign_bit = n1[31];
			end else begin
				operation = 0;
				if (n1[30:23] > n2[30:23]) begin
					sign_bit = n1[31];
				end else if (n1[30:23] == n2[30:23]) begin
					if (n1[22:0] > n2[22:0]) begin
						sign_bit = n1[31];
					end else begin
						sign_bit = n2[31];
					end
				end else begin
					sign_bit = n2[31];
				end
			end
		//Sub function is selected
		end else begin
			if (n1[31] == n2[31]) begin
				operation = 0;
				if (n1[30:23] > n2[30:23]) begin
					sign_bit = n1[31];
				end else if (n1[30:23] == n2[30:23]) begin
					if (n1[22:0] > n2[22:0]) begin
						sign_bit = n1[31];
					end else begin
						sign_bit = (n1[22:0] == n2[22:0]) ? 1'b0 : ~n2[31];
					end
				end else begin
					sign_bit = ~n2[31];
				end
			end else begin
				operation = 1;
				sign_bit = n1[31];
			end
		end	
	end

	//Calculates the exponent difference, and sorts the two numbers into big and small
	always_comb begin		
		if (n1[30:23] > n2[30:23]) begin
			exp_diff = n1[30:23] - n2[30:23];
			small_no = n2;
			big_no = n1;
			big_exp = n1[30:23];
		end else if (n1[30:23] == n2[30:23]) begin
			exp_diff = n1[30:23] - n2[30:23];
			big_exp = n1[30:23];
			small_no = (n1[22:0] >= n2[22:0]) ? n2 : n1;
			big_no = (n1[22:0] >= n2[22:0]) ? n1 : n2;
		end else begin
			exp_diff = n2[30:23] - n1[30:23];
			small_no = n1;
			big_no = n2;
			big_exp = n2[30:23];
		end
	end

	//Performs the final addition/subtraction
	always_comb begin
		//Adder
		if (operation) begin
			if (exp_diff == 0) begin
				sig_add_sub = {1'b1 , big_no[22:0]} + ({1'b1 , small_no[22:0]});
			end else begin
				sig_add_sub = {1'b1 , big_no[22:0]} + (({1'b1 , small_no[22:0]} + small_no[exp_diff-1]) >> exp_diff); //Numbers are rounded before shiting
			end
			i = 0;
			shifted_sig_add_sub = 0;
			if (sig_add_sub[24:23] == 2'b01) begin
				z = {sign_bit, big_exp, sig_add_sub[22:0]};
			end else begin
				z = {sign_bit, 8'(big_exp+1), 23'((sig_add_sub[23:0] + sig_add_sub[0]) >> 1)};
			end
		//Subtractor
		end else begin
			if (exp_diff == 0) begin
				sig_add_sub = {1'b1 , big_no[22:0]} - ({1'b1 , small_no[22:0]});
			end else begin
				sig_add_sub = {1'b1 , big_no[22:0]} - (({1'b1 , small_no[22:0]} + small_no[exp_diff-1]) >> exp_diff);
			end
			//Calculates the leading number of zeros for normalization
			for (i = 23; i > 0; i = i-1 ) begin
				if (sig_add_sub[i] == 0) begin
					continue;
				end else begin
					break;
				end
			end
			//Normalizing
			shifted_sig_add_sub = sig_add_sub[24:0]<<(2+23-i);
			z = {sign_bit, 8'(big_exp+i-23), shifted_sig_add_sub[24:2]};
		end
	end

endmodule