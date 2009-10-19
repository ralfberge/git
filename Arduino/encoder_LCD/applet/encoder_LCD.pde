
#include <LCD4Bit.h> 
#include <stdio.h> 


//create object to control an LCD.  
//number of lines in display=1
LCD4Bit lcd = LCD4Bit(1); 

//some messages to display on the LCD
char msgs[6][15] = {"apple", "banana", "pineapple", "mango", "watermelon", "pear"};
int NUM_MSGS = 6;
int pin = 13;
int encoderB = 1;
volatile int state = LOW;
int encoder0Pos = 0;
int help = 0;
char buffer[4]; 


void setup()
{
  pinMode(pin, OUTPUT);
  pinMode(encoderB, INPUT);
  lcd.init();
  attachInterrupt(1, blink, FALLING);
}


void blink()
{

     if (digitalRead(encoderB) == LOW) {
       encoder0Pos--;
     } else {
       encoder0Pos++;
     //  state = !state;
     //  digitalWrite(pin, state);
     }
     

}


void loop() {  

  
  
   //pick a random message from the array
  help=encoder0Pos;
  sprintf(buffer,"%4d",encoder0Pos);
  encoder0Pos=help;
  lcd.clear();
  lcd.printIn(buffer);
  delay (100);

 
  //print something on the display's second line. 
  //uncomment this if your display HAS two lines!
  /*
  lcd.cursorTo(2, 0);  //line=2, x=0.
  lcd.printIn("Score: 6/7");
  delay(1000);
  */
 
}
