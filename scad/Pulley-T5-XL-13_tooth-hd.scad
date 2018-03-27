// Belt pulley is http://www.thingiverse.com/thing:3104 by GilesBathgate
// GPLV3
// Made parametric by droftarts September 2011
// extra mods by triffid_hunter

/**
 * @name Pulley
 * @category Printed
 * @using 1 x m3 nut, normal or nyloc
 * @using 1 x m3x10 set screw or 1 x m3x8 grub screw
 */

module pulley()
{

// tuneable constants

m3_dia = 4;		// 3mm hole diameter
m3_nut_hex = 1;		// 1 for hex, 0 for square nut
m3_nut_flats = 7.9;	// normal M3 hex nut exact width = 5.5
m3_nut_depth = 2.7;	// normal M3 hex nut exact depth = 2.4, nyloc = 4
motor_shaft = 5.2;	// NEMA17 motor shaft exact diameter = 5

retainer = 1;		// Belt retainer end, 1 for Yes, 0 for No
idler = 1;			// 0 = No, 1 = Yes; fills in dish of retainer, if required
retainer_ht = 5;		// height of retainer flange over pulley, standard = 4. Indented into pulley by 2mm.

teeth = 13;			// Number of teeth, standard Mendel = 8
tooth_width = 2.85;	// width of base of tooth, exact size for T5 = 2.65, XL = 2.6124. Increase to improve fit.
tooth_angle = 40;	// angle of tooth sides, exact angle for T5 = 40, XL = 50
tooth_height = 1.3;	// height of tooth, exact size for T5 = 1.2, XL = 1.3 Increase to improve fit.

pulley_t_ht = 12;	// length of toothed part of pulley, standard = 12
pulley_b_ht = 8;		// pulley base height, standard = 8
pulley_b_dia = 25;	// pulley base diameter, standard = 20
no_of_nuts = 1;		// number of captive nuts required, standard = 1
nut_angle = 90;		// angle between nuts, standard = 90
nut_shaft_distance = 2;	// distance between inner face of nut and shaft. standard = 1. Can be negative if your motor has D-shaft or filed flat. Do not set to zero or openscad will make a bad STL

// BELT SELECTION - uncomment preferred belt type

belt_type = "T5"; teeth_dia = ((1.591 * pow(teeth,1.064)) / (0.6523 + pow(teeth,1.064))) * teeth;
//belt_type = "XL"; teeth_dia = ((1.617 * pow(teeth,1.021)) / (0.339 + pow(teeth,1.021))) * teeth;

echo (str("Belt type = ",belt_type,"; number of teeth = ",teeth,"; teeth diameter = ",teeth_dia,"mm"));

// calculated constants

nut_elevation = pulley_b_ht/2;
m3_nut_points = 2*((m3_nut_flats/2)/cos(30)); // This is needed for the nut trap

// Modules

	module spur()
	{
	linear_extrude(height=pulley_t_ht+2) polygon([[0,-(tooth_width/2)],[0,(tooth_width/2)],[-tooth_height,((tooth_width/2)-(tan(tooth_angle/2)*tooth_height))],[-tooth_height,-((tooth_width/2)-(tan(tooth_angle/2)*tooth_height))]],[[0,1,2,3,0]]);
	}

	module retainer()
	{
	rotate_extrude($fn=teeth*4) translate([teeth_dia/2-2.5,0,0]) 
	polygon([[0,0],[1,0],[retainer_ht , retainer_ht - 1],[retainer_ht , retainer_ht],[retainer_ht-2 , retainer_ht],[0,2]],[[0,1,2,3,4,5,0]]);
	}

// Main

difference()
 {	 
 	union()
 	{
 		//base

		if ( pulley_b_ht < 2 ) { echo ("CAN'T DRAW PULLEY BASE, HEIGHT LESS THAN 2!!!"); } else {
 			rotate_extrude($fn=pulley_b_dia*2)
 			{
 					square([pulley_b_dia/2-1,pulley_b_ht]);
 					square([pulley_b_dia/2,pulley_b_ht-1]);
 					translate([pulley_b_dia/2-1,pulley_b_ht-1]) circle(1);
 			}
		}

	difference()
		{
	    	//shaft - diameter is outside diameter of pulley
		translate([0,0,pulley_b_ht]) rotate ([0,0,360/(teeth*4)]) cylinder(r=teeth_dia/2,h=pulley_t_ht, $fn=teeth*2);

	    	//teeth - cut out of shaft
		for(i=[1:teeth]) rotate([0,0,i*(360/teeth)])
		translate([teeth_dia/2,0,pulley_b_ht-1]) spur();
		}
    	
	//belt retainer end
	if ( retainer > 0 ) {translate ([0,0,pulley_b_ht + pulley_t_ht -2]) retainer();
	if ( idler > 0 ) {translate ([0,0,pulley_b_ht + pulley_t_ht]) cylinder(r1=teeth_dia/2-1,r2=(teeth_dia/2-2) + (retainer_ht-2),h=retainer_ht-2,$fn=teeth*4);}}

	}
   
	//hole for motor shaft
    translate([0,0,-1])cylinder(r=motor_shaft/2,h=pulley_b_ht + pulley_t_ht + (retainer_ht),$fn=motor_shaft*4);
    		
    //captive nut and grub screw holes

	if ( pulley_b_ht < m3_nut_flats ) { echo ("CAN'T DRAW CAPTIVE NUTS, HEIGHT LESS THAN NUT DIAMETER!!!"); } else {
	if ( (pulley_b_dia - motor_shaft)/2 < m3_nut_depth + 3 ) { echo ("CAN'T DRAW CAPTIVE NUTS, DIAMETER TOO SMALL FOR NUT DEPTH!!!"); } else {

		for(j=[1:no_of_nuts]) rotate([0,0,j*nut_angle])
		translate([0,0,nut_elevation])rotate([90,0,0])

		union()
		{
			//entrance
			translate([0,-pulley_b_ht/4-0.5,motor_shaft/2+m3_nut_depth/2+nut_shaft_distance]) cube([m3_nut_flats,pulley_b_ht/2+1,m3_nut_depth],center=true);

			//nut
			if ( m3_nut_hex > 0 )
				{
					// hex nut
					translate([0,0.25,motor_shaft/2+m3_nut_depth/2+nut_shaft_distance]) rotate([0,0,30]) cylinder(r=m3_nut_points/2,h=m3_nut_depth,center=true,$fn=6);
				} else {
					// square nut
					translate([0,0.25,motor_shaft/2+m3_nut_depth/2+nut_shaft_distance]) cube([m3_nut_flats,m3_nut_flats,m3_nut_depth],center=true);
				}

			//grub screw hole
			rotate([0,0,22.5])cylinder(r=m3_dia/2,h=pulley_b_dia/2+1,$fn=8);
		}
	}}
 }
   
}

//pulley();