
module myBufwFIR
(
	input	[13:0]  data,
	input	  rdclk,
	input	  rdreq,
	input	  wrclk,
	input	  wrreq,
	input rst_n,
	output	[17:0]  q,
	output data_valid,
	output [1:0] source_err,
	output	  rdempty,
	output	  wrfull,
	output [13:0] monitor_fifout

);


wire [13:0] fifo_out;


assign monitor_fifout = fifo_out;


fifo	fifo_inst (
	.data ( data ),
	.rdclk ( rdclk ),
	.rdreq ( rdreq ),
	.wrclk ( wrclk ),
	.wrreq ( wrreq ),
	.q ( fifo_out ),
	.rdempty ( rdempty ),
	.wrfull ( wrfull )
	);

	
/***
module fir (
	input  wire        clk,              //                     clk.clk
	input  wire        reset_n,          //                     rst.reset_n
	input  wire [13:0] ast_sink_data,    //   avalon_streaming_sink.data
	input  wire        ast_sink_valid,   //                        .valid
	input  wire [1:0]  ast_sink_error,   //                        .error
	output wire [31:0] ast_source_data,  // avalon_streaming_source.data
	output wire        ast_source_valid, //                        .valid
	output wire [1:0]  ast_source_error  //                        .error
);
***/

fir fir_inst (
	.clk              (rdclk),              //                     clk.clk
	.reset_n          (rst_n),          //                     rst.reset_n
	.ast_sink_data    (fifo_out),    //   avalon_streaming_sink.data [13:0]
	.ast_sink_valid   (rdreq),   //                        .valid
	.ast_sink_error   (2'b0),   //                        .error [1:0]
	.ast_source_data  (q),  // avalon_streaming_source.data
	.ast_source_valid (data_valid), //                        .valid
	.ast_source_error (source_err)  //                        .error
);
	

endmodule