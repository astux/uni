class Lecture < ActiveRecord::Base
  belongs_to :discipline
  belongs_to :academic_period
  belongs_to :lecture_situation
  
  has_many :lecture_time_slots, :dependent => :destroy
  
  has_many :lecture_professors, :dependent => :destroy
  has_many :professors, :through => :lecture_professors
  
  has_many :lecture_students, :dependent => :destroy
  has_many :students, :through => :lecture_students
  
  has_many :lessons, :dependent => :destroy
  
  has_many :lecture_files, :dependent => :destroy
  has_many :walls, :dependent => :destroy
  
  scope :current, where(['academic_periods.start <= ? AND academic_periods.end >= ?', Date.today.to_s, Date.today.to_s]).includes([:academic_period, :discipline])
                  
  scope :with_discipline, includes({:discipline => :course})
  scope :by_code, order('lectures.code')
  
  validates :code, :presence => true
  validates :discipline_id, :presence => true
  validates :professor_ids, :presence => true
  validates :academic_period_id, :presence => true
  validates_uniqueness_of :code, :scope => :academic_period_id
  
  def name
    discipline.name
  end
  
  def to_xml(options = {})
    options[:include] ||= {:discipline => {:include => {:course => {:include => :course_category}}}}
    
    super(options)
  end
  
  def as_json(options = {})
    options[:include] ||= {:discipline => {:include => {:course => {:include => :course_category}}}}
    
    super(options)
  end
end
