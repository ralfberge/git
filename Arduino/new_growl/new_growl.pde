
#include <SPI.h>
#include <Ethernet.h>
#include <NewSoftSerial.h>

byte mac[] =     { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] =      { 192,168,0,77 };   // local Arduino IP
byte gateway[] = { 192,168,0,1 };    // IP of your gateway
byte subnet[] =  { 255,255,255,0 };   // subnet mask

byte server[] = { 62,80,29,14 }; // buero-berge.com

#define rxPin 3
#define txPin 2

#define alarmPin 3
#define gartenPin 4

const int relais1Pin = 7;         
const int relais2Pin = 6;       
const int ledPin =  13;      // the number of the LED pin

const int maxtries = 5;    // Anzahl der Versuche zum Webconnect
int tries = 0;


const int Gartendelay = 5;   // Verzögerung bis Gartenlicht angeht
const int Gartenlaenge = 60;   // Dauer die Gartenlicht anbleibt

const int Gartenpause = 60;   // Ruhepause nach Garten
const int Alarmpause = 300;   // Ruhepause nach Alarm


NewSoftSerial mySerial(rxPin, txPin);

// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client(server, 80);



void setup() {
  
  pinMode(alarmPin, INPUT);     
  pinMode(gartenPin, INPUT);   
  
  pinMode(relais1Pin, OUTPUT);      // sets the digital pin as output
  pinMode(relais2Pin, OUTPUT);      // sets the digital pin as output
  pinMode(ledPin, OUTPUT);    
  
  delay(1000);
  mySerial.begin(9600);// set the data rate for the SoftwareSerial port

  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway, subnet);
  // start the serial library:
  Serial.begin(9600);
  // give the Ethernet shield a second to initialize:
  delay(1000);

}

void loop()
{ 
  
 // --------------------------------------   Alarm   --------------------------------------
   
 if (digitalRead(alarmPin)==LOW) 
    {
  tries = 0;
  do 
  { 
  Serial.println("connecting...");
  backlightOn();
  clearLCD();  
  selectLine(1);
  mySerial.print("connecting...");
 
  // if you get a connection, report back via serial:
  if (client.connect()) {
    Serial.println("connected");
     selectLine(2);
     mySerial.print("connected");
    
    // Make a HTTP request:
    client.println("GET http://www.buero-berge.com/growlscripts/example.php/?event=Melder&app=Alarmanlage&descr=Einbruch&prior=2&user=all");
    client.println();
    
    
    while (client.available()) 
    {
    char c = client.read();
    Serial.print(c);
    
    selectLine(4);
    mySerial.print(c);
    }
  
  client.stop();
  tries = maxtries + 1;
  } 
 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
    
    selectLine(3);
    mySerial.print("connection failed");
    client.stop();
    tries = tries + 1;
    delay (10000); 
  }
  
  } while (tries < maxtries);
 
 seconds (Alarmpause);
 }
  
 // --------------------------------------   Gartenmelder   --------------------------------------
 if (digitalRead(gartenPin)==LOW)
    {
   seconds (Gartendelay);
   Lichtsequenz();    
   
  tries = 0;
  do 
  {
  Serial.println("connecting...");
  backlightOn();
  clearLCD();  
  selectLine(1);
  mySerial.print("connecting...");
 
  // if you get a connection, report back via serial:
  if (client.connect()) {
    Serial.println("connected");
     selectLine(2);
     mySerial.print("connected");
    
    // Make a HTTP request:
    client.println("GET http://www.buero-berge.com/growlscripts/example.php/?event=Melder&app=Alarmanlage&descr=Garten&prior=0&user=all");
    client.println();
    
    
    while (client.available()) 
    {
    char c = client.read();
    Serial.print(c);
    
    selectLine(4);
    mySerial.print(c);
    }
  
  client.stop();
  tries = maxtries + 1;
  } 
  
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
    selectLine(3);
    mySerial.print("connection failed");
    client.stop();
    tries = tries + 1;
    delay (10000); 
  }
 } while (tries < maxtries);
 
seconds (Gartenpause);

} 
 
 
delay (300); 
 
}  // loop
  

void Lichtsequenz()
{
  digitalWrite(relais1Pin, HIGH);
  delay (500);
  digitalWrite(relais1Pin, LOW);  

  seconds (Gartenlaenge); 

  digitalWrite(relais2Pin, HIGH);
  delay (500);
  digitalWrite(relais2Pin, LOW);
}



void seconds(int secs)
{  
  for (int i=0; i <= secs; i++)
  {
   delay(1000);
  }  
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

