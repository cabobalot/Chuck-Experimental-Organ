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

	fun void playNote(int note) {
		for (0 => int i; i < stops.cap(); i++) {
			stops[i].startNote(note);
		}
		1 => noteStates[note];
	}

	fun void stopNote(int note) {
		for (0 => int i; i < stops.cap(); i++) {
			stops[i].stopNote(note);
		}
		0 => noteStates[note];
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
		int harmonic;
		while( file => trash ) {
			file => trash;
			file => harmonic;
			file => trash;

			Stop newStop;
			newStop.setup(gain, harmonic);

			(stops.cap() + 1) => stops.size;
			newStop @=> stops[stops.cap() - 1];
		}
	}
}