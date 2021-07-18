module max_fp_4input #(parameter DATA_WIDTH = 32)(o_max, o_valid, i_data_0, i_data_1, i_data_2, i_data_3, i_valid);

input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_data_0;
input 	[DATA_WIDTH-1:0] 	i_data_1;
input 	[DATA_WIDTH-1:0] 	i_data_2;
input 	[DATA_WIDTH-1:0] 	i_data_3;
output 	[DATA_WIDTH-1:0] 	o_max;
output 							o_valid;

wire 		[DATA_WIDTH-1:0] 	max0, max1;
wire 								valid_max0, valid_max1;

max_fp_2input #(.DATA_WIDTH(DATA_WIDTH)) Max0 (max0, i_data_0, i_data_1, i_valid, valid_max0);
max_fp_2input #(.DATA_WIDTH(DATA_WIDTH)) Max1 (max1, i_data_2, i_data_3, i_valid, valid_max1);
max_fp_2input #(.DATA_WIDTH(DATA_WIDTH)) Max2 (o_max, max0, max1, valid_max0 & valid_max1, o_valid);

endmodule
