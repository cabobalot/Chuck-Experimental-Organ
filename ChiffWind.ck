
/*
public class ChiffWind extends Chugraph {
	ADSR windEnv(10::ms, 50::ms, 0.90, 30::ms);
	windEnv.gain(0.5);
	Comb comb;
	inlet => comb => windEnv => outlet;
	
	// chiff
	ADSR chiffEnv(20::ms, 90::ms, 0.05, 5::ms);
	chiffEnv.gain(0.6);
    ResonZ f;
    50 => f.Q;

	inlet => f => chiffEnv => outlet;

	fun float setFreq(float freq) {
		comb.setFreq(freq);

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
 */


// expects a noise through inlet
public class ChiffWind extends Chugraph {
	ADSR windEnv(10::ms, 50::ms, 0.90, 30::ms);
	LPF lpf;
	15000 => lpf.freq;
	windEnv.gain(0.4);

	lpf => windEnv => outlet;
	

	ResonZ fs[2]; // too slow ?

	// chiff
	ADSR chiffEnv(20::ms, 90::ms, 0.05, 5::ms);
	chiffEnv.gain(0.6);
    ResonZ f;
    50 => f.Q;

	inlet => f => chiffEnv => outlet;

	for(0 => int i; i < fs.size(); i++ ) {
		30 => fs[i].Q; // set filter Q (higher == narrower, sharper resonance)
		inlet => fs[i] => lpf;
	}


	fun float setFreq(float freq) {
		for(0 => int i; i < fs.size(); i++ ) {
			freq * 2 *  (i + 1) => fs[i].freq;
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



// thanks Pi for this class
class Comb extends Chugraph
{
    Gain g1=> DelayL delay => Gain g11 => g1;
    inlet=>Gain g12=>g1;
    g1=> LPF lp=> outlet;
    
    (1/440.0)::second=>delay.delay;
    4*440=>lp.freq;
    1=>lp.Q;

    0.8=>g11.gain;
    0.1=>g12.gain;
    
    fun void setInputGain(float gain)
    {
        gain=>g12.gain;
    }
    
    fun void setFeedbackGain(float gain)
    {
        gain=>g11.gain;
    }
    
    fun void setFilterQ(float Q)
    {
        Q=>lp.Q;
    }
    
    fun void setFreq(float frequency)
    {
        4*frequency=>lp.freq;
        (1/frequency)::second=>delay.delay;
    }
}
