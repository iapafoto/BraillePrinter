int PIN_X0 = 10; // SER1


void setup() {
 Serial.begin(9600);
  Serial.setTimeout(50);

// Butee de fin de course X
  pinMode(PIN_X0, INPUT_PULLUP);
//  pinMode(9, INPUT_PULLUP);
  //digitalWrite(10, HIGH);
  //digitalWrite(9, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
  int val = digitalRead(PIN_X0);
 // Serial.print("10---");
 // Serial.println(val);
  int val2 = digitalRead(10);
  Serial.print("10---");
  Serial.println(val2);
 // sleep(100);
}
