
include <nema17.scad>

$fn = 100;

// epaisseur des plaques
ep = 6;
plC_dx=0;
xAxis1 = 20;
yMotor1 = 30;
xMotor2 = -20;
yMotor2 = -8;
yGround = yMotor2-8-ep/2;
workWidth = 230;


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
    }
}



module plaque() {
    difference() { 
        translate([0,20/2]) rounded_square(120,80, 10,center = true); 
        translate([plC_dx-ep/2,yMotor1]) square([ep,50], center = false); 
    }
}

module plaqueA() {
    difference() {
        plaque();
        union() {
            translate([0,yMotor1]) rounded_square(8, 15, 2, true);
            translate([10,yGround-ep/2]) square([30, ep]);
            translate([-40,yGround-ep/2]) square([30, ep]);
        }
    } 
}


module plaqueB() {
    difference() {
        union() {
            plaque();
            translate([0,yMotor1]) rounded_square(8, 15, 2, true);
        }
        union() {
            translate([0,yMotor1]) rounded_square(8, 15, 2, true);
            
            translate([xAxis1,yMotor1]) circle(3);
            translate([-xAxis1,yMotor1]) circle(3);

            translate([xMotor2,yMotor2]) circle(4);
            
            translate([20,yGround-ep/2]) square([30, ep]);
            translate([-30,yGround-ep/2]) square([30, ep]);

        }
    } 
}

module plaqueC() {
    difference() { 
        plaqueB();
        translate([xMotor2,yMotor2]) nema17Fix(false, true, true, true);
    }
}

module plaqueD() {
    difference() { 
        plaqueA();
        translate([0,yMotor1]) rounded_square(30, 6, 2, true);
        translate([xMotor2,yMotor2]) nema17Fix(false, true, true, true);
    }
}

// La plaque qui acroche moteur 1 et maintient le haut
module plaqueE1() {
    difference() {
        rounded_square(42,42,10);
        union() {
            translate([21,21]) nema17Fix(false, true, true, true);
        } 
    }
}

module plaqueE2() {
    difference() {
        union() {
            rounded_square(42+ workWidth+ 4*ep+20,42,10);
            translate([42-10,-16]) rounded_square(20+2*ep,20,3);
            translate([42+workWidth+2*ep-10,-16]) rounded_square(20+2*ep,20,3);
        }
        union() {
            translate([21,21]) nema17Fix(false, true, true, true);
            translate([42+ep*2+workWidth,-21]) square([ep*2,21]);
            translate([42,-21]) square([ep*2,21]);
            translate([10,10]) rounded_square(42+workWidth+ep*4,22,5);
        } 
    }
}

module plaqueF() {
    difference() { 
        union() {
            rounded_square(120,workWidth, 10, center = false); 
            translate([20,-2*ep]) rounded_square(30,workWidth+4*ep, 3, center = false); 
            translate([70,-2*ep]) rounded_square(30,workWidth+4*ep, 3, center = false); 
        }
        union() {
            translate([20,-ep]) square([10,ep]);
            translate([70,-ep]) square([10,ep]);
            translate([20,workWidth]) square([10,ep]);
            translate([70,workWidth]) square([10,ep]);
      //      translate([xMotor2+50, workWidth+2*ep-25-6]) square([20,50]);
        }
     //   translate([plC_dx-ep/2,yMotor1]) square([ep,50], center = false); 
    }
}

module chariotCut() {
    difference() { 
        rounded_square(64,30,3, center = true);
        union() {
            circle(r=6);
            translate([0,11]) rounded_square(10,2.5,1, true);
            translate([0,-11]) rounded_square(10,2.5,1, true);
            translate([-xAxis1-5,0]) rounded_square(2.5,10,1, true);
            translate([xAxis1+5,0]) rounded_square(2.5,10,1, true);
            translate([-xAxis1+5,0]) rounded_square(2.5,10,1, true);
            translate([xAxis1-5,0]) rounded_square(2.5,10,1, true);
        }
    }
}

module solenoid() {
     union() {
         translate([-6,-5.5,0])cube([12,11,20.5]);
         translate([0,0,20.5]) cylinder(r=1.6/2, h=3.5);
         translate([0,0,24]) cylinder(r=3/2, h=1.);
         translate([0,0,-4.2]) cylinder(r=2, h=4.2);
     }       
}
module linearBearing() {
    translate([xAxis1,0,0]) cylinder(r=6,h=30);
    translate([-xAxis1,0,0]) cylinder(r=6,h=30);
  //  translate([0,-5-1.5,15]) rotate([90,0,0])linear_extrude(3) chariotCut();
}



color([0,1,0]) 
linear_extrude(height=ep) plaqueA();

color([0,1,1]) 
translate([0,0,ep]) linear_extrude(height=ep) plaqueB();

color([0,1,1]) 
translate([0,0,workWidth+2*ep]) linear_extrude(height=ep) plaqueC();
color([0,1,0]) 
translate([0,0,workWidth+3*ep]) linear_extrude(height=ep) plaqueD();


translate([plC_dx+1.5*ep,yMotor1-21,-42]) color([1,.5,.5]) rotate(270,[0,1,0]) linear_extrude(height=ep) plaqueE1();
translate([plC_dx+ep/2,yMotor1-21,-42]) color([1,0,0]) rotate(270,[0,1,0]) linear_extrude(height=ep) plaqueE2();

translate([39+plC_dx+3*ep/2.,yMotor1-42.3/2.,0])rotate([-90,0,90])
    Nema17(42.3,42.3,39,3,2.5);


color([1,1,0]) 
translate([-120/2,yGround+ep/2,2*ep]) rotate([90,0,0]) linear_extrude(height=ep) plaqueF();




/*
translate([xAxis1,yMotor1,ep]) cylinder(r=3,h=workWidth+2*ep);
translate([-xAxis1,yMotor1,ep]) cylinder(r=3,h=workWidth+2*ep);
*/

translate([xMotor2,yMotor2,ep]) cylinder(r=4,h=workWidth+2*ep);

//translate([0,yMotor1,100]) linearBearing();
translate([0,yMotor1-6-3,100+15]) rotate([90,0,0]) solenoid();

//color([0,0,1]) 
//translate([0,yMotor1-5-1.5,115]) rotate([90,0,0]) linear_extrude(3) chariotCut();

translate([xMotor2,yMotor2,workWidth+4*ep-3-25]) cylinder(r=7,h=25);

//translate([xMotor2+42.3/2,yMotor2-42.3/2,workWidth+4*ep+39]) rotate([0,180,0]) Nema17(42.3,42.3,39,3,2.5);



//nema17(false, true, true, false);