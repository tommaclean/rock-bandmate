require_relative '../config/environment'

Instrument.delete_all
Band.delete_all
Student.delete_all

# Instrument defaults
guitar = Instrument.create(name: "Guitar")
bass = Instrument.create(name: "Bass")
keyboard = Instrument.create(name: "Keyboard")
vocals = Instrument.create(name: "Vocals")
drums = Instrument.create(name: "Drums")

the_white_stripes = Band.create(name: "the white stripes")
deftones = Band.create(name: "deftones")
the_beatles = Band.create(name: "the beatles")

Student.create(name: "Tom", band_id: the_beatles.id)
Student.create(name: "Josh", band_id: the_white_stripes.id)
Student.create(name: "Avi", band_id: deftones.id)


# set up prompt and new student
prompt = TTY::Prompt.new
new_student = Student.create()

# get student name
puts "What is your name?"
student_name = prompt.ask


if Student.all.map{|s|s.name}.include?(student_name)
  data_choices = ["Join Band", "Drop Band", "Change Instrument", "Delete Profile"]
  data_choice = prompt.select("Welcome back, #{new_student.name}! What would you like to do today?", data_choices)
# DON'T FORGET TO ADD CODE HERE!!!!!!!!!
  case data_choice
    when "Join Band"
      band_choice = prompt.select("Here is a list of all current bands:", Band.all.map {|band| band.name})
      new_student.update(band_id: Band.all.find {|band| band.name == band_choice}.band_id)
    when "Drop Band"
        current_band = Band.all.find {|band| band.id == new_student.band_id}
        prompt.yes?("Are you sure you want to leave #{current_band}?")

    when "Change Instrument"
      puts "chg inst"
    when "Delete Profile"
      puts "del pro"
    end
  # ^^^^ HERE!!!! ^^^^
else
  new_student.update(name: student_name)
  inst_choices = Instrument.all.map{|inst| inst.name} << "Other"
  inst_choice = prompt.select("What instrument do you play?", inst_choices)
  if inst_choice == "Other"
    new_student.update(instrument_id: Instrument.create(name: prompt.ask("Please enter the name of your instrument:")).id)
  else
    new_student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  end
  # there are no active bands so create your own!  What would you like the name of your band to be?
  if !Band.all.empty?
    join_or_create = prompt.select("Would you like to join a band or create your own?", %w(Join Create))
    if join_or_create == "Join"
      existing_bands = Band.all.map{|e|e.name}
      join_band_selection = prompt.select("Choose a band to join:", existing_bands)
      new_student.update(band_id: Band.all.find{|band| band.name == join_band_selection}.id)
    else
      puts "What would you like the name of your new band to be?"
      new_student.band_id = Band.create(name: prompt.ask).id
    end
  else
    create_a_band = Band.create(name: prompt.ask("There are no active bands so create your own!  What would you like the name of your band to be?"))
    new_student.update(band_id: create_a_band.id)
  end
end

# if student exists, welcome them back & ask if they would like to view band or instrument data or delete acct
### if student chooses band data, they can view other band members, leave the band, or switch to another band
### if student chooses instrument data, they can view who else plays that instrument or change instruments

# new student
# puts "Hello, #{new_student.name}, what instrument do you play?"
# # prompt.select from pre-existing array of instruments + "other" which will allow student to write in their instrument
# new_student.instrument_name = prompt.ask
# if !Instrument.all.map{|e|e.name}.include?(new_student.instrument_name)
#   Instrument.create(name: new_student.instrument_name)
# end
#
# join_or_create = prompt.select("Would you like to join one or create your own?", %w(Join Create))
# if join_or_create == "Join"
#   existing_bands = Band.all.map{|e|e.name}
#   join_band_selection = prompt.select("Choose a band to join:", existing_bands)
#   new_student.band_name = join_band_selection
# else
#   puts "What would you like the name of your new band to be?"
#   new_student.band_name = Band.create(name: prompt.ask)
# end
#
# binding.pry
