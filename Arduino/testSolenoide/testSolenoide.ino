
int pinSolenoid = 2;

void setup() {

  pinMode(pinSolenoid,OUTPUT);
  Serial.begin(19200);
  Serial.println("Ready");
}

void loop() {

  for (int i=0; i<8; i++) {
     digitalWrite(pinSolenoid, HIGH);       
     delay(40);
     
     digitalWrite(pinSolenoid, LOW);
     delay(100); 
  }
  delay(2000);
} 
