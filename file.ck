

fun void readStopFile() {
	FileIO file;
	"Stops.txt" => string filename;
	file.open( filename, FileIO.READ );
	if( !file.good() ) {
		<<< "can't open file: " , filename , " for reading..." >>>;
		me.exit();
	}
	string trash;
	int harmonic;
	while( file => trash ) {
		file => trash;
		file => harmonic;
		file => trash;
	}
}

readStopFile();
