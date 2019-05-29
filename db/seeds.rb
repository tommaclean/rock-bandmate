# # Instruments
guitar = Instrument.create(name: "guitar")
drums = Instrument.create(name: "drums")
bass = Instrument.create(name: "bass")
#
# # Bands
the_white_stripes = Band.create(name: "the white stripes")
deftones = Band.create(name: "deftones")
the_beatles = Band.create(name: "the beatles")

# Students
Student.create(name: "joe", band_name: the_white_stripes, instrument_name: bass)
Student.create(name: "jeff", band_name: the_beatles, instrument_name: drums)
Student.create(name: "sara", band_name: deftones, instrument_name: guitar)

# binding.pry
