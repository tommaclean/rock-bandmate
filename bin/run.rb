require_relative '../config/environment'

# set up prompt and new student
prompt = TTY::Prompt.new
new_student = Student.create()

# get student name
puts "What is your name?"
student_name = prompt.ask


if Student.all.map{|s|s.name}.include?(student_name)
  data_choices = ["Join/Drop Band", "Change Instrument", "Delete Profile"]
  data_choice = prompt.select("Welcome back, #{new_student.name}! What would you like to do today?", data_choices)
# DON'T FORGET TO ADD CODE HERE!!!!!!!!!
  case data_choice
  when "Join/Drop Band"
    puts "join/drop"
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
    Instrument.create(name: prompt.ask("Please enter the name of your instrument:"))
  else
    new_student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  end
end

# # if student exists, welcome them back & ask if they would like to view band or instrument data or delete acct
# ### if student chooses band data, they can view other band members, leave the band, or switch to another band
# ### if student chooses instrument data, they can view who else plays that instrument or change instruments
#
# # new student
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
