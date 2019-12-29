public class Stop {

	200 => int NUM_NOTES;

	SinOsc s;
	SinOsc notes[NUM_NOTES];
	int noteStates[NUM_NOTES];
	Gain @ outGain;
	Gain myGain;
	0 => int harmNum;
	0 => int isNoteOn;
	0 => int isActivated;

	fun void setup(Gain g, int baseNum, int harmonic, float volume) {
		harmonic => harmNum;
		g @=> outGain;
		volume => myGain.gain;
		if (harmonic > 0) {
			for (0 => int i; i < notes.cap(); i++) {
				(Std.mtof(i) * harmNum * baseNum) => notes[i].freq;
				0 => noteStates[i];
			}
		}
		else {
			for (0 => int i; i < notes.cap(); i++) {
				((Std.mtof(i) * 4) / (-harmNum)) => notes[i].freq;
				0 => noteStates[i];
			}
		}

		<<< "Stop.setup" , harmNum >>>;
	}

	fun void activate() {
		1 => isActivated;
		myGain => outGain;
		// for (0 => int i; i < notes.cap(); i++) {
		// 	if (noteStates[i]) {
		// 		notes[i] => outGain;
		// 	}
		// }
	}

	fun void deactivate() {
		0 => isActivated;
		myGain =< outGain;
		// stopAllNotes();
	}

	fun void startNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number] => myGain;
			1 => noteStates[number];
		}
	}

	fun void stopNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number] =< myGain;
			0 => noteStates[number];
		}
	}

	fun void stopAllNotes() {
		for (0 => int i; i < notes.cap(); i++) {
			notes[i] =< myGain;
		}
	}
}