`timescale 1ns/1ps
module block_fc_tb();
parameter k =5;

reg clk, rst_n, i_valid;
wire o_valid;

initial begin
  clk <= 0;
  rst_n <= 1;
  i_valid <= 1;
  #k#k i_valid <= 0;
end

block_3fc
	#(	.DATA_WIDTH(32),
		/////// ---- parameter of fc 1
		.NUMBER_INPUT_NODE_FC1(576),
		.NUMBER_OUTPUT_NODE_FC1(64),
		.IN_DATA_FILE("data_out_b5.txt"),
		.IN_WEIGHT_FILE_FC1("weight_fc1.txt"),
		.BIAS_FILE_FC1("bias_fc1.txt"),
		/////// ---- parameter of fc 2
		.NUMBER_OUTPUT_NODE_FC2(64),
		.IN_WEIGHT_FILE_FC2("weight_fc2.txt"),
		.BIAS_FILE_FC2("bias_fc2.txt"),
		/////// ---- parameter of fc 3
		.NUMBER_OUTPUT_NODE_FC3(2),
		.OUT_DATA_FILE("data_out_vgg16.txt"),
		.IN_WEIGHT_FILE_FC3("weight_fc3.txt"),
		.BIAS_FILE_FC3("bias_fc3.txt"))
	fc
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


