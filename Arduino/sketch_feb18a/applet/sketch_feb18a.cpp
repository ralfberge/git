
#include <NewSoftSerial.h>

#include "WProgram.h"
void getAZEL();
void setup();
void loop();
void selectLineOne();
void selectLineTwo();
void goTo(int position);
void clearLCD();
void backlightOn();
void backlightOff();
void serCommand();
NewSoftSerial mySerial(2, 3); //RX 2, TX 3
int inbyte[30];
int i;
int inlenght;
int AZ;
int EL;





void getAZEL()

{
        AZ = 0;
        i=0;
        while (inbyte[i]!=46) { i++;}
           
           if (inbyte[i-1]>=48 && inbyte[i-1]<=57) {
           AZ = AZ + inbyte[i-1]-48;
           }
           
           if (inbyte[i-2]>=48 && inbyte[i-2]<=57) {
              AZ = AZ + (inbyte[i-2]-48) * 10;
           }
           
           if (inbyte[i-3]>=48 && inbyte[i-3]<=57) {
              AZ = AZ + (inbyte[i-3]-48) * 100;
           }
    
        EL = 0;
        i= i+1;
        while (inbyte[i]!=46) { i++;}
           
           if (inbyte[i-1]>=48 && inbyte[i-1]<=57) {
           EL = EL + inbyte[i-1]-48;
           }
           
           if (inbyte[i-2]>=48 && inbyte[i-2]<=57) {
              EL = EL + (inbyte[i-2]-48) * 10;
           }
           
           if (inbyte[i-3]>=48 && inbyte[i-3]<=57) {
              EL = EL + (inbyte[i-3]-48) * 100;
           }
}





void setup()
{
  Serial.begin(9600);
  
  mySerial.begin(9600);

  backlightOn();
  clearLCD();  
  selectLineOne();
  mySerial.print("Hello, world?");
  
  delay(3000);

}

void loop()
{  

  inlenght=0;
  if (Serial.available()>0) {
    delay (100);
    inlenght=Serial.available()-1;
  
    for (i=0; i <= inlenght; i++) {
      inbyte[i] = Serial.read();
       }
   }

 if  (inlenght > 0) {
   selectLineOne();   
     mySerial.print(">");
     for (i=0; i <= inlenght; i++){
     mySerial.print(inbyte[i], BYTE);
     }
   mySerial.print("<");
   getAZEL();
   
   selectLineTwo();
    mySerial.print("AZ: ");
    mySerial.print(AZ);
    mySerial.print(" EL: ");
    mySerial.print(EL);
   
   delay(5000);
   clearLCD();  
   selectLineOne();
   mySerial.print("Hello, world?");
   }


  
  /*
  
    if (mySerial.available()) {
      Serial.print((char)mySerial.read());
  }
  if (Serial.available()) {
      mySerial.print((char)Serial.read());
  }
  
  */
  
}

void selectLineOne(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(128, BYTE);    //position
}
void selectLineTwo(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(192, BYTE);    //position
}
void goTo(int position) { //position = line 1: 0-15, line 2: 16-31, 31+ defaults back to 0
if (position<16){ Serial.print(0xFE, BYTE);   //command flag
              Serial.print((position+128), BYTE);    //position
}else if (position<32){Serial.print(0xFE, BYTE);   //command flag
              Serial.print((position+48+128), BYTE);    //position 
} else { goTo(0); }
}

void clearLCD(){
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(0x01, BYTE);   //clear command.
}
void backlightOn(){  //turns on the backlight
    Serial.print(0x7C, BYTE);   //command flag for backlight stuff
    Serial.print(157, BYTE);    //light level.
}
void backlightOff(){  //turns off the backlight
    Serial.print(0x7C, BYTE);   //command flag for backlight stuff
    Serial.print(128, BYTE);     //light level for off.
}
void serCommand(){   //a general function to call the command flag for issuing all other commands   
  Serial.print(0xFE, BYTE);
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

