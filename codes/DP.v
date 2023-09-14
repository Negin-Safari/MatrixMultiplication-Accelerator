module DP #(parameter n, parameter m)(clk, rst, aadr, badr, init0reg, ldreg, abufread, abufwrite,
                               bbufread, bbufwrite, abufdatain, bbufdatain, d0, d1, d2, dim0, dim1,
                                dim2, loaddim, result, res_we, aadrw, badrw);
  
  input clk, rst, abufread, abufwrite, bbufread, bbufwrite, init0reg, ldreg, loaddim, res_we;
  input [m-1:0] aadr, badr, aadrw, badrw;
  input [n-1:0] abufdatain, bbufdatain, d0, d1, d2;
  
  output [n-1:0] dim0, dim1, dim2;
  
  output [2*n-1:0] result;
  
  wire [n-1:0] abufdatain, abufdataout, bbufdatain, bbufdataout;
  
  wire [2*n-1:0] multout, addout, regout;
  
  
  buffer #(n, m) ABUFF(clk, rst, abufread, abufwrite, aadrw, aadr, abufdatain, abufdataout);
  
  buffer #(n, m) BBUFF(clk, rst, bbufread, bbufwrite, badrw, badr, bbufdatain, bbufdataout);
  
  
  assign multout = abufdataout * bbufdataout;
  
  assign addout = multout + regout;
  
  
  register #(2*n) REG(clk, rst, init0reg, ldreg, addout, regout);
  
  assign result = regout;
  
  register #(n) D0dim(clk, rst, 1'b0, loaddim, d0, dim0);
  
  register #(n) D1dim(clk, rst, 1'b0, loaddim, d1, dim1);
  
  register #(n) D2dim(clk, rst, 1'b0, loaddim, d2, dim2);
  
  RAM #(2*n, m) RESRAM(clk, rst, res_we, 1'b0, {m{1'bz}}, result,);
  
endmodule
  
  
