// Adafruit Motor shield library
// copyright Adafruit Industries LLC, 2009
// this code is public domain, enjoy!

#include <AFMotor.h>

// Connect a stepper motor with 48 steps per revolution (7.5 degree)
// to motor port #2 (M3 and M4)
AF_Stepper motor1(200, 1);
AF_Stepper motor2(200, 2);

int PIN_X0 = 10;

int isXEnd = 0;

/*
void setup()
{
  pinMode(PIN_X0, INPUT_PULLUP);
  pinMode(3, INPUT_PULLUP);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
}
 
void loop()
{
  int b3 = digitalRead(3);
   
  digitalWrite(12, b2 ? HIGH : LOW);
  digitalWrite(13, b3 ? HIGH : LOW);
  
}
*/

void setup() {

  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

pinMode(PIN_X0, INPUT);
  //pinMode(PIN_X0, INPUT_PULLUP);

  motor1.setSpeed(20);  // 10 rpm   
  motor2.setSpeed(20);  // 10 rpm   
}

void loop() {

 // Serial.println("Single coil steps");

  isXEnd = digitalRead(PIN_X0);
 Serial.println(isXEnd);

  if (isXEnd) {
    motor1.step(100, FORWARD, INTERLEAVE); 
    //motor1.step(30, BACKWARD, INTERLEAVE); 
  
    motor2.step(100, FORWARD, SINGLE); 
    motor2.step(30, BACKWARD, SINGLE);
  }
   
/*
  Serial.println("Double coil steps");
  motor.step(100, FORWARD, DOUBLE); 
  motor.step(100, BACKWARD, DOUBLE);

  Serial.println("Interleave coil steps");
  motor.step(100, FORWARD, INTERLEAVE); 
  motor.step(100, BACKWARD, INTERLEAVE); 

  Serial.println("Micrsostep steps");
  motor.step(30, FORWARD, MICROSTEP); 
  motor.step(30, BACKWARD, MICROSTEP); 
*/
}
