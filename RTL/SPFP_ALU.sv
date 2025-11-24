`include "SPFP_AddSub.sv"
`include "SPFP_Mul.sv"
`include "SPFP_Div.sv"

module SPFP_ALU(
	input logic [31:0] n1,
	input logic [31:0] n2,
	input logic [1:0] s,
	output logic [31:0] z	
	);

	logic [31:0] zAS, zM, zD;

	SPFP_AddSub A1(.n1(n1), .n2(n2), .add_or_sub(s[0]), .z(zAS));
	SPFP_Mul M1(.n1(n1), .n2(n2), .z(zM));
	SPFP_Div D1(.n1(n1), .n2(n2), .z(zD));

	always_comb begin
		if (s == 2'b00 || s == 2'b01) begin
			z = zAS;
		end else if (s == 2'b10) begin
			z = zM;
		end else if (s == 2'b11) begin
			z = zD;
		end else begin
			z = 32'b0;
		end
	end

endmodule