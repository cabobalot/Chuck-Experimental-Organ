
Gain gain => dac;

0.01 => gain.gain;

StopList stoplist;
stoplist.giveGain(gain);

// number of the MIDI device to open (see: chuck --probe)
0 => int device;
// get command line
if( me.args() ) me.arg(0) => Std.atoi => device;
// the midi event
MidiIn min;
// the message for retrieving data
MidiMsg msg;

// open the device
if( !min.open( device ) ) me.exit();
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


spork ~ keyboardHandler();
spork ~ stopOSCHandler();
spork ~ runJavaWindow();

// time-loop

while (true) {
    1::second => now;
}

fun int runJavaWindow() {
	Std.system("START /B JavaStopJamb.jar");
}

fun int stopOSCHandler() {
	OscIn oin;
	OscMsg msg;
	4446 => oin.port;
	oin.addAddress( "/stop/set, ii" );

	while(true) {
		oin => now;
		
		while(oin.recv(msg)) {
			<<< msg.address >>>;
			<<< msg.getInt(0) >>>;
			<<< msg.getInt(1) >>>;
			stoplist.setStopActive(msg.getInt(0), msg.getInt(1));
		}
	}
}

fun int keyboardHandler() {
	while(true) {
		// wait on kbhit event
		min => now;
		// potentially more than 1 key at a time
		while(min.recv(msg)) {
			if(msg.data1 == 144) { // keyboard note event
				msg.data2 => int noteNum;
				
				if (msg.data3 > 0) {
					<<< "key down: ",  noteNum >>>;
					stoplist.playNote(noteNum);
				}
				else {
					<<< "key up: ",  noteNum >>>;
					stoplist.stopNote(noteNum);
				}
			}
		}
	}
}

