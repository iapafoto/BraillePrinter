// Braille Authority of North America][bana-size]. 
// http://www.brailleauthority.org/sizespacingofbraille/index.html
// in mm
double ch_scale = 2.5; //2.34; // distance between dots on chars
double ONE_LINE_Y = 11; //10; //10;  // Size of one line
double ONE_CHAR_X = 6.5; //6.5; //6.2; // Size of One char carret


// Speed -----------------------------------
  int WRITE_SPEED = 40;
  int MOVE_SPEED = 110;
  
  int NB_EMBOSS_REP = 2;
  int EMBOSS_DELAY_REP = 50; 
  
  int EMBOSS_DELAY_BEFORE = 10; // delais entre le dernier mouvement et le debut de l'embossage
  int EMBOSS_DURATION = 20; // 50
  int EMBOSS_DELAY_AFTER = 50; // 20


// Page configuration (A4) -------
int PAGE_W = 210;
int PAGE_H = 297;
int MARGIN_X = 27, MARGIN_Y = 25;
int MIN_X = 0 + MARGIN_X/2 - 5;
int MAX_X = PAGE_W - MARGIN_X/2 + 5 ;
int MIN_Y = 0 + MARGIN_Y/2;
int MAX_Y = PAGE_H - MARGIN_Y/2;


// Debug -------------------------- 
#define WITH_MOTORS
#define WITH_SOLENOIDE
#define WITH_X0_SWITCH
//#define DEBUG

// --------------------------------


// Arduino Pins ----------------------------
int PIN_X0 = 10; // SER1 End of course on X axis
int PIN_SOLENOID = 2; // Command of solenoid
int PIN_LED = 13; //pin number LED is connected to

// Motors ----------------------------------
double MOTOR_SCALE_X = 10; // step to mm 
double MOTOR_SCALE_Y = 8; // step to mm
#define MOTOR_STEP_MODE INTERLEAVE  // MICROSTEP


//String tabAscii = " A1B'K2L@CIF/MSP\"E3H9O6R^DJG>NTQ,*5<-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=";
//String tabBraille = "⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿";

//String fullAsciiToUnicode6_1 = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~";
//String fullAsciiToUnicode6_2 = "⠀⠮⠐⠼⠫⠩⠯⠄⠷⠾⠡⠬⠠⠤⠨⠌⠴⠂⠆⠒⠲⠢⠖⠶⠦⠔⠱⠰⠣⠿⠜⠹⠈⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠪⠳⠻⠘⠸⠀⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠀⠀⠀⠀⠀";

//                                     !  \" #  $  %  &  '  (  )  *  +  ,  -  .  /     0  1  2  3  4  5  6  7  8  9     :  ;  <  =  >  ?  @   A B C D  E  F  G  H  I  J  K L M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z     [  \\ ]  ^  _ `  A B C D  E  F  G  H  I  J  K L M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  { | } ~ ";
//int fullAsciiToBraille[] =        {0,46,16,60,43,41,47,4 ,55,62,33,44,32,36,40,12,   52,2, 6, 18,50,34,22,54,38,20,   49,48,35,63,28,57,8,  1,3,9,25,17,11,27,19,10,26,5,7,13,29,21,15,31,23,14,30,37,39,58,45,61,53,   42,51,59,24,56,0,1,3,9,25,17,11,27,19,10,26,5,7,13,29,21,15,31,23,14,30,37,39,58,45,61,53,0,0,0,0,0};
int fullAsciiToBrailleAntoine[] =   {0,46,16,60,43,41,47,4 ,55,62,33,44,32,36,40,12,   60,33,35,41,57,49,43,59,51,42,   49,48,35,63,28,57,8,  1,3,9,25,17,11,27,19,10,26,5,7,13,29,21,15,31,23,14,30,37,39,58,45,61,53,   42,51,59,24,56,0,1,3,9,25,17,11,27,19,10,26,5,7,13,29,21,15,31,23,14,30,37,39,58,45,61,53,0,0,0,0,0};

// ------------------------------------------


#include <EEPROM.h>

#ifdef WITH_MOTORS
  #include <AFMotor.h>
#endif

#define BACK -1
#define FORW 1


#include <Arduino.h>  // for type definitions

template <class T> int EEPROM_writeAnything(int ee, const T& value)
{
    const byte* p = (const byte*)(const void*)&value;
    unsigned int i;
    for (i = 0; i < sizeof(value); i++)
          EEPROM.write(ee++, *p++);
    return i;
}

template <class T> int EEPROM_readAnything(int ee, T& value)
{
    byte* p = (byte*)(void*)&value;
    unsigned int i;
    for (i = 0; i < sizeof(value); i++)
          *p++ = EEPROM.read(ee++);
    return i;
}

void loadConfiguration()
{
    if (EEPROM.read(0) == 100) {
      EEPROM_readAnything(1, WRITE_SPEED);
      EEPROM_readAnything(5, MOVE_SPEED);
      EEPROM_readAnything(9, NB_EMBOSS_REP);
      EEPROM_readAnything(13, EMBOSS_DELAY_REP);
      EEPROM_readAnything(17, EMBOSS_DELAY_BEFORE);
      EEPROM_readAnything(21, EMBOSS_DURATION);
      EEPROM_readAnything(25, EMBOSS_DELAY_AFTER);
    } // sinon on garde les valeurs par defaut
}

void saveConfiguration()
{
    EEPROM.write(0, 100); // Pour indiquer que l'on a deja sauvegardé une fois des vrai valeurs
    EEPROM_writeAnything(1, WRITE_SPEED);
    EEPROM_writeAnything(5, MOVE_SPEED);
    EEPROM_writeAnything(9, NB_EMBOSS_REP);
    EEPROM_writeAnything(13, EMBOSS_DELAY_REP);
    EEPROM_writeAnything(17, EMBOSS_DELAY_BEFORE);
    EEPROM_writeAnything(21, EMBOSS_DURATION);
    EEPROM_writeAnything(25, EMBOSS_DELAY_AFTER);
}


// Connect a stepper motor 
#ifdef WITH_MOTORS
  AF_Stepper motor1(200, 2);
  AF_Stepper motor2(200, 1);
#endif

// POSITION top right of current char
double x0 = MARGIN_X, 
       y0 = MARGIN_Y;
double pxLast = x0, pyLast = y0;

int isXEnd = 0; // indicate if X is end of course
char data; //variable to store incoming data from JAVA 
boolean brailleOn = false;

// ordre des points Braille 
int brailleOrder[] = { 1,2,3,7,8,6,5,4 };
//int brailleOrder[] = { 0,1,2,6,7,5,4,3 };
//int brailleOrderInv[] = { 3,4,5,7,6,2,1,0 };

void setup() {
  
  loadConfiguration();
  
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
  st_mm = -st_mm;
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

void moveXToEnd() {
#ifdef WITH_MOTORS
    motor1.setSpeed(MOVE_SPEED);

    // En attendant d'avoir un capteur de ce coté, on va vers le capteur tout a la fin
    while (digitalRead(PIN_X0)) {
      motorX(1);
    }
    // et retour en debut de ligne a la meme vitesse
    //pxLast = PAGE_W;
    motorX(-(PAGE_W-MARGIN_X));
    pxLast = MARGIN_X;
    
    // Retour a la vitesse d'ecriture classique
    motor1.setSpeed(WRITE_SPEED);
#endif   
    x0 = MARGIN_X;
}

void nextLine() {
    //moveXToStart();
    //moveXToEnd();
    motor1.setSpeed(MOVE_SPEED);
    //pxLast = MARGIN_X;
    motorY(ONE_LINE_Y);
    motorX(MARGIN_X-pxLast); 
    pxLast = MARGIN_X;
    motor1.setSpeed(WRITE_SPEED);
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
     delay(EMBOSS_DELAY_BEFORE);
     for (int i=0; i<NB_EMBOSS_REP; i++) {
        if (i>0) delay(EMBOSS_DELAY_REP);
        digitalWrite(PIN_SOLENOID, HIGH);       
        delay(EMBOSS_DURATION);
        digitalWrite(PIN_SOLENOID, LOW);
     }
     delay(EMBOSS_DELAY_AFTER); 
  #endif // WITH_SOLENOIDE
}

// bch = (unicode-0x2800);
void drawBrailleChar(int bch) {
#ifdef DEBUG
    Serial.print("BCH:");
    Serial.println(bch);
#endif    
    int id;
    for (int i=0; i<8; i++) {
       id = brailleOrder[i];
       if ((bch & (1<<(id-1))) != 0) {
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



/**
 * Methode pour convertir un carctere Ascii en braille
 */
int convertToBraille(char ascii) {
  int id = ascii-32;
  // Petit blindage
  if (id <0 || id >= 98) {
    id = 0;
  }
  //Serial.println("value at");
  //Serial.println(id);
  //Serial.println(fullAsciiToBrailleAntoine[id]);
  
  int braille = fullAsciiToBrailleAntoine[id];
 // Serial.println(unicode);
  return braille;
}


int configuration(char kind, int val) {
  switch(kind) {
      case 'W': WRITE_SPEED = val; break;
      case 'M': MOVE_SPEED = val; break;
      case 'N': NB_EMBOSS_REP = val; break;
      case 'R': EMBOSS_DELAY_REP = val; break;
      case 'B': EMBOSS_DELAY_BEFORE = val; break;
      case 'D': EMBOSS_DURATION = val; break;
      case 'A': EMBOSS_DELAY_AFTER = val; break;
      default: break;
  }
}


void printConfiguration() {
  Serial.print("$");
  Serial.print("@W:");
  Serial.print(WRITE_SPEED);
  Serial.print("@@M:");
  Serial.print(MOVE_SPEED);
  Serial.print("@@N:");
  Serial.print(NB_EMBOSS_REP);
  Serial.print("@@R:");
  Serial.print(EMBOSS_DELAY_REP);
  Serial.print("@@B:");
  Serial.print(EMBOSS_DELAY_BEFORE);
  Serial.print("@@D:");
  Serial.print(EMBOSS_DURATION);
  Serial.print("@@A:");
  Serial.print(EMBOSS_DELAY_AFTER);
  Serial.println("@$");
}

void loop() {

// Stream.readBytesUntil(character, buffer, length)
// http://pwillard.com/?p=249

  
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
     // Serial.print(data);
         
// TODO voir si pas plus simple avec
// String command = Serial.readString();
// surtout pour gerer la marche arriere 1 ligne sur 2(et peu etre unicode)

     if (data == '~') {
          printConfiguration();
     } else if (data == '^') {
          saveConfiguration();
          Serial.println("Configuration sauvegardée");
     } else if (data == '@') {
        // ex:"@W:40@@M:100@"
          String conf = Serial.readStringUntil('@');
          
          Serial.print("=>[");
          Serial.print(conf);
          Serial.println("]");
          
          char type = conf.charAt(0);
          int value = conf.substring(2).toInt();
          configuration(type, value);          
          
     } else if (/*data == '\n' ||*/ data == '\r') {
      // Retour a la ligne
     
     } else if (data == '{') {
        
        // Init position
        //#ifdef DEBUG
          Serial.println("Init position");
        //#endif
          moveXToEnd();
        
        //#ifdef DEBUG
          Serial.println("Braille On");
        //#endif
          brailleOn = true;
     
     } else if (data == '}') {
        #ifdef DEBUG
          Serial.println("Braille Off");
        #endif
          brailleOn = false;
     
    // } else if (data == 'A') {
        //moveXToStart();
       // motorX(40);
       // pxLast+=40;
       // x0 += 40;
     } else if (data == '\n'/* || data == '#'*/) {
        nextLine();
        Serial.println("EndOfLine");
        
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
          if (data < '~') {
            Serial.println(data);
           // Serial.println((int)data);
            data = convertToBraille(data); // ascii char to unicode
            //Serial.print("braille: ");
            //Serial.println(data, HEX);
            
            drawBrailleChar(data);
          }else {
          
            drawBrailleChar((data-0x2800));
          }
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


// Adapted from Stream.h
const int bSize = 32; 
char Buffer[bSize];  // Serial buffer
char Command[10];    // Arbitrary Value for command size
char Data[15];       // ditto for data size
int ByteCount;
        
// protected method to read stream with timeout
int timedRead(int _timeout) {
  int c;
  int _startMillis = millis();
  do {
    c = Serial.read();
    if (c >= 0) return c;
  } while(millis() - _startMillis < _timeout);
  return -1;     // -1 indicates timeout
}

size_t readBytesUntil(char terminator, char *buffer, size_t length){
  if (length < 1) return 0;
  size_t index = 0;
  while (index < length) {
    int c = timedRead(1000);
    if (c < 0 || c == terminator) break;
    *buffer++ = (char)c;
    index++;
  }
  return index; // return number of characters, not including null terminator
}

String readLine(char terminator){
  size_t sz = readBytesUntil(terminator, Buffer, bSize);
  String str(Buffer);
  return str;
}




