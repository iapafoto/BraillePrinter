
include <nema17.scad>
include <stepper28BYJ48.scad>

$fn = 100;

// epaisseur des plaques
ep = 6;
ep2=3;
plC_dx=15-ep/2;
xAxis1 = 18;
horizontal = false;
yMotor1 = 15;
xMotor2 = -37;
yMotor2 = -8;

yGround = yMotor2-8-1.5*ep;
workWidth = 210+2; // A4 simple     // 297+3 = A3 ou A4 horizon  
// Diametre du raccord entre le moteur 2 et l'axe d'entrainement du papier
dRaccordAxe58 = 14;  // Thin : 14mm  - Standard 19mm

AXE_2_END = 5; //5 : piece en cuivre,  8 : Roulement 686 ZZ

withStepper28BYJ48 = false;
// Avec la petite plaque pour soutenir le bout de la courroie
withE2 = true;

module stepper() {
   if (withStepper28BYJ48) 
        stepper28BYJ();
   else
        translate([-42.3/2,-42.3/2,-39]) Nema17(42.3,42.3,39,3,2.5);
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
           //yMotor1 
            RoundedPolygon([[-50,6], [-20,43+6-20], [20,43+6-20], [48,25], [50,-43+16], [-60,-43+16]], 10);     
            union() {
                translate([plC_dx-ep/2,yMotor1]) square([ep,50], center = false); 
            }
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
            
            if (horizontal) {
                translate([xAxis1,yMotor1]) circle(3);
                translate([-xAxis1,yMotor1]) circle(3);
            } else {
                translate([0,yMotor1+xAxis1]) circle(3);
                translate([0,yMotor1-xAxis1]) circle(3);
            }
            
            // Axe d'entrainement avec roulement a bille de rollers
            translate([xMotor2,yMotor2]) circle(AXE_2_END); 
            // roulement de rollers circle(10.5);
            // sans roulement a bille : circle(4);
            
            translate([20,yGround-ep/2]) square([30, ep]);
            translate([-30,yGround-ep/2]) square([30, ep]);
            translate([20,yGround+ep*.5]) square([30, ep]);
            translate([-60,yGround+ep*.5]) square([40, ep]);
        }
    } 
}

module plaqueA() {
    difference() { 
        plaqueA0();
        // interrupteur fin de course X
        translate([0,yMotor1-xAxis1-8.5]) square([12.6-.5,5.7-1.5],center=true);  // 6.5 ?
    }
}

module plaqueB() {
    difference() { 
        plaqueB0();
        // interrupteur fin de course X
        translate([0,yMotor1-xAxis1-8.5]) square([12.6,5.7],center=true);  // 6.5 ?
    }
}

module plaqueC() {
    difference() { 
        plaqueB0();
        union() {
            translate([xMotor2,yMotor2]) nema17Fix(false, true, true, false);
            // Passage du raccort 5mm vers 8mm
            translate([xMotor2,yMotor2]) circle(dRaccordAxe58/2+2);
            // Fixation de la petite plaque en bout de courroie
            if (withE2) {
                translate([-plC_dx-ep/2,yMotor1]) square([ep2,50], center = false); 
            }
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
        }
    }
}

// La plaque qui acroche moteur 1 et maintient le haut
module plaqueE() {
    difference() {
        rounded_square(42.3+ workWidth+ 4*ep+20,42.3,10);
        
        union() {
            translate([21,21]) nema17Fix(false, true, true, true);
            
            translate([42+ep*2+workWidth,-1]) square([ep*2,21]);
            translate([42,-1]) square([ep*2,21]);

            translate([42+ep*2+10,20]) rounded_square(workWidth-20,12,5);
           // translate([42+ep*2+10,31.2]) rounded_square(workWidth-20,40,10);

            translate([42+ep*4+workWidth+10,21]) circle(2.5);
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
            translate([0,0])rounded_square(110,workWidth, 3, center = false); 
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
            translate([-20,0]) rounded_square(150, workWidth, 10, center = false); 
            translate([0,-ep]) rounded_square(40,workWidth+2*ep, 3, center = false); 
            translate([80,-ep]) rounded_square(30,workWidth+2*ep, 3, center = false); 
        }
        union() {
            translate([4, 2]) square([27,207], center = false); 
            translate([40, ep]) rounded_square(10,workWidth-2*ep, 3, center = false); 
        }
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
     if (horizontal) {

    translate([xAxis1,0,0]) cylinder(r=6,h=30);
    translate([-xAxis1,0,0]) cylinder(r=6,h=30);
     } else {
        translate([0,xAxis1,0]) cylinder(r=6,h=30);
        translate([0,-xAxis1,0]) cylinder(r=6,h=30);
     }
  //  translate([0,-5-1.5,15]) rotate([90,0,0])linear_extrude(3) chariotCut();
}


module assembled() {
    color([0,1,0]) linear_extrude(height=ep) plaqueA();
    color([0,1,1]) translate([0,0,ep]) linear_extrude(height=ep) plaqueB();
    color([0,1,1]) translate([0,0,workWidth+2*ep]) linear_extrude(height=ep) plaqueC();
    color([0,1,0]) translate([0,0,workWidth+3*ep]) linear_extrude(height=ep) plaqueD();

    color([1,0,0]) translate([plC_dx+ep/2.,yMotor1-21,-42]) rotate(270,[0,1,0]) linear_extrude(height=ep) plaqueE();
    if (withE2) {
        color([1,.5,.5]) translate([-plC_dx+ep/2.-ep2,yMotor1-21,workWidth+2*ep-10]) rotate(270,[0,1,0]) linear_extrude(height=ep2) plaqueE2();
    }
    color([1,1,0]) translate([-120/2,yGround+ep/2,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueF();
    color([1,.5,0]) translate([-120/2,yGround+ep+ep/2,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueG();


    translate([plC_dx+ep/2.,yMotor1,-42.3/2]) rotate([-90,90,90]) stepper();

     if (horizontal) {
         translate([xAxis1,yMotor1,ep]) cylinder(r=3,h=workWidth+2*ep);
         translate([-xAxis1,yMotor1,ep]) cylinder(r=3,h=workWidth+2*ep);     
         color([0,0,1]) translate([0,yMotor1-5-1.5,15]) rotate([90,0,0])           linear_extrude(3) chariotCut();
         translate([0,yMotor1-6-3,100+15]) rotate([90,0,0]) solenoid();
     } else {
        translate([0,yMotor1+xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
        translate([0,yMotor1-xAxis1,ep]) cylinder(r=3,h=workWidth+2*ep);
        color([0,0,1]) translate([-9,yMotor1,115]) rotate([90,0,90])                linear_extrude(3) chariotCut();
        translate([-15,yMotor1-6-3+25,100+15]) rotate([90,0,0]) solenoid();
     }
     translate([0,yMotor1,100]) linearBearing();
     
     
    translate([xMotor2,yMotor2,ep]) cylinder(r=4,h=workWidth+2*ep);

    translate([xMotor2,yMotor2,workWidth+4*ep-3-25]) cylinder(r=dRaccordAxe58/2.,h=25);
    translate([xMotor2,yMotor2,workWidth+4*ep]) rotate(180, [1,0,0]) stepper();

}

module cut6mm() {
    translate([0,3]) rotate(180) plaqueA();
    translate([126,3]) plaqueC();
    translate([0,-75]) rotate(180) plaqueB();
    translate([126,-75]) plaqueD();

    translate([-60,157]) plaqueE();
//    translate([176,114]) plaqueE2();
    translate([-50,154]) rotate(-90) plaqueF();
    translate([207,-105]) /*rotate(-90)*/ plaqueG();
}


/*color([.77,.7,.55]) linear_extrude(ep)*/ 
//rotate(90) cut();
module cut3mm() {
    chariotCut();
    translate([-15,20]) plaqueE2();
   // translate([0,32]) chariotCut2();
   // translate([0,65]) chariotCut2();
}


//assembled();


//cut3mm();
cut6mm();

//nema17(false, true, true, false);


