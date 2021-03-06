class CoursesController  < ApplicationController
  protect_from_forgery

  def index
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @courses = Course.find_all_by_semester_id(@semester, :order => "sunday desc, monday desc, tuesday desc, wednesday desc, thursday desc, friday desc, saturday desc, name asc")
    @enrollmentHash = {}
    @courses.each do |course|
      @enrollmentHash[course.id] = course.students.length
    end
  end

  def new
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    @ptainstructors = Ptainstructor.find_all_by_semester_id(@semester, :order => "first_name asc, last_name asc")
    teachers1 = Teacher.where("semester_id = ? AND grade = ?", @semester.id, "K").order("name asc")
    teachers2 = Teacher.where("semester_id = ? AND grade != ?", @semester.id, "K").order("grade asc","name asc")
    @teachers = teachers1 + teachers2
    @ptainstructors.unshift(Ptainstructor.new(:first_name => "Select", :last_name => "Item:")) #add item to the beginning of the ptainstructor's list
    @teachers.unshift(Teacher.new(:classroom => "Select Item:"))
    if flash.key? :course
      @course = Course.new(flash[:course])
      render 'new'
      return
    end
    @course = Course.new
  end

  #Returns the fee of the course
  def coursefee
    course = Course.find(params[:id])
    @coursefee = course.total_fee.to_json
    return
  end

  def create
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester,"Error: Unable to find a semester to associated with the class.")
    @course = @semester.courses.create(params[:course])
    if @course.new_record?
      flash[:warning] = @course.errors
      flash[:course] = params[:course] #save fields so the user doesn't have to re-enter everything again
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
     @ptainstructors = Ptainstructor.find_all_by_semester_id(@semester, :order => "first_name asc, last_name asc")
    teachers1 = Teacher.where("semester_id = ? AND grade = ?", @semester.id, "K").order("name asc")
    teachers2 = Teacher.where("semester_id = ? AND grade != ?", @semester.id, "K").order("grade asc","name asc")
    @teachers = teachers1 + teachers2
    if flash.key? :course
      course_id = @course.id
      @course = Course.new(flash[:course])
      @course.id = course_id
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
    if @course.update_attributes(params[:course])
      if params[:course].length > 0
          flash[:notice] = "#{@course.name} in #{@semester.name} was successfully updated."
      end
      redirect_to semester_courses_path(@semester)
    else
      flash[:warning] = @course.errors
      flash[:course] = params[:course]
      redirect_to edit_semester_course_path
    end
  end

  public
  #Returns the number of times a class meets in a semester. Called from javascript, with a hash of the days of the week that are checked
  def calculate_meetings
    @semester = Semester.find_by_id params[:semester_id]
    return unless semester_is_valid(@semester)
    class_meetings = 0
    class_meetings_hash = @semester.specific_days_in_semester
    params.each do |d, value|
      day_of_week = d.to_i
      if value != "checked"; next; end
      if ((1 <= day_of_week) and (day_of_week <= 7))
        class_meetings += class_meetings_hash[day_of_week]
      end
    end

    @calculate_meetings = class_meetings.to_json
    render :text => @calculate_meetings
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
