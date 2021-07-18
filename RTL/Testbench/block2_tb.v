`timescale 1ns/1ps
module block2_tb();
parameter k =5;

reg clk, rst_n, i_valid;
wire o_valid;

initial begin
  clk <= 0;
  rst_n <= 1;
  i_valid <= 1;
  #k#k i_valid <= 0;
end

block_2conv
	#(	.DATA_WIDTH(32),
		.IMAGE_WIDTH(56),
		.NUMBER_OF_KERNEL(16),
		.NUMBER_OF_CHANNEL(8),
		.IN_DATA_FILE("data_out_b1.txt"),
		.OUT_DATA_FILE("data_out_b2.txt"),
		.IN_KERNEL_FILE_CONV1("block2_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block2_conv2_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block2_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block2_conv2_bias.txt"))
	block_2convolution
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
