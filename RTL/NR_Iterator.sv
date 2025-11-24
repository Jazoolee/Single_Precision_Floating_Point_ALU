//Calculates the successive approximation of the reciprocal of a number using Newton-Raphson method
module NR_Iterator(
	input logic [31:0] XI,
	input logic [31:0] D,
	output logic [31:0] XO	
	);

    logic [31:0] I1, I2; //Intermediate Wires

    SPFP_Mul M1(XI, D, I1);
    SPFP_AddSub A1(32'h40000000, {1'b0, I1[30:0]}, 0, I2); //32'h40000000 => 2 in IEEE754
    SPFP_Mul M2(XI, I2, XO);

endmodule
