/*
 * MotorKnob
 *
 * A stepper motor follows the turns of a potentiometer
 * (or other sensor) on analog input 0.
 *
 * http://www.arduino.cc/en/Reference/Stepper
 */

#include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 200

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, 7, 8, 9, 10);

// the previous reading from the analog input
int previous = 0;
int stepper_enable=5;

void setup()
{
pinMode(stepper_enable, OUTPUT);
digitalWrite(stepper_enable, HIGH);
// set the speed of the motor to 30 RPMs
  stepper.setSpeed(50);
}

void loop()
{
 
  stepper.step(100);


}
