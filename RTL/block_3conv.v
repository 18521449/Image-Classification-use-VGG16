module block_3conv
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 5,
		parameter NUMBER_OF_KERNEL = 8,
		parameter NUMBER_OF_CHANNEL = 3,
		parameter IN_DATA_FILE = "i_data.txt",
		parameter OUT_DATA_FILE = "o_data.txt",
		parameter IN_KERNEL_FILE_CONV1 = "block3_conv1_kernel.txt",
		parameter IN_KERNEL_FILE_CONV2 = "block3_conv2_kernel.txt",
		parameter IN_KERNEL_FILE_CONV3 = "block3_conv3_kernel.txt",
		parameter IN_KERNEL_BIAS_CONV1 = "block3_conv1_bias.txt",
		parameter IN_KERNEL_BIAS_CONV2 = "block3_conv2_bias.txt",
		parameter IN_KERNEL_BIAS_CONV3 = "block3_conv3_bias.txt")
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);

localparam OUT_DATA_FILE_CONV1 = "data_out_conv1.txt";
localparam OUT_DATA_FILE_CONV2 = "data_out_conv2.txt";
localparam OUT_DATA_FILE_CONV3 = "data_out_conv3.txt";
localparam OUT_KERNEL_FILE_CONV1 = "kernel_out_conv1.txt";
localparam OUT_KERNEL_FILE_CONV2 = "kernel_out_conv2.txt";
localparam OUT_KERNEL_FILE_CONV3 = "kernel_out_conv3.txt";

//---------input and output port---------//
input 								clk;
input 								rst_n;
input 								i_valid;
output 	 							o_valid;
//---------------------------------------//

//------------------------------------------------------//
wire valid_out_conv1, valid_out_conv2, valid_out_conv3;
//------------------------------------------------------//


//-------------------conv1---------------------//
conv3x3_3D_top
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL),
		.NUMBER_OF_CHANNEL(NUMBER_OF_CHANNEL),
		.IN_DATA_FILE(IN_DATA_FILE),
		.OUT_DATA_FILE(OUT_DATA_FILE_CONV1),
		.IN_KERNEL_FILE(IN_KERNEL_FILE_CONV1),
		.OUT_KERNEL_FILE(OUT_KERNEL_FILE_CONV1),
		.BIAS_FILE(IN_KERNEL_BIAS_CONV1))
	conv1
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(i_valid),
		.o_valid(valid_out_conv1)
	);
//--------------------------------------------//

//------------------conv2---------------------//
conv3x3_3D_top
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL),
		.IN_DATA_FILE(OUT_DATA_FILE_CONV1),
		.OUT_DATA_FILE(OUT_DATA_FILE_CONV2),
		.IN_KERNEL_FILE(IN_KERNEL_FILE_CONV2),
		.OUT_KERNEL_FILE(OUT_KERNEL_FILE_CONV2),
		.BIAS_FILE(IN_KERNEL_BIAS_CONV2))
	conv2
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_conv1),
		.o_valid(valid_out_conv2)
	);
//--------------------------------------------//

//------------------conv3---------------------//
conv3x3_3D_top
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL),
		.NUMBER_OF_CHANNEL(NUMBER_OF_KERNEL),
		.IN_DATA_FILE(OUT_DATA_FILE_CONV2),
		.OUT_DATA_FILE(OUT_DATA_FILE_CONV3),
		.IN_KERNEL_FILE(IN_KERNEL_FILE_CONV3),
		.OUT_KERNEL_FILE(OUT_KERNEL_FILE_CONV3),
		.BIAS_FILE(IN_KERNEL_BIAS_CONV3))
	conv3
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_conv2),
		.o_valid(valid_out_conv3)
	);
//--------------------------------------------//

//------------max_pooling + ReLU--------------//
max_pooling2x2_base
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_KERNEL(NUMBER_OF_KERNEL),
		.IN_DATA_FILE(OUT_DATA_FILE_CONV3),
		.OUT_DATA_FILE(OUT_DATA_FILE))
	max_pooling
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_conv3),
		.o_valid(o_valid)
	);
//---------------------------------------------//

endmodule
