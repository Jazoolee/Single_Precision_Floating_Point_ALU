module SPFP_Div(
	input logic [31:0] n1,
	input logic [31:0] n2,
	output logic [31:0] z	
	);

    logic [31:0] D;
    logic [31:0] I1, X0, X1, X2, X3;
    logic [31:0] n2_D;

    //Exponent adjusted denominator
    assign D = {1'b0, 8'd126, n2[22:0]};

    //Newton Raphson method for calculating reciprocal
    SPFP_Mul M1(32'h3FF0_F0F1, D, I1); //32'h3FF0_F0F1 => 32/17 in IEEE754
    SPFP_AddSub A1(32'h4034_B4B5, {1'b0, I1[30:0]}, 0, X0); //32'h4034_B4B5 => 48/17 in IEEE754

    NR_Iterator N1(X0, D, X1);
    NR_Iterator N2(X1, D, X2);
    NR_Iterator N3(X2, D, X3);

    //Reciprocal of n2
    assign n2_D = {n2[31], X3[30:23]+8'd126-n2[30:23], X3[22:0]};

    //Multiplying the numerator with the calculated denominator
    SPFP_Mul M2(n1, n2_D, z);

endmodule