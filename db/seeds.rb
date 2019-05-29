Instrument.destroy_all
Band.destroy_all
Student.destroy_all

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
Student.create(name: "joe", band_id: the_white_stripes.id, instrument_id: bass.id)
Student.create(name: "jeff", band_id: the_beatles.id, instrument_id: drums.id)
Student.create(name: "sara", band_id: deftones.id, instrument_id: guitar.id)

# binding.pry
