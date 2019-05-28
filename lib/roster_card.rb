class RosterCard
  attr_reader :student_name, :band_name

  @@all = []

  def initialize(student_name, band_name)
    @student_name = student_name
    @band_name = band_name
    @@all << all
  end

  def self.all
    @@all
  end
end
