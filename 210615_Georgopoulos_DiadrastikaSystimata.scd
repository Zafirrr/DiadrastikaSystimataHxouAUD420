s.boot;
//:
(

{ var sig1, sig2, sig3, sig4, sig5;

sig3 = {LFNoise1;Ndef(\x,{a=SinOsc.ar(65,Ndef(\x).ar*n.ar(0.1,3),n.ar(3,6)).tanh;9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};a.tanh})};

sig2 = {HPF.ar(ar(PinkNoise,5e-3),10)*Line.kr(0,1,9);ar(GVerb,({|i|ar(Ringz,a*LFNoise1.kr(0.05+0.1.rand),55*i+60,0.2)}!99).sum,70,99).tanh};

sig4 =
{
x = OnePole.ar(WhiteNoise.ar(0.1)+Dust.ar(100, 0.5), 0.7);
x = x + Splay.ar(FreqShift.ar(x, 1/(4..7)));
};

sig5 =
{
Ndef(\fdb1, {
	var src, loc, freq, rt;
	rt = 0.25;
	freq = Duty.ar(16/rt,0,Dseq([60,68,67,59,61,64,65].midicps,inf));

	src = Saw.ar(freq)*Decay.ar(Impulse.ar(rt),1/rt,0.25);
	//src = SoundIn.ar(0);
	loc = LocalIn.ar(2)+src;
	loc = FreqShift.ar(loc,-1);
	loc = loc+DelayC.ar(loc,0.2,freq.reciprocal);
	loc = DelayC.ar(loc,4,LFNoise1.ar(rt!2).range(0.25,2));
	loc = DelayC.ar(loc,4,2);
	//loc = (loc*250).tanh;
	//loc = LPF.ar(loc,2500);
	loc = loc+AllpassC.ar(loc,0.1,LFNoise0.ar(rt!2).range(0.05,0.1),4);
	loc = HPF.ar(loc,100);

	LocalOut.ar(loc*1.75);

	Out.ar(0,Limiter.ar(loc)*0.5);
})
};

	sig1 =
	{ | bus = 50 |
		Mix.fill(8, {
			var fb, env, fq, osc;
			fb = (LFSaw.ar(
				Latch.ar(
					WhiteNoise.ar(0.5).abs
					+ 0.5,
					InFeedback.ar(bus,1)),1)+0.999)/2;
			Out.ar(bus, fb);
			env = 1-fb;
			fq = Latch.ar(WhiteNoise.ar(
				\noise.kr(1000))
				+ \noisep.kr(6000), fb);
			osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
			Out.ar(0, \amp.kr(1)*Pan2.ar(osc,Latch.ar(WhiteNoise.ar(1),fb),0.01*Env.linen(10,25,15,0.15,1).kr( doneAction: 2)))})
	};



// time arrangment
	0.wait;
	sig1.play;
	10.wait;
	sig2.play;
	10.wait;
	sig3.play;
	10.wait;
	sig2.stop;
	sig4.play;
	sig3.stop;
	10.wait;
	sig5.play;
	sig2.play;
	20.wait;
	sig3.play;

}.fork


)