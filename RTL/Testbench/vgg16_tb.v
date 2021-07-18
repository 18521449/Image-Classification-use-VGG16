`timescale 1ns/1ps
module vgg16_tb();
parameter k =5;

reg clk, rst_n, i_valid;
wire o_valid;

initial begin
  clk <= 0;
  rst_n <= 1;
  i_valid <= 1;
  #k#k i_valid <= 0;
end

vgg16 VGG16_tb
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);

always @(posedge clk) begin
  if (o_valid) begin
    #k#k#k#k $finish;
  end
end
  
always @(*) begin
  #k clk <= ~clk;
end

endmodule




