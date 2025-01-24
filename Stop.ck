@import "Pipe.ck"

public class Stop {

	100 => int NUM_NOTES;

	Pipe notes[NUM_NOTES];
	Gain @ outGain;
	Gain myGain;
	0 => int harmNum;
	0 => int isNoteOn;
	0 => int isActivated;
	0 => int MIDIChannel;

	fun void setup(Gain g, float baseNum, int harmonic, float volume, int channel) {
		harmonic => harmNum;
		g @=> outGain;
		volume => myGain.gain;
		if (channel == 3) {
			volume * 2 => myGain.gain;
		}
		channel => MIDIChannel;

		for (0 => int i; i < notes.cap(); i++) {
			if (baseNum > 0) {
				(Std.mtof(i) * harmNum * baseNum) => notes[i].freq;
			}
			else {
				((Std.mtof(i) * (-baseNum)) / (harmNum)) => notes[i].freq;
			}
			notes[i] => myGain;
			
		}

		<<< "Stop setup-- harm: " , harmNum , "Base: ", baseNum , "Channel: " , MIDIChannel >>>;
	}

	fun void activate() {
		1 => isActivated;
		myGain => outGain;
	}

	fun void deactivate() {
		0 => isActivated;
		myGain =< outGain;
		// stopAllNotes();
	}

	fun void startNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number].startNote();
		}
	}

	fun void stopNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number].stopNote();
		}
	}

	fun void stopAllNotes() {
		for (0 => int i; i < notes.cap(); i++) {
			notes[i] =< myGain;
		}
	}

	fun int getChannel() {
		return MIDIChannel;
	}
}