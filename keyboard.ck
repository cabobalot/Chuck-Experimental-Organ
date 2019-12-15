Hid hi;
HidMsg msg;

int useS[10];
SinOsc s[10];
for (0 => int i; i < s.cap(); i++) {
    0.05 => s[i].gain;
    ((880 * 2) / (i + 1)) => s[i].freq;
    
    0 => useS[i];
}

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// infinite event loop
while( true )
{
    // wait on event
    hi => now;

    // get one or more messages
    while( hi.recv( msg ) )
    {
        // check for action type
        if( msg.isButtonDown() ) {
            <<< "down:", msg.which, "(code)" >>>;
            msg.which - 2 => int key;
            if ((key < 10) && (key >= 0)) {
                if (useS[key]) {
                    s[key] =< dac;
                    0 => useS[key];
                } else {
                    1 => useS[key];
                    s[key] => dac;
                    
                }
                <<<"key: ", key >>>;
            }
            
        }
        
        else
        {
            //<<< "up:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
        }
    }
}