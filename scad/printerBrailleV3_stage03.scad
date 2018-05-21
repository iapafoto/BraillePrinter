
include <nema17.scad>
//include <stepper28BYJ48.scad>
// https://www.thingiverse.com/thing:26347/#files
include <Pulley-T5-XL-13_tooth-hd.scad>

// https://www.thingiverse.com/thing:18139 by Jestin Stoffel
include <arduino.scad>

// https://www.thingiverse.com/thing:8000
include <braille.scad>


//https://www.thingiverse.com/thing:193647
//include <Nut_Job.scad> TO HEAVY

$fn = 100;

// epaisseur des plaques
ep = 6;
ep2=3;
plC_dx = 15-ep/2;
xAxis1 = 18;

yMotor1 = 15;
xMotor2 = -37;
yMotor2 = -8;

yGround = -25; //yMotor2-8-1.5*ep;
workWidth = 210+2; // A4 simple     // 297+3 = A3 ou A4 horizon  
// Diametre du raccord entre le moteur 2 et l'axe d'entrainement du papier
dRaccordAxe58 = 14;  // Thin : 14mm  - Standard 19mm

AXE_2_END = 5; //5 : piece en cuivre,  8 : Roulement 686 ZZ

withSteppers = true;
withStepper28BYJ48 = false;
// Avec la petite plaque pour soutenir le bout de la courroie
withE2 = true;
//IS_INVERSE = true;

ELECTRO_H = 42;
ELECTRO_W = 59;
ELECTRO_BOTTOM = yGround+20; //35; //yMotor1-20;


// espace entre la plaque D et le trou de fixation de la courroie 
DELTA_END_X = 11;

module stepper() {
    if (withSteppers) {
       if (withStepper28BYJ48) 
            stepper28BYJ();
       else 
            translate([-42.3/2,-42.3/2,-39]) Nema17(42.3,42.3,39,3,2.5);
   }
}


module RoundedPolygon(P,r)
{
    v = rounded_polygon_v(P,r,$fn);
    polygon(v);
}

function rounded_polygon_v(P,r,fn) =
let
(
    step = 360 / fn,
    n = len(P),
    o_v = [ for(i=[0:n-1]) atan2(P[(i+1)%n][1] - P[i][1], P[(i+1)%n][0] - P[i][0]) + 90 + 360 ]
)
[ 
        for(i=[0:n-1])
            let 
            (
                n1 = i, 
                n2 = (i+1)%n,
                w1 = o_v[n1],
                w2 = (o_v[n2] < w1) ? o_v[n2] : o_v[n2] - 360
            )
            for (w=[w1:-step:w2]) 
                [ cos(w)*r+P[n2][0], sin(w)*r+P[n2][1] ] 
] ;



module rounded_square( width, height, radius_corner, center=false ) {
	tr = center == true ? 0 : radius_corner;
    translate( [ tr, tr] )
		minkowski() {
			square( [width-2*radius_corner, height-2*radius_corner ], center );
			circle( radius_corner );
		}
}

module nema17Fix(withSquare, withFixTop, withFixBottom, withAxis, withBigAxis) {
    width = 42.3; // mm
    fix = 31;
    rFix = 3/2;
    rAxis2 = 22/2;
    rAxis = 5/2;
    
    if (withSquare) {
        square([width,width], center = true);
    }
    
    if (withAxis) {
        circle(r=rAxis);
    }

    if (withBigAxis) {
        circle(r=rAxis2);
    }
    
    if (withFixTop) {
        translate([fix/2,fix/2]) circle(r=rFix);
        translate([-fix/2,fix/2]) circle(r=rFix);
    }
    if (withFixBottom) {
        translate([fix/2,-fix/2]) circle(r=rFix);
        translate([-fix/2,-fix/2]) circle(r=rFix);
    }    
    // add fix for 28BYJ48
    if (withStepper28BYJ48) {
        translate([-35/2,8]) circle(r=rFix);
        translate([35/2,8]) circle(r=rFix);
    }
}


module plaque() {
        difference() {  
            maxX = plC_dx + ep/2+ ELECTRO_W - 1; 
            maxY = ELECTRO_BOTTOM + ELECTRO_H - 1; // 38;    a prendre en compte
            RoundedPolygon([[-50,6], [-0, maxY], [maxX,maxY], [maxX,0], [60,-43+16], [-60,-43+16]], 10);     
            translate([plC_dx-ep/2,yMotor1]) square([ep,50], center = false); 
        }
}


module plaqueA0() {
    difference() {
        plaque();
        union() {
            translate([0,yMotor1]) rounded_square(11, 22, 2., true);
            translate([10,yGround-ep/2]) square([30, ep]);
            translate([-40,yGround-ep/2]) square([30, ep]);
         }
    } 
}

module plaqueB0() {
    difference() {
        union() {
            plaque();
           // translate([0,yMotor1]) rounded_square(8, 22, 2, true);
        }
        union() {
            translate([0,yMotor1]) rounded_square(11, 22, 2, true);
            translate([0,yMotor1+xAxis1]) circle(3);
            translate([0,yMotor1-xAxis1]) circle(3);
            
            
            // Axe d'entrainement avec roulement a bille de rollers
            translate([xMotor2,yMotor2]) circle(AXE_2_END); 
            // roulement de rollers circle(10.5);
            // sans roulement a bille : circle(4);
            
            
            translate([20,yGround-ep/2]) square([30, ep]);
            translate([-30,yGround-ep/2]) square([30, ep+.01]);
            translate([20,yGround+ep*.5]) square([30, ep+.01]);
            translate([-60,yGround+ep*.5]) square([40, ep]);
            
            // Plaque boitier electronique du bas
            translate([plC_dx+ep+ELECTRO_W/2,ELECTRO_BOTTOM-ep2]) square([ELECTRO_W/2, ep2],center=true);
            // plaque boitier electronique du haut
            translate([plC_dx+ep+ELECTRO_W+ELECTRO_W/4,ELECTRO_BOTTOM+ELECTRO_H]) square([ELECTRO_W, ep2],center=true);  
            // Plaque boitier electronique du coté
            translate([plC_dx+ep/2+ELECTRO_W+ep2/2,ELECTRO_BOTTOM+ELECTRO_H/2-ep2/2]) square([ep2,ELECTRO_H/2],center=true);            
        }
    } 
}

module plaqueA() {
    difference() { 
        plaqueA0();
        
        union() {
            // Passage fil moteur X
            translate([plC_dx-ep/2+40,yMotor1]) square([24+2,20],center=true);
            // interrupteur fin de course X
            translate([0,yMotor1-xAxis1-8.5]) square([12.6-.5,5.7-1.5],center=true);
            // Passage fil capteur
            RoundedPolygon([[2,yMotor1-xAxis1-8.5], [14,yMotor1-xAxis1-8.5+12]], 2);
        }
    }
}

module plaqueB() {
    difference() { 
        plaqueB0();
        // Passage fil moteur X
        translate([plC_dx-ep/2+30,yMotor1]) square([9+2,16.5+2],center=true);
        // Passage fil capteur
        RoundedPolygon([[12,yMotor1-xAxis1-8.5+10], [22,yMotor1-xAxis1-8.5+20]], 2);
        // interrupteur fin de course X
        translate([0,yMotor1-xAxis1-8.5]) square([12.6,5.7],center=true);
    }
}

module plaqueC() {
    difference() { 
        plaqueB0();
        union() {
            translate([xMotor2,yMotor2]) nema17Fix(false, true, false, true, false);
            // Passage du raccort 5mm vers 8mm
            translate([xMotor2,yMotor2]) circle(dRaccordAxe58/2+1.2);
            // Fixation de la petite plaque en bout de courroie
      //      if (withE2) {
      //          translate([-plC_dx-ep/2,yMotor1]) square([ep2,50], center = false); 
      //      }
            // Prise USB
            translate([plC_dx+ep/2.+18.5,ELECTRO_BOTTOM+12]) rounded_square(13+1,12+1, 1, center = true);
            // Alimentation 12v
            translate([plC_dx+ep/2.+18.5,ELECTRO_BOTTOM+36]) circle(6);
            // Entree fils Moteur Y && Passage fil capteur
          //  translate([plC_dx+3,yMotor2+8]) rounded_square(12,12, 1,center=true);
            RoundedPolygon([[plC_dx-2,yMotor2+4], [22,yMotor1-xAxis1-8.5+20]], 2);;

            // Passage fil capteur
         //   RoundedPolygon([[12,yMotor1-xAxis1-8.5+10], [22,yMotor1-xAxis1-8.5+20]], 2);
            // interrupteur fin de course X
            translate([0,yMotor1-xAxis1-8.5]) square([12.6,5.7],center=true);

        }
    }
}

module plaqueD() {
    difference() { 
        plaqueA0();

        union() {
            
            // Fixation de la petite plaque en bout de courroie
           
            if (withE2) {
                 translate([-13,yMotor1]) square([ep2, 24], true);
  //              translate([-plC_dx-ep/2,yMotor1]) square([ep2,50], center = false); 
            }
            
            // Fixation moteur Y
            translate([xMotor2,yMotor2]) nema17Fix(false, true, false, true, true);    
            
            // Prise USB + Alimentation 12v
            translate([plC_dx+ep/2.+18.5,ELECTRO_BOTTOM+5+18.5]) rounded_square(14+3,39, 3, center = true);
            // entree fils Moteur Y
            //RoundedPolygon([[plC_dx-6,yMotor2], [plC_dx+3,yMotor2+9]], 2);
            // Passage fil capteur
            //RoundedPolygon([[2,yMotor1-xAxis1-8.5], [14,yMotor1-xAxis1-8.5+12]], 2);
            // entree fils Moteur Y & Passage fil capteur
            RoundedPolygon([[2,yMotor1-xAxis1-8.5], [plC_dx+3,yMotor2+9]], 2);

            // interrupteur fin de course X
            translate([0,yMotor1-xAxis1-8.5]) square([12.6-.5,5.7-1.5],center=true);
           
        }
    }
}

// La plaque qui acroche moteur 1 et maintient le haut
module plaqueE() {
    rnd = ep;
    x0 = rnd;
    x1 = 42.3 + workWidth + 4*ep + 30-2*rnd;
    yhole = (ELECTRO_BOTTOM+ELECTRO_H /*- ep2/2*/) -(yMotor1-20);
    maxY = yhole + 9; // 53
    difference() {
        
        RoundedPolygon([[x0+42.3-rnd,rnd-11], [x0,rnd], [x0,42.3-rnd], [x0+42.3-rnd,maxY-rnd],[x1-30+2*rnd,maxY-rnd],[x1,32-rnd], [x1,24-rnd], [x1-30+2*rnd,rnd-11]], rnd, center = false);   
        
        union() {
            translate([21,21]) nema17Fix(false, true, true, true, true);
 
            // Les encoches principales        
            translate([42+ep*2+workWidth,-1]) square([ep*2,21]);
            translate([42,-1]) square([ep*2,21]);
            translate([42,-20]) square([workWidth+4*ep,20]);

            translate([42+ep*2+10,20]) rounded_square(workWidth-20,12,5);
            
            // Axe de fin de course
            translate([42+ep*4+workWidth+DELTA_END_X,21]) circle(2.5);
            
            // Encastrement capo
              
           // translate([42+ep*2+workWidth/2-workWidth/3.3,yhole]) square([30, ep2], center = true); 
           // translate([42+ep*2+workWidth/2+workWidth/3.3,yhole]) square([30, ep2], center = true); 
            translate([42+ep*2+8,yhole]) square([16, ep2], center = true); 
            translate([42+ep*2+workWidth-8,yhole]) square([16, ep2], center = true); 
            translate([42+ep*2+workWidth/2,yhole]) square([30, ep2], center = true); 
        } 
    }
}

// la petite plaque carre pour soutenir l'axe 
module plaqueE2() {
    
    difference() {
        union() {
            translate([-ep2,-12]) square([ep2,24]);
            RoundedPolygon([[0,12-ep2], [DELTA_END_X+9-ep2,3], [DELTA_END_X+9-ep2,-3], [0,-(12-ep2)]], ep2);
        }     
        union() {
         //   translate([10,-1]) square([ep*2,21]);
            translate([1+DELTA_END_X,0]) circle(2.5);
        } 
    }
}

module plaqueF() {
    difference() { 
        union() {
            translate([0,0]) rounded_square(110,workWidth, 3, center = false); 
            translate([20,-2*ep]) rounded_square(30,workWidth+4*ep, 3, center = false); 
            translate([70,-2*ep]) rounded_square(30,workWidth+4*ep, 3, center = false); 
        }
        union() {
            // encoches pour bloquer les plaques B et C
            translate([18,-ep]) square([12,ep]);
            translate([68,-ep]) square([12,ep]);
            translate([18,workWidth]) square([12,ep]);
            translate([68,workWidth]) square([12,ep]);
            // Legers biseaux pour faciiter le montage
            translate([18,-ep-1.3]) rotate(15) square([10,ep/2]);
            translate([68,-ep-1.3]) rotate(15) square([10,ep/2]);
            translate([18,workWidth+4.3]) rotate(-15) square([10,ep/2]);
            translate([68,workWidth+4.3]) rotate(-15) square([10,ep/2]);

// trou pour les petites roulettes
          translate([18, 7]) rounded_square(10,197,2, center = false);  
// trou pour viser            
         //   translate([xMotor2+30,workWidth-30]) rounded_square(20,50,3);
         //      translate([xMotor2+50, workWidth+2*ep-25-6]) square([20,50]);
        }
     //   translate([plC_dx-ep/2,yMotor1]) square([ep,50], center = false); 
    }
}

module plaqueG() {
    difference() { 
        union() {
            translate([-20,0]) rounded_square(160, workWidth, 10, center = false); 
            translate([0,-ep]) rounded_square(40,workWidth+2*ep, 3, center = false); 
            translate([80,-ep]) rounded_square(30,workWidth+2*ep, 3, center = false); 
        }
        union() {
            translate([4, 2]) square([27,207], center = false); 
        // Sans le chariot reglable
        //    translate([40, ep]) rounded_square(10,workWidth-2*ep, 3, center = false); 
        // Avec le chariot reglable
            translate([40-ep2, ep]) rounded_square(10,workWidth-2*ep, 3, center = false); 
        }
    }
}

// Support caret arduino 
module plaqueH() {
    difference() {
        union() {
            translate([-ep2/2,0]) square([ELECTRO_W+ep2, workWidth], center = true); 
            rounded_square(ELECTRO_W/2, workWidth+2*ep, 3, center = true); 
        }
       // rotate(-90,[0,1,0]) rotate(-90,[1,0,0])  translate([workWidth-4,plC_dx+ep/2.+5,0]) rotate(180,[0,0,1]) {
        union() {
            translate([-ELECTRO_W/2+51.5,90]) rotate(-90) MountingHoles2D(.5);
//            translate([ELECTRO_W-23,90]) rotate(-90) MountingHoles2D();
            for (i=[0:2]) {
                translate([20-3,-i*55+15]) rounded_square(2,6,.5);
                translate([20+3,-i*55+15]) rounded_square(2,6,.5);
            }
        }
     //   }
    }
}

// la plaque du dessus
module plaqueH2() {
    
    translate([-ep2/2,0]) {
        square([ELECTRO_W+ep2, workWidth], center = true); 
        translate([(ELECTRO_W+ep2)/2-ELECTRO_W/8,0]) rounded_square(ELECTRO_W/4, workWidth+2*ep, 3, center = true); 
    //    translate([-ep*1.2,-workWidth/3.3]) rounded_square(ELECTRO_W, 30, 3, center = true); 
    //    translate([-ep*1.2,workWidth/3.3]) rounded_square(ELECTRO_W, 30, 3, center = true); 
        translate([-ep*1.2,0]) rounded_square(ELECTRO_W, 30, 3, center = true); 
        
        difference() {
            union() {
                translate([-ep*2,-workWidth/2+8]) rounded_square(ELECTRO_W, 16, 3, center = true); 
                translate([-ep*2,workWidth/2-8]) rounded_square(ELECTRO_W, 16, 3, center = true); 
            }
            union() {
                translate([-ELECTRO_W/2-ep-1,-workWidth/2+8]) rounded_square(2, 6, .5, center = true); 
                translate([-ELECTRO_W/2-ep-1,workWidth/2-8]) rounded_square(2, 6, .5, center = true); 
            }
        }
    }
}

// La plaque du capo de derriere
module plaqueH3() {

    difference() { 
        union() {
            square([ELECTRO_H, workWidth], center = true); 
            rounded_square(ELECTRO_H/2, workWidth+2*ep, 3, center = true); 
        }
   
      //  y_random_voronoi(   n = 20,
       //                     thickness = 1,
       //                     round = 1,
       //                     xsize = 2*ELECTRO_H/3,
        //                   ysize = workWidth/2,
       //                     seed = undef,
       //                     center = true);
        translate([-15,65]) scale([-1.2,1.2]) rotate(-90) drawText("La Picoreuse", dotRadius = 1.0, charWidth = 9, resolution = 32);
        translate([-2,59]) scale([-1.,1.]) rotate(-90) drawText("abcdefghijklm", dotRadius = 1.0, charWidth = 9, resolution = 32);
        translate([9,59]) scale([-1.,1.]) rotate(-90) drawText("nopqrstuvwxyz", dotRadius = 1.0, charWidth = 9, resolution = 32);
        
        
        //for (i =[0:workWidth/12]) {
        //    translate([0,workWidth/4-i*6]) rounded_square(ELECTRO_H/2, 3, 1, center = true); 
       // }
    //    union() {
    //        translate([4, 2]) square([27,207], center = false); 
    //        translate([40, ep]) rounded_square(10,workWidth-2*ep, 3, center = false); 
    //    }
    }
    
}

module chariotCut() {
    difference() { 
        rounded_square(22+2*xAxis1,30,3, center = true);
        union() {
         //   circle(r=6);
            translate([0,0]) rounded_square(25,2.5,1.2, true);
            // Fixation courroie (Emplacements a verifier)
            translate([6.8,11]) circle(2.5);
            translate([6.8,-11]) circle(2.5);
//            translate([0,11]) rounded_square(16,2.5,1.2, true);
//            translate([0,-11]) rounded_square(16,2.5,1.2, true);
            
            
          /*  
            for (dy=[-10,0,10]) {
                translate([-xAxis1-5,dy]) rounded_square(2.5,5,1., true);
                translate([-xAxis1+5,dy]) rounded_square(2.5,5,1., true);
                
                translate([xAxis1-5,dy]) rounded_square(2.5,5,1., true);
                translate([xAxis1+5,dy]) rounded_square(2.5,5,1., true);                        
            }
            */
             translate([xAxis1-5,-10]) rounded_square(2.5,5,1., true);
             translate([xAxis1+5,-10]) rounded_square(2.5,5,1., true);
                
             translate([xAxis1-5,+10]) rounded_square(2.5,5,1., true);
             translate([xAxis1+5,+10]) rounded_square(2.5,5,1., true);                        
             translate([-xAxis1-5,0]) rounded_square(2.5,5,1., true);
             translate([-xAxis1+5,0]) rounded_square(2.5,5,1., true); 
        }
    }
}

module chariotCutReglable() {
    difference() {
        union() {
            rounded_square(22+2*xAxis1,30,3, center = true);
            translate([-25,0]) rounded_square(80,20,3., true);
        }
        union() {
            translate([-3.5,0]) rounded_square(35,8,1.2, true);
            
            translate([0,11]) rounded_square(16,2.5,1.2, true);
            translate([0,-11]) rounded_square(16,2.5,1.2, true);
            
                translate([-xAxis1-5,-10]) rounded_square(2.5,5,1., true);
                translate([-xAxis1+5,-10]) rounded_square(2.5,5,1., true);
                
                translate([-xAxis1-5,+10]) rounded_square(2.5,5,1., true);
                translate([-xAxis1+5,+10]) rounded_square(2.5,5,1., true);                        
             translate([xAxis1-5,0]) rounded_square(2.5,5,1., true);
             translate([xAxis1+5,0]) rounded_square(2.5,5,1., true); 
            translate([-42,0]) rounded_square(35,2.5,1., true);
        }
    }
    
    difference() {
        translate([-110,0]) rounded_square(80,20,6., true);
        translate([-110,0]) rounded_square(70,2.5,1., true);
    }

}
module chariotCut2() {
    difference() { 
        rounded_square(15+28,30, 3, center = true);   
        union() {
            translate([15/2+7,0]) circle(r=3);
            translate([-15/2-7,10]) circle(r=3);
            translate([-15/2-7,-10]) circle(r=3);
            translate([-4,0]) rounded_square(28,2.1,1, true);
            translate([4,-10]) rounded_square(25,2.1,1, true);
            translate([4,10]) rounded_square(25,2.1,1, true);
        }
    }
 
}

module solenoidMini() {
     union() {
         translate([-6,-5.5,0])cube([12,11,20.5]);
         translate([0,0,20.5]) cylinder(r=1.6/2, h=3.5);
         translate([0,0,24]) cylinder(r=3/2, h=1.);
         translate([0,0,-4.2]) cylinder(r=2, h=4.2);
     }       
}

module solenoid() {
    l=30;
    w=15;
    h=13;
    union() {
        union() {
             translate([-w/2,-h/2,0])cube([w,h,l]);
             translate([0,0,-10]) cylinder(r=2.5, h=55);
        } 
        union() {
             translate([-5,0,l/2-15/2]) rotate([0,90,0]) cylinder(r=2.5, h=15);
            translate([-5,0,l/2+15/2]) rotate([0,90,0]) cylinder(r=2.5, h=15);    
        }
    }
}

module linearBearing() {
    
    translate([0,xAxis1,0]) cylinder(r=6,h=30);
    translate([0,-xAxis1,0]) cylinder(r=6,h=30);
  //  translate([0,-5-1.5,15]) rotate([90,0,0])linear_extrude(3) chariotCut();
}


module MountingHoles2D(r=1.5)
{
    translate([-1.0929112, 0]) ArduinoHole2D(r);
    translate([0, -48.4026972]) ArduinoHole2D(r);
    //translate([51, -29.25+14]) ArduinoHole2D();
    //translate([51, -29.25-14]) ArduinoHole2D();
    translate([51, -5.15]) ArduinoHole2D(r);
    translate([51, -5.15-28]) ArduinoHole2D(r);

   
}

module ArduinoHole2D(rayon=1.5) {
	circle(r=rayon, $fn=24);
}

// Arduino
module electronique() {
    rotate(-90,[0,1,0]) rotate(-90,[1,0,0])  
    translate([workWidth-4,plC_dx+ep/2.+6,0]) rotate(180,[0,0,1]) {
        Arduino(true, false, false);//cube([68,53,38], center=false);
       // translate([0,0,15]) Board();
   //     translate([0,0,15]) scale([1,1,11]) Board();
        rotate(90,[0,1,0]) translate([-31,-13,-15]) cylinder(r=5,h=17, center = true);
       // translate([0,0,34]) Board();
    }
}

module vis() {
    cylinder(r=1.5, h=12);
    translate([0,0,11]) cylinder(r=2.5, h=2);    
}

module exploded(k, withFurnitures) {

    color([1,0,0]) translate([0,0,0-k*30]) linear_extrude(height=ep) plaqueA();
    color([0,1,0]) translate([0,0,ep-k*20]) linear_extrude(height=ep) plaqueB();
    color([0,0,1]) translate([0,0,workWidth+2*ep+k*20]) linear_extrude(height=ep) plaqueC();
    color([1,0,0]) translate([0,0,workWidth+3*ep+k*30]) linear_extrude(height=ep) plaqueD();
    translate([plC_dx+ep/2,yMotor1-20+k*50,-42]) rotate(270,[0,1,0]) linear_extrude(height=ep) plaqueE();
    if (withE2) {
     //   translate([-plC_dx+ep/2.-ep2,yMotor1-21,workWidth+2*ep-k*10]) rotate(270,[0,1,0])  linear_extrude(height=ep2) plaqueE2();
        translate([-plC_dx+ep/2.-ep2,yMotor1,workWidth+4*ep+k*40]) rotate(270,[0,1,0])  linear_extrude(height=ep2) plaqueE2();
        
    }
        
    translate([-120/2,yGround+ep/2-k*40,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueF();    
    translate([-120/2,yGround+ep+ep/2-k*20,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueG();

    translate([plC_dx+ep,ELECTRO_BOTTOM-ep2/2, 2*ep+workWidth/2]) rotate([90,0,0]) {
        union(){
            color([.8,.8,.4]) translate([ELECTRO_W/2+k*20,0,-k*40]) linear_extrude(height=ep2) plaqueH();
      // le capo du dessus
            color([.8,.8,.4]) translate([ELECTRO_W/2+k*20,0, -ELECTRO_H-ep2-k*60]) linear_extrude(height=ep2) plaqueH2();
        }
    }
        
        color([.8,.0,.0]) translate([plC_dx+ep/2.+ELECTRO_W+ep2 +k*40, ELECTRO_BOTTOM+ELECTRO_H/2-ep2/2+k*50,2*ep+workWidth/2]) rotate([90,0,-90]) {
             linear_extrude(height=ep2) plaqueH3();
        } 


        color([.8,.8,.4]) translate([-9-k*20,yMotor1+k*30,115]) rotate([90,0,90]) linear_extrude(3) chariotCut();
    

    if (withFurnitures) {
        // Stepper 1
       
        translate([plC_dx+ep/2.+k*10,yMotor1 +k*50,-42.3/2]) rotate([-90,90,90]) {
            color([.6,.6,.8])stepper();
            color([.8,.6,.4]) {
                translate([0,0,5+k*20]) scale(.8) pulley();
                translate([-15.8,-15.8,-5+k*20]) vis();
                translate([-15.8, 15.8,-5+k*20]) vis();
                translate([ 15.8,-15.8,-5+k*20]) vis();
                translate([ 15.8, 15.8,-5+k*20]) vis();
            }
        }

        // vis et poulie fin de l'axe X    
        translate([plC_dx-23+k*20,yMotor1 +k*50, workWidth+4*ep+DELTA_END_X])  rotate([-90,90,90]) {
            scale(.8) rotate([180,0,0]) pulley();
            translate([0,0,-5-k*20]) scale([1.8,1.8,1.8]) rotate([180,0,0]) vis();
        }

        color([.8,.6,.4]) translate([0,yMotor1+xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
        color([.8,.6,.4]) translate([0,yMotor1-xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
  
  // Chariot   
        color([.8,.6,.4]) translate([0-k*15,yMotor1+k*30,115]) 
            difference() {
                union() {
                    translate([0,xAxis1,-10]) cylinder(r=4,h=6, center=true);
                    translate([0,xAxis1,10]) cylinder(r=4,h=6, center=true);
                    translate([0,-xAxis1,0]) cylinder(r=4,h=6, center=true);
                }
                union () {
                    translate([0,xAxis1,10]) cylinder(r=3,h=100, center=true);
                    translate([0,-xAxis1,0]) cylinder(r=3,h=100, center=true);
                }
            }
        color([.6,.6,.8]) translate([-15-k*30,yMotor1-6-3+25+k*30,100+15]) rotate([90,0,0]) solenoid();

    // Moteur 2
        color([.8,.6,.4]) {
            translate([2-k*30,yMotor1+6+k*30,104]) rotate([0,-90,0]) vis();
            translate([2-k*30,yMotor1+6+k*30,126]) rotate([0,-90,0]) vis();
        }
        color([.8,.6,.4]) translate([xMotor2,yMotor2,ep]) cylinder(r=4,h=workWidth+2*ep);

        color([.8,.6,.4]) translate([xMotor2,yMotor2,workWidth+4*ep-3-25+k*57]) {
            translate([-16,16,27-k*50]) rotate([180,0,0]) vis();
            translate([ 16,16,27-k*50]) rotate([180,0,0]) vis();

            difference() {
                cylinder(r=dRaccordAxe58/2.,h=25);
                cylinder(r=8/2.,h=26);
            }
        }
        
       color([.8,.6,.4]) translate([xMotor2,yMotor2,ep-k*10]) { 
            difference() {
                cylinder(r=AXE_2_END,h=6);
                cylinder(r=4.,h=8);
            }
        }
        
        color([.6,.6,.8]) translate([xMotor2,yMotor2,workWidth+4*ep+k*78]) rotate(180, [1,0,0]) {       stepper();
        }    
        translate([k*20,ELECTRO_BOTTOM+5+k*50,0]) color([1,.5,.5]) electronique();
    
        }
  

}


module cut6mm() {
    translate([0,4]) rotate(180) plaqueA();
    translate([126,-6]) plaqueC();
    translate([0,-85]) rotate(180) plaqueB();
    translate([125,-95]) rotate(0) plaqueD();
    translate([-70,154]) rotate(-90) plaqueF();
    translate([-70,295]) rotate(-90) plaqueG();
    translate([168,347]) rotate(-90) plaqueE();
  //   translate([-140,170]) rotate(-90) plaqueE();
}

module cut3mm() {
    translate([25,-50]) rotate(90) chariotCut();
    if (withE2) {
        translate([20,50]) plaqueE2();
    }
    translate([75,0]) plaqueH2();
    translate([140,0]) plaqueH();
    translate([193,0]) plaqueH3();    
}


rotate(90,[1,0,0]) rotate(90/*$t*360*/,[0,1,0]) translate([0,0,-workWidth/2]) exploded(1.*(.5+.5*cos(360*$t))*1.501, true);

//plaqueH();

//translate([-60,-270]) linear_extrude(3)  
//    cut3mm();
//linear_extrude(6) 
  //  cut6mm();

//plaqueG();
//linear_extrude(6) plaqueC();
//nema17(false, true, true, false);
//plaqueH3();
//chariotCutReglable();
//translate([50,18]) rotate(90) rounded_square(10,workWidth-2*ep, 3, center = false); 

