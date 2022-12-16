module booth_algorithm_tb;

  // Parameters
  localparam  N = 32;

  // Ports
  reg clk = 0;
  reg rst = 0;
  reg [N-1 : 0] a;
  reg [N-1 : 0 ] b;
  wire [ (N*2) - 1 : 0] c;

  booth_algorithm 
  #(
    .N (
        N )
  )
  booth_algorithm_dut (
    .clk (clk ),
    .rst (rst ),
    .a (a ),
    .b (b ),
    .c  ( c)
  );

  initial begin
    begin
        rst = 1;
        a = -15;
        b =10 ; 
        #10;
        rst = 0;
        #10*34;

      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
