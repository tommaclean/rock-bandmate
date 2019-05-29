class Instrument < ActiveRecord::Base
  has_many :students
  has_many :bands, through: :students
end
