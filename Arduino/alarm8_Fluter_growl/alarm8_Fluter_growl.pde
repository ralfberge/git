#undef int
#include <stdio.h> 
#include <Wire.h>
#include "pins_arduino.h"
#include <NewSoftSerial.h>
#include <SPI.h>
#include <Ethernet.h>

byte mac[] =     { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] =      { 192,168,0,77 };   // local Arduino IP
byte gateway[] = { 192,168,0,1 };    // IP of your gateway
byte subnet[] =  { 255,255,255,0 };   // subnet mask
byte server[] =  { 62,80,29,14 };    // IP of your web server

int  startup_sec  = 50;             // Zeit, bis alle Sensoren aktiv sind
int  rtc          = 104;
int  status;                        //scharf HIGH, unscharf LOW

const int HauptPin = 0;             // Eingangsschalter
const int relais1Pin = 6;           // EIB Küchenlicht
const int relais2Pin = 7;           // EIB Aussenlicht

const int LS_Pin   = 8;             // Lichtschranke Garten
const int BM1_Pin  = 5;             // Bewegungsmelder Wintergarten 
const int BM2_Pin  = 3;             // Bewegungsmelder OG

#define rxPin 3
#define txPin 2

NewSoftSerial mySerial(rxPin, txPin);
Client client(server, 80);


byte second = 0x00;                             // default to 01 JAN 2008, midnight 
byte minute = 0x00; 
byte hour = 0x00; 
byte wkDay = 0x02; 
byte day = 0x01; 
byte month = 0x01; 
byte year = 0x08; 
byte ctrl = 0x00; 


void setup() 
{ 

  Ethernet.begin(mac, ip, gateway, subnet);
  Wire.begin(); 
  Serial.begin(9600);
  mySerial.begin(9600);// set the data rate for the SoftwareSerial port

  pinMode(relais1Pin, OUTPUT);      // sets the digital pin as output
  pinMode(relais2Pin, OUTPUT);      // sets the digital pin as output
  
  digitalWrite(relais1Pin, LOW);   // turn LED OFF
  digitalWrite(relais2Pin, LOW);   // turn LED OFF

  pinMode(LS_Pin, INPUT);            // declare pushbutton as input
  pinMode(BM1_Pin, INPUT);            // declare pushbutton as input


  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);

  delay(3000); // um das dispalay hochfahren zu lassen
  backlightOn();
  clearLCD();  
  selectLine(1);
  mySerial.print("Alarmanlage   V. 2.1");
  selectLine(2);
  mySerial.print("starting up...");
  
  Serial.println("Alarmanlage   V. 2.1");
  Serial.println();
  Serial.print("Startup: ");

  if (analogRead(HauptPin) < 200)
  {
   status = LOW;
   Serial.println("unscharf");
  }
  else 
  {
    status = HIGH;
    Serial.println("scharf");
  }

  
  print_timestamp(); 
    
  for (int i=0; i < startup_sec; i++)
  { 
    selectLine(4);
    display_timestamp();
    delay (1000);
  }


/*
second = 0x00;                                // demo time 
minute = 0x32; 
hour   = 0x22; 
wkDay  = 0x01; 
month  = 0x02; 
year   = 0x11; 
ctrl   = 0x00;   
   
   
   setClock() ;

*/

}  //setup


void loop() 
{  

  selectLine(1);
  mySerial.print("Alarmanlage   V. 2.1");
  selectLine(3);
  mySerial.print("                    ");
  selectLine(4);
  display_timestamp();
  
  
  if (analogRead(HauptPin) < 200)

  {
    selectLine(2);
    mySerial.print("-unscharf-          ");
      if (status == HIGH)
      {
       Serial.print("unscharf: ");
       print_timestamp();
      }
      status = LOW;
  }

  else 
  {
    selectLine(2);
    mySerial.print("-scharf-            ");
    
      if (status == LOW)
      {
       Serial.print("scharf: ");
       print_timestamp();
      }
    status = HIGH;



    //**************** Lichtschranke aktiviert ***********************
  
   if (digitalRead(LS_Pin) == LOW) { 
      digitalWrite(relais1Pin, LOW); 
      digitalWrite(relais2Pin, LOW);
    } 

    else {

      selectLine(3);
      mySerial.print("Lichtschranke Garten");
     

      Serial.print("Lichtschranke Garten: ");
      print_timestamp();
      growl("Garten", 1,"all");  
      // printAlarm(); 
      Lichtsequenz();
      delay (10000);
    }



    //**************** BM Wintergarten aktiviert ***********************

   if (digitalRead(BM1_Pin) == LOW) {  
      digitalWrite(relais1Pin, LOW);   
      digitalWrite(relais2Pin, LOW);  
    } 

    else {

      selectLine(3);
      mySerial.print("Wintergarten");

      Serial.print("Bewegungsmelder Wintergarten: ");
      print_timestamp();
       
      growl("Wintergarten",0,"ralf");  
      // printAlarm(); 
      Lichtsequenz();
      delay (10000);
    }  


    //**************** BM OG aktiviert ***********************

    if (digitalRead(BM2_Pin)== LOW) {                    
      digitalWrite(relais1Pin, LOW);   
      digitalWrite(relais2Pin, LOW); 
    } 

    else {

      selectLine(3);
      mySerial.print("Bewegungsmelder OG  ");

      Serial.print("Bewegungsmelder OG: ");
      print_timestamp();
      growl("Obergeschoss", 2,"ralf");  

      delay (10000);

    } 

  }    /// else von analog Haupt



  delay (500);

}   /// loop



void Lichtsequenz()
{
  delay (1500);  

  digitalWrite(relais1Pin, HIGH);
  delay (500);
  digitalWrite(relais1Pin, LOW);  

  delay (3000); 

  digitalWrite(relais2Pin, HIGH);
  delay (500);
  digitalWrite(relais2Pin, LOW);

  delay (60000);

  digitalWrite(relais1Pin, HIGH);
  digitalWrite(relais2Pin, HIGH);
  delay (500);
  digitalWrite(relais1Pin, LOW);  // turn LED ON
  digitalWrite(relais2Pin, LOW);  // turn LED ON


}

void display_timestamp()
{
  getClock();
  if (hour< 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(hour));
  }
  else { 
    mySerial.print(bcd2Dec(hour));
  }
  mySerial.print(":");
  if (minute < 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(minute));
  }
  else { 
    mySerial.print(bcd2Dec(minute));
  }
  mySerial.print(":");
  if (second< 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(second));
  }
  else { 
    mySerial.print(bcd2Dec(second));
  }
  mySerial.print("    ");
  if (day< 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(day));
  }
  else { 
    mySerial.print(bcd2Dec(day));
  }
  mySerial.print(".");
  if (month< 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(month));
  }
  else { 
    mySerial.print(bcd2Dec(month));
  }
  mySerial.print(".");
  if (year< 10) {
    mySerial.print("0");
    mySerial.print(bcd2Dec(year));
  }
  else { 
    mySerial.print(bcd2Dec(year));
  }

} //timestamp




void setClock() 
{ 
  Wire.beginTransmission(rtc); 
  Wire.send(0); 
  Wire.send(second); 
  Wire.send(minute); 
  Wire.send(hour); 
  Wire.send(wkDay); 
  Wire.send(day); 
  Wire.send(month); 
  Wire.send(year); 
  Wire.send(ctrl); 
  Wire.endTransmission(); 
} 



int bcd2Dec(byte bcdVal) 
{ 
  return bcdVal / 16 * 10 + bcdVal % 16; 
}




void getClock() 
{ 
  Wire.beginTransmission(rtc); 
  Wire.send(0); 
  Wire.endTransmission(); 

  delay(10);

  Wire.requestFrom(rtc, 8); 
  second = Wire.receive(); 
  minute = Wire.receive(); 
  hour   = Wire.receive(); 
  wkDay  = Wire.receive(); 
  day    = Wire.receive(); 
  month  = Wire.receive(); 
  year   = Wire.receive(); 
  ctrl   = Wire.receive(); 
} 




void print_timestamp()
{
  getClock();

  if (hour< 10) {
    Serial.print("0");
    Serial.print(bcd2Dec(hour));
  }
  else { 
    Serial.print(bcd2Dec(hour));
  }

  Serial.print(":");

  if (minute < 10) {
    Serial.print("0");
    Serial.print(bcd2Dec(minute));
  }
  else { 
    Serial.print(bcd2Dec(minute));
  }

  Serial.print(":");

  if (second< 10) {
    Serial.print("0");
    Serial.print(bcd2Dec(second));
  }
  else { 
    Serial.print(bcd2Dec(second));
  }

  Serial.print("    ");

  if (day< 10) {
    Serial.print("0");
    Serial.print(bcd2Dec(day));
  }
  else { 
    Serial.print(bcd2Dec(day));
  }

  Serial.print(".");

  if (month< 10) {
    Serial.print("0");
    Serial.print(bcd2Dec(month));
  }
  else { 
    Serial.print(bcd2Dec(month));
  }

  Serial.print(".");

  if (year< 10) {
    Serial.print("0");
    Serial.println(bcd2Dec(year));
  }
  else { 
    Serial.println(bcd2Dec(year));
  }
  
  Serial.println("-----------------------------------------");
 
} 

void selectLine(int line){  //puts the cursor at line 0 char 0.
 mySerial.print(0xFE, BYTE);   //command flag

 switch (line) {
 case 1:
  mySerial.print(128, BYTE);    //position
  break;
 case 2:
  mySerial.print(192, BYTE);    //position
  break;
 case 3:
  mySerial.print(148, BYTE);    //position
  break;
 case 4:
  mySerial.print(212, BYTE);    //position
  break;
 }
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



void growl(char melder[15], int prior, char user[5] )
{
  if (client.connect()) { //connect to server

    // Make a HTTP request:
    client.print("GET http://www.buero-berge.com/growlscripts/example.php/?event=Melder&app=Alarmanlage&descr=");
    client.print (melder);
    client.print ("&prior=");  
    client.print (prior);
    client.print ("&user=");
    client.print (user);
    client.println();
  } 
  
  else {         
    Serial.print("growl failed: ");
    print_timestamp();
  } 
    client.stop();
} 
