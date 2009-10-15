 /* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  


#include <AFMotor.h>


 int encoder0PinA = 0;
 int encoder0PinB = 1;
 int encoder0Pos = 0;
 int val1 = 0;       // variable to store the value coming from the sensor
 int val2 = 0;       // variable to store the value coming from the sensor
 int potPinA = 1;    // select the input pin for the potentiometer
 int potPinB = 2;    // select the input pin for the potentiometer
 
 int ledPin = 13;                // LED connected to digital pin 13
 int encoder0PinALast = LOW;
 int n = LOW;

 void setup() { 
   
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode(ledPin, OUTPUT);      // sets the digital pin as output
   Serial.begin (9600);
   
   
  motor.setSpeed(10);  // 10 rpm   
  motor.release();
  
 } 

 void loop() { 
   val1 = analogRead(potPinA);    // read the value from the sensor
   val2 = analogRead(potPinB);    // read the value from the sensor
   if ((encoder0PinALast == 0) && (val1 > 500)) {
     if (val2 < 500) {
       encoder0Pos--;
         motor.step(1, BACKWARD, SINGLE); 
     } else {
       encoder0Pos++;
         motor.step(1, FORWARD, SINGLE); 
     }
     Serial.print (encoder0Pos);
     Serial.print ("/");
   } 
        // sets the LED on
     
     if (val1 < 500) {
         encoder0PinALast = 0;
         digitalWrite(ledPin, LOW);
     } else {
         encoder0PinALast = 1000;
         digitalWrite(ledPin, HIGH);
     }
    
 } 






/*

  motor.step(100, FORWARD, SINGLE); 
  motor.step(100, BACKWARD, SINGLE); 

  motor.step(100, FORWARD, DOUBLE); 
  motor.step(100, BACKWARD, DOUBLE);

  motor.step(100, FORWARD, INTERLEAVE); 
  motor.step(100, BACKWARD, INTERLEAVE); 

  motor.step(100, FORWARD, MICROSTEP); 
  motor.step(100, BACKWARD, MICROSTEP); 
*/
