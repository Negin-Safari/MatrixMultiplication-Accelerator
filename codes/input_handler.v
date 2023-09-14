module input_handler #(parameter n, parameter m)(clk, rst, start, dim0, dim1, dim2,
                                                 abufwrite, bbufwrite, aadrw, badrw);
  input clk, rst, start;
  input [n-1:0] dim0, dim1, dim2;
  
  output [m-1:0] aadrw, badrw;
  output reg abufwrite, bbufwrite;
  
  reg [1:0] ps, ns;
  
  reg [m-1:0] cntA, cntB1, cntB2;
  reg cenA, cenB1, init;
  wire coB1;
  wire [m-1:0] addo;
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      cntA <= 0;
    else if(init)
      cntA <= 0;
    else if(cenA)
      cntA <= cntA + 1;
    else
      cntA <= cntA;
  end
  
 // assign coA = (dim0 * dim1 - 1)? 1 : 0;
  
   always @(posedge clk, posedge rst) begin
    if(rst)
      cntB1 <= 0;
    else if(init | coB1)
      cntB1 <= 0;
    else if(cenB1)
      cntB1 <= cntB1 + 1;
    else
      cntB1 <= cntB1;
  end
  
  assign coB1 = (cntB1 == (dim1 - 1))? 1 : 0;
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      cntB2 <= 0;
    else if(init)
      cntB2 <= 0;
    else if(coB1)
      cntB2 <= cntB2 + 1;
    else
      cntB2 <= cntB2;
  end
  
  assign addo = (cntB1*dim2) + cntB2;
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      ps <= 0;
    else
      ps <= ns;  
  end
  
  always @(ps, start, addo, cntA) begin
    case(ps)
      0: ns = (start) ? 1 : 0;
      1: ns = 2;
      2: ns = ((cntA==(dim0*dim1))&(addo == ((dim1*dim2) - 1))) ? 0 : 2;
    endcase
  end
  
  always @(ps, addo, dim0, dim1, dim2) begin
    init = 0; cenA = 0; cenB1 = 0; abufwrite = 0; bbufwrite = 0; 
    case(ps) 
      1: begin  init = 1; end
      2: begin
        if(~(cntA==(dim0*dim1)))begin cenA = 1;  abufwrite = 1; end
        if(~(addo == ((dim1*dim2)))) begin cenB1=1;  bbufwrite = 1; end
      end
    endcase
  end
  assign aadrw = cntA;
  assign badrw = addo;
  
endmodule
  
  
  
  
