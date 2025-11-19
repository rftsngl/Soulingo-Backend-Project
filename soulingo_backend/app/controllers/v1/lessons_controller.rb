module V1
  class LessonsController < ApplicationController
    before_action :set_course, only: [:index, :create]
    before_action :set_lesson, only: [:show, :update, :destroy]
    before_action :require_admin!, only: [:create, :update, :destroy]

    # GET /v1/courses/:course_id/lessons
    def index
      # SPECIFICATION.md'de "Öğrenci kursa kayıtlı mı kontrol etmek istersen" - net değil
      # Şimdilik auth zorunlu ama enrollment kontrolü yapmıyoruz
      
      cache_key = CacheHelper.lesson_list_key(@course.id)
      
      result = CacheHelper.fetch(cache_key) do
        lessons = @course.lessons.order(:order_index)
        lessons.map { |lesson| serialize_lesson(lesson) }
      end

      render json: {
        data: result
      }, status: :ok
    end

    # GET /v1/lessons/:id
    def show
      cache_key = CacheHelper.lesson_detail_key(@lesson.id)
      
      result = CacheHelper.fetch(cache_key) do
        serialize_lesson(@lesson, include_course_title: true)
      end
      
      render json: {
        data: result
      }, status: :ok
    end

    # POST /v1/courses/:course_id/lessons
    def create
      lesson = @course.lessons.build(lesson_params)

      if lesson.save
        # Cache invalidation
        CacheHelper.invalidate_lesson(lesson.id, @course.id)
        
        render json: {
          data: serialize_lesson(lesson)
        }, status: :created
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: lesson.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # PATCH /v1/lessons/:id
    def update
      if @lesson.update(lesson_params)
        # Cache invalidation
        CacheHelper.invalidate_lesson(@lesson.id, @lesson.course_id)
        
        render json: {
          data: serialize_lesson(@lesson)
        }, status: :ok
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: @lesson.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # DELETE /v1/lessons/:id
    def destroy
      lesson_id = @lesson.id
      course_id = @lesson.course_id
      @lesson.destroy
      
      # Cache invalidation
      CacheHelper.invalidate_lesson(lesson_id, course_id)
      
      head :no_content
    end

    private

    def set_course
      @course = Course.find(params[:course_id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: {
          code: 'not_found',
          message: 'Course not found'
        }
      }, status: :not_found
      return
    end

    def set_lesson
      @lesson = Lesson.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: {
          code: 'not_found',
          message: 'Lesson not found'
        }
      }, status: :not_found
      return
    end

    def lesson_params
      params.require(:lesson).permit(:title, :order_index, :description, :video_url, :expected_duration_minutes)
    end

    def serialize_lesson(lesson, include_course_title: false)
      {
        id: lesson.id,
        type: "lesson",
        attributes: LessonSerializer.new(lesson, include_course_title: include_course_title).as_json
      }
    end
  end
end

