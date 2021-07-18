module lines_buffer_conv 
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
		o_data_4,
		o_data_5,
		o_data_6,
		o_data_7,
		o_data_8,
		o_valid
	);

//--------input and output port--------//
input 							clk;
input 							rst_n;
input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_data;
output 	[DATA_WIDTH-1:0] 	o_data_0;
output 	[DATA_WIDTH-1:0] 	o_data_1;
output 	[DATA_WIDTH-1:0] 	o_data_2;
output 	[DATA_WIDTH-1:0] 	o_data_3;
output  	[DATA_WIDTH-1:0] 	o_data_4;
output  	[DATA_WIDTH-1:0] 	o_data_5;
output  	[DATA_WIDTH-1:0] 	o_data_6;
output  	[DATA_WIDTH-1:0] 	o_data_7;
output  	[DATA_WIDTH-1:0] 	o_data_8;
output reg						o_valid;
//-------------------------------------//

//--------------register to save data--------------//
reg [DATA_WIDTH-1:0] register [0:2*IMAGE_WIDTH+2];
//-------------------------------------------------//

//---------------------------------------------------------------//
integer row = 1; // hang 
integer col = 0; // cot
integer count;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin	
		for (count=0; count<2*IMAGE_WIDTH+3; count=count+1) begin
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
			for (count=2*IMAGE_WIDTH+2; count>0; count=count-1) begin
				register[count] = register[count-1];
			end
			register[0] = i_data;
			if (col >= 3 && row >=3) begin
				if (col <= IMAGE_WIDTH) begin
					o_valid <= 1;
				end
			end
			else begin
				o_valid <= 0;
			end
		end
		else o_valid <= 0;
	end
end
//------------------------------------------------------------------//

//-----------------------assign output----------------------------//
assign o_data_0 = (o_valid) ? register[IMAGE_WIDTH*2+2] : 32'dz;
assign o_data_1 = (o_valid) ? register[IMAGE_WIDTH*2+1] : 32'dz;
assign o_data_2 = (o_valid) ? register[IMAGE_WIDTH*2+0] : 32'dz;
assign o_data_3 = (o_valid) ? register[IMAGE_WIDTH+2] : 32'dz;
assign o_data_4 = (o_valid) ? register[IMAGE_WIDTH+1] : 32'dz;
assign o_data_5 = (o_valid) ? register[IMAGE_WIDTH+0] : 32'dz;
assign o_data_6 = (o_valid) ? register[2] : 32'dz;
assign o_data_7 = (o_valid) ? register[1] : 32'dz;
assign o_data_8 = (o_valid) ? register[0] : 32'dz;
//----------------------------------------------------------------//

endmodule

