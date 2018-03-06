// 28BYJ-48 Stepper Motor Model

// Mark Benson

// 23/07/2013

// Creative Commons Non Commerical

module stepper28BYJ()
{
translate([0,-8,-19])
difference()
{
	
	union()
	{
		//Body
		color("SILVER") cylinder(r=28/2, h=19, $fn=60);

		//Base of motor shaft
		color("SILVER") translate([0,8,19]) cylinder(r=9/2, h=1.5, $fn=40);

		//Motor shaft
		color("SILVER") translate([0,8,20.5]) 
		intersection()
		{
            cylinder(r=5/2, h=9, $fn=40);
            cube([3,6,9],center=true);
		}

		//Left mounting lug
		color("SILVER") translate([-35/2,0,18.5]) mountingLug();
		
		//Right mounting lug
		color("SILVER") translate([35/2,0,18.5]) rotate([0,0,180]) mountingLug();
	
	//	difference()
	//	{
			//Cable entry housing
			color("BLUE") translate([-14.6/2,-17,1.9]) cube([14.6,17,17]);

	//		cylinder(r=27/2, h=29, $fn=60);
	//	}

	}

	union()
	{
		//Flat on motor shaft
		//translate([-5,0,22]) cube([10,7,25]);
	}
}

}//end of stepper28BYJ module wrapper

module mountingLug()
{
	difference()
	{
		hull()
		{
			cylinder(r=7/2, h=0.5, $fn=40);
			translate([0,-7/2,0]) cube([7,7,0.5]);
		}

		translate([0,0,-1]) cylinder(r=4.2/2, h=2, $fn=40);
	}
}

//Call stepper module - comment this out if you include this file in another model
//stepper28BYJ();
//mountingLug();

