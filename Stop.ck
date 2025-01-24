@import "Pipe.ck"

public class Stop extends Chugraph {

	100 => int NUM_NOTES;

	// pass the noise along
	inlet => Pipe notes[NUM_NOTES];
	Gain myGain;
	0 => int harmNum;
	0 => int isNoteOn;
	0 => int isActivated;
	0 => int MIDIChannel;

	fun void Stop(float baseNum, int harmonic, float volume, int channel) {
		harmonic => harmNum;
		volume => myGain.gain;
		if (channel == 3) { // is this for pedal or something ?
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
		}

		<<< "Stop setup-- harm: " , harmNum , "Base: ", baseNum , "Channel: " , MIDIChannel >>>;
	}

	fun void activate() {
		1 => isActivated;
		myGain => outlet; // this is gonna clip...
	}

	fun void deactivate() {
		0 => isActivated;
		myGain =< outlet;
		stopAllNotes(); // this is gonna clip...
	}

	fun void startNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number] => myGain;
			notes[number].startNote();
		}
	}

	fun void stopNote(int number) {
		if ((number < NUM_NOTES) && (number >= 0) && isActivated) {
			notes[number].stopNote();
			spork ~ unpatchLater(number, now + notes[number].getDecayTime());
		}
	}

	fun void stopAllNotes() {
		for (0 => int i; i < notes.cap(); i++) {
			// notes[i] =< myGain;
			stopNote(i);
		}
	}

	fun void unpatchLater(int number, time when) {
		when => now;
		notes[number] =< myGain;
	}

	fun int getChannel() {
		return MIDIChannel;
	}
}