#define PIC18F4550
#include <string.h>
#include <stdlib.h>
 
int i;



void setup() {
	pinMode(0, INPUT);
	pinMode(1, INPUT);
	pinMode(2, INPUT);
	pinMode(13, OUTPUT);
	pinMode(14, OUTPUT);

	//LEDs
	for (i=21; i <= 28; i++) {
		pinMode(i,OUTPUT);
		digitalWrite(i,HIGH);
	}


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
	

}