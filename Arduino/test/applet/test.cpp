#include "WProgram.h"
 /* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  


 void setup();
void loop();
int val; 
 int encoder0PinA = 0;
 int encoder0PinB = 1;
 int encoder0Pos = 0;
 
 int ledPin = 13;                // LED connected to digital pin 13
 int potPinA = 1;    // select the input pin for the potentiometer
 int potPinB = 2;    // select the input pin for the potentiometer
 
 int encoder0PinALast = LOW;
 int n = LOW;

 void setup() { 
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode(ledPin, OUTPUT);      // sets the digital pin as output
   Serial.begin (9600);
 } 

 void loop() { 
   val = analogRead(potPinA);
  
     Serial.print (val);
     Serial.print ("/");
   
     digitalWrite(ledPin, n);   // sets the LED on
     encoder0PinALast = n;
     delay (500);
 } 
 
 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

