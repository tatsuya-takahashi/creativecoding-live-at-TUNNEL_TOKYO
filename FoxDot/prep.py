# init
Clock.bpm = 122
Scale.default = Scale.major
Root.default = -3

# Root.default = 5

# Chords
BmM7add9 =  (1,3,5,7,9)
E6add9 = (4,6,8,9,12)
AMaj7_h = (7,9,11,13) 
AMaj7 = (0,2,4,6, 8)
Fs7 = (5, 7, 9, 14)
Cs7add9 = (2,4,6,8,10.5)
PAMaj7 = P[0,2,4,6, 8]
PCs7add9 = P[2,4,6,8,10.5]
guitarPhrase = P[PAMaj7.arp([0, 0, 7]).every(4, 'shuffle'), PCs7add9.arp([0, 0, 7]).every(4, 'shuffle')]
bassPhrase = P[0, 2, 6, 6,7,6,4,1] - 7 | P[2, 6, 10.5, 10.5, 11, 10.5, 8, 5] - 7
bassDur = [0.75,0.75,4, 1/4, 1/4,0.5,0.5,1]
syE = P(4,6,8)
syBm = P(5,8,10.5)
syE5 = P(6,8,11)
syE6 = P(8,11, 13)
syE7 = P(10.5,13,15)
synthPattern = P[syE,syE,syE,syE,syE,syE,syE,syE, syBm,syBm,syBm,syBm, syE5, syE5,syE5,syE5,syE5,syE5, syE6, syE6, syE7,syE7,syE7,syE7]


# Adjust
Clock.midi_nudge = 0.75

# Pad
pad = Player('pad')
drum = Player('drum')
guitar = Player('guitar')
bass = Player('bass')
synth = Player('synth')


# For Adjust
aj >> play("x x ")
aj.stop()

