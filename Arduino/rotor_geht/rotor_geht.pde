                                                                                                                                                                                                                                                                                                                                                                                                                       
#include <NewSoftSerial.h>

NewSoftSerial mySerial(10, 11); //RX 2, TX 3
int inbyte[30];
int i;
int inlenght = 0;

int AZ;
int EL;
int poti_AZ=0;
int poti_EL=0;

const int poti_AZ_Pin =  0;   
const int poti_EL_Pin =  1;
const int man_switch =  5;  

const int kulanz_AZ =  3;   
const int kulanz_EL =  3;  

const int offset_AZ =  10;   
const int offset_EL =  10;  

const float faktor_AZ =  3.33333;   
const float faktor_EL =  5.33333;  


const int leftPin =  7;   
const int rightPin =  6;   
const int upPin =  4;   
const int downPin =  5;   


void position()

{
  
  
poti_AZ = analogRead(poti_AZ_Pin);
poti_EL = analogRead(poti_EL_Pin);

poti_AZ = (poti_AZ - offset_AZ) / faktor_AZ;
poti_EL = (poti_EL - offset_EL) / faktor_EL;



  if  (AZ > (poti_AZ +  kulanz_AZ)) 
     {
    stop_AZ(); 
    digitalWrite(rightPin, HIGH); 
     }

  else
     {
       if  (AZ < (poti_AZ -  kulanz_AZ)) 
     {
      stop_AZ(); 
      digitalWrite(leftPin, HIGH); 
     }
     
       else
     {

      stop_AZ(); 
 
     }

}


  if  (EL > (poti_EL +  kulanz_EL)) 
     {
    stop_EL(); 
    digitalWrite(upPin, HIGH); 
     }

  else
     {
       if  (EL < (poti_EL -  kulanz_EL)) 
     {
      stop_EL(); 
      digitalWrite(downPin, HIGH); 
     }
     
       else
     {

      stop_EL(); 
 
     }

}

}


void setup()
{
  
  pinMode(leftPin, OUTPUT);     
  pinMode(rightPin, OUTPUT);     
  pinMode(upPin, OUTPUT);     
  pinMode(downPin, OUTPUT);     
  
  digitalWrite(leftPin, LOW); 
  digitalWrite(rightPin, LOW); 
  digitalWrite(upPin, LOW); 
  digitalWrite(downPin, LOW); 
  
  
  
  Serial.begin(9600);
  
  mySerial.begin(9600);

  backlightOn();
  clearLCD();  
  selectLineOne();
  mySerial.print("  Hello world!  ");
  
  delay(3000);
  poti_AZ = analogRead(poti_AZ_Pin);
  poti_EL = analogRead(poti_EL_Pin);

  poti_AZ = (poti_AZ - offset_AZ) / faktor_AZ;
  poti_EL = (poti_EL - offset_EL) / faktor_EL;
  
  AZ = poti_AZ;
  EL = poti_EL;
  
  
}




void loop()
{  
 
  
if (analogRead( man_switch) < 100)  
  
  { 
  digitalWrite(leftPin, LOW); 
  digitalWrite(rightPin, LOW); 
  digitalWrite(upPin, LOW); 
  digitalWrite(downPin, LOW); 
  

  selectLineOne();
  mySerial.print(" HANDSTEUERUNG! ");
  
  
  poti_AZ = analogRead(poti_AZ_Pin);
  poti_EL = analogRead(poti_EL_Pin);

  poti_AZ = (poti_AZ - offset_AZ) / faktor_AZ;
  poti_EL = (poti_EL - offset_EL) / faktor_EL;
  
  AZ = poti_AZ;
  EL = poti_EL;
  
  selectLineTwo();
  mySerial.print("AZ: ");
  mySerial.print(poti_AZ);
  mySerial.print(" EL: ");
  mySerial.print(poti_EL);
  
  Serial.flush();
  
  }
  
else   // switch auf automatisch
  {
       
  if (Serial.available()>0) {
    delay (100);
    inlenght=Serial.available()-1;
  
    for (i=0; i <= inlenght; i++) {
      inbyte[i] = Serial.read();
       }
       
   getAZEL(); 
 
 }

/* if  (inlenght > 0) {
   selectLineOne();   
     mySerial.print(">");
     for (i=0; i <= inlenght; i++){
     mySerial.print(inbyte[i], BYTE);
     }
   mySerial.print("<");
 */ 

  

   
   selectLineOne();
    mySerial.print("AZ: ");
    mySerial.print(AZ);
    mySerial.print(" EL: ");
    mySerial.print(EL);
    mySerial.print("    ");
   
   position();
   
    selectLineTwo();
    mySerial.print("AZ: ");
    mySerial.print(poti_AZ);
    mySerial.print(" EL: ");
    mySerial.print(poti_EL);
    
   delay(500);

   } //


delay(500);

} // loop

  


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




void stop_AZ()
{
  
  digitalWrite(leftPin, LOW); 
  digitalWrite(rightPin, LOW); 

}

void stop_EL()
{
  digitalWrite(upPin, LOW); 
  digitalWrite(downPin, LOW); 

}
