




/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   

#include <LiquidCrystal.h>


LiquidCrystal lcd (12, 11, 7, 8, 9, 10);

 int val; 
 int encoder0PinA = 3;
 int encoder0PinB = 2;
 int encoder_min = 100;
 int encoder_max = 1000;
 int encoder0Pos = 100;
 int encoder0PinALast = LOW;
 int n = LOW;
 
 
int motorPins[] = {7, 9, 8, 10 };
int count = 0;
int count2 = 0;
int delayTime = 20;


int stepper_enable=5;
  
   char buffer[5]    = "";





void moveForward() {
  if ((count2 == 0) || (count2 == 1)) {
    count2 = 16;
  }
  count2>>=1;
  for (count = 3; count >= 0; count--) {
    digitalWrite(motorPins[count], count2>>count&0x01);
  }
  delay(delayTime);
}

void moveBackward() {
  if ((count2 == 0) || (count2 == 1)) {
    count2 = 16;
  }
  count2>>=1;
  for (count = 3; count >= 0; count--) {
    digitalWrite(motorPins[3 - count], count2>>count&0x01);
  }
  delay(delayTime);
}





 void setup() { 
 
   
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode (stepper_enable, OUTPUT);
 
//   Serial.begin (9600);
   digitalWrite(stepper_enable, HIGH);
    
   for (count = 0; count < 4; count++) {
     pinMode(motorPins[count], OUTPUT);
     }
  
   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Stepper, Vers. 1.0");
  
  
  
  
  
 
 } 



 void loop() { 


   n = digitalRead(encoder0PinA);
   if ((encoder0PinALast == LOW) && (n == HIGH)  ) {
      digitalWrite(stepper_enable, HIGH);
      
      if ((digitalRead(encoder0PinB) == LOW) && (encoder0Pos > encoder_min)) {
           
         encoder0Pos--;
         moveBackward();
    

     
   } else {
   
 if  (encoder0Pos < encoder_max)    {
        
           encoder0Pos++;
           moveForward();
 }
   
     }


 //   Serial.print (encoder0Pos);
 //   Serial.print ("/");
   
   digitalWrite(stepper_enable, LOW);

   lcd.setCursor(0, 2);
   lcd.print("Position:");
   sprintf(buffer,"%4d",encoder0Pos);
   lcd.setCursor(10, 2);
   lcd.print(buffer);
        
  } 
   encoder0PinALast = n;
   
 } 
