`timescale 1ns/1ps
module max_pooling2x2_base
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 4,
		parameter NUMBER_OF_KERNEL = 8,
		parameter IN_DATA_FILE = "i_data.txt",
		parameter OUT_DATA_FILE = "o_data.txt")
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);
localparam OUT_IMAGE_WIDTH = IMAGE_WIDTH / 2;
//----------input and output port----------//
input 							clk;
input 							rst_n;
input 							i_valid;
output reg						o_valid;
//-----------------------------------------//

//----------------------------------------bus--------------------------------------//
reg 	[DATA_WIDTH-1:0] 	data_in 			[NUMBER_OF_KERNEL*(IMAGE_WIDTH**2)-1:0];
reg  	[DATA_WIDTH-1:0] 	data_out 		[NUMBER_OF_KERNEL*(OUT_IMAGE_WIDTH**2)-1:0];
reg 	[DATA_WIDTH-1:0] 	data_in_maxp 	[NUMBER_OF_KERNEL-1:0];
wire 	[DATA_WIDTH-1:0] 	data_out_maxp 	[NUMBER_OF_KERNEL-1:0];
//---------------------------------------------------------------------------------//

//---------------------valid-----------------------//
reg 									valid_in_maxp;
wire	[NUMBER_OF_KERNEL-1:0]	valid_out_maxp;
//------------------------------------------------//

integer in_pixel_count, out_pixel_count, k;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	end
	else begin
		o_valid <= 0;
		if (i_valid)  begin
			$readmemh(IN_DATA_FILE, data_in);
			in_pixel_count = 0;
			out_pixel_count = 0;
		end
		if (in_pixel_count < IMAGE_WIDTH**2 && in_pixel_count >= 0) begin
			for (k=0; k<NUMBER_OF_KERNEL; k=k+1) begin
				data_in_maxp[k] = data_in[(IMAGE_WIDTH**2)*k + in_pixel_count];
			end
			valid_in_maxp <= 1;
			in_pixel_count = in_pixel_count + 1;
		end
		else begin
			in_pixel_count = -1;
		end
		if (out_pixel_count < OUT_IMAGE_WIDTH**2 && out_pixel_count >= 0) begin
			if (&valid_out_maxp) begin
				for (k=0; k<NUMBER_OF_KERNEL; k=k+1) begin
					data_out[(OUT_IMAGE_WIDTH**2)*k + out_pixel_count] = data_out_maxp[k];
				end
				out_pixel_count = out_pixel_count + 1;
			end
		end
		else begin
			if (out_pixel_count > 0) begin 
				out_pixel_count = -1;
				o_valid <= 1;
				#1 $writememh(OUT_DATA_FILE, data_out);
			end
		end
	end
end	

genvar i;
generate
	for (i=0; i<NUMBER_OF_KERNEL; i=i+1) begin: max_pooling_generate
		max_pooling2x2 
			#(	.DATA_WIDTH(DATA_WIDTH),
				.IMAGE_WIDTH(IMAGE_WIDTH))
			max_pooling
			(	.clk(clk),
				.rst_n(rst_n),
				.i_valid(valid_in_maxp),
				.i_data(data_in_maxp[i]),
				.o_data(data_out_maxp[i]),
				.o_valid(valid_out_maxp[i])
			);
	end
endgenerate


endmodule


