class Admin::StudentsController < ApplicationController
  # GET /students
  def index
    @conditions = nil
    if params[:term]
      @conditions = ['people.name ILIKE ? OR code = ?', '%' + params[:term] + '%', params[:term]]
    end
    
    @students = Student.paginate :conditions => @conditions, 
                                 :page => params[:page], 
                                 :include => ['person'], 
                                 :order => 'people.name'
    
    @students_hash = []
    @students.each do |student|
      @students_hash << {"id" => student.id, "label" => student.code + ' - ' + student.name}
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @students }
      format.json { render :json => @students.to_json(:include => [:person]) }
      format.js { render :json => @students_hash }
    end
  end

  # GET /students/1
  def show
    @student = Student.find_by_code(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @student }
      format.json { render :json => @student }
    end
  end

  # GET /students/new
  def new
    @student = Student.new
    @student.person = Person.new
  end

  # GET /students/1/edit
  def edit
    @student = Student.find_by_code(params[:id])
  end

  # POST /students
  def create
    @student = Student.new(params[:student])
    @student.person.password = Digest::MD5.hexdigest(@student.code)
    @student.person.roles = [Role.find_by_name('Student')]
    
    respond_to do |format|
      if @student.save
        format.html { redirect_to([:admin, @student], :notice => I18n.t('StudentCreated')) }
        format.xml  { render :xml => @student, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  def update
    @student = Student.find_by_code(params[:id])
    
    if params[:delete_photo]
      params[:photo] = nil
      @student.person.photo = nil
    end
    
    if params[:reset_password]
      @student.person.password = Digest::MD5.hexdigest(@student.code)
    end

    if @student.update_attributes(params[:student])
      redirect_to([:admin, @student], :notice => I18n.t('StudentUpdated'))
    else
      redirect_to :action => "edit"
    end
  end

  # DELETE /students/1
  def destroy
    @student = Student.find_by_code(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(admin_students_url, :notice => I18n.t('StudentDeleted')) }
      format.xml  { head :ok }
    end
  end
end
