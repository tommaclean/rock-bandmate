require_relative '../config/environment'
# require_relative ''

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
def get_student_name
  puts "What is your name?"
  $student_name = $prompt.ask
end

get_student_name

def instrument_selection(msg, student)
  inst_choices = Instrument.all.map{|inst| inst.name} << "Other"
  inst_choice = $prompt.select(msg, inst_choices)
  if inst_choice == "Other"
    student.update(instrument_id: Instrument.create(name: $prompt.ask("Please enter the name of your instrument:")).id)
  else
    student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  end
end

def join_band(student)
  band_choice = $prompt.select("Choose a band to join:", Band.all.map{|band| band.name})
  student.update(band_id: Band.all.find {|band| band.name == band_choice}.id)
end

def create_band(student)
  student.update(band_id: Band.create(name: $prompt.ask("What would you like the name of your band to be?")).id)
end

def student_instrument(student)
  Instrument.all.find{|i|i.id == student.instrument_id}
end

# check if new or returning student
if Student.all.map{|s|s.name}.include?($student_name)
  # if returning student set `student` to that student
  student = Student.all.find{|s|s.name == $student_name}
  data_choices = ["Join Band", "Drop Band", "Change Instrument", "Delete Profile"]
  data_choice = $prompt.select("Welcome back, #{student.name}! What would you like to do today?", data_choices)
  case data_choice
    when "Join Band"
      join_band(student)
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
 else
   # create new student and set to `student`
   student = Student.create(name: $student_name)
   instrument_selection("What instrument do you play?", student)
   if !Band.all.empty?
     join_or_create = $prompt.select("Would you like to join a band or create your own?", %w(Join Create))
     if join_or_create == "Join"
       join_band(student)
     else
       create_band(student)
     end
   else
     puts "There are no active bands so create your own!"
     create_band(student)
   end
 end

# closing message
if Student.all.include?(student)
  if student.band_id == nil
    leave_or_start_over = $prompt.select("You aren't in a band.  Would you like to join or create one?", %w(Join Create Quit))
    case leave_or_start_over
      when "Join"
        join_band(student)
      when "Create"
        create_band(student)
      when "Quit"
        puts "leaving program..........."
      end
    else
      puts "#{student.name}, you're on #{student_instrument(student).name.downcase} in the band, #{Band.all.find{|b|b.id == student.band_id}.name}!"
      puts "Here's the roster:"
      Band.all.find{|b|b.id==student.band_id}.students.each{|s| puts "#{s.name}: #{student_instrument(s).name.downcase}"}
    end
else
  puts "You've been expelled from the School of Rock!"
end
