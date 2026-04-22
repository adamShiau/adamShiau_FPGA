#include "adda_config.h"
// #include "system.h"
// #include "altera_avalon_spi_regs.h"

void init_ADDA(void)
{
    //select ADC_1CH of IRIS1 -> Reset -> change format to 2's complement
    IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADC_BASE, SEL_CS_ADC_1CH); usleep (10); 
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_RESET); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_FMT); usleep (10);

    //select ADC_2CH of IRIS1 -> Reset -> change format to 2's complement
    IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADC_BASE, SEL_CS_ADC_2CH); usleep (10); //select ADC_2CH
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_RESET); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_FMT); usleep (10);

    //select DAC_1CH of IRIS1 -> Reset -> change format to 2's complement
    IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_DAC_BASE, SEL_CS_DAC_1CH); usleep (10); //select DAC_1CH
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC1_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC1_GAIN_LSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC2_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC2_GAIN_LSB_W_NR); usleep (10);

	//select DAC_2CH of IRIS1 -> Reset -> change format to 2's complement
	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_DAC_BASE, SEL_CS_DAC_2CH); usleep (10); //select DAC_CH2
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC1_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC1_GAIN_LSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC2_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_DAC_BASE, DAC2_GAIN_LSB_W_NR); usleep (10);

	// clear_DAC_reset();
}

void set_ADC_all_zero()
{
    IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_ALL_ZERO); usleep (10);
}


void set_ADC_all_one()
{
    IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, ADC_ALL_ONE); usleep (10);
}

void set_DAC_reset()
{
	IOWR_ALTERA_AVALON_PIO_DATA(DAC_RST_BASE, 0x01);

}

void clear_DAC_reset()
{
	IOWR_ALTERA_AVALON_PIO_DATA(DAC_RST_BASE, 0x00);
}
