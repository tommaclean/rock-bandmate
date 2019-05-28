class InstrumentCard
  attr_reader :student_name, :instrument

  @@all = []

  def initialize(student_name, instrument)
    @student_name = student_name
    @instrument = instrument
    @@all << all
  end

  def self.all
    @@all
  end
end
