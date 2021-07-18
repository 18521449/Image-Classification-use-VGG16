module max_fp_2input #(parameter DATA_WIDTH = 32)(o_max, i_data_0, i_data_1, i_valid, o_valid);

input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_data_0;
input 	[DATA_WIDTH-1:0] 	i_data_1;
output 	[DATA_WIDTH-1:0] 	o_max;
output 							o_valid;

wire [DATA_WIDTH-1:0] sub;
addition_fp Subtrac (sub, i_data_0, {~i_data_1[DATA_WIDTH-1],i_data_1[DATA_WIDTH-2:0]}, i_valid, o_valid);
assign o_max = (o_valid) ? ((sub[DATA_WIDTH-1]) ? i_data_1 : i_data_0) : 32'dz;

endmodule


