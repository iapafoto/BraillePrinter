//testText = ["Feature me", "Thingiverse"];
//testText = [
//	"La Picoreuse"
//];

/*
dotHeight = 0.5;
dotRadius = 1;
charWidth = 7;
resolution = 10;
lineHeight = 12;
totalHeight = len(testText)*lineHeight;
//slabX = 50;
slabX = 150;
slabY = totalHeight;
*/

module drawDot(location, dotRadius = 0.5, resolution = 10) {
	translate(location) {
		difference() {
			circle(r=dotRadius, $fn = resolution);
		}
	}
}

module drawCharacter(charMap, dotRadius = 0.5, resolution = 10) {
	for(i = [0: len(charMap)-1]) {
		drawDot([floor((charMap[i]-1)/3)*.5*3*dotRadius*2, -(charMap[i]-1)%3*.5*3*dotRadius*2, 0], dotRadius, resolution);
	}
}

charKeys = ["a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", ",", ";", ":", ".", "!", "(", ")", "?", "\"", "*", "'", "-"];
charValues = [[1], [1], [1, 2], [1, 2], [1, 4], [1, 4], [1, 4, 5], [1, 4, 5], [1, 5], [1, 5], [1, 2, 4], [1, 2, 4], [1, 2, 4, 5], [1, 2, 4, 5], [1, 2, 5], [1, 2, 5], [2, 4], [2, 4], [2, 4, 5], [2, 4, 5], [1, 3], [1, 3], [1, 2, 3], [1, 2, 3], [1, 3, 4], [1, 3, 4], [1, 3, 4, 5], [1, 3, 4, 5], [1, 3, 5], [1, 3, 5], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 5], [1, 2, 3, 5], [2, 3, 4], [2, 3, 4], [2, 3, 4, 5], [2, 3, 4, 5], [1, 3, 6], [1, 3, 6], [1, 2, 3, 6], [1, 2, 3, 6], [2, 4, 5, 6], [2, 4, 5, 6], [1, 3, 4, 6], [1, 3, 4, 6], [1, 3, 4, 5, 6], [1, 3, 4, 5, 6], [1, 3, 5, 6], [1, 3, 5, 6], [2], [2, 3], [2, 5], [2, 5, 6], [2, 3, 5], [2, 3, 5, 6], [2, 3, 5, 6], [2, 3, 6], [2, 3, 6], [3, 5], [3], [3, 6]];

module drawText(text, dotRadius = 0.5, charWidth = 3.5, resolution = 10) {
    
	for(i = [0: len(text)-1]) {
		translate([charWidth*i, 0, 0]) {
			for(j = [0:len(charKeys)]) {
				if(charKeys[j] == text[i]) {
					drawCharacter(charValues[j], dotRadius, resolution);
				}
			}
		}
	}

}




//drawText("testText", dotRadius = 1., charWidth = 7, resolution = 16);

/*
translate([0, 0, 0.499]) {
	for(i = [0: len(testText)]) {
		translate([-len(testText[i])*charWidth/2, totalHeight/2-lineHeight*i, 0])
			drawText(testText[i], dotHeight = dotHeight, dotRadius = dotRadius, charWidth = charWidth, resolution = resolution);
	}
}
*/