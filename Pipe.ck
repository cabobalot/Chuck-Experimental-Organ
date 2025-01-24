// attempt to synthesize an organ pipe artificially


public class Pipe extends Chugraph {

	ADSR env(50::ms, 30::ms, 0.95, 30::ms);

	// Noise n;
	inlet => UGen n;

	//sustain and envelope
    Phasor drive => Gen10 sustain => env => Gain g;

	n => ChiffWind wind => g;
	wind.gain(1);

    g.gain(0.1);

	n => LPF waver;
	waver.Q(20);
	waver.freq(3);
	Gain mix;
	mix.op(3); // multiply mode
	waver => Rectifier r => mix;

	g => mix;

	mix => outlet;

    // load up the coeffs; amplitudes for successive partials
    sustain.coefs( [0.14, 0.13, 0.095, 0.035, 0.014] );

    
	freq(255);

	fun float freq(float fr) {
		//higher notes speak faster
		((4300.0 / fr) + 15)::ms => dur attack;
		env.attackTime(attack);
		env.decayTime(attack / 2);
		env.releaseTime(attack / 2);

		// <<< Math.clampf(60 - (0.03 * fr), 0, 150) >>>;
		// <<< env.attackTime(), env.decayTime(), env.releaseTime() >>>;

		drive.freq(fr);
		wind.setFreq(fr);

		return fr;
	}

    fun void startNote() {
		env.keyOn();
		wind.keyOn();
		// spork ~ attack();
    }

    fun void stopNote() {
		env.keyOff();
		wind.keyOff();
    }

	fun dur getDecayTime() {
		if (env.decayTime() > 30::ms) {
			return env.decayTime();
		}
		return 30::ms;
	}

	// larger beginning waver? 
	// 100::ms => dur t;
	// fun void attack() {
	// 	(t / 1::samp) => float num;
	// 	for (0 => int i; i < num $ int; i++) {
	// 		waver.freq((-3 * (1 - (i / num))) + 6);
	// 		1::samp => now;
	// 	}
	// }

}

// expects a noise through inlet
class ChiffWind extends Chugraph {
	ADSR windEnv(10::ms, 50::ms, 0.90, 30::ms);
	LPF lpf;
	15000 => lpf.freq;
	windEnv.gain(0.15);

	lpf => windEnv => outlet;
	

	ResonZ fs[10];


	// chiff
	// n.gain(0.5);
	ADSR chiffEnv(20::ms, 90::ms, 0.05, 5::ms);
	chiffEnv.gain(0.6);
    ResonZ f;
    50 => f.Q;

	inlet => f => chiffEnv => outlet;

	for( int i; i < fs.size(); i++ ) {
		30 => fs[i].Q; // set filter Q (higher == narrower, sharper resonance)
		inlet => fs[i] => lpf;
	}


	fun float setFreq(float freq) {
		for( int i; i < fs.size(); i++ ) {
			freq * i => fs[i].freq;
		}

        freq * 15 => f.freq;

		return freq;
	}

	fun void keyOn() {
		windEnv.keyOn();
		chiffEnv.keyOn();
	}

	fun void keyOff() {
		windEnv.keyOff();
		chiffEnv.keyOff();
	}
}

class Rectifier extends Chugen {
    7 => float order;

    fun float tick( float in ) {
        return (in + order - 1) / order;
    }
}


Pipe pipe => GVerb rev => dac;
rev.gain(0.5);
0.3=>rev.dry;
150=>rev.roomsize;
3::second=>rev.revtime;

// infinite time loop
while (true) {
	pipe.startNote();
    // advance time
    4::second => now;

    pipe.stopNote();
	4::second => now;
}


