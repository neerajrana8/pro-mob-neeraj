class CoursesController < ApplicationController
  def create
    @course = Course.new(course_params)
    if @course.save
      render json: @course.to_json(include: :tutors), status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def index
    @courses = Course.includes(:tutors).all
    render json: @courses.to_json(include: :tutors), status: :ok
  end

  private

  def course_params
    params.require(:course).permit(:name, tutors_attributes: [:name, :email, :age ])
  end
end
