


 
int i;
char stringbuffer[20];	//buffer for reading one line of the serial input
int bufferpos = 0;
char ping[]="PING\n"; 

char camera_on[]="CAMERA_ON\n"; 
char camera_rec[]="CAMERA_REC\n"; 
char out_camera_rec[]="Switch Recording\r\n";
char out_camera_on[]="Switch Power\r\n";
char end_out[]="\r\n";

void setup() {
	TRISBbits.TRISB0 = 1;	// portb buttons = inputs
	TRISBbits.TRISB1 = 1;
//
	INTCON2bits.NOT_RBPU = 0;  
	pinmode(13, OUTPUT);
	pinmode(14, OUTPUT);

//
	for (i=21; i <= 28; i++) {
		pinmode(i,OUTPUT);
		digitalwrite(i,HIGH);
	}

	setup_UART(57600);
}
void loop() {
	Delayms(3);
	if (digitalread(0)) {
		for (i=21; i <= 28; i++) {
			digitalwrite(i,HIGH);
		}
	} else {
		for (i=21; i <= 28; i++) {
			digitalwrite(i,LOW);
		}

	}
	
	if (charreceived()) {
		stringbuffer[bufferpos] = getch();
		if (stringbuffer[bufferpos] == '\n' || (bufferpos>15) || stringbuffer[bufferpos] == '\0') {
			stringbuffer[bufferpos+1] = '\0';
			if (strcmp(stringbuffer,ping) == 0) {
				serial_write("PONG\r\n");
			} else if (strcmp(stringbuffer,camera_on) == 0) {
				serial_write(out_camera_on);
				digitalwrite(13,HIGH);
				digitalwrite(25,LOW);
				Delayms(3000);	//power button requires long press
				digitalwrite(25,HIGH);
				digitalwrite(13,LOW);
			} else if (strcmp(stringbuffer,camera_rec) == 0) {
				serial_write(out_camera_rec);
				digitalwrite(14,HIGH);
				digitalwrite(25,LOW);
				Delayms(1000);
				digitalwrite(25,HIGH);
				digitalwrite(14,LOW);
			} else if (bufferpos == 0) {

			} else {
				serial_write("No comprendo ");
				serial_write(stringbuffer);
				serial_write(end_out);
//
				while(charreceived()) {
					getch();
				}
			}
			bufferpos = 0;
		} else {
			bufferpos++;
		}
	}
}

