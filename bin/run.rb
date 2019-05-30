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

Student.create(name: "Tom", band_id: deftones.id, instrument_id: keyboard.id)
Student.create(name: "Josh", band_id: deftones.id, instrument_id: bass.id)
Student.create(name: "Avi", band_id: deftones.id, instrument_id: drums.id)

# set up $prompt and new student
$prompt = TTY::Prompt.new
# student = Student.create()

# get student name
puts "What is your name?"
student_name = $prompt.ask

def instrument_selection(msg, student)
  inst_choices = Instrument.all.map{|inst| inst.name} << "Other"
  inst_choice = $prompt.select(msg, inst_choices)
  if inst_choice == "Other"
    student.update(instrument_id: Instrument.create(name: $prompt.ask("Please enter the name of your instrument:")).id)
  else
    student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  end
end

if Student.all.map{|s|s.name}.include?(student_name)
  student = Student.all.find{|s|s.name == student_name}
  data_choices = ["Join Band", "Drop Band", "Change Instrument", "Delete Profile"]
  data_choice = $prompt.select("Welcome back, #{student.name}! What would you like to do today?", data_choices)
# DON'T FORGET TO ADD CODE HERE!!!!!!!!!
  case data_choice
    when "Join Band"
      band_choice = $prompt.select("Here is a list of all current bands:", Band.all.map {|band| band.name})
      student.update(band_id: Band.all.find {|band| band.name == band_choice}.id)
    when "Drop Band"
      current_band = Band.all.find {|band| band.id == student.band_id}
      leave_band = $prompt.yes?("Are you sure you want to leave #{current_band.name}?")
      if leave_band
        student.band_id = nil
        current_band.students.delete(student)
      else
        puts "KEEP ON ROCKIN!!!!"
      end
    when "Change Instrument"
      instrument_selection("What instrument would you like to switch to?", student)
      puts "Congratulations!  Your new instrument is #{Instrument.all.find{|inst| inst.id == student.instrument_id}.name}!"
    when "Delete Profile"
      Student.all.delete(student)
    end
  # ^^^^ HERE!!!! ^^^^
else
  student = Student.create(name: student_name)
  # student.update(name: student_name)

  instrument_selection("What instrument do you play?", student)

  ##################################################################
  ##################################################################
  # inst_choices = Instrument.all.map{|inst| inst.name} << "Other"
  # inst_choice = $prompt.select("What instrument do you play?", inst_choices)
  # if inst_choice == "Other"
  #   student.update(instrument_id: Instrument.create(name: $prompt.ask("Please enter the name of your instrument:")).id)
  # else
  #   student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  # end
  ##################################################################
  ##################################################################
  # there are no active bands so create your own!  What would you like the name of your band to be?
  if !Band.all.empty?
    join_or_create = $prompt.select("Would you like to join a band or create your own?", %w(Join Create))
    if join_or_create == "Join"
      existing_bands = Band.all.map{|e|e.name}
      join_band_selection = $prompt.select("Choose a band to join:", existing_bands)
      student.update(band_id: Band.all.find{|band| band.name == join_band_selection}.id)
    else
      student.update(band_id: Band.create(name: $prompt.ask("What would you like the name of your new band to be?")).id)
    end
  else
    create_a_band = Band.create(name: $prompt.ask("There are no active bands so create your own!  What would you like the name of your band to be?"))
    student.update(band_id: create_a_band.id)
  end
end

# closing message
if Student.all.include?(student)
  if student.band_id == nil
    leave_or_start_over = $prompt.select("You aren't in a band.  Would you like to join or create one?", %w(Join Create Quit))
    case leave_or_start_over
      when "Join"
        puts "join a band------"
      when "Create"
        puts "create a band-----"
      when "Quit"
        puts "leaving program..........."
      end
    else
      puts "#{student.name}, you play #{Instrument.all.find{|i|i.id == student.instrument_id}.name} in the band, #{Band.all.find{|b|b.id == student.band_id}.name}!"
      puts "Here's the roster:"
      Band.all.find{|b|b.id==student.band_id}.students.each{|s| puts "#{s.name}: #{Instrument.all.find{|i|i.id == s.instrument_id}.name}"}
    end
else
  puts "You've been expelled from the School of Rock!"
end
# if student exists, welcome them back & ask if they would like to view band or instrument data or delete acct
### if student chooses band data, they can view other band members, leave the band, or switch to another band
### if student chooses instrument data, they can view who else plays that instrument or change instruments

# new student
# puts "Hello, #{student.name}, what instrument do you play?"
# # $prompt.select from pre-existing array of instruments + "other" which will allow student to write in their instrument
# student.instrument_name = $prompt.ask
# if !Instrument.all.map{|e|e.name}.include?(student.instrument_name)
#   Instrument.create(name: student.instrument_name)
# end
#
# join_or_create = $prompt.select("Would you like to join one or create your own?", %w(Join Create))
# if join_or_create == "Join"
#   existing_bands = Band.all.map{|e|e.name}
#   join_band_selection = $prompt.select("Choose a band to join:", existing_bands)
#   student.band_name = join_band_selection
# else
#   puts "What would you like the name of your new band to be?"
#   student.band_name = Band.create(name: $prompt.ask)
# end
#
# binding.pry
