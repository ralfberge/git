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
void blink();
int val; 
 int encoder0PinA = 0;
 int encoder0PinB = 3;
 int encoder0Pos = 0;
 int ledPin = 13;                // LED connected to digital pin 13
 int encoder0PinALast = LOW;
 int n = LOW;

 void setup() 
 { 
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode(ledPin, OUTPUT);      // sets the digital pin as output
   Serial.begin (9600);
   attachInterrupt(0, blink, FALLING);
 }


 void loop()
  {
     digitalWrite(ledPin, LOW);
     Serial.print (encoder0Pos);
     Serial.print ("/");
   } 



void blink()
{
 if (digitalRead(encoder0PinB) == LOW) {
       encoder0Pos--;
     } else {
       encoder0Pos++;
       digitalWrite(ledPin, HIGH);
     }

}



int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

