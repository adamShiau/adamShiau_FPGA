	VarSet_60 u0 (
		.address    (<connected-to-address>),    // avalon_slave_0.address
		.chipselect (<connected-to-chipselect>), //               .chipselect
		.rst_n      (<connected-to-rst_n>),      //               .beginbursttransfer
		.write_n    (<connected-to-write_n>),    //               .write_n
		.writedata  (<connected-to-writedata>),  //               .writedata
		.o_reg59    (<connected-to-o_reg59>),    //               .readdata
		.i_var59    (<connected-to-i_var59>),    //               .writebyteenable_n
		.clk        (<connected-to-clk>)         //          clock.clk
	);

