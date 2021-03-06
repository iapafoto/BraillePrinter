
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
plC_dx=15-ep/2;
xAxis1 = 18;

yMotor1 = 15;
xMotor2 = -37;
yMotor2 = -8;

yGround = yMotor2-8-1.5*ep;
workWidth = 210+2; // A4 simple     // 297+3 = A3 ou A4 horizon  
// Diametre du raccord entre le moteur 2 et l'axe d'entrainement du papier
dRaccordAxe58 = 14;  // Thin : 14mm  - Standard 19mm

AXE_2_END = 5; //5 : piece en cuivre,  8 : Roulement 686 ZZ

withSteppers = true;
withStepper28BYJ48 = false;
// Avec la petite plaque pour soutenir le bout de la courroie
withE2 = false;

ELECTRO_H = 40;
ELECTRO_W = 57;

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

module nema17Fix(withSquare, withFix, withAxis, withBigAxis) {
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
    
    if (withFix) {
        translate([fix/2,fix/2]) circle(r=rFix);
        translate([fix/2,-fix/2]) circle(r=rFix);
        translate([-fix/2,fix/2]) circle(r=rFix);
        translate([-fix/2,-fix/2]) circle(r=rFix);
        // add fix for 28BYJ48
        if (withStepper28BYJ48) {
            translate([-35/2,8]) circle(r=rFix);
            translate([35/2,8]) circle(r=rFix);
        }
    }
    
}







module plaque() {
        difference() {   
            RoundedPolygon([[-50,6], [-0,38], [70,38], [70,0], [60,-43+16], [-60,-43+16]], 10);     
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
            translate([-30,yGround-ep/2]) square([30, ep]);
            translate([20,yGround+ep*.5]) square([30, ep]);
            translate([-60,yGround+ep*.5]) square([40, ep]);
            
            // Plaque boitier electronique du bas
            translate([plC_dx+ep+ELECTRO_W/2,yMotor1-ELECTRO_H/2+3-ep2/2]) square([ELECTRO_W/2, ep2],center=true);
            // plaque boitier electronique du haut
            translate([plC_dx+ep+ELECTRO_W+ELECTRO_W/4,yMotor1+ELECTRO_H/2+3+ep2/2]) square([ELECTRO_W, ep2],center=true);  
            // Plaque boitier electronique du coté
            translate([plC_dx+ep+ELECTRO_W,yMotor1+ep2]) square([ep2,ELECTRO_H/2],center=true);            
        }
    } 
}

module plaqueA() {
    difference() { 
        plaqueA0();
        
        union() {
            // interrupteur fin de course X
            translate([0,yMotor1-xAxis1-8.5]) square([12.6-.5,5.7-1.5],center=true);
            // Passage fil moteur X
            translate([plC_dx-ep/2+30,yMotor1]) square([9+2,16.5+2],center=true);
            // Passage fil capteur
            RoundedPolygon([[2,yMotor1-xAxis1-8.5], [14,yMotor1-xAxis1-8.5+12]], 2);
        }
    }
}

module plaqueB() {
    difference() { 
        plaqueB0();
        // interrupteur fin de course X
        translate([0,yMotor1-xAxis1-8.5]) square([12.6,5.7],center=true);
        // Passage fil moteur X
        translate([plC_dx-ep/2+30,yMotor1]) square([9+2,16.5+2],center=true);
 // Passage fil capteur
           RoundedPolygon([[12,yMotor1-xAxis1-8.5+10], [22,yMotor1-xAxis1-8.5+20]], 2);
    }
}

module plaqueC() {
    difference() { 
        plaqueB0();
        union() {
            translate([xMotor2,yMotor2]) nema17Fix(false, true, true, false);
            // Passage du raccort 5mm vers 8mm
            translate([xMotor2,yMotor2]) circle(dRaccordAxe58/2+1.2);
            // Fixation de la petite plaque en bout de courroie
            if (withE2) {
                translate([-plC_dx-ep/2,yMotor1]) square([ep2,50], center = false); 
            }
            // Prise USB
            translate([plC_dx+ep/2.+18,7]) rounded_square(14+1,12+1, 2, center = true);
            // Alimentation 12v
            translate([plC_dx+ep/2.+18,31]) circle(6);
            // Entree fils Moteur Y
          //  translate([plC_dx+3,yMotor2+8]) rounded_square(12,12, 1,center=true);
            RoundedPolygon([[plC_dx-3,yMotor2+3], [plC_dx+6,yMotor2+12]], 3);;
        }
    }
}

module plaqueD() {
    difference() { 
        plaqueA0();
    //    translate([0,yMotor1]) rounded_square(30, 6, 2, true);
        union() {
            // Fixation de la petite plaque en bout de courroie
            if (withE2) {
                translate([-plC_dx-ep/2,yMotor1]) square([ep2,50], center = false); 
            }
            translate([xMotor2,yMotor2]) nema17Fix(false, true, true, true);
            
            // Prise USB + Alimentation 12v
            // translate([plC_dx+ep/2.+18,7]) rounded_square(14+3,12+3, 2, center = true);
            translate([plC_dx+ep/2.+18,18.5]) rounded_square(14+3,39, 4, center = true);
            // entree fils Moteur Y
//            translate([plC_dx-1,yMotor2+5]) rounded_square(ep,10, 2,center=true);
            RoundedPolygon([[plC_dx-6,yMotor2], [plC_dx+3,yMotor2+9]], 3);
        }
    }
}

// La plaque qui acroche moteur 1 et maintient le haut
module plaqueE() {
    rnd = ep;
    x0 = rnd;
    x1 = 42.3 + workWidth + 4*ep + 30-2*rnd;
    difference() {
        
      //  rounded_square(42.3 + workWidth + 4*ep+20,55,10);
        RoundedPolygon([[x0+42.3-rnd,rnd-11], [x0,rnd], [x0,42.3-rnd], [x0+42.3-rnd,53-rnd],[x1-30+2*rnd,53-rnd],[x1,32-rnd], [x1,24-rnd], [x1-30+2*rnd,rnd-11]], rnd, center = false);   
        
        union() {
            translate([21,21]) nema17Fix(false, true, true, true);
 
            // Les encoches principales        
            translate([42+ep*2+workWidth,-1]) square([ep*2,21]);
            translate([42,-1]) square([ep*2,21]);
            translate([42,-20]) square([workWidth+4*ep,20]);

            translate([42+ep*2+10,20]) rounded_square(workWidth-20,12,5);

         //   translate([42+ep*3+workWidth,-2]) rounded_square(8,10,2);
           // translate([42+ep*2+10,31.2]) rounded_square(workWidth-20,40,10);

            translate([42+ep*4+workWidth+10,21]) circle(2.5);
            
            // Encastrement capo
            yhole = (yMotor1 + ELECTRO_H/2 + 3 /*- ep2/2*/) -(yMotor1-21);  
            translate([42+ep*2+workWidth/2-workWidth/3.3,yhole]) square([30, ep2], center = true); 
            translate([42+ep*2+workWidth/2+workWidth/3.3,yhole]) square([30, ep2], center = true); 
        } 
    }
}

// la petite plaque carre pour soutenir l'axe 
module plaqueE2() {
    difference() {
        translate([0,0]) rounded_square(30+2*ep, 42.3,10);
        union() {
            translate([10,-1]) square([ep*2,21]);
            translate([30,21]) circle(2.5);
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
            translate([20,-ep]) square([10,ep]);
            translate([70,-ep]) square([10,ep]);
            translate([20,workWidth]) square([10,ep]);
            translate([70,workWidth]) square([10,ep]);

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
            translate([40, ep]) rounded_square(10,workWidth-2*ep, 3, center = false); 
        }
    }
}

// Support caret arduino 
module plaqueH() {
    square([ELECTRO_W+ep2, workWidth], center = true); 
    rounded_square(ELECTRO_W/2, workWidth+2*ep, 3, center = true); 
}

module plaqueH2() {

    square([ELECTRO_W+ep2, workWidth], center = true); 
    translate([(ELECTRO_W+ep2)/2-ELECTRO_W/8,0]) rounded_square(ELECTRO_W/4, workWidth+2*ep, 3, center = true); 
    translate([-ep*1.2,-workWidth/3.3]) rounded_square(ELECTRO_W, 30, 3, center = true); 
    translate([-ep*1.2,workWidth/3.3]) rounded_square(ELECTRO_W, 30, 3, center = true); 
}

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
        translate([-10,65]) scale([-1.2,1.2]) rotate(-90) drawText("La Picoreuse", dotRadius = 1.0, charWidth = 9, resolution = 32);
        translate([5,35]) scale([-1.,1.]) rotate(-90) drawText("iapafoto", dotRadius = 1.0, charWidth = 9, resolution = 32);
        
        
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
            translate([0,11]) rounded_square(16,2.5,1.2, true);
            translate([0,-11]) rounded_square(16,2.5,1.2, true);
            
            for (dy=[-10,0,10]) {
                translate([-xAxis1-5,dy]) rounded_square(2.5,5,1., true);
                translate([-xAxis1+5,dy]) rounded_square(2.5,5,1., true);
                
                translate([xAxis1-5,dy]) rounded_square(2.5,5,1., true);
                translate([xAxis1+5,dy]) rounded_square(2.5,5,1., true);                        
            }
        }
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


// Arduino
module electronique() {
    rotate(-90,[0,1,0]) rotate(-90,[1,0,0])  
    translate([workWidth-4,plC_dx+ep/2.+5,0]) rotate(180,[0,0,1]) {
        Arduino(true, false, false);//cube([68,53,38], center=false);
       // translate([0,0,15]) Board();
        translate([0,0,15]) scale([1,1,11]) Board();
        rotate(90,[0,1,0]) translate([-31,-13,-15]) cylinder(r=5,h=17, center = true);
       // translate([0,0,34]) Board();
    }
}

module vis() {
    cylinder(r=1.5, h=12);
    translate([0,0,11]) cylinder(r=2.5, h=2);    
}

module exploded(k, withFurnitures) {

    translate([0,0,0-k*30]) linear_extrude(height=ep) plaqueA();
    translate([0,0,ep-k*20]) linear_extrude(height=ep) plaqueB();
    translate([0,0,workWidth+2*ep+k*20]) linear_extrude(height=ep) plaqueC();
    translate([0,0,workWidth+3*ep+k*30]) linear_extrude(height=ep) plaqueD();

    translate([plC_dx+ep/2.,yMotor1-21+k*50,-42]) rotate(270,[0,1,0]) linear_extrude(height=ep) plaqueE();
    
    if (withE2) {
        translate([-plC_dx+ep/2.-ep2,yMotor1-21,workWidth+2*ep-k*10]) rotate(270,[0,1,0])  linear_extrude(height=ep2) plaqueE2();
    }
    
    translate([-120/2,yGround+ep/2-k*40,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueF();
    
    translate([-120/2,yGround+ep+ep/2-k*20,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueG();

color([.8,.8,.4]) {
    translate([plC_dx+ep/2.,yMotor1+3, 2*ep+workWidth/2]) rotate([90,0,0]) {
        union(){
        translate([ELECTRO_W/2+ep2,0, ELECTRO_H/2+k*5]) linear_extrude(height=ep2) plaqueH();
        translate([ELECTRO_W/2+ep2,0, -ELECTRO_H/2-ep2-k*5]) linear_extrude(height=ep2) plaqueH2();
        }
    }
    
    translate([plC_dx+ep/2.+ELECTRO_W+3*ep2/2, yMotor1+3,2*ep+workWidth/2]) rotate([90,0,-90]) {
        linear_extrude(height=ep2) plaqueH3();
    }    



    
    translate([-9-k*20,yMotor1+k*30,115]) rotate([90,0,90]) linear_extrude(3) chariotCut();
}

    if (withFurnitures) {
        translate([plC_dx+ep/2.+k*10,yMotor1 +k*50,-42.3/2]) rotate([-90,90,90]) {
            color([.6,.6,.8])stepper();
            color([.8,.6,.4]) {
                translate([0,0,5+k*20]) scale(.8) pulley();
                translate([-16,-16,5+k*20]) vis();
                translate([-16, 16,5+k*20]) vis();
                translate([ 16,-16,5+k*20]) vis();
                translate([ 16, 16,5+k*20]) vis();
                translate([-(workWidth+4*ep+33),0,5+k*20+20]) {
                    scale(.8) rotate([180,0,0]) pulley();
                    translate([0,0,-k*30]) scale([1.8,1.8,1.8]) rotate([180,0,0]) vis();
                }
            }
        }


        color([.8,.6,.4]) translate([0,yMotor1+xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
        color([.8,.6,.4]) translate([0,yMotor1-xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
    
    
         color([.8,.6,.4]) translate([-9-k*10,yMotor1+k*30,115]) 
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
            
        color([.6,.6,.8]) translate([-15-k*30,yMotor1-6-3+25+k*30,100+15]) rotate([90,0,0])         solenoid();

color([.8,.6,.4]) {
    translate([-15-k*25,yMotor1+6+k*30,104]) rotate([0,-90,0]) vis();
    translate([-15-k*25,yMotor1+6+k*30,126]) rotate([0,-90,0]) vis();
}
       //  translate([0,yMotor1,100]) linearBearing();
         
         
        color([.8,.6,.4]) translate([xMotor2,yMotor2,ep]) cylinder(r=4,h=workWidth+2*ep);

        color([.8,.6,.4]) translate([xMotor2,yMotor2,workWidth+4*ep-3-25+k*57]) {
            translate([-16,16,-k*40]) rotate([180,0,0]) vis();
            translate([ 16,16,-k*40]) rotate([180,0,0]) vis();

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
         color([1,.5,.5]) electronique();
    }    

}


module cut6mm() {
    translate([0,4]) rotate(180) plaqueA();
    translate([126,-6]) plaqueC();
    translate([0,-85]) rotate(180) plaqueB();
    translate([126,-95]) plaqueD();
    translate([-70,154]) rotate(-90) plaqueF();
    translate([-70,295]) rotate(-90) plaqueG();
    translate([156,346]) rotate(-90) plaqueE();
}

module cut3mm() {
    translate([28,19]) rotate(90) chariotCut();
    if (withE2) {
        translate([0,-122]) plaqueE2();
    }
    translate([75,0]) plaqueH2();
    translate([137,0]) plaqueH();
    translate([190,0]) plaqueH3();    
}


rotate(90,[1,0,0]) rotate(90,[0,1,0]) exploded(1.5, true);



//translate([-60,-270]) linear_extrude(3)  
//    cut3mm();
//linear_extrude(6) 
//    cut6mm();

//nema17(false, true, true, false);
//plaqueH3();

