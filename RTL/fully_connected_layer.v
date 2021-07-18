 `timescale 1ns/1ps
 module fully_connected_layer
 #(	parameter DATA_WIDTH = 32,
		parameter NUMBER_INPUT_NODE = 5,
		parameter NUMBER_OUTPUT_NODE = 3,
		parameter IN_DATA_FILE = "i_data_fc.txt",
		parameter OUT_DATA_FILE = "o_data_fc.txt",
		parameter IN_WEIGHT_FILE = "i_weight.txt",
		parameter OUT_WEIGHT_FILE = "o_weight.txt",
		parameter BIAS_FILE = "bias.txt")
	(	clk,
		rst_n,
		i_valid,
		o_valid
	);

//-------input and output port-------//
input 						clk;
input 						rst_n;
input 						i_valid;
output reg 					o_valid;
//-----------------------------------//

//----------------------------------------------------------------------------------//
reg 	[DATA_WIDTH-1:0]	weight_in	[NUMBER_INPUT_NODE*NUMBER_OUTPUT_NODE-1:0];
reg 	[DATA_WIDTH-1:0] 	bias_in 		[NUMBER_OUTPUT_NODE-1:0];
reg 	[DATA_WIDTH-1:0] 	bias;
reg 	[DATA_WIDTH-1:0]	weight_out	[NUMBER_INPUT_NODE-1:0];
reg 	[DATA_WIDTH-1:0] 	data_out 	[NUMBER_OUTPUT_NODE-1:0];
wire	[DATA_WIDTH-1:0] 	data_out_node;
//----------------------------------------------------------------------------------//

//----------------------------------------------------------------------------------//
reg valid_in;
reg valid_delay;
wire valid_out_node;
//----------------------------------------------------------------------------------//

integer i;
//-------------------------------------//
initial begin	
	$readmemh(IN_WEIGHT_FILE, weight_in);
	$readmemh(BIAS_FILE, bias_in);
	for (i=0; i<NUMBER_INPUT_NODE; i=i+1) begin
		weight_out[i] <= weight_in[i];
	end
	#1 $writememh(OUT_WEIGHT_FILE, weight_out);
	bias <= bias_in[0];
	o_valid <= 0;
end
//-------------------------------------//

//---------------------------------------------------------------------------//
integer node_count = -1;
always @(posedge clk) begin
	if (i_valid) begin	
		valid_in <= 1;
		node_count = 0;
	end
	else begin
		valid_in <= 0;
		if (node_count < NUMBER_OUTPUT_NODE && node_count >= 0) begin
			o_valid <= 0;
			if (valid_out_node) begin
				data_out[node_count] <= data_out_node;
				node_count = node_count + 1;
				for (i=0; i<NUMBER_INPUT_NODE; i=i+1) begin
					weight_out[i] <= weight_in[NUMBER_INPUT_NODE*node_count + i];
				end
				$writememh(OUT_WEIGHT_FILE, weight_out);
				bias <= bias_in[node_count];
				valid_delay <= 1;
			end
			else begin
				if (valid_delay) begin
					valid_delay <= 0;
					valid_in <=1;
				end
			end
		end
		else begin
			if (node_count > 0) begin
				node_count = -1;
				o_valid <= 1;
				$writememh(OUT_DATA_FILE, data_out);
			end
			else o_valid <= 0;
		end
	end
end

fully_connected_node 
	#(	.DATA_WIDTH(DATA_WIDTH),
		.NUMBER_INPUT_NODE(NUMBER_INPUT_NODE),
		.DATA_FILE(IN_DATA_FILE),
		.WEIGHT_FILE(OUT_WEIGHT_FILE))
	fc_node
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_in),
		.i_bias(bias),
		.o_data(data_out_node), 
		.o_valid(valid_out_node)
	);
	
endmodule
