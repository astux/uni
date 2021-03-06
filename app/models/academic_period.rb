class AcademicPeriod < ActiveRecord::Base
  validates :name, :presence => true
  validates :start, :presence => true
  validates :end, :presence => true
  
  validate :validate_registration
  validate :validate_registrationInterval
  
  has_many :lectures, :dependent => :destroy
  
  def validate_registration
    errors.add(:registration_start, "periodo de matricula invalido") if (registration_start == nil) ^ (registration_end == nil) 
  end
  
  def validate_registrationInterval
    if registration_start and registration_end and registration_start > registration_end
      errors.add('Inicio da Matricula', " deve ser anterior ao fim")
    end
  end
  
  def has_open_registration_period?
    @today = Date.today.to_s
    AcademicPeriod.all(:conditions => ['academic_periods.start >= ? AND academic_periods.end <= ?', @today, @today]).size > 0
  end
  
  def close_to_conclusion?
    @today = Date.today
    @end = self.end - 7
    
    return @today >= @end
  end
end
