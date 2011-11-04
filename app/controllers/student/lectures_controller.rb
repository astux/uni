class Student::LecturesController < LecturesController
  before_filter :load_lecture_student
  
  def load_lecture_student
    @student = Student.find_by_person_id(@user.id)
    if params[:id]
      @lecture_student = LectureStudent.find_by_lecture_id_and_student_id(params[:id], @student.id)
      
      redirect_to({:controller => :home}, :alert => 'YouDontHaveAccessToThisLecture') unless @lecture_student
    end
  end
  
  def index
    @lectures = @student.current_lectures
  end
  
  def tests_and_abscences
    @student = Student.find_by_person_id(@user.id)
    @lecture_student = LectureStudent.find_by_lecture_id_and_student_id(@lecture.id, @student.id)
    @month_absences = @lecture_student.month_absences
  end
end
