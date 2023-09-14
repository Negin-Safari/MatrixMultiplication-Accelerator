// Negin Safari
module MatrixMult #(parameter n = 8, parameter m = 10)(clk, rst, start, abufdatain, bbufdatain, d0, d1, d2, valid, result, done);
  
  input clk, rst, start;
  input [n-1:0] abufdatain, bbufdatain, d0, d1, d2;
  
  output valid, done;
  output [2*n-1:0] result;
  
  wire [n-1:0] dim0, dim1, dim2;
  wire abufread, abufwrite, bbufread, bbufwrite, init0reg, ldreg, loaddim;
  wire [m-1:0] aadr, badr, aadrw, badrw;
  
  
  
  DP #(n, m) dpath (clk, rst, aadr, badr, init0reg, ldreg, abufread, abufwrite,
                               bbufread, bbufwrite, abufdatain, bbufdatain, d0, d1, d2,
                                dim0, dim1, dim2, loaddim, result, valid, aadrw, badrw);


  
  CU #(n, m) cntrlr(clk, rst, start, dim0, dim1, dim2, loaddim, aadr, badr, init0reg, ldreg,
                                     abufread, bbufread, valid, done);
                                     
                                     
  input_handler #(n, m) inpH(clk, rst, start, d0, d1, d2,
                                                 abufwrite, bbufwrite, aadrw, badrw);
  
  
  
endmodule

module TB();
  
  reg clk = 0, rst, start;
  reg [8-1:0] abufdatain, bbufdatain, d0 = 2, d1 = 5, d2 = 3;
  
  wire valid, done;
  wire [2*8-1:0] result;
  
  reg [8-1:0] inpa [0:((2**10)-1)]; //((2**m)-1)
  reg [8-1:0] inpb [0:((2**10)-1)]; //((2**m)-1)
  
  
  initial begin
    $readmemh("ainp.txt", inpa);
    $readmemh("binp.txt", inpb);
  end 
  

  
  MatrixMult #(8, 10) uut(clk, rst, start, abufdatain, bbufdatain, d0, d1, d2, valid, result, done);

  
  initial repeat(300) #5 clk = ~clk;
  
  integer j;
  
  
  initial begin
    start = 0;
    rst = 1;
    #12;
    rst = 0;
    start = 1;
    #10;
    start = 0;
    #4;
   for(j =0; j<5*3; j= j+1) begin
      if(j<(2*5)) abufdatain = inpa[j];
      bbufdatain = inpb[j];
      #10;
    end
    #100;
  end
  
  
  
endmodule


module test_TB();
  
  reg [8-1:0] abufdatain, bbufdatain;
  
  reg [8-1:0] inpa [0:((2**10)-1)]; //((2**m)-1)
  reg [8-1:0] inpb [0:((2**10)-1)]; //((2**m)-1)
  
  integer i,j;
  
  initial begin
    $readmemh("ainp.txt", inpa);
    $readmemh("binp.txt", inpb);
  end 
  
  initial begin
    //#16;
    for(j =0; j<5*3; j= j+1) begin
      if(j<(2*5)) abufdatain = inpa[j];
      bbufdatain = inpb[j];
      #10;
    end
  end
  
  
  
endmodule
  
  
  
  
