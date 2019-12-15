public class Stop {

	SinOsc s;
	SinOsc notes[200];
	Gain @ gain;
	0 => int harmNum;
	0 => int isNoteOn;


	fun void setup(Gain g, int harmonic) {
		harmonic => harmNum;
		g @=> gain;

		for (0 => int i; i < notes.cap(); i++) {
			(Std.mtof(i) * harmNum) => notes[i].freq;
		}

		<<< "Stop.setup" >>>;
	}

	fun void startNote(int number) {
		notes[number] => gain;

		// if (!isNoteOn) {
		// 	(Std.mtof(number) * harmNum) => s.freq;
		// 	s => gain;
		// 	1 => isNoteOn;
		// }
	}

	fun void stopNote(int number) {
		notes[number] =< gain;

		// if (isNoteOn) {
		// 	s =< gain;
		// 	0 => isNoteOn;
		// }
	}

	fun void stopAllNotes() {
		for (0 => int i; i < notes.cap(); i++) {
			notes[i] =< gain;
		}
	}
}