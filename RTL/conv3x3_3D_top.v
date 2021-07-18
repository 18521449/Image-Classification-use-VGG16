 `timescale 1ns/1ps
 module conv3x3_3D_top
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 5,
		parameter NUMBER_OF_KERNEL = 8,
		parameter NUMBER_OF_CHANNEL = 3,
		parameter IN_DATA_FILE = "i_data.txt",
		parameter OUT_DATA_FILE = "o_data.txt",
		parameter IN_KERNEL_FILE = "i_kernel.txt",
		parameter OUT_KERNEL_FILE = "o_kernel.txt",
		parameter BIAS_FILE = "bias.txt")
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);

//---------input and output port---------//
input 								clk;
input 								rst_n;
input 								i_valid;
output reg 							o_valid;
//---------------------------------------//

//----------------------------------------------------------------------------------//
reg 	[DATA_WIDTH*9-1:0]	kernel_in		[NUMBER_OF_KERNEL*NUMBER_OF_CHANNEL-1:0];
reg 	[DATA_WIDTH-1:0] 		bias_in 			[NUMBER_OF_KERNEL-1:0];
reg 	[DATA_WIDTH-1:0] 		bias;
reg 	[DATA_WIDTH*9-1:0]	kernel_out		[NUMBER_OF_CHANNEL-1:0];
reg 	[DATA_WIDTH-1:0] 		data_out 		[NUMBER_OF_KERNEL*(IMAGE_WIDTH**2)-1:0];
//----------------------------------------------------------------------------------//

//---------------------------------------------------------------//
wire 	[DATA_WIDTH-1:0] 		data_out_conv;
wire 								valid_out_conv;
reg 								valid_in;
reg 								valid_delay;
reg 								valid_delay_kernel;
//---------------------------------------------------------------//
integer i;
//-------------------------------------//

//---------------------------------------------------------------------------//
integer kernel_count;
integer pixel_count;
always @(posedge clk) begin
	if (i_valid) begin	
		o_valid <= 0;
		kernel_count = 0;
		pixel_count = 0;
		$readmemh(IN_KERNEL_FILE, kernel_in);
		$readmemh(BIAS_FILE, bias_in);
		for (i=0; i<NUMBER_OF_CHANNEL; i=i+1) begin
			kernel_out[i] <= kernel_in[NUMBER_OF_KERNEL*i];
		end
		bias <= bias_in[0];
		#1 $writememh(OUT_KERNEL_FILE, kernel_out);
		valid_delay <= 1;
	end
	else begin
		if (valid_delay) begin
			valid_delay <= 0;
			valid_in <= 1;
		end
		else valid_in <= 0;
		if (valid_out_conv) begin
			data_out[(IMAGE_WIDTH**2)*kernel_count + pixel_count] <= data_out_conv;
			pixel_count = pixel_count + 1;
		end
		if (kernel_count < NUMBER_OF_KERNEL) begin
			if (kernel_count == NUMBER_OF_KERNEL-1 && pixel_count == IMAGE_WIDTH**2) begin
				pixel_count = -1;
				kernel_count = -1; 
				o_valid <= 1;
				valid_in <= 0;
				#1 $writememh(OUT_DATA_FILE, data_out);
			end
			else o_valid <= 0;
			if (pixel_count == IMAGE_WIDTH**2 && kernel_count >= 0) begin
				pixel_count = 0;
				kernel_count = kernel_count + 1;
				for (i=0; i<NUMBER_OF_CHANNEL; i=i+1) begin
					kernel_out[i] <= kernel_in[NUMBER_OF_KERNEL*i + kernel_count];
				end
				#1 $writememh(OUT_KERNEL_FILE, kernel_out);
				bias <= bias_in[kernel_count];
				valid_delay_kernel <= 1;
			end
			else begin
				if (valid_delay_kernel) begin
					valid_delay_kernel <= 0;
					valid_in <= 1;
				end
			end
		end
	end
end


//---------------------------------------------------------------------------//
//
conv3x3_3D
	#(	.DATA_WIDTH(DATA_WIDTH),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.NUMBER_OF_CHANNEL(NUMBER_OF_CHANNEL),
		.DATA_FILE(IN_DATA_FILE),
		.KERNEL_FILE(OUT_KERNEL_FILE))
	conv_3D
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_in),
		.i_bias(bias),
		.o_data(data_out_conv),
		.o_valid(valid_out_conv)
	);
	
endmodule
