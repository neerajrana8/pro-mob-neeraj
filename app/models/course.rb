class Course < ApplicationRecord
  has_many :tutors
  accepts_nested_attributes_for :tutors
end
