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
	"8",
	"Octave",
	"4",
	"Nasard-12th",
	"2-2/3",
	"Octave-15th",
	"2",
	"Tierce-17th",
	"1-3/5",
	"Larigot-19t",
	"1-1/3",
	"Septime-21st-(flat)",
	"1-1/7",
	"Octave-22nd",
	"1"
] @=> string overtoneNames[];

[
	"Under-Base",
	"2",
	"Under-Octave",
	"4",
	"Under-Nasard",
	"6",
	"Under-Super-Octave",
	"8",
	"Under-Tierce",
	"10",
	"Under-Larigot",
	"12",
	"Under-Septime",
	"14",
	"Under-Super-Duper-Octave",
	"16"
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
		for (0 => int i; i < (overtoneNames.cap() / 2); i++) {
			"" => string copy;
			fout <= overtoneNames[i * 2] <= IO.newline();
			fout <= overtoneNames[(i * 2) + 1] <= IO.newline();
			fout <= me.arg(0) <= IO.newline();
			fout <= me.arg(1) <= IO.newline();
			fout <= me.arg(2) <= IO.newline();
			fout <= i + 1 <= IO.newline();
			fout <= volumes[i] <= IO.newline();
			fout <= "=" <= IO.newline();
		}
	}
	else {
		for (0 => int i; i < (undertoneNames.cap() / 2); i++) {
			"" => string copy;
			fout <= undertoneNames[i * 2] <= IO.newline();
			fout <= undertoneNames[(i * 2) + 1] <= IO.newline();
			fout <= me.arg(0) <= IO.newline();
			fout <= me.arg(1) <= IO.newline();
			fout <= me.arg(2) <= IO.newline();
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
