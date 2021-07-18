 module conv3x3_3D
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 5,
		parameter NUMBER_OF_CHANNEL = 3,
		parameter DATA_FILE = "image_data_in.txt",
		parameter KERNEL_FILE = "block1_conv1_kernel.txt")
	(	clk,
		rst_n,
		i_valid,
		i_bias,
		o_data,
		o_valid
	);

//---------input and output port---------//
input 								clk;
input 								rst_n;
input 								i_valid;
input 		[DATA_WIDTH-1:0]	i_bias;
output reg	[DATA_WIDTH-1:0] 	o_data;
output reg 							o_valid;
//---------------------------------------//

//---------------------------------------------------------------//
reg 	[DATA_WIDTH-1:0] 		total_data 		[NUMBER_OF_CHANNEL*(IMAGE_WIDTH**2)-1:0];
reg 	[DATA_WIDTH-1:0] 		data	 			[NUMBER_OF_CHANNEL-1:0];
reg 	[DATA_WIDTH*9-1:0]	kernel			[NUMBER_OF_CHANNEL-1:0];
reg 	[DATA_WIDTH-1:0]		bias;
//---------------------------------------------------------------//

//---------------------------------------------------------------//
wire 	[DATA_WIDTH-1:0] 		data_out_conv 	[NUMBER_OF_CHANNEL-1:0];
wire 	[DATA_WIDTH-1:0] 		data_out_temp;
wire 	[DATA_WIDTH-1:0] 		result_temp 	[NUMBER_OF_CHANNEL:0];
wire 	[NUMBER_OF_CHANNEL-1:0]	valid_out_conv ;
wire 	[NUMBER_OF_CHANNEL-1:0] valid_out_add;
wire valid_out_temp;
reg 									valid_in;
//---------------------------------------------------------------//

//-------------------------------------//
integer pixel_count, k;
always @(posedge clk) begin
	if (i_valid) begin	
		pixel_count = 0;
		bias <= i_bias;
		$readmemh(DATA_FILE, total_data);
		$readmemh(KERNEL_FILE, kernel);
	end
	else begin
		if (pixel_count < IMAGE_WIDTH**2) begin
			for (k=0; k<NUMBER_OF_CHANNEL; k=k+1) begin
				data[k] <= total_data[(IMAGE_WIDTH**2)*k + pixel_count];
				valid_in <= 1;
			end
			pixel_count = pixel_count + 1;
		end
		else valid_in <= 0;
	end
end

//
assign result_temp[0] = 'd0;
genvar i;
generate 
	for (i=0; i<NUMBER_OF_CHANNEL; i=i+1) begin: conv3x3_2D_block
		conv3x3_2D 
		#(	.DATA_WIDTH(DATA_WIDTH),
			.IMAGE_WIDTH(IMAGE_WIDTH))
		conv_2D
		(	.clk(clk),
			.rst_n(rst_n),
			.i_valid(valid_in),
			.i_data(data[i]),
			.i_kernel(kernel[i]),
			.o_data(data_out_conv[i]),
			.o_valid(valid_out_conv[i])
		);
		addition_fp add
		(	.Sum(result_temp[i+1]), 
			.InA(data_out_conv[i]), 
			.InB(result_temp[i]), 
			.valid_in(valid_out_conv[i]), 
			.valid_out(valid_out_add[i])
		);
	end
endgenerate

addition_fp add_bias (data_out_temp, result_temp[NUMBER_OF_CHANNEL], bias, &valid_out_add, valid_out_temp);

always @(posedge clk) begin	
	if (valid_out_temp) begin
		o_data <= (data_out_temp[31]) ? 'd0 : data_out_temp; //ReLU
		o_valid <= 1'b1;
	end 
	else begin
		o_data <= 'dz;
		o_valid <= 1'b0;
	end
end

endmodule
