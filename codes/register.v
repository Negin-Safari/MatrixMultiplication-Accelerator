module register #(parameter n)(clk, rst, init0, load, datain, dataout);
  
  input clk, rst, init0, load;
  
  input [n-1:0] datain;
  
  output reg [n-1:0] dataout;
  
  always @(posedge clk, posedge rst) begin
    if(rst)
      dataout = 0;
    else if(init0)
      dataout = 0;
    else if(load)
      dataout = datain;
    else
      dataout = dataout;
  end
  
endmodule
