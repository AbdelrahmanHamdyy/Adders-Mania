module CSA #(parameter N = 32)
(
		a,b,
		sum,cout,overflow
);
    	input [N-1:0] a,b;
    	output cout,overflow;
    	output [N-1:0] sum;

	wire [N/4-1:0]of;

	wire [N/4-1:0] couts;
	wire [N/4-2:0] temp;

	ripple_carry_adder1 rc0(a[3:0],b[3:0],1'b0,couts[0],sum[3:0],of[0]);
	ripple_carry_adder1 rc[N/4-1:1](a[N-1:4],b[N-1:4],temp[N/4-2:0],couts[N/4-1:1],sum[N-1:4],of[N/4-1:1]);

	skipLogic skip0(a[3:0],b[3:0],1'b0,couts[0],temp[0]);
	skipLogic skip[N/4-2:1](a[N-5:4],b[N-5:4],temp[N/4-3:0],couts[N/4-2:1],temp[N/4-2:1]);
	skipLogic skipFinal(a[N-1:N-4],b[N-1:N-4],temp[N/4-2],couts[N/4-1],cout);

	assign overflow=of[N/4-1];

endmodule


// the logic of getting the total propagation (selector of the mux)
module skipLogic #(parameter N=4)
(
		a,b,cin,cout,
		out
);
	input [N-1:0] a,b;
	input cin,cout;
	output out;

	wire [N-1:0] p;
	wire finalP;
	wire e;
	
	genvar i;
	for(i=0; i<N; i=i+1) begin
		assign p[i]= a[i] ^ b[i];
	end
	assign finalP= &p;

	mux21 skipMux(cout,cin,finalP,out);
endmodule

module mux21 (in1,in2,selector,out);
	input in1,in2,selector;
	output out;

	assign out = selector?in2 :in1;
endmodule

module ripple_carry_adder1 #(parameter N = 4)
(
    in1, in2,cin,
    cout,sum,overflow
);
    input cin;
    input [N-1:0] in1,in2;
    output cout,overflow;
    output [N-1:0] sum;

    wire [N:0] C;
    assign C[0] = cin;
    assign cout = C[N];

    genvar i;
    generate
        for(i =0; i<N; i = i+1)
        begin
            fa fa(
                .cin(C[i]),
                .in1(in1[i]),
                .in2(in2[i]),
                .sum(sum[i]),
                .cout(C[i+1])
            );
        end
    endgenerate
    assign overflow = C[N-1] ^ C[N];

endmodule

module fa (
    in1,in2,cin,sum,cout
);

    input in1,in2,cin;
    output sum,cout;

    assign sum = in1 ^ in2 ^ cin;
    assign cout = (in1 & in2) | (in2 & cin) | (in1 & cin);
endmodule
