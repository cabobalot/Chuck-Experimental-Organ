
Gain gain => dac;

Shred shreds[0];
me @=> Shred @ mainShred;

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

fun int keyboardHandler() {
	while(true) {
		// wait on kbhit event
		min => now;
		// potentially more than 1 key at a time
		while(min.recv(msg)) {
			if ((msg.data1 >= 0x80) && (msg.data1 < 0x90)) { //note off
				((msg.data1 - 0x80) + 1) => int channel;
				msg.data2 => int noteNum;

				<<< "key up: ",  noteNum , "channel: ", channel >>>;
				stoplist.stopNote(noteNum, channel);
			}
			if ((msg.data1 >= 0x90) && (msg.data1 < 0xA0)) { //note on
				((msg.data1 - 0x90) + 1) => int channel;
				msg.data2 => int noteNum;

				<<< "key down: ",  noteNum , "channel: ", channel >>>;
				stoplist.playNote(noteNum, channel);
			}
		}
	}
}

