module CU #(parameter n, parameter m)(clk, rst, start, dim0, dim1, dim2, loaddim, aadr, badr, init0reg, ldreg,
                                     abufread, bbufread, valid, done);
  
  
  input clk, rst, start;
  input [n-1:0] dim0, dim1, dim2;
  
  output reg abufread, bbufread, init0reg, ldreg, valid, done, loaddim;
  output [m-1:0] aadr, badr;
  
  reg [3:0] ns, ps;
  reg inita1, cena1, ldga1, initb1, cenb1, ldgb1,inita2, cena2, ldga2;
  reg [m-1:0] initvala1, stepa1, goala1, initvalb1, stepb1, goalb1, initvala2, stepa2, goala2;
  wire coa1, cob1, coa2;
  wire [m-1:0] cnta1, cntb1, cnta2;
  
  
  
  
  Counter #(m) CA1(clk, rst, inita1, cena1, initvala1, stepa1, ldga1, goala1, cnta1, coa1);
  
  Counter #(m) CB1(clk, rst, initb1, cenb1, initvalb1, stepb1, ldgb1, goalb1, cntb1, cob1);
  
  Counter #(m) CA2(clk, rst, inita2, cena2, initvala2, stepa2, ldga2, goala2, cnta2, coa2); ///
  
  always @(dim2) begin
    initvala2 = 0;
    stepa2 = 1;
    goala2 = dim2;
    ldga2 = 1;
    
  end
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      ps <= 0;
    else
      ps <= ns;
  end
  
  always @(ps, start, initvala1, coa1, cnta2) begin
    case(ps)
      0: ns = (start)? 1 : 0;
      1: ns = 2;
      2: ns = 5;
      5: ns = (coa1 == 1)? 6 : 5; 
      6: ns = (cnta2 == (dim2 -1))? 7 : 5;
      7: ns = (initvala1 == (dim0 * dim1))? 8 : 5;
      8: ns = 0;  
    endcase  
  end
  
  
  assign aadr = cnta1;
  assign badr = cntb1; 
  
  
  always @(ps) begin // cntinp, coa2, cob1, coa1, cnta1, cntb1
    inita1 = 0; initb1 = 0; inita2 = 0; init0reg = 0; ldreg = 0; valid = 0; done = 0;
    ldga1 = 0; ldgb1 = 0; loaddim = 0; //badr = {m{1'bz}}; aadr = {m{1'bz}};
    stepa1 = 1; stepb1 = dim2; cena1 = 0; cenb1 = 0; cena2 = 0; abufread = 0; bbufread = 0;
    case(ps)
      0: begin end
        
      1: begin loaddim = 1;end
        
      2: begin
        inita1 = 1; initvala1 = 0; goala1 = dim1 -1 ; ldga1 = 1; //////
        initb1 = 1; initvalb1 = 0; goalb1 = ((dim1)*dim2) - 1; ldgb1 = 1; /////
        inita2 = 1; 
        init0reg = 1;
      end
      
      5: begin
        abufread = 1; bbufread = 1;
        cena1 = 1;
        cenb1 = 1;
        ldreg = 1;
      end
      
      6: begin
        cena2 = 1; valid = 1;
        initb1 = 1; initvalb1 = initvalb1 + 1; goalb1 = initvalb1 + (dim1)*dim2 - 1; ldgb1 = 1; init0reg = 1;
      end
      
      7: begin
        inita1 = 1; initvala1 = initvala1 + dim1; goala1 = initvala1 + dim1 - 1; ldga1 = 1;
        initb1 = 1; initvalb1 = 0; goalb1 = (dim1)*dim2 - 1; ldgb1 = 1; init0reg = 1;
      end
      
      
          
      8: begin done = 1; end
    
    endcase
  end
  
  
  
endmodule
  
  
  
  
  
  
  
  
  
  
   
  
