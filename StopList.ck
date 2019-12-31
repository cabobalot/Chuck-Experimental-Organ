public class StopList {

	Gain @ gain;

	//stops
	0 => int STOP_COUNT;
	Stop @ stops[STOP_COUNT];

	200 => int NUM_NOTES;
	int noteStates[NUM_NOTES];



	fun void giveGain(Gain g) {
		g @=> gain;

		readStopFile();
	}

	fun void setStopActive(int stopNum, int setVal) {
		if (setVal == 1) {
			stops[stopNum].activate();
			for (0 => int i; i < noteStates.cap(); i++) {
				if (noteStates[i]) {
					stops[stopNum].startNote(i);
				}
			}
		}
		if (setVal == 0) {
			stops[stopNum].deactivate();
		}
		
	}

	fun void playNote(int note, int channel) {
		for (0 => int i; i < stops.cap(); i++) {
			if (stops[i].MIDIChannel == channel) {
				stops[i].startNote(note);
			}
		}
		if ((note > 0) && (note < noteStates.cap())) {
			1 => noteStates[note];
		}
		
	}

	fun void stopNote(int note, int channel) {
		for (0 => int i; i < stops.cap(); i++) {
			if (stops[i].MIDIChannel == channel) {
				stops[i].stopNote(note);
			}
		}
		if ((note > 0) && (note < noteStates.cap())) {
			0 => noteStates[note];
		}
	}

	fun Stop at(int i) {
		return stops[i];
	}

	fun void readStopFile() {
		FileIO file;
		"Stops.txt" => string filename;
		file.open( filename, FileIO.READ );
		if( !file.good() ) {
			<<< "can't open file: " , filename , " for reading..." >>>;
			me.exit();
		}
		string val;
		string trash;
		int MIDIChannel; //keyboard
		int harmonic;
		float baseNumber;
		float volume;
		while( file => trash ) {
			file => trash;
			file => trash;
			file => MIDIChannel;
			file => baseNumber;
			file => harmonic;
			file => volume;
			file => trash;

			Stop newStop;
			newStop.setup(gain, baseNumber, harmonic, volume, MIDIChannel);

			(stops.cap() + 1) => stops.size;
			newStop @=> stops[stops.cap() - 1];
		}
	}
}