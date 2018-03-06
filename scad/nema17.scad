module Nema17(xdim ,ydim ,zdim,rdim,shaft){
    translate([xdim/2,ydim/2,0])cylinder(r=shaft,h=65, $fn=50);
    translate([xdim/2,ydim/2,0])cylinder(r=11,h=41, $fn=50);
    difference(){ 
        union(){
            hull(){
                translate([rdim,rdim,0])cylinder(h=zdim,r=rdim, $fn=4);
                translate([xdim-rdim,rdim,0])cylinder(h=zdim,r=rdim, $fn=4);

                translate([rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim, $fn=4);
                translate([xdim-rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim, $fn=4);
            }
        }
        union(){
            #translate([36.55,5.75,34])cylinder(r=1.5,h=5, $fn=50);
            #translate([36.55,36.55,34])cylinder(r=1.5,h=5, $fn=50);    
            #translate([5.75,5.75,34])cylinder(r=1.5,h=5, $fn=50);
            #translate([5.75,36.55,34])cylinder(r=1.5,h=5, $fn=50);    
        }

    }
}



//Nema17(42.3,42.3,39,3,2.5);
//translate([0,60,0])rotate([90,0,90])Nema17(42.3,42.3,39,3,2.5);
