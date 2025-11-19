module V1
  class SessionAnalysesController < ApplicationController
    before_action :set_lesson, only: [:create, :lesson_analyses]
    before_action :set_user, only: [:user_analyses]

    # POST /v1/lessons/:lesson_id/session_analyses
    def create
      # Kullanıcı kendi adına analiz kaydı oluşturuyor
      session_analysis = SessionAnalysis.new(session_analysis_params)
      session_analysis.user = current_user
      session_analysis.lesson = @lesson

      if session_analysis.save
        # Real-time broadcast: analysis_complete mesajı gönder
        broadcast_analysis_complete(session_analysis)
        
        render json: {
          data: serialize_session_analysis(session_analysis, include_lesson_title: true)
        }, status: :created
      else
        render json: {
          error: {
            code: 'validation_error',
            message: 'Given data is invalid',
            details: session_analysis.errors.as_json
          }
        }, status: :unprocessable_entity
      end
    end

    # GET /v1/users/:user_id/session_analyses
    def user_analyses
      # Kullanıcı sadece kendi analizlerini görebilir veya admin herkesi görebilir
      require_self_or_admin!(@user.id)
      return if performed? # Authorization failed, already rendered

      session_analyses = SessionAnalysis.where(user: @user)
                                        .includes(:lesson)

      # Filtering
      session_analyses = session_analyses.where(lesson_id: params[:lesson_id]) if params[:lesson_id].present?
      if params[:start_date].present?
        start_date = Date.parse(params[:start_date]) rescue nil
        session_analyses = session_analyses.where('session_started_at >= ?', start_date) if start_date
      end
      if params[:end_date].present?
        end_date = Date.parse(params[:end_date]) rescue nil
        session_analyses = session_analyses.where('session_started_at <= ?', end_date.end_of_day) if end_date
      end

      session_analyses = session_analyses.order(created_at: :desc)

      render json: {
        data: session_analyses.map { |analysis| serialize_session_analysis(analysis, include_lesson_title: true) }
      }, status: :ok
    end

    # GET /v1/lessons/:lesson_id/session_analyses
    def lesson_analyses
      # Sadece admin görebilir
      require_admin!
      return if performed? # Authorization failed, already rendered

      session_analyses = SessionAnalysis.where(lesson: @lesson)
                                        .includes(:user)
                                        .order(created_at: :desc)

      render json: {
        data: session_analyses.map { |analysis| serialize_session_analysis(analysis, include_user_email: true) }
      }, status: :ok
    end

    private

    def set_lesson
      # Nested route (create): /v1/lessons/:lesson_id/session_analyses -> params[:lesson_id]
      # Member route (lesson_analyses): /v1/lessons/:id/session_analyses -> params[:id]
      lesson_id = params[:lesson_id] || params[:id]
      @lesson = Lesson.find(lesson_id)
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: {
          code: 'not_found',
          message: 'Lesson not found'
        }
      }, status: :not_found
      return
    end

    def set_user
      # Member route: /v1/users/:id/session_analyses -> params[:id]
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

    def session_analysis_params
      params.require(:session_analysis).permit(
        :overall_score, :fluency_score, :grammar_score, :pronunciation_score,
        :feedback_text, :recorded_video_url, :raw_transcript,
        :session_started_at, :session_ended_at
      )
    end

    def serialize_session_analysis(analysis, include_user_email: false, include_lesson_title: false)
      {
        id: analysis.id,
        type: "session_analysis",
        attributes: SessionAnalysisSerializer.new(
          analysis,
          include_user_email: include_user_email,
          include_lesson_title: include_lesson_title
        ).as_json
      }
    end

    def broadcast_analysis_complete(session_analysis)
      # Lesson channel'ına analysis_complete mesajı gönder
      ActionCable.server.broadcast("lesson_#{session_analysis.lesson_id}", {
        type: "analysis_complete",
        message: "Session analysis completed",
        timestamp: Time.current.iso8601,
        lesson_id: session_analysis.lesson_id,
        session_analysis_id: session_analysis.id,
        overall_score: session_analysis.overall_score
      })
    end
  end
end

