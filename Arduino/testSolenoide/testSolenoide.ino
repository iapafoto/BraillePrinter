
int PIN_SOLENOID = 2;

void setup() {

  pinMode(PIN_SOLENOID,OUTPUT);
  Serial.begin(19200);
  Serial.println("Ready");
}

void loop() {

  for (int i=0; i<8; i++) {
     digitalWrite(PIN_SOLENOID, HIGH);       
     delay(40);
     digitalWrite(PIN_SOLENOID, LOW);
     delay(100); 
  }
  delay(2000);
} 
