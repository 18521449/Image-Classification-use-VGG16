module fifo_padding_image 
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 4)
	(	clk,
		rst_n,
		i_valid,
		i_data,
		o_data,
		o_valid
	);

localparam IMAGE_OUT_WIDTH = IMAGE_WIDTH + 2;
//-----------input and output port-----------//
input 								clk;
input 								rst_n;
input 								i_valid;
input 		[DATA_WIDTH-1:0]	i_data;
output reg 	[DATA_WIDTH-1:0] 	o_data;
output reg 							o_valid;
//-------------------------------------------//

//---------------------------------------------------------//
reg 		[DATA_WIDTH-1:0] 	ram_in 	[0:IMAGE_WIDTH*3-1];
//---------------------------------------------------------//

//----------------//
integer col = 0;
integer row = 0;
integer i;
integer pixel_count = -1;
integer mem_count = 0;
//---------------------------------------------------------//
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i=0; i<IMAGE_WIDTH*3; i=i+1) begin
			ram_in[i] = 'd0;
		end
	end
	else begin
		if (i_valid) begin
			ram_in[mem_count] = i_data;
			mem_count = mem_count + 1;
		end
		if (mem_count == 1) begin
			if (pixel_count < 0) begin
				pixel_count = 0;
			end
		end
		if (pixel_count < IMAGE_OUT_WIDTH**2 && pixel_count >= 0) begin
			if (row < IMAGE_OUT_WIDTH+1) begin
				if (col < IMAGE_OUT_WIDTH) begin
					col = col + 1;
				end
				else begin
					col = 1;
					row = row + 1;
				end
			end
			if (col == 1 || col == IMAGE_OUT_WIDTH || row == 0 || row == IMAGE_OUT_WIDTH) begin	
				o_data <= 'd0;
			end
			else begin
				if (mem_count > 0) begin
					o_data <= ram_in[0];
					for (i=0; i<IMAGE_WIDTH*3-1; i=i+1) begin
						ram_in[i] = ram_in[i+1];
					end
					mem_count = mem_count - 1;
				end
			end
			pixel_count = pixel_count + 1;
			o_valid <= 1'b1;
		end
		else begin
			row = 0;
			col = 1;
			pixel_count = -1;
			o_valid <= 0;
		end
	end
end
//---------------------------------------------------------//

endmodule
