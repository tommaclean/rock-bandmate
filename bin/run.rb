
require_relative '../config/environment'
# require_relative ''

Instrument.delete_all
Band.delete_all
Student.delete_all

# Instrument defaults
guitar = Instrument.create(name: "🎸 Guitar")
bass = Instrument.create(name: "𝄢 Bass")
keyboard = Instrument.create(name: "🎹 Keys")
vocals = Instrument.create(name: "🎤 Vocals")
drums = Instrument.create(name: "🥁 Drums")

# Bands
the_summertime_joes = Band.create(name: "🌞 the summertime joes ☕️")
avi_and_the_whattheforks = Band.create(name: "🍴 avi and the whattheforks 🍴")
kevins_nola_sunburn = Band.create(name: "🏖 kevin's NOLA sunburn ⛱")
glorious_pegasus = Band.create(name: "🦄🦄🦄 Glorious Pegasus 🦄🦄🦄")

# Students
Student.create(name: "Tom", band_id: avi_and_the_whattheforks.id, instrument_id: keyboard.id)
Student.create(name: "Josh", band_id: avi_and_the_whattheforks.id, instrument_id: bass.id)
Student.create(name: "Avi", band_id: avi_and_the_whattheforks.id, instrument_id: drums.id)
Student.create(name: "Joe", band_id: kevins_nola_sunburn.id, instrument_id: guitar.id)
Student.create(name: "George", band_id: kevins_nola_sunburn.id, instrument_id: bass.id)
Student.create(name: "Carla", band_id: kevins_nola_sunburn.id, instrument_id: drums.id)
Student.create(name: "Lucy", band_id: the_summertime_joes.id, instrument_id: keyboard.id)
Student.create(name: "Kenton", band_id: the_summertime_joes.id, instrument_id: bass.id)
Student.create(name: "Bill", band_id: the_summertime_joes.id, instrument_id: drums.id)
Student.create(name: "Kevin", band_id: the_summertime_joes.id, instrument_id: guitar.id)
Student.create(name: "Greg", band_id: kevins_nola_sunburn.id, instrument_id: bass.id)
Student.create(name: "Tony", band_id: kevins_nola_sunburn.id, instrument_id: drums.id)


# set up $prompt and new student
$prompt = TTY::Prompt.new
# student = Student.create()
# get student name
def get_student_name
  $student_name = $prompt.ask("What is your name?", required: true).capitalize
end

def capitalize_band_names
  Band.all.each{|b| b.update(name: b.name.split.map!{|n|n.capitalize}.join(' '))}
end

# Main menu
def returning_student_selection(student)
  data_choices = ["Join Band", "Create Band", "Drop Band", "Change Instrument", "View Band Roster / Instrument Data", "View Profile", "Delete Profile", "Quit"]
  data_choice = $prompt.select("Welcome back, #{student.name}! What would you like to do today?", data_choices)
  case data_choice
    when "Join Band"
      join_band(student)
    when "Create Band"
      create_band(student)
    when "Drop Band"
      if student.band_id == nil
        puts "\n"
        puts "You're not in a band!".red + "Back to the main menu with you!"
        puts "\n"
        returning_student_selection(student)
      end
      current_band = Band.all.find {|band| band.id == student.band_id}
      leave_band = $prompt.yes?("Are you sure you want to leave #{current_band.name}?")
      if leave_band
        student.band_id = nil
        current_band.students.delete(student)
        if current_band.students.length == 0
          Band.delete(current_band)
        end
      else
        puts "KEEP ON ROCKIN!!!!"
      end
    when "Change Instrument"
      instrument_selection("What instrument would you like to switch to?", student)
      puts "\nYour new instrument is #{Instrument.all.find{|inst| inst.id == student.instrument_id}.name}!\n\n"
    when "View Band Roster / Instrument Data"
      view_data
    when "View Profile"
      puts "\nName: #{student.name}"
      if student.band
        puts "Current Band: #{student.band.name}"
      else
        puts "Current Band: " + "You're not in a band!".red
      end
      puts "Instrument: #{student.instrument.name}\n\n"
    when "Delete Profile"
      delete_profile(student)
    when "Quit"
      quit_app
  end
  leave_or_start_over("So what's next?")
end

def new_student_selection(student)
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

def instrument_selection(msg, student)
  inst_choices = Instrument.all.map{|inst| inst.name} << "❓ Other"
  inst_choice = $prompt.select(msg, inst_choices)
  if inst_choice == "Other"
    student.update(instrument_id: Instrument.create(name: $prompt.ask("Please enter the name of your instrument:")).id)
  else
    student.update(instrument_id: Instrument.all.find{|inst| inst.name == inst_choice}.id)
  end
end

def active_bands(message)
  $prompt.select(message, Band.all.map{|band| band.name} << "Go Back")
end

def join_band(student)
  band_choice = active_bands("Choose a band to join:")
  if student.band_id != nil && student.band.name == band_choice
    puts "\nYou're already in #{band_choice}!".red + "\n\n"
  else
    Band.all.map{ |b| b.name }.include?(band_choice) ? student.update(band_id: Band.all.find { |b| b.name == band_choice}.id) : returning_student_selection(student)
    puts "\nYou are now a member of #{band_choice}!".light_cyan + "\n\n"
  end
  leave_or_start_over("What would you like to do now?")
end

def create_band(student)
  new_band = Band.create(name: $prompt.ask("What would you like the name of your band to be?"))
  student.update(band_id: new_band.id)
  new_band.update(name: new_band.name.split.map!{|e| e.capitalize}.join(" "))
  puts "\n#{new_band.name} formation date: #{Time.now.strftime("%A, %B %d, %Y")}".light_yellow + "\n"
end

def delete_profile(student)
  Student.all.delete(student)
  puts "\nYour profile has been deleted!\n\n"
  create_new_profile_choice = $prompt.yes?("Do you want to create a new profile?")
  if create_new_profile_choice
    get_student_name
    initial_user_nav
  else
    quit_app
  end
end

def quit_app
  puts "\nThanks for using Rock BandMaker!\n\n"
  exit
end

def student_instrument(student)
  Instrument.all.find{|i|i.id == student.instrument_id}
end

# check if new or returning student & provide selections
def initial_user_nav
  if Student.all.map{|s|s.name}.include?($student_name)
    # if returning student set `student` to that student
    $student = Student.all.find{|s|s.name == $student_name}
    returning_student_selection($student)
  else
    # create new student and set to `$student`
    $student = Student.create(name: $student_name)
    new_student_selection($student)
  end
end

def leave_or_start_over(msg)
  choice = $prompt.select(msg, ["Main Menu", "Quit"])
  case choice
    when "Main Menu"
      returning_student_selection($student)
    when "Quit"
      puts "Thanks for using Rock BandMaker!"
      exit
  end
end

def view_data
  view_data_choice = $prompt.select("Which data would you like to view?", ['Band Data', 'Instrument Data'])
  case view_data_choice
    when 'Band Data'
      band_choice = active_bands("Choose a band to view their roster:")
        puts "\n"
        puts "Here's the roster:"
        Band.all.find { |b| b.name == band_choice }.students.each { |s| puts "#{s.name}: #{student_instrument(s).name.capitalize}" }
        puts "\n"
    when 'Instrument Data'
      # choose instrument: guitar
      instrument_data_choice = $prompt.select("Choose an instrument:", Instrument.all.map{|inst| inst.name})
        instrument_instance = Instrument.all.find {|i| i.name == instrument_data_choice}
        puts "\nThere are #{instrument_instance.students.count} student(s) on #{instrument_data_choice}!"
        puts "Here is a list of those students:\n\n"
        instrument_instance.students.each do |s|
          # binding.pry
          puts "#{s.name} (#{s.band_id ? Band.all.find{|band| band.id == s.band_id}.name : 'Not in a band!'.red})"
        end
        puts "\n"
    end
end

get_student_name
capitalize_band_names
initial_user_nav

# closing message
def closing_message
  puts "\n"
  if Student.all.include?($student)
    if $student.band_id == nil
      leave_or_start_over("You aren't in a band. Head back to the Main Menu to join one!")
      else
        puts "#{$student.name}, you're on #{student_instrument($student).name.downcase} in the band, #{Band.all.find{|b|b.id == $student.band_id}.name}!"
        puts "Here's the roster:"
        Band.all.find { |b| b.id == $student.band_id }.students.each { |s| puts "#{s.name}: #{student_instrument(s).name.downcase}" }
        puts "\n"
        leave_or_start_over("What would you like to do next?")
      end
  else
    puts "You've been expelled from the School of Rock!"
    leave_or_start_over("Would you like to quit or start over?")
end
end

closing_message
