
#undef int
#include <stdio.h> 
#include <Wire.h>

#include <LCD4Bit.h> 
#include "pins_arduino.h"
#include <NewSoftSerial.h>
#include <SPI.h>
#include <Ethernet.h>


byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192,168,0,77 }; // local Arduino IP
byte gateway[] = { 192,168,0,1 }; // IP of your gateway
byte server[] = { 62,80,29,14 }; // IP of your web server
Client client(server, 80);

int  startup_sec  = 40;            // Zeit, bis alle Sensoren aktiv sind
int  sig          = 3;             // signal
int  value[10]    = {0,0,100,255,0};
int  valueadd[5]  = {0,1,2,4,5};
int  rtc          = 104;
int  potPin       = 1;             // select the input pin for the potentiometer
int  ledPin       = 13;            // select the pin for the LED
int  val          = 0;             // variable to store the value coming from the sensor
char buffer[4]    = "";            // must be large enough to hold your longest string including trailing 0 !!!

const int relais1Pin = 6;          // EIB Küchenlicht
const int relais2Pin = 7;          // EIB Aussenlicht

const int LS_Pin = 4;              // Lichtschranke Garten
const int BM1_Pin = 5;             // Bewegungsmelder Wintergarten 
const int BM2_Pin = 3;             // Bewegungsmelder OG

#define R_SECS      0 
#define R_MINS      1 
#define R_HRS       2 
#define R_WKDAY     3 
#define R_DATE      4 
#define R_MONTH     5 
#define R_YEAR      6 
#define R_SQW       7 


#define rxPin 3
#define txPin 2

const byte command = 0x1B;
const byte fullcut = 0x69;
const byte partialcut = 0x6D;


NewSoftSerial mySerial(rxPin, txPin);

byte second = 0x00;                             // default to 01 JAN 2008, midnight 
byte minute = 0x00; 
byte hour = 0x00; 
byte wkDay = 0x02; 
byte day = 0x01; 
byte month = 0x01; 
byte year = 0x08; 
byte ctrl = 0x00; 
 
 
void growl(String event, String app, String descr, String prior, String user)
 {
      if (client.connect()) { //connect to server

    
      // Make a HTTP request:
      client.println("GET http://www.buero-berge.com/growlscripts/example.php/?event=anlage&app=Alarm&descr=" + descr + "&prior=" + prior + "&user=" + user);  // "&app=" + app + "&descr=" + descr + "&prior=" + prior +  location of ProwlPHP script  /?event=Event&app=Applikation&descr=an%20beide&prior=-2&user=ralf
      client.println();
      selectLineFour();
      mySerial.print("connected to server ");
    } 
    else {         
      selectLineFour();
      mySerial.print("connection failed   ");
    }
    
    delay(2000);
    selectLineFour();
    mySerial.print  ("Response server:    ");

    delay(2000);
    
    selectLineFour();    
    while (client.available()) {
      for (int i=0; i < 20; i++)
       { char c = client.read();
         mySerial.print(c);
       }
       delay(2000);
       selectLineFour();
       mySerial.print("                    ");
       selectLineFour();   
   }
    // if the server's disconnected, stop the client:
    if (!client.connected()) {
       delay(2000);
       selectLineFour();
       mySerial.print("                    ");
       selectLineFour();   
       mySerial.print("disconnecting server");
       client.stop();
    }
    
    
  } 



void setup() 
{ 
      
  Ethernet.begin(mac, ip, gateway);
  Wire.begin(); 
  Serial.begin(9600);
  mySerial.begin(9600);// set the data rate for the SoftwareSerial port

       pinMode(ledPin, OUTPUT);          //we'll use the debug LED to output a heartbeat
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
  selectLineOne();
  mySerial.print("Alarmanlage Vers 1.2");
  selectLineTwo();
  mySerial.print("starting up...");
 

for (int i=0; i < startup_sec; i++)

{ 
  selectLineFour();
  timestamp();
  delay (1000);
 
}
  selectLineTwo();
  mySerial.print("running!            ");
 
/*
       second = 0x00;                                // demo time 
       minute = 0x36; 
       hour   = 0x14; 
       wkDay  = 0x07; 
       day    = 0x26; 
       month  = 0x02; 
       year   = 0x11; 
       ctrl   = 0x00;   
       
    
         setClock() ;
*/


}  //setup



void loop() 
{  
  
//**************** Lichtschranke aktiviert ***********************
  
  val = digitalRead(LS_Pin);               // read Lichtschranke value
  if (val == LOW) {                      // check if the input is HIGH (button released)
    digitalWrite(ledPin, LOW);           // turn LED OFF
    digitalWrite(relais1Pin, LOW);   // turn LED OFF
    digitalWrite(relais2Pin, LOW);   // turn LED OFF
  } 
  
  else {
    
    selectLineThree();
    mySerial.print("Lichtschranke Garten");
 
    Serial.println("Lichtschranke Garten");
        
    growl("Alarm", "Anlage", "Garten", "1","ralf");   // void growl(char event[10], char app[10], char descr[15], char prior[2], char user[5])
   // printAlarm(); 
    Lichtsequenz();
   delay (10000);
  }
  
  
  
//**************** BM Wintergarten aktiviert ***********************
  
  
  
  val = digitalRead(BM1_Pin);               // read Lichtschranke value
  if (val == LOW) {                      // check if the input is HIGH (button released)
    digitalWrite(ledPin, LOW);           // turn LED OFF
    digitalWrite(relais1Pin, LOW);   // turn LED OFF
    digitalWrite(relais2Pin, LOW);   // turn LED OFF
  } 
  
  else {
 
    selectLineThree();
    mySerial.print("Wintergarten");

    Serial.println("Bewegungsmelder Wintergarten");
    growl("Alarm", "Anlage", "WG", "0","ralf");  
   // printAlarm(); 
    Lichtsequenz();
    delay (10000);
  }  
  
  
  //**************** BM OG aktiviert ***********************
  
  
  val = digitalRead(BM2_Pin);               // read Lichtschranke value
  if (val == LOW) {                      // check if the input is HIGH (button released)
    digitalWrite(ledPin, LOW);           // turn LED OFF
    digitalWrite(relais1Pin, LOW);   // turn LED OFF
    digitalWrite(relais2Pin, LOW);   // turn LED OFF
  } 
  
  else {
    
    selectLineThree();
    mySerial.print("Bewegungsmelder OG  ");

    Serial.println("Bewegungsmelder OG");
    growl("Alarm", "Anlage", "OG", "2","ralf");  
    
    delay (10000);// printAlarm(); 
 
  }  
  
 
  delay (500);
    
  selectLineOne();
  mySerial.print("Alarmanlage Vers 1.2");
  selectLineTwo();
  mySerial.print("                    ");
  selectLineThree();
  mySerial.print("                    ");
  
  selectLineFour();
  timestamp();
  
  
  
}   /// loop



void Lichtsequenz()
  {
    delay (1500);  // 
    
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
 
  void timestamp()
 {
       getClock();
       
       if (hour< 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(hour));
                     }
       else { mySerial.print(bcd2Dec(hour));}
       
       mySerial.print(":");
       
       if (minute < 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(minute));
                     }
       else { mySerial.print(bcd2Dec(minute));}
       
       mySerial.print(":");
       
         if (second< 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(second));
                     }
       else { mySerial.print(bcd2Dec(second));}
       
       mySerial.print("    ");
       
         if (day< 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(day));
                     }
       else { mySerial.print(bcd2Dec(day));}

       mySerial.print(".");
       
         if (month< 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(month));
                     }
       else { mySerial.print(bcd2Dec(month));}
       
       mySerial.print(".");
       
         if (year< 10) {mySerial.print("0");
                      mySerial.print(bcd2Dec(year));
                     }
       else { mySerial.print(bcd2Dec(year));}


}
  
 
 void printAlarm()
 {
 
 
       digitalWrite(ledPin, HIGH);           // turn LED ON
       getClock();
    
       mySerial.print("Alarm: ");
       mySerial.print(bcd2Dec(hour));
       mySerial.print(":");
       mySerial.print(bcd2Dec(minute));
       mySerial.print(":");
       mySerial.print(bcd2Dec(second));
       
       mySerial.print("  ");
         
       mySerial.print(bcd2Dec(day));
       mySerial.print(".");
       mySerial.print(bcd2Dec(month));
       mySerial.print(".");
       mySerial.print(bcd2Dec(year));
       mySerial.print("");  
              
       mySerial.print("****************************************");  
     
 
 }


 void setClock() 
{ 
  Wire.beginTransmission(rtc); 
  Wire.send(R_SECS); 
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


void print_startup()
{
       getClock();
 
       mySerial.println("Startup: ");
       mySerial.print(bcd2Dec(hour));
       mySerial.print(":");
       mySerial.print(bcd2Dec(minute));
       mySerial.print(":");
       mySerial.print(bcd2Dec(second));
       
       mySerial.print("  ");
         
       mySerial.print(bcd2Dec(day));
       mySerial.print(".");
       mySerial.print(bcd2Dec(month));
       mySerial.print(".");
       mySerial.print(bcd2Dec(year));
       mySerial.println("");
       mySerial.println("");
       mySerial.println("****************************************");    
       mySerial.println("");         
       mySerial.println("");   
} 




void selectLineOne(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(128, BYTE);    //position
}
void selectLineTwo(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(192, BYTE);    //position
}
void selectLineThree(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(148, BYTE);    //position
}
void selectLineFour(){  //puts the cursor at line 0 char 0.
   mySerial.print(0xFE, BYTE);   //command flag
   mySerial.print(212, BYTE);    //position
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

