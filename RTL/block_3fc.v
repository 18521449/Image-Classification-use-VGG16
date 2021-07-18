module block_3fc
	#(	parameter DATA_WIDTH = 32,
		/////// ---- parameter of fc 1
		parameter NUMBER_INPUT_NODE_FC1 = 576,
		parameter NUMBER_OUTPUT_NODE_FC1 = 64,
		parameter IN_DATA_FILE = "i_data_fc.txt",
		parameter IN_WEIGHT_FILE_FC1 = "weight_fc1.txt",
		parameter BIAS_FILE_FC1 = "bias_fc1.txt",
		/////// ---- parameter of fc 2
		parameter NUMBER_OUTPUT_NODE_FC2 = 64,
		parameter IN_WEIGHT_FILE_FC2 = "weight_fc2.txt",
		parameter BIAS_FILE_FC2 = "bias_fc2.txt",
		/////// ---- parameter of fc 3
		parameter NUMBER_OUTPUT_NODE_FC3 = 2,
		parameter OUT_DATA_FILE = "o_data_fc.txt",
		parameter IN_WEIGHT_FILE_FC3 = "weight_fc3.txt",
		parameter BIAS_FILE_FC3 = "bias_fc3.txt")
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);

localparam OUT_DATA_FILE_FC1 = "data_out_fc1.txt";
localparam OUT_DATA_FILE_FC2 = "data_out_fc2.txt";
localparam OUT_WEIGHT_FILE_FC1 = "kernel_out_fc1.txt";
localparam OUT_WEIGHT_FILE_FC2 = "kernel_out_fc2.txt";
localparam OUT_WEIGHT_FILE_FC3 = "kernel_out_fc3.txt";

//---------input and output port---------//
input 								clk;
input 								rst_n;
input 								i_valid;
output 	 							o_valid;
//---------------------------------------//

//-----------------fully_connected_1---------------//
fully_connected_layer
 #(	.DATA_WIDTH(DATA_WIDTH),
		.NUMBER_INPUT_NODE(NUMBER_INPUT_NODE_FC1),
		.NUMBER_OUTPUT_NODE(NUMBER_OUTPUT_NODE_FC1),
		.IN_DATA_FILE(IN_DATA_FILE),
		.OUT_DATA_FILE(OUT_DATA_FILE_FC1),
		.IN_WEIGHT_FILE(IN_WEIGHT_FILE_FC1),
		.OUT_WEIGHT_FILE(OUT_WEIGHT_FILE_FC1),
		.BIAS_FILE(BIAS_FILE_FC1))
	fc1
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(i_valid),
		.o_valid(valid_out_fc1)
	);
//-------------------------------------------------//

//-----------------fully_connected_2---------------//
fully_connected_layer
 #(	.DATA_WIDTH(DATA_WIDTH),
		.NUMBER_INPUT_NODE(NUMBER_OUTPUT_NODE_FC1),
		.NUMBER_OUTPUT_NODE(NUMBER_OUTPUT_NODE_FC2),
		.IN_DATA_FILE(OUT_DATA_FILE_FC1),
		.OUT_DATA_FILE(OUT_DATA_FILE_FC2),
		.IN_WEIGHT_FILE(IN_WEIGHT_FILE_FC2),
		.OUT_WEIGHT_FILE(OUT_WEIGHT_FILE_FC2),
		.BIAS_FILE(BIAS_FILE_FC2))
	fc2
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_fc1),
		.o_valid(valid_out_fc2)
	);
//-------------------------------------------------//

//-----------------fully_connected_3---------------//
fully_connected_layer
 #(	.DATA_WIDTH(DATA_WIDTH),
		.NUMBER_INPUT_NODE(NUMBER_OUTPUT_NODE_FC2),
		.NUMBER_OUTPUT_NODE(NUMBER_OUTPUT_NODE_FC3),
		.IN_DATA_FILE(OUT_DATA_FILE_FC2),
		.OUT_DATA_FILE(OUT_DATA_FILE),
		.IN_WEIGHT_FILE(IN_WEIGHT_FILE_FC3),
		.OUT_WEIGHT_FILE(OUT_WEIGHT_FILE_FC3),
		.BIAS_FILE(BIAS_FILE_FC3))
	fc3
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_fc2),
		.o_valid(o_valid)
	);
//-------------------------------------------------//

endmodule
	