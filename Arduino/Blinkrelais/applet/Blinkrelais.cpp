#include "WProgram.h"
/*
 * Blink
 *
 * The basic Arduino example.  Turns on an LED on for one second,
 * then off for one second, and so on...  We use pin 13 because,
 * depending on your Arduino board, it has either a built-in LED
 * or a built-in resistor so that you need only an LED.
 *
 * http://www.arduino.cc/en/Tutorial/Blink
 */

int ledPin = 13;                // LED connected to digital pin 13
int relaisPin = 6;                // LED connected to digital pin 13
int inPin = 5;   // choose the input pin (for a pushbutton)
int val = 0;     // variable for reading the pin status



void setup()                    // run once, when the sketch starts
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
    pinMode(relaisPin, OUTPUT);      // sets the digital pin as output
      pinMode(inPin, INPUT);    // declare pushbutton as input

}

void loop()                     // run over and over again
{


val = digitalRead(inPin);  // read input value
  if (val == HIGH) {         // check if the input is HIGH (button released)
    digitalWrite(ledPin, LOW);  // turn LED OFF
        digitalWrite(relaisPin, LOW);  // turn LED OFF
  } else {
    digitalWrite(ledPin, HIGH);  // turn LED ON
        digitalWrite(relaisPin, HIGH);  // turn LED ON
  }



/*  digitalWrite(ledPin, HIGH);   // sets the LED on
    digitalWrite(relaisPin, HIGH);   // sets the LED on
  delay(1000);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
    digitalWrite(relaisPin, LOW);    // sets the LED off
  delay(1000);                  // waits for a second


*/

}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

