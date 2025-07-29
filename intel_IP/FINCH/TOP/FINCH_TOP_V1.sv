module FINCH_TOP_V1(

	//////////// CLOCK INPUT ////////    
	CLOCK_100M, 
	//////////// CLOCK OUTPUT ////////  
	CLK_ADC,
	// CLK_ADC_N,
	//////////// ADC //////////
	//----BUS----
	ADC_1 
	
);

//////////// CLOCK //////////
input				CLOCK_100M;

//////////// PLL CLOCK //////////
output 				CLK_ADC;
// output 				CLK_ADC_N;

//////////// ADC //////////
input	[13:0] 		 ADC_1;

wire lock;
 
 
PLL	PLL_inst (
	.inclk0 ( CLOCK_100M ),
	.c0 ( CLK_ADC ),
	.locked ( lock )
	);
 
endmodule
