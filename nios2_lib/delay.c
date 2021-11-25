#include "delay.h"
#include "stdint.h"
/***
 delay 1ms: arg value = 1e5
	   2ms: arg value = 2*1e5
***/
alt_u32 delay_ms(alt_u32 ms)
{
	alt_u32 t0;
	t0 = alt_timestamp();
	while((alt_timestamp()-t0) < ms ) 
	{
		printf("%d\n", (alt_timestamp()-t0));
	}
	return alt_timestamp() - t0;
}


/***
 delay 1us: arg value = 1e2
	   2us: arg value = 2*1e2
***/
alt_u32 delay_us(alt_u32 us)
{
	alt_u32 t0;
	t0 = alt_timestamp();
	while((alt_timestamp()-t0) < us );
	return alt_timestamp() - t0;
}
