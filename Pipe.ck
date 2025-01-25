// attempt to synthesize an organ pipe artificially

@import "ChiffWind.ck"

public class Pipe extends Chugraph {

	ADSR env(50::ms, 30::ms, 0.95, 30::ms);

	inlet => UGen n;

	//sustain and envelope
    Phasor drive => Gen10 sustain => env => Gain g;


	n => ChiffWind wind;
	wind => g;
	wind.gain(1);

    g.gain(0.1);

	// maybe this is too slow?
	// Gain mix;
	// mix.op(3); // multiply mode
	// Waver wav => mix;

	// g => mix => outlet;
	g => outlet;


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



// this is way too slow
class Waver extends Chugen {
    1 => int direction;

    fun float tick( float in ) {

        if (Math.random() < 5000000) {
			-direction => direction;
		}

        last() + (Math.random2f(0.0, 0.0002) * (direction)) => float out;

        if (out > 1) {
			1 => out;
            -1 => direction;
		}
		if (out < 0.85) {
			0.85 => out;
            1 => direction;
		}

        return out;
    }

}


// even more too slow
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


