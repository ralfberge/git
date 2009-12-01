#include <DmxSimple.h>

void setup() {
}

void loop() {
  int brightness;  
  for (brightness = 0; brightness <= 255; brightness++) {
    DmxSimple.write(1, brightness); // Set DMX channel 1 to new value
     delay(80); // Wait 10ms
  }
  
  for (brightness = 255; brightness >= 0; brightness--) {
    DmxSimple.write(1, brightness); // Set DMX channel 1 to new value
    
    
    delay(80); // Wait 10ms
  }
}
