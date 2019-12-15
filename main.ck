
Gain gain => dac;

0.01 => gain.gain;

StopList stoplist;
stoplist.giveGain(gain);

// HID
Hid kb;
HidMsg msg;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !kb.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + kb.name() + "' ready", "" >>>;


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
		kb => now;
		// potentially more than 1 key at a time
		while(kb.recv(msg)) {
			if(msg.isButtonDown()) {
				msg.which => int dataNum;
				<<< "key down: ",  dataNum >>>;
				// if (dataNum == 71) {
				// 	stoplist.setStopActive(0, true);
				// }
				// else if (dataNum == 72) {
				// 	stoplist.setStopActive(0, false);
				// }
				// else if (dataNum == 75) {
				// 	stoplist.setStopActive(1, true);
				// }
				// else if (dataNum == 76) {
				// 	stoplist.setStopActive(1, false);
				// }

				40 +=> dataNum;
				stoplist.playNote(dataNum);

			}
			else {
				msg.which => int dataNum;
				<<< "key up: ",  dataNum >>>;
				40 +=> dataNum;
				stoplist.stopNote(dataNum);
			}
		}
	}
}

