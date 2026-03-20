#include "output_mode.h"
#include "acq_fog.h"
#include "acq_rst.h"
#include "acq_imu.h"

void output_mode_setting(cmd_ctrl_t* rx, fn_ptr *output_fn)
{
	if(rx->mux == MUX_OUTPUT)
	{
		DEBUG_PRINT("in output_mode_setting\n");
		DEBUG_PRINT("cmd= %u\n", rx->cmd);
		rx->mux = MUX_ESCAPE;

		switch(rx->cmd) {
			case MODE_RST: {
				*output_fn = acq_rst;
				rx->select_fn = SEL_RST;
				rx->sync_mode = rx->value;
				break;
			}
			case MODE_FOG: {
				*output_fn = acq_fog;
				DEBUG_PRINT("output_fn select to acq_fog\n");
				rx->select_fn = SEL_FOG;
				rx->sync_mode = rx->value;
				break;
			} 
			case MODE_IMU: {
				*output_fn = acq_imu;
				DEBUG_PRINT("output_fn select to acq_imu\n");
				rx->select_fn = SEL_IMU;
				rx->sync_mode = rx->value;
				break;
			}

      		default: DEBUG_PRINT("function mode out of range\n");break;
      }
	}
	else if(rx->mux == MUX_DEFAULT)
	{
		rx->mux = MUX_ESCAPE;
		*output_fn = acq_rst;
		DEBUG_PRINT("just start, enter acq_rst ");
	}
}