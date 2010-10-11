/*
Dalli
 
 */
#include "WProgram.h"
void setup();
void loop();
int Buzzer1 =  2;    // Lampe 1 an Output 5
int Buzzer2 =  3;
int Buzzer3 =  4;

int Lampe1 =  5;    // Lampe 1 an Output 5
int Lampe2 =  6;
int Lampe3 =  7;

int Poti =  5;
int Verzug = 100;

// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pin as an output:
  
  pinMode(Buzzer1, INPUT);
  pinMode(Buzzer2, INPUT);
  pinMode(Buzzer3, INPUT);  
  
  pinMode(Lampe1, OUTPUT);
  pinMode(Lampe2, OUTPUT);
  pinMode(Lampe3, OUTPUT);  

  
  digitalWrite(Lampe1, HIGH);   // set the LED on
  delay(500);                  // wait for a second
  digitalWrite(Lampe1, LOW);    // set the LED off
  delay(500);                  // wait for a second
  digitalWrite(Lampe2, HIGH);   // set the LED on
  delay(500);                  // wait for a second
  digitalWrite(Lampe2, LOW);    // set the LED off
  delay(500);                  // wait for a second
  digitalWrite(Lampe3, HIGH);   // set the LED on
  delay(500);                  // wait for a second
  digitalWrite(Lampe3, LOW);    // set the LED off
  delay(500);  
}



void loop()                     
{ 
  
   Verzug = analogRead(Poti)* 10;  
   digitalWrite(Lampe1, digitalRead(Buzzer1));
   
   
     if (digitalRead(Buzzer1)==LOW)
     {     
     digitalWrite(Lampe1, HIGH); 
     digitalWrite(Lampe2, LOW);
     digitalWrite(Lampe3, LOW);
     delay(Verzug);      
     } 
  
     else {  if (digitalRead(Buzzer2)==LOW)
             {     
              digitalWrite(Lampe2, HIGH);
              digitalWrite(Lampe1, LOW);
              digitalWrite(Lampe3, LOW);
              delay(Verzug);       
             } 

             else {  if (digitalRead(Buzzer3)==LOW)
                     {     
                       digitalWrite(Lampe3, HIGH);
                       digitalWrite(Lampe1, LOW);
                       digitalWrite(Lampe2, LOW);
                       delay(Verzug);       
                     } 
                   }
           }
    
   
     digitalWrite(Lampe1, LOW);
     digitalWrite(Lampe2, LOW);
     digitalWrite(Lampe3, LOW);
  
  
 /*
  Verzug = analogRead(Poti)* 10;  
  delay(Verzug);                  // wait for a second
  digitalWrite(Lampe1, HIGH);   // set the LED on
    Verzug = analogRead(Poti)* 10;  
  delay(Verzug);                  // wait for a second
    Verzug = analogRead(Poti)* 10;  
  digitalWrite(Lampe1, LOW);    // set the LED off
  delay(Verzug);                  // wait for a second
    Verzug = analogRead(Poti)* 10;  
  digitalWrite(Lampe2, HIGH);   // set the LED on
  delay(Verzug);                  // wait for a second
    Verzug = analogRead(Poti)* 10;  
  digitalWrite(Lampe2, LOW);    // set the LED off
  delay(Verzug);                  // wait for a second
    Verzug = analogRead(Poti)* 10;  
  digitalWrite(Lampe3, HIGH);   // set the LED on
  delay(Verzug);                  // wait for a second
    Verzug = analogRead(Poti)* 10;  
  digitalWrite(Lampe3, LOW);    // set the LED off
 
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

