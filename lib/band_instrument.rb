class BandInstrument
  attr_reader :band_name, :instrument

  @@all = []

  def initialize(band_name, instrument)
    @band_name = band_name
    @instrument = instrument
    @@all << all
  end

  def self.all
    @@all
  end
end
