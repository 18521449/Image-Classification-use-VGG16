module lines_buffer_maxpool
	#(	parameter DATA_WIDTH = 32,
		parameter IMAGE_WIDTH = 4)
	(	clk,
		rst_n,
		i_valid,
		i_data,
		o_data_0,
		o_data_1,
		o_data_2,
		o_data_3,
		o_valid
	);

//----------input and output port----------//
input 							clk;
input 							rst_n;
input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_data;
output 	[DATA_WIDTH-1:0] 	o_data_0;
output 	[DATA_WIDTH-1:0] 	o_data_1;
output 	[DATA_WIDTH-1:0] 	o_data_2;
output 	[DATA_WIDTH-1:0] 	o_data_3;
output reg 						o_valid;
//-----------------------------------------//

//--------------register to save data--------------//
reg [DATA_WIDTH-1:0] register [0:IMAGE_WIDTH+1];
//-------------------------------------------------//

//---------------------------------------------------------------//
integer row = 1; // hang 
integer col = 0; // cot
integer count;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin	
		for (count=0; count<IMAGE_WIDTH+2; count=count+1) begin
			register[count] = 32'd0;
		end
	end
	else begin
		if (i_valid) begin
			if (col < IMAGE_WIDTH) begin
				col = col + 1;
			end
			else begin
				if (row < IMAGE_WIDTH) begin
					row = row + 1;
					col = 1;
				end
				else begin
					row = 1;
					col = 1;
				end
			end
			for (count=IMAGE_WIDTH+1; count>0; count=count-1) begin
				register[count] = register[count-1];
			end
			register[0] = i_data;
			if (col >= 2 && row >= 2) begin
				if (col%2==0 && row%2==0) begin
					o_valid <= 1;
				end
				else o_valid <= 0;
			end
			else o_valid <= 0;
		end
		else begin
			o_valid <= 0;
		end
	end
end
//------------------------------------------------------------------//

//-----------------------assign output----------------------------//
assign o_data_0 = (o_valid) ? register[IMAGE_WIDTH+1] : 32'dz;
assign o_data_1 = (o_valid) ? register[IMAGE_WIDTH] : 32'dz;
assign o_data_2 = (o_valid) ? register[1] : 32'dz;
assign o_data_3 = (o_valid) ? register[0] : 32'dz;
//----------------------------------------------------------------//

endmodule

