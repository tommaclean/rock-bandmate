class Student < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :band
end
