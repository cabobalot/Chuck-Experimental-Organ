public class StopList {

	Gain @ gain;

	//stops
	0 => int STOP_COUNT;
	Stop @ stops[STOP_COUNT];

	int isActivated[STOP_COUNT];

	

	// Stop p8 @=> stops[0];
	// Stop p4 @=> stops[1];

	fun void giveGain(Gain g) {
		g @=> gain;

		readStopFile();

		// p8.setup(g, 1);
		// p4.setup(g, 2);
	}

	fun void setStopActive(int stopNum, int setVal) {
		setVal => isActivated[stopNum];

		if (setVal == 0) {
			stops[stopNum].stopAllNotes();
		}
	}

	fun void playNote(int note) {
		for (0 => int i; i < stops.cap(); i++) {
			if (isActivated[i]) {
				stops[i].startNote(note);
			}
		}
	}

	fun void stopNote(int note) {
		for (0 => int i; i < stops.cap(); i++) {
			stops[i].stopNote(note);
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
		int harmonic;
		while( file => trash ) {
			file => trash;
			file => harmonic;
			file => trash;

			Stop newStop;
			newStop.setup(gain, harmonic);
			
			//push back
			isActivated << 0;

			(stops.cap() + 1) => stops.size;
			newStop @=> stops[stops.cap() - 1];
		}
	}
}