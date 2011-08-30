#define PIC18F4550
#include <string.h>
#include <stdlib.h>
 
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
	// enable pull-up resistors of port B (buttons)
	INTCON2bits.NOT_RBPU = 0;  
	pinMode(13, OUTPUT);
	pinMode(14, OUTPUT);

	//LEDs
	for (i=21; i <= 28; i++) {
		pinMode(i,OUTPUT);
		digitalWrite(i,HIGH);
	}

	Serial.begin(57600);
}
void loop() {
	delay(3);
	if (digitalRead(0)) {
		for (i=21; i <= 28; i++) {
			digitalWrite(i,HIGH);
		}
	} else {
		for (i=21; i <= 28; i++) {
			digitalWrite(i,LOW);
		}

	}
	
	if (Serial.available()) {
		stringbuffer[bufferpos] = Serial.read();
		if (stringbuffer[bufferpos] == '\n' || (bufferpos>15) || stringbuffer[bufferpos] == '\0') {
			stringbuffer[bufferpos+1] = '\0';
			if (strcmp(stringbuffer,ping) == 0) {
				Serial.print("PONG\r\n");
			} else if (strcmp(stringbuffer,camera_on) == 0) {
				Serial.print(out_camera_on);
				digitalWrite(13,HIGH);
				digitalWrite(25,LOW);
				delay(3000);	//power button requires long press
				digitalWrite(25,HIGH);
				digitalWrite(13,LOW);
			} else if (strcmp(stringbuffer,camera_rec) == 0) {
				Serial.print(out_camera_rec);
				digitalWrite(14,HIGH);
				digitalWrite(25,LOW);
				delay(1000);
				digitalWrite(25,HIGH);
				digitalWrite(14,LOW);
			} else if (bufferpos == 0) {

			} else {
				Serial.print("No comprendo ");
				Serial.print(stringbuffer);
				Serial.print(end_out);
				//also, clear input buffer
				while(Serial.available()) {
					Serial.read();
				}
			}
			bufferpos = 0;
		} else {
			bufferpos++;
		}
	}
}