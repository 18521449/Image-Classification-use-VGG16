`timescale 1ns/1ps
module block3_tb();
parameter k =5;

reg clk, rst_n, i_valid;
wire o_valid;

initial begin
  clk <= 0;
  rst_n <= 1;
  i_valid <= 1;
  #k#k i_valid <= 0;
end

block_3conv
	#(	.DATA_WIDTH(32),
		.IMAGE_WIDTH(28),
		.NUMBER_OF_KERNEL(32),
		.NUMBER_OF_CHANNEL(16),
		.IN_DATA_FILE("data_out_b2.txt"),
		.OUT_DATA_FILE("data_out_b3.txt"),
		.IN_KERNEL_FILE_CONV1("block3_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block3_conv2_kernel.txt"),
		.IN_KERNEL_FILE_CONV3("block3_conv3_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block3_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block3_conv2_bias.txt"),
		.IN_KERNEL_BIAS_CONV3("block3_conv3_bias.txt"))
	block_3convolution
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
