public class StopList {

	Gain @ gain;

	//stops
	2 => int STOP_COUNT;
	Stop stops[STOP_COUNT];
	Stop p8 @=> stops[0];
	Stop p4 @=> stops[1];

	int isActivated[STOP_COUNT];

	fun void giveGain(Gain g) {
		g @=> gain;

		p8.setup(g, 1);
		p4.setup(g, 2);
	}

	fun void setStopActive(int stopNum, int setVal) {
		setVal => isActivated[stopNum];

		if (setVal == 0) {
			stops[stopNum].stopAllNotes();
		}
	}

	fun void playNote(int note) {
		for (0 => int i; i < STOP_COUNT; i++) {
			if (isActivated[i]) {
				stops[i].startNote(note);
			}
		}
	}

	fun void stopNote(int note) {
		for (0 => int i; i < STOP_COUNT; i++) {
			stops[i].stopNote(note);
		}
	}

	fun Stop at(int i) {
		return stops[i];
	}

}