class CourseCategory < ActiveRecord::Base
  has_many :course
  
  validates :name, :presence => true
end
