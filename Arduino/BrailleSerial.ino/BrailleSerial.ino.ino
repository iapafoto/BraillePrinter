// Braille Authority of North America][bana-size]. 
// http://www.brailleauthority.org/sizespacingofbraille/index.html
// in mm
double ch_scale = 2.34; // distance between dots on chars
double ONE_LINE_Y = 10;  // Size of one line
double ONE_CHAR_X = 6.2; // Size of One char carret

// Page configuration (A4) -------
int MARGIN_X = 30, MARGIN_Y = 30;
int MIN_X = 0 + MARGIN_X;
int MAX_X = 210 - MARGIN_X;
int MIN_Y = 0 + MARGIN_Y;
int MAX_Y = 297 - MARGIN_Y;

// Debug -------------------------- 
#define WITH_MOTORS
#define WITH_SOLENOIDE
#define WITH_X0_SWITCH
#define DEBUG
// --------------------------------



// Arduino Pins ----------------------------
int PIN_X0 = 10; // SER1 End of course on X axis
int PIN_SOLENOID = 2; // Command of solenoid
int PIN_LED = 13; //pin number LED is connected to

// Motors ----------------------------------
double MOTOR_SCALE_X = 10; // step to mm 
double MOTOR_SCALE_Y = 8; // step to mm
#define MOTOR_STEP_MODE INTERLEAVE

// Speed -----------------------------------
int WRITE_SPEED = 40;
int MOVE_SPEED = 100;
int EMBOSS_DURATION = 40;
int EMBOSS_DELAY = 10;


// ------------------------------------------

#ifdef WITH_MOTORS
  #include <AFMotor.h>
#endif

#define BACK -1
#define FORW 1


// Connect a stepper motor 
#ifdef WITH_MOTORS
  AF_Stepper motor1(200, 1);
  AF_Stepper motor2(200, 2);
#endif

// POSITION top right of current char
double x0 = MARGIN_X, 
       y0 = MARGIN_Y;
double pxLast = x0, pyLast = y0;

int isXEnd = 0; // indicate if X is end of course
char data; //variable to store incoming data from JAVA 
boolean brailleOn = false;

int brailleOrder[] = { 1,2,3,7,8,6,5,4 };
//int brailleOrder[] = { 0,1,2,6,7,5,4,3 };
//int brailleOrderInv[] = { 3,4,5,7,6,2,1,0 };

void setup() {
  pinMode(PIN_LED, OUTPUT);
  
  Serial.begin(9600);
  Serial.setTimeout(50);

// Butee de fin de course X (utilisation de la resistance pull up)
  pinMode(PIN_X0, INPUT_PULLUP);
// Solenoide pour embossage
  pinMode(PIN_SOLENOID,OUTPUT);
  
// Les moteurs  
#ifdef WITH_MOTORS
  motor1.setSpeed(WRITE_SPEED);  // 10 rpm   
  motor2.setSpeed(WRITE_SPEED);  // 10 rpm
#endif

// TODO at end
//motor1.release();
//motor2.release();
}


void motorX(double st_mm) {
#ifdef WITH_MOTORS
  motor1.step(abs(st_mm)*MOTOR_SCALE_X, st_mm>=0?FORWARD:BACKWARD, MOTOR_STEP_MODE);
#endif
}

void motorY(double st_mm) {
#ifdef WITH_MOTORS
  motor2.step(abs(st_mm)*MOTOR_SCALE_Y, st_mm>=0?FORWARD:BACKWARD, MOTOR_STEP_MODE);
#endif
}

void moveXToStart() {
#ifdef WITH_MOTORS
    motor1.setSpeed(MOVE_SPEED);
    while (digitalRead(PIN_X0)) {
      motorX(-1);
    }
    motor1.setSpeed(WRITE_SPEED);
#endif   
    pxLast = 0;
    x0 = MARGIN_X;
}


void nextLine() {
    moveXToStart();
    motorY(ONE_LINE_Y);
    x0 = MARGIN_X;
    y0 += ONE_LINE_Y;
    pyLast += ONE_LINE_Y;    
}

void moveTo(double chx, double chy) {
    double dx, dy,
           x = x0+ch_scale*chx, 
           y = y0+ch_scale*chy;  

    if (x != pxLast && x>=MIN_X && x<=MAX_X) {
        // move M1 from pxLast to x
        dx = x-pxLast;
        motorX(dx); 
        pxLast = x;
    }
    
    if (y != pyLast && y>=MIN_Y && y<=MAX_Y) {
        // M2 from pyLast to y
        dy = y-pyLast;
        motorY(dy); 
       pyLast = y;
    }
}

void embosse() {
  #ifdef WITH_SOLENOIDE
     digitalWrite(PIN_SOLENOID, HIGH);       
     delay(EMBOSS_DURATION);
     digitalWrite(PIN_SOLENOID, LOW);
     delay(EMBOSS_DELAY); 
  #endif // WITH_SOLENOIDE
}

// bch = (unicode-0x2800);
void drawBrailleChar(char bch) {
#ifdef DEBUG
    Serial.print("BCH:");
    Serial.println(bch);
#endif    
    int id;
    for (int i=0; i<8; i++) {
       id = brailleOrder[i];
       if ((bch & (1<<id)) != 0) {
          moveTo(id<7?(id-1)/3:id-7, id<7?((id-1)%3):3);
          embosse();
#ifdef DEBUG
          Serial.print("ID:");
          Serial.println(id);          
          Serial.print("moveTo(");
          Serial.print(id<7?(id-1)/3:id-7);
          Serial.print(",");
          Serial.print(id<6?((id-1)%3):3);
          Serial.println(");");
#endif          
       }
    }
}


void loop() {
  
  if (Serial.available()>0){ //if data has been written to the Serial stream
/*
   // Serial.print("⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏");
   String command = Serial.readString();

   // data = Serial.read();
    Serial.println(command);
    //Serial.print("---");
    
  }
  */
   
      data = Serial.read();
 //     Serial.print(data);
         
// TODO voir si pas plus simple avec
// String command = Serial.readString();
// surtout pour gerer la marche arriere 1 ligne sur 2(et peu etre unicode)
     if (data == '\n' || data == '\r') {
      // Retour a la ligne
     
     } else if (data == '{') {
        #ifdef DEBUG
          Serial.println("Braille On");
        #endif
          brailleOn = true;
     
     } else if (data == '}') {
        #ifdef DEBUG
          Serial.println("Braille Off");
        #endif
          brailleOn = false;
     
     } else if (data == 'A') {
        //moveXToStart();
        motorX(40);
        pxLast+=40;
        x0 += 40;
     } else if (data == 'B') {
        nextLine();
       //B moveXToStart();
 #ifdef WITH_MOTORS
        motor1.release();
        motor2.release();
 #endif
        //motorX(-40);
        //pxLast-=40;
        //x0 -= 40;
     } else {

        if (brailleOn) {
          drawBrailleChar(data);
          x0 += ONE_CHAR_X;
        } else {

      
        }
     
      }
  } else {
     // Keep peacefull
     #ifdef WITH_MOTORS
        motor1.release();
        motor2.release();
    #endif
  }

  
}


