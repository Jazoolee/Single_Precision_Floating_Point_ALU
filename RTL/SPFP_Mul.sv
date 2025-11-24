module SPFP_Mul(
	input logic [31:0] n1,
	input logic [31:0] n2,
	output logic [31:0] z	
	);

    logic sign_bit;
    logic [7:0] exponent;
    logic [22:0] significant;
    logic [47:0] init_mult; //initial multiplication without truncating

    assign sign_bit = n1[31] ^ n2[31];
    assign init_mult = 48'({1'b1 , n1[22:0]} * {1'b1 , n2[22:0]});

    always_comb begin
        //Checking to see number of resultant bits for advancing the exponent by one
        if (init_mult[47]) begin
            exponent = n1[30:23] + n2[30:23] - 8'd126;
            //Round to the nearest even logic
            if (init_mult[23:0] == 24'h800000) begin
                significant = init_mult[24] ? (init_mult[46:24] + 1'b1) : init_mult[46:24];
            end else begin
                significant = init_mult[23] ? (init_mult[46:24] + 1'b1) : init_mult[46:24];
            end

        end else begin
            exponent = n1[30:23] + n2[30:23] - 8'd127;

            if (init_mult[22:0] == 24'h400000) begin
                significant = init_mult[23] ? (init_mult[45:23] + 1'b1) : init_mult[45:23];
            end else begin
                significant = init_mult[22] ? (init_mult[45:23] + 1'b1) : init_mult[45:23];
            end

        end
    end

    assign z = {sign_bit, exponent, significant};

endmodule