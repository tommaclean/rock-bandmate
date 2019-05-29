require_relative '../config/environment'

puts 'What is your name?'

student_name = gets.chomp
new_student = Student.create(name: student_name)

puts "Hello, #{new_student.name}, what instrument do you play?"
new_student_instrument = gets.chomp
new_student.instrument_name = new_student_instrument
puts "There are X bands looking for a #{new_student.instrument_name} player.  Would you like to join one or create your own?"
