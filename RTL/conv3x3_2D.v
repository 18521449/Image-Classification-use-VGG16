module conv3x3_2D
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 5)
	(	clk,
		rst_n,
		i_valid,
		i_data,
		i_kernel,
		o_data,
		o_valid
	);

//----------input and output port----------//
input 								clk;
input 								rst_n;
input 								i_valid;
input 	[DATA_WIDTH-1:0] 		i_data;
input 	[DATA_WIDTH*9-1:0] 	i_kernel;
output 	[DATA_WIDTH-1:0] 		o_data;
output 								o_valid;	
//-----------------------------------------//

//---------------------bus-----------------------//
wire 		[DATA_WIDTH-1:0]		data_fifo_out;
wire 		[DATA_WIDTH-1:0] 		kernel 	[0:8];
wire 		[DATA_WIDTH-1:0] 		data 	[0:8];
wire 		[DATA_WIDTH-1:0] 		data_out_temp;
wire 		[DATA_WIDTH-1:0] 		mul [0:8];
wire 		[DATA_WIDTH-1:0] 		sum [0:6];
//------------------------------------------------//
//----------------------valid---------------------//
wire valid_fifo_out, load_data_done;
wire mul_done[0:8];
wire add1_done [0:3];
wire add2_done [0:1];
wire add3_done, add4_done;
wire add1_valid, add2_valid, add3_valid, add4_valid;
//------------------------------------------------//
//----------------------assign kernel----------------------//
assign kernel[0] = i_kernel[DATA_WIDTH*1-1:DATA_WIDTH*0];
assign kernel[1] = i_kernel[DATA_WIDTH*2-1:DATA_WIDTH*1];
assign kernel[2] = i_kernel[DATA_WIDTH*3-1:DATA_WIDTH*2];
assign kernel[3] = i_kernel[DATA_WIDTH*4-1:DATA_WIDTH*3];
assign kernel[4] = i_kernel[DATA_WIDTH*5-1:DATA_WIDTH*4];
assign kernel[5] = i_kernel[DATA_WIDTH*6-1:DATA_WIDTH*5];
assign kernel[6] = i_kernel[DATA_WIDTH*7-1:DATA_WIDTH*6];
assign kernel[7] = i_kernel[DATA_WIDTH*8-1:DATA_WIDTH*7];
assign kernel[8] = i_kernel[DATA_WIDTH*9-1:DATA_WIDTH*8];
//---------------------------------------------------------//

//------------fifo padding-----------//
fifo_padding_image 
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH))
	fifo_padding
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(i_valid),
		.i_data(i_data),
		.o_data(data_fifo_out),
		.o_valid(valid_fifo_out)
	);
//-----------------------------------//

//---------------lines buffer convolution-------------//
lines_buffer_conv 
		#(	.DATA_WIDTH(DATA_WIDTH),
			.IMAGE_WIDTH(IMAGE_WIDTH+2))
	LinesBuffer
		(	.clk(clk), 
			.rst_n(rst_n), 
			.i_valid(valid_fifo_out), 
			.i_data(data_fifo_out), 
			.o_data_0(data[0]),
			.o_data_1(data[1]),
			.o_data_2(data[2]),
			.o_data_3(data[3]),
			.o_data_4(data[4]),
			.o_data_5(data[5]),
			.o_data_6(data[6]),
			.o_data_7(data[7]),
			.o_data_8(data[8]),
			.o_valid(load_data_done)
		);
//-----------------------------------------------------//

//------------------------------assign valid-------------------------------------//	
assign add1_valid = mul_done[0] & mul_done[1] & mul_done[2] & mul_done[3] & mul_done[4] & mul_done[5] & mul_done[6] & mul_done[7] & mul_done[8];
assign add2_valid = add1_done[0] & add1_done[1] & add1_done[2] & add1_done[3];
assign add3_valid = add2_done[0] & add2_done[1];
assign add4_valid = add3_done;
//--------------------------------------------------------------------------------//

//-------------------------generate multiple and addition--------------------------//
genvar i;
generate 
	for (i=0; i<9; i=i+1) begin: mul_generate
		multiple_fp muls (mul[i], kernel[i], data[i], load_data_done, mul_done[i]);
	end 
endgenerate

generate 
	for (i=0; i<4; i=i+1) begin: add1_generate
		addition_fp adds1 (sum[i], mul[7-i], mul[i], add1_valid, add1_done[i]);
	end
endgenerate

generate 
	for (i=0; i<2; i=i+1) begin: add2_generate
		addition_fp adds2 (sum[i+4], sum[3-i], sum[i], add2_valid, add2_done[i]);
	end
endgenerate

addition_fp adds3 (sum[6], sum[5], sum[4], add3_valid, add3_done);
addition_fp adds4 (data_out_temp, sum[6], mul[8], add4_valid, add4_done);


//-------------------assign output-----------------//
assign o_valid = add4_done;
assign o_data = (o_valid) ? data_out_temp : 32'dz;
//-------------------------------------------------//

endmodule 


