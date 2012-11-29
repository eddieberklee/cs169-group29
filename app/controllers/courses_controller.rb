class CoursesController  < ApplicationController
  protect_from_forgery
=begin
  def show
    @course = Course.find_by_id params[:course_id]
    if not @course
      flash[:warning] = @course.errors
      redirect_to semesters_path
    end
  end
=end
  def index
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @courses = @semester.courses
    @enrollmentHash = {}
    @courses.each do |course|
      @enrollmentHash[course.id] = course.students.length
    end
  end

  def new
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @ptainstructors = Ptainstructor.where( :semester_id => @semester )
    @teachers = Teacher.where( :semester_id => @semester )
    if flash.key? :course
      @course = flash[:course]
      render 'new'
      return
    end
  end

  def create
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester,"Error: Unable to find a semester to associated with the class.")
    #special_time_parsing_helper
    params[:course][:ptainstructor] = Ptainstructor.find_by_id params[:course][:ptainstructor]
    params[:course][:teacher] = Teacher.find_by_id params[:course][:teacher]
    @course = @semester.courses.create(params[:course])
    if @course.new_record?
      flash[:warning] = @course.errors
      flash[:course] = @course
      redirect_to new_semester_course_path
      return
    end
    flash[:notice] = "Successfully created #{@course.name}."
    redirect_to semester_courses_path(@semester)
  end

  def edit
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @course = Course.find_by_id params[:id]
    if not @course
      flash[:warning] = [[:id, "Unable to locate the course given for modification."]]
      redirect_to semester_courses_path
      return
    end
    @ptainstructors = Ptainstructor.find_all_by_semester_id @semester
    @teachers = Teacher.find_all_by_semester_id @semester
    if flash.key? :course
      @course = flash[:course]
      render 'edit'
      return
    end
  end

  def destroy
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @course = Course.find_by_id params[:id]
    if not @course
      flash[:warning] = [[:id,"Could not find the course to be destroyed."]]
      redirect_to semester_courses_path(@semester)
      return
    end
    course_name = @course.name
    if @course.destroy
      flash[:notice] = "#{course_name} was successfully removed from the database."
    else
      flash[:warning] = @course.errors
    end
    redirect_to semester_courses_path(@semester)
  end

  def update
    @semester = Semester.find_by_id params[:semester_id]

    return unless semester_is_valid(@semester)

    @course = Course.find_by_id params[:id]
    if not @course
      flash[:warning] = [[:id, "The given course for updating could not be found."]]
      redirect_to semester_courses_path(@semester)
      return
    end
    params[:course][:ptainstructor] = Ptainstructor.find_by_id params[:course][:ptainstructor]
    params[:course][:teacher] = Teacher.find_by_id params[:course][:teacher]
    #not sure what to call update_attributes with
    if @course.update_attributes(params[:course])
      if params[:course].length > 0
          flash[:notice] = "#{@course.name} in #{@semester.name} was successfully updated."
      end
      redirect_to semester_courses_path(@semester)
    else
      flash[:warning] = @course.errors
      flash[:course] = @course
      redirect_to edit_semester_course_path
    end
  end

  private
  def semester_is_valid(semester, message="Error: Unable to find the semester for the course.")
    if not semester
      flash[:warning] = [[:semester_id, message]]
      redirect_to semesters_path, :method => :get
      return false
    end
    return true
  end


end
