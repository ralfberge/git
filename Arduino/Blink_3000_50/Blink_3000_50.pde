/*
 * Blink
 *
 * The basic Arduino example.  Turns on an LED on for one second,
 * then off for one second, and so on...  We use pin 13 because,
 *

   Zeiten ge�ndert: 3000ms zu 50 ms


 * depending on your Arduino board, it has either a built-in LED
 * or a built-in resistor so that you need only an LED.
 *
 * http://www.arduino.cc/en/Tutorial/Blink
 */

int ledPin = 13;                // LED connected to digital pin 13

void setup()                    // run once, when the sketch starts
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
  Serial.begin(9600);       // use the serial port
}

void loop()                     // run over and over again
{
  digitalWrite(ledPin, HIGH);   // sets the LED on
  delay(50);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
  Serial.println("Knock!");          // send the string "Knock!" back to the computer, followed by newline
  delay(3000);                  // waits for a second
}


