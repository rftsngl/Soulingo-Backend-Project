module V1
  class CoursesController < ApplicationController
    skip_before_action :authenticate_request, only: [:index, :show]
    before_action :set_course, only: [:show, :update, :destroy]
    before_action :require_admin!, only: [:create, :update, :destroy]

    # GET /v1/courses
    def index
      # Filtering
      language_code = params[:language_code]
      level = params[:level]
      
      # Pagination
      page = params[:page]&.to_i || 1
      per_page = params[:per_page]&.to_i || 20
      per_page = [per_page, 100].min # Max 100 per page
      
      # Cache key
      cache_key = CacheHelper.course_list_key(
        language_code: language_code,
        level: level,
        page: page,
        per_page: per_page
      )
      
      # Cache'den oku veya oluştur
      result = CacheHelper.fetch(cache_key) do
        courses = Course.all
        courses = courses.where(language_code: language_code) if language_code.present?
        courses = courses.where(level: level) if level.present?
        
        total = courses.count
        courses = courses.offset((page - 1) * per_page).limit(per_page)
        
        {
          data: courses.map { |course| serialize_course(course) },
          meta: {
            page: page,
            per_page: per_page,
            total: total
          }
        }
      end
      
      render json: result, status: :ok
    end

    # GET /v1/courses/:id
    def show
      cache_key = CacheHelper.course_detail_key(@course.id)
      
      result = CacheHelper.fetch(cache_key) do
        serialize_course(@course, include_lessons_count: true)
      end
      
      render json: {
        data: result
      }, status: :ok
    end

    # POST /v1/courses
    def create
      course = Course.new(course_params)
      
      if course.save
        # Cache invalidation
        CacheHelper.invalidate_course(course.id)
        
        render json: {
          data: serialize_course(course)
        }, status: :created
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: course.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # PATCH /v1/courses/:id
    def update
      if @course.update(course_params)
        # Cache invalidation
        CacheHelper.invalidate_course(@course.id)
        
        render json: {
          data: serialize_course(@course)
        }, status: :ok
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: @course.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # DELETE /v1/courses/:id
    def destroy
      course_id = @course.id
      @course.destroy
      
      # Cache invalidation
      CacheHelper.invalidate_course(course_id)
      
      head :no_content
    end

    private

    def set_course
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

    def course_params
      params.require(:course).permit(:title, :language_code, :level, :description, :is_published)
    end

    def serialize_course(course, include_lessons_count: false)
      {
        id: course.id,
        type: "course",
        attributes: CourseSerializer.new(course, include_lessons_count: include_lessons_count).as_json
      }
    end
  end
end

