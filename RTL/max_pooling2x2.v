module max_pooling2x2 
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 4)
	(	clk,
		rst_n,
		i_valid,
		i_data,
		o_data,
		o_valid
	);

//----------input and output port----------//
input 							clk;
input 							rst_n;
input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_data;
output 	[DATA_WIDTH-1:0] 	o_data;
output 							o_valid;
//-----------------------------------------//

//---------------------bus-----------------------//
wire [DATA_WIDTH-1:0] data [0:3];
//------------------------------------------------//
wire load_data_done;
//-----------component block----------//
// line_buffer
lines_buffer_maxpool 
		#(	.DATA_WIDTH(DATA_WIDTH),
			.IMAGE_WIDTH(IMAGE_WIDTH))
	LinesBuffer
		(	.clk(clk), 
			.rst_n(rst_n), 
			.i_valid(i_valid), 
			.i_data(i_data), 
			.o_data_0(data[0]),
			.o_data_1(data[1]),
			.o_data_2(data[2]),
			.o_data_3(data[3]),
			.o_valid(load_data_done)
		);
// max_pooling
max_fp_4input 
		#(	.DATA_WIDTH(DATA_WIDTH))
		max_pool
		(	.o_max(o_data), 
			.o_valid(o_valid),
			.i_data_0(data[0]),
			.i_data_1(data[1]), 
			.i_data_2(data[2]), 
			.i_data_3(data[3]), 
			.i_valid(load_data_done)
		);
//-------------------------------------//

endmodule


