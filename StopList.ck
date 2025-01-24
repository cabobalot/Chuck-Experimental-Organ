
@import "Stop.ck"

public class StopList extends Chugraph {

	//stops
	0 => int STOP_COUNT;
	Stop @ stops[STOP_COUNT];

	Noise noise; // single noise source for whole organ

	fun void StopList() {
		readStopFile();
	}

	fun void setStopActive(int stopNum, int setVal) {
		if (setVal == 1) {
			stops[stopNum].activate();
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
		
	}

	fun void stopNote(int note, int channel) {
		for (0 => int i; i < stops.cap(); i++) {
			if (stops[i].MIDIChannel == channel) {
				stops[i].stopNote(note);
			}
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

			noise => Stop newStop(baseNumber, harmonic, volume, MIDIChannel) => outlet;

			(stops.size() + 1) => stops.size;
			newStop @=> stops[stops.size() - 1];
		}
	}
}