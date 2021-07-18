module fully_connected_node 
	#(	parameter DATA_WIDTH = 32,
		parameter NUMBER_INPUT_NODE = 5,
		parameter DATA_FILE = "data_fc.txt",
		parameter WEIGHT_FILE = "weight.txt")
	(	clk,
		rst_n,
		i_valid,
		i_bias,
		o_data, 
		o_valid
	);
//-----------------input and output port-----------------//
input 								clk;
input 								rst_n;
input 								i_valid;
input 		[DATA_WIDTH-1:0] 	i_bias;
output reg	[DATA_WIDTH-1:0] 	o_data;
output reg 							o_valid;
//-------------------------------------------------------//

//--------------------------------------------------------------------//
reg 			[DATA_WIDTH-1:0] 	data 				[NUMBER_INPUT_NODE-1:0];
reg 			[DATA_WIDTH-1:0] 	weight 			[NUMBER_INPUT_NODE-1:0];
reg 			[DATA_WIDTH-1:0] 	bias;
wire 			[DATA_WIDTH-1:0] 	data_out_mul 	[NUMBER_INPUT_NODE-1:0];
wire 			[DATA_WIDTH-1:0] 	result_temp		[NUMBER_INPUT_NODE:0];
wire 			[DATA_WIDTH-1:0] 	data_out_temp;
//--------------------------------------------------------------------//

//---------------------------------------------------------//
reg valid_in;
wire [NUMBER_INPUT_NODE-1:0] valid_out_mul; 
wire [NUMBER_INPUT_NODE-1:0] valid_out_add;
wire valid_out_temp;
//---------------------------------------------------------//

//-------------------------------------------------------//
assign result_temp[0] = 'd0;
//-------------------------------------------------------//
genvar i;
generate
	for (i=0; i<NUMBER_INPUT_NODE; i=i+1) begin: node_generate
		multiple_fp mul 
			(	.Out(data_out_mul[i]), 
				.InA(data[i]), 
				.InB(weight[i]), 
				.valid_in(valid_in), 
				.valid_out(valid_out_mul[i]));
		addition_fp add
			(	.Sum(result_temp[i+1]), 
				.InA(data_out_mul[i]), 
				.InB(result_temp[i]), 
				.valid_in(valid_out_mul[i]), 
				.valid_out(valid_out_add[i]));
	end
endgenerate

addition_fp add_bias (data_out_temp, result_temp[NUMBER_INPUT_NODE], bias, &valid_out_add, valid_out_temp);

always @(posedge clk) begin	
	if (i_valid) begin
		$readmemh(DATA_FILE, data);
		$readmemh(WEIGHT_FILE, weight);
		bias <= i_bias;
		valid_in <= 1;
	end
	else valid_in <= 0;
	if (valid_out_temp) begin
		o_data <= data_out_temp;
		o_valid <= 1;
	end 
	else begin
		o_data <= 'dz;
		o_valid <= 0;
	end
end

endmodule

