# drum
drum >> loop('amb_drum.wav', amp=0.6, dur=4)
bd >> MidiOut([0], channel=10, dur=1)
drum >> loop('tes.wav', amp=0.6, dur=8)

# pad
pad >> MidiOut(P[AMaj7,AMaj7, Cs7add9, Cs7add9], channel=1, sus=0.3, dur=4, amp=0.7)
pad.solo()
pad.solo(0)

# Guitar
guitar >> MidiOut(guitarPhrase, channel=2, dur=P[0.5] | P[1/4].stutter(13) | P[4.25], amp=0.7)

# sine
pl >> sinepad(P[0, 0, 0, 0, -5], sus=0.2, dur=[rest(1.5), 0.5, rest(1.5), 1/4, 1/4], lpf=300, amp=1.5)

# bass
bass >> MidiOut(bassPhrase, sus=bassDur, channel=4, dur=bassDur, amp=0.6)

# synth
synth >> MidiOut(synthPattern, channel=5, dur=[0.75,0.75,0.75,0.75,0.5,0.5], amp=0.4, sus=0.4)
