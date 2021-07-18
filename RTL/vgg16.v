module vgg16 (clk, rst_n, i_valid, o_valid);

parameter DATA_WIDTH = 32;
parameter IMAGE_WIDTH = 112;
parameter NUMBER_OF_KERNEL = 8;
parameter IN_DATA_FILE = "image_data_in.txt";
parameter OUT_DATA_FILE = "data_out_vgg16.txt";

localparam OUT_DATA_FILE_B1 = "data_out_b1.txt";
localparam OUT_DATA_FILE_B2 = "data_out_b2.txt";
localparam OUT_DATA_FILE_B3 = "data_out_b3.txt";
localparam OUT_DATA_FILE_B4 = "data_out_b4.txt";
localparam OUT_DATA_FILE_B5 = "data_out_b5.txt";


//---------input and output port---------//
input 								clk;
input 								rst_n;
input 								i_valid;
output 	 							o_valid;
//---------------------------------------//

//---------------------------------------//
wire valid_out_block1;
wire valid_out_block2;
wire valid_out_block3;
wire valid_out_block4;
wire valid_out_block5;
//---------------------------------------//

//---------------------------------------//
block_2conv
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL),
		.NUMBER_OF_CHANNEL(3),
		.IN_DATA_FILE(IN_DATA_FILE),
		.OUT_DATA_FILE(OUT_DATA_FILE_B1),
		.IN_KERNEL_FILE_CONV1("block1_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block1_conv2_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block1_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block1_conv2_bias.txt"))
	block1
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(i_valid),
		.o_valid(valid_out_block1)
	);
//---------------------------------------//

//---------------------------------------//
block_2conv
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH/2),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL*2),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL),
		.IN_DATA_FILE(OUT_DATA_FILE_B1),
		.OUT_DATA_FILE(OUT_DATA_FILE_B2),
		.IN_KERNEL_FILE_CONV1("block2_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block2_conv2_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block2_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block2_conv2_bias.txt"))
	block2
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_block1),
		.o_valid(valid_out_block2)
	);
//---------------------------------------//

//---------------------------------------//
block_3conv
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH/4),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL*4),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL*2),
		.IN_DATA_FILE(OUT_DATA_FILE_B2),
		.OUT_DATA_FILE(OUT_DATA_FILE_B3),
		.IN_KERNEL_FILE_CONV1("block3_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block3_conv2_kernel.txt"),
		.IN_KERNEL_FILE_CONV3("block3_conv3_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block3_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block3_conv2_bias.txt"),
		.IN_KERNEL_BIAS_CONV3("block3_conv3_bias.txt"))
	block3
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_block2),
		.o_valid(valid_out_block3)
	);
//---------------------------------------//

//---------------------------------------//
block_3conv
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH/8),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL*8),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL*4),
		.IN_DATA_FILE(OUT_DATA_FILE_B3),
		.OUT_DATA_FILE(OUT_DATA_FILE_B4),
		.IN_KERNEL_FILE_CONV1("block4_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block4_conv2_kernel.txt"),
		.IN_KERNEL_FILE_CONV3("block4_conv3_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block4_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block4_conv2_bias.txt"),
		.IN_KERNEL_BIAS_CONV3("block4_conv3_bias.txt"))
	block4
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_block3),
		.o_valid(valid_out_block4)
	);
//---------------------------------------//

//---------------------------------------//
block_3conv
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH/16),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL*8),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL*4),
		.IN_DATA_FILE(OUT_DATA_FILE_B4),
		.OUT_DATA_FILE(OUT_DATA_FILE_B5),
		.IN_KERNEL_FILE_CONV1("block5_conv1_kernel.txt"),
		.IN_KERNEL_FILE_CONV2("block5_conv2_kernel.txt"),
		.IN_KERNEL_FILE_CONV3("block5_conv3_kernel.txt"),
		.IN_KERNEL_BIAS_CONV1("block5_conv1_bias.txt"),
		.IN_KERNEL_BIAS_CONV2("block5_conv2_bias.txt"),
		.IN_KERNEL_BIAS_CONV3("block5_conv3_bias.txt"))
	block5
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_block4),
		.o_valid(valid_out_block5)
	);
//---------------------------------------//

//---------------------------------------//
block_3fc
	#(	.DATA_WIDTH(DATA_WIDTH),
		/////// ---- parameter of fc 1
		.NUMBER_INPUT_NODE_FC1(576),
		.NUMBER_OUTPUT_NODE_FC1(64),
		.IN_DATA_FILE(OUT_DATA_FILE_B5),
		.IN_WEIGHT_FILE_FC1("weight_fc1.txt"),
		.BIAS_FILE_FC1("bias_fc1.txt"),
		/////// ---- parameter of fc 2
		.NUMBER_OUTPUT_NODE_FC2(64),
		.IN_WEIGHT_FILE_FC2("weight_fc2.txt"),
		.BIAS_FILE_FC2("bias_fc2.txt"),
		/////// ---- parameter of fc 3
		.NUMBER_OUTPUT_NODE_FC3(2),
		.OUT_DATA_FILE(OUT_DATA_FILE),
		.IN_WEIGHT_FILE_FC3("weight_fc3.txt"),
		.BIAS_FILE_FC3("bias_fc3.txt"))
	block_fc
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_block5),
		.o_valid(o_valid)
	);
endmodule
