//Creates a list of stops following a specific harmonic.
/*
Run with three arguments:
keyboard name/label
keyboard midi channel num
harmonic series base feet (negative for undertones)

example:
chuck genStopList.ck:Great:2:1
*/

FileIO fout;

// open for write
fout.open( "StopsOut.txt", FileIO.WRITE );

// test file
if(!fout.good()) {
	cherr <= "can't open file for writing..." <= IO.newline();
	me.exit();
}

[
	"Unison",
	"Octave",
	"Nasard-12th",
	"Octave-15th",
	"Tierce-17th",
	"Larigot-19t",
	"Septime-21st-(flat)",
	"Octave-22nd"
] @=> string overtoneNames[];

[
	"Under-Base",
	"Under-Octave",
	"Under-Nasard",
	"Under-Super-Octave",
	"Under-Tierce",
	"Under-Larigot",
	"Under-Septime",
	"Under-Super-Duper-Octave"
] @=> string undertoneNames[];

[
	0.9,
	0.7,
	0.5,
	0.35,
	0.25,
	0.2,
	0.15,
	0.1
] @=> float volumes[];

float feetPresets[0];
0.25  => feetPresets["32"];
0.5  => feetPresets["16"];
1 => feetPresets["8"];
2 => feetPresets["4"];
4 => feetPresets["2"];
8 => feetPresets["1"];

/*

name
feet for display
keyboard name/label
keyboard midi num
harmonic series base
harmonic number
volume

*/

//fout <=  <= IO.newline();

if(me.args()) {
	if (Std.atoi(me.arg(2)) > 0) {
		for (0 => int i; i < overtoneNames.cap(); i++) {
			fout <= overtoneNames[i] <= IO.newline();
			fout <= simpleFraction(Std.atoi(me.arg(2)), i + 1) <= IO.newline();
			fout <= me.arg(0) <= IO.newline();
			fout <= me.arg(1) <= IO.newline();
			fout <= feetPresets[me.arg(2)] <= IO.newline();
			fout <= i + 1 <= IO.newline();
			fout <= volumes[i] <= IO.newline();
			fout <= "=" <= IO.newline();
		}
	}
	else {
		for (0 => int i; i < undertoneNames.cap(); i++) {
			fout <= undertoneNames[i] <= IO.newline();
			fout <= -Std.atoi(me.arg(2)) * (i + 1) <= IO.newline();
			fout <= me.arg(0) <= IO.newline();
			fout <= me.arg(1) <= IO.newline();
			fout <= -feetPresets["" + (-Std.atoi(me.arg(2)))] <= IO.newline();
			fout <= i + 1 <= IO.newline();
			fout <= volumes[i] <= IO.newline();
			fout <= "=" <= IO.newline();
		}
	}
	
}
else {
	<<< "You need some arguments bro." >>>;
	me.exit();
}

// close file
fout.close();


fun string simpleFraction(int top, int bottom) {
	
	top => int numerator;
	bottom => int denominator;

	(top / bottom) => int wholePart;
	top % bottom => numerator;

	if (numerator > 0) {
		return "" + wholePart + "-" + numerator + "/" + denominator;
	}
	else {
		return "" + wholePart;
	}

	
}


