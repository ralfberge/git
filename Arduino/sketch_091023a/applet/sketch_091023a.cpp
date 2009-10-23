#include "WProgram.h"
#include "LiquidCrystal.h"
//LiquidCrystal(rs, enable, d4, d5, d6, d7) 
  LiquidCrystal (12, 2, 7, 8, 9, 10);

void setup()
{
  lcd.print("hello, world!");
}

void loop() {}
int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

