class Band < ActiveRecord::Base
  has_many :students
  has_many :instruments, through: :students
end
