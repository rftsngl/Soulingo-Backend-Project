module V1
  class EnrollmentsController < ApplicationController
    before_action :set_course, only: [:enroll, :students]
    before_action :set_user, only: [:user_courses]

    # POST /v1/courses/:course_id/enroll
    def enroll
      # Kullanıcı kendi adına kayıt oluyor
      enrollment = Enrollment.find_or_initialize_by(
        user: current_user,
        course: @course
      )

      if enrollment.persisted?
        render json: {
          error: {
            code: 'already_enrolled',
            message: 'User is already enrolled in this course'
          }
        }, status: :unprocessable_entity
        return
      end

      enrollment.status = 'active'
      enrollment.started_at = Time.current

      if enrollment.save
        render json: {
          data: serialize_enrollment(enrollment, include_course_title: true)
        }, status: :created
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: enrollment.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # GET /v1/users/:user_id/courses
    def user_courses
      # Kullanıcı sadece kendi kurslarını görebilir veya admin herkesi görebilir
      require_self_or_admin!(@user.id)
      return if performed? # Authorization failed, already rendered

      courses = @user.courses.includes(:lessons)
      
      render json: {
        data: courses.map { |course| serialize_course(course, include_lessons_count: true) }
      }, status: :ok
    end

    # GET /v1/courses/:course_id/students
    def students
      # Sadece admin görebilir
      require_admin!
      return if performed? # Authorization failed, already rendered

      students = @course.users.where(role: 'student')
      
      render json: {
        data: students.map { |user| serialize_user(user) }
      }, status: :ok
    end

    private

    def set_course
      # Member route'larda :id parametresi course_id'yi temsil eder
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: {
          code: 'not_found',
          message: 'Course not found'
        }
      }, status: :not_found
      return
    end

    def set_user
      # Member route: /v1/users/:id/courses -> params[:id]
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: {
          code: 'not_found',
          message: 'User not found'
        }
      }, status: :not_found
      return
    end

    def serialize_enrollment(enrollment, include_course_title: false, include_user_email: false)
      {
        id: enrollment.id,
        type: "enrollment",
        attributes: EnrollmentSerializer.new(
          enrollment,
          include_course_title: include_course_title,
          include_user_email: include_user_email
        ).as_json
      }
    end

    def serialize_course(course, include_lessons_count: false)
      {
        id: course.id,
        type: "course",
        attributes: CourseSerializer.new(course, include_lessons_count: include_lessons_count).as_json
      }
    end

    def serialize_user(user)
      {
        id: user.id,
        type: "user",
        attributes: UserSerializer.new(user).as_json
      }
    end
  end
end

