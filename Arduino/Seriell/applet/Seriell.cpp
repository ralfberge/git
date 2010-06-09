// include the SoftwareSerial library so you can use its functions:
#include <SoftwareSerial.h>

#define rxPin 3
#define txPin 11
#define ledPin 13

// set up a new serial port
#include "WProgram.h"
void setup();
void loop();
void toggle(int pinNum);
SoftwareSerial mySerial =  SoftwareSerial(rxPin, txPin);
byte pinState = 0;

void setup()  {
  // define pin modes for tx, rx, led pins:
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  pinMode(ledPin, OUTPUT);
  // set the data rate for the SoftwareSerial port
  mySerial.begin(9600);
}

void loop() {
  // listen for new serial coming in:
  
  mySerial.print("Kuss ");
  // toggle an LED just so you see the thing's alive.  
  // this LED will go on with every OTHER character received:
  toggle(13);

}


void toggle(int pinNum) {
  // set the LED pin using the pinState variable:
  digitalWrite(pinNum, pinState); 
  // if pinState = 0, set it to 1, and vice versa:
  pinState = !pinState;
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

