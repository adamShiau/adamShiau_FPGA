#include "uart.h"

#define TEST_MODE
// const alt_u8 buffer_size = 5;

alt_u8* readData(alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt)
{
	
    static alt_u8 buffer[5];
    const alt_u8 data_size_expected = 5;
    
    // if (IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE) == 0) return NULL; //return immediately if no serial data in buffer 
    alt_u8 data = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
    printf("data: %x\n", data);


	static alt_u8 bytes_received = 0;
	static enum {
		EXPECTING_HEADER, 
		EXPECTING_PAYLOAD,
        EXPECTING_TRAILER
	} state = EXPECTING_HEADER; // state machine definition
	
	switch (state) {
		case EXPECTING_HEADER:
            #if defined(TEST_MODE)
                printf("state : EXPECTING_HEADER\n");
            #endif
			
			if (data != expected_header[bytes_received++])
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
                (*try_cnt)++;
			}

            #if defined(TEST_MODE)
                printf("bytes_received: ");
                printf("%d", bytes_received);
                printf(", ");
                printf("%x\n", data);
            #endif

			if(bytes_received >= header_size){
				state = EXPECTING_PAYLOAD;
				bytes_received = 0;
			}

			break;

		case EXPECTING_PAYLOAD:
			#if defined(TEST_MODE)
                printf("\nstate : EXPECTING_PAYLOAD");
            #endif

			buffer[bytes_received++] = data;

            #if defined(TEST_MODE)
                printf("bytes_received: ");
                printf(bytes_received);
                printf(", ");
                printf("%x\n", buffer[bytes_received-1]);
            #endif

			if(bytes_received >= data_size_expected)
            {
                bytes_received = 0;
                // state = EXPECTING_HEADER;
                // Serial.print("buf: ");
                // Serial.print((long)buffer, HEX);
                // Serial.print(", ");
                // Serial.print((long)&buffer[0], HEX);
                // Serial.print(", ");
                // Serial.println((long)&buffer[1], HEX);

                state = EXPECTING_HEADER;
                *try_cnt = 0;
                #if defined(TEST_MODE)
                    printf("reset try_cnt: ");
                    printf("%d\n", *try_cnt);
                #endif
                return buffer;

                // if(expected_trailer == nullptr) {
                //     state = EXPECTING_HEADER;
                //     *try_cnt = 0;
                //     #if defined(TEST_MODE)
                //         printf("reset try_cnt: ");
                //         printf("%d\n", *try_cnt);
                //     #endif
                //     return buffer;
                // }
                // else state = EXPECTING_TRAILER;
			}
			break;
        // case EXPECTING_TRAILER:
        //     #if defined(TEST_MODE)
        //         printf("\nstate : EXPECTING_TRAILER");
        //         printf("Trailer: ");
        //         printf("%x\n", data);
        //     #endif

        //     if (data != expected_trailer[bytes_received++])
		// 	{
		// 		state = EXPECTING_HEADER;
		// 		bytes_received = 0;
        //         (*try_cnt)++;
		// 	}

        //     if(bytes_received >= trailer_size){
		// 		state = EXPECTING_HEADER;
		// 		bytes_received = 0;
        //         *try_cnt = 0;
        //         return buffer;
		// 	}
        // break;
	}
	// return NULL;
}