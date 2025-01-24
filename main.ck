
@import "StopList.ck"

StopList stoplist => GVerb rev => dac;
0.3 => rev.dry;
100 => rev.roomsize;
2::second => rev.revtime;

Shred shreds[0];
me @=> Shred @ mainShred;

0.1 => stoplist.gain;


// number of the MIDI device to open (see: chuck --probe)
0 => int device;
// get command line
if( me.args() ) me.arg(0) => Std.atoi => device;
// the midi event
MidiIn min;
// the message for retrieving data
MidiMsg msg;

// open the device
if( !min.open( device ) ) {
	// me.exit();
	<<< "MIDI device", device, "failed to open." >>>;
} else {
	<<< "MIDI device:", min.num(), " -> ", min.name() >>>;
	spork ~ keyboardHandler();
	
}

spork ~ runJavaWindow();
spork ~ stopOSCHandler();

// time-loop

while (true) {
    100::ms => now;
	// <<< gain.last() >>>;
}

// may have to use "start java -jar JavaStopJamb.jar" on windows?
fun void runJavaWindow() {
	Std.system("java -jar JavaStopJamb.jar &");
}

fun void stopOSCHandler() {
	OscIn oin;
	OscMsg msg;
	4446 => oin.port;
	oin.addAddress( "/stop/set, ii" );
	oin.addAddress( "/stop/program, ii" );


	while(true) {
		oin => now;
		
		while(oin.recv(msg)) {
			<<< msg.address >>>;
			<<< msg.getInt(0) >>>;
			<<< msg.getInt(1) >>>;
			if (msg.address == "/stop/set") {
				stoplist.setStopActive(msg.getInt(0), msg.getInt(1));
			}
			else if (msg.address == "/stop/program") {
				mainShred.exit();
			}
		}
	}
}

fun void keyboardHandler() {
	while(true) {
		// wait on kbhit event
		min => now;
		// potentially more than 1 key at a time
		while(min.recv(msg)) {
			(msg.data1 & 0xF0) >> 4 => int message;
			msg.data1 & 0xF => int channel;
			msg.data2 => int noteNum;

			if (message == 0x8) { //note off
				<<< "key up: ",  noteNum , "channel: ", channel >>>;
				stoplist.stopNote(noteNum, channel);
			}
			else if (message == 0x9) { //note on
				if (msg.data3 == 0) { // zero velocity
					<<< "zero vel: ",  noteNum , "channel: ", channel >>>;
					stoplist.stopNote(noteNum, channel);
				}
				else {
					<<< "key down: ",  noteNum , "channel: ", channel >>>;
					stoplist.playNote(noteNum, channel);
				}
			}
		}
	}
}

