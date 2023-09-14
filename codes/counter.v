`timescale 1ns/1ns
module Counter #(parameter m)(clk, rst, init, cen, initval, step, ldg, goalin, cnt, co);
  
  input clk, rst, init, cen, ldg;
  input [m-1:0] goalin, initval, step;
  
  output co;
  output reg [m-1:0] cnt;
  
  reg [m-1:0] goal;
  
  always @(posedge clk, posedge rst)begin
    if(rst)
      cnt = 0;
    else if(init || co)
      cnt = initval;
    else if(cen)
      cnt = cnt + step;  
    else
      cnt = cnt;
  end
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      goal = 0;
    else if(ldg) begin
      goal = goalin;
    end
  end
  
  
  assign co = (cnt == goal)? 1 : 0;
  
endmodule

module counter_tb();
  
  reg clk = 0, rst, init, cen;
  reg [8-1:0] initval, step = 2, goal;
  
  wire co;
  wire [8-1:0] cnt;
  
  Counter #(8) uut(clk, rst, init, cen, initval, step, goal, cnt, co);
  
  
  initial repeat(50) #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #6;
    rst = 0;
    #12;
    cen = 1;
    #200;
    cen = 0;
    init = 1;
    #10;
    init = 0; 
  end
  
 endmodule 



module testCU(clk, rst, start);
  
  input clk, rst, start;
  
  reg init, cen, ldg;
  reg [8-1:0] initval, step, goal;
  
  wire co;
  wire [8-1:0] cnt;
  
  wire dn;
  
  Counter #(8) uut(clk, rst, init, cen, initval, step, ldg, goal, cnt, co);
  
  reg [1:0] ps, ns;
  
  
  always @(posedge clk, posedge rst)begin
    if(rst)
      ps <= 0; 
    else
      ps <= ns;
  end
  
  always@(ps, start, dn)begin
    case(ps)
      0: ns = (start) ? 1: 0;
      1: ns = (dn) ? 0:1;
    endcase
  end
  
  always @(ps, cnt, co) begin
    init = 0; cen = 0; ldg = 0;
    case(ps)
      0: begin init = 1; initval = 0; goal = 6; step = 3; ldg =1; end
      1: begin
        cen = 1;
        if(co == 1) begin
          init = 1;
          initval = initval + 1;
          goal = 6 + initval; ldg =1;
        end
      end
  endcase
    
  end
  
  assign dn = (initval == 3)? 1 : 0;
  
endmodule


module test_tb();
  
  reg clk = 0, rst , start;
  
  testCU uut(clk, rst, start);
  
  
  initial repeat(100) #5 clk = ~clk;
  
  initial begin
    start = 0;
    rst = 1;
    #6;
    rst = 0;
    #12;
    start = 1;
    #12;
    start = 0;
  end
  
 endmodule 
  
  
  
  
  
 

