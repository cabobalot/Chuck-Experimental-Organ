public class Stop {

	200 => int NUM_NOTES;

	SinOsc s;
	SinOsc notes[NUM_NOTES];
	int noteStates[NUM_NOTES];
	Gain @ gain;
	0 => int harmNum;
	0 => int isNoteOn;
	0 => int isActivated;

	fun void setup(Gain g, int harmonic) {
		harmonic => harmNum;
		g @=> gain;

		for (0 => int i; i < notes.cap(); i++) {
			(Std.mtof(i) * harmNum) => notes[i].freq;
			0 => noteStates[i];
		}

		<<< "Stop.setup" , harmNum >>>;
	}

	fun void activate() {
		1 => isActivated;
		for (0 => int i; i < notes.cap(); i++) {
			if (noteStates[i]) {
				notes[i] => gain;

			}
		}
	}

	fun void deactivate() {
		0 => isActivated;
		stopAllNotes();
	}

	fun void startNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number] => gain;
			1 => noteStates[number];
		}
	}

	fun void stopNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number] =< gain;
			0 => noteStates[number];
		}
	}

	fun void stopAllNotes() {
		for (0 => int i; i < notes.cap(); i++) {
			notes[i] =< gain;
		}
	}
}