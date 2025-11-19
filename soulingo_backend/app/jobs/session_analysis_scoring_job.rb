class SessionAnalysisScoringJob < ApplicationJob
  queue_as :default

  # SessionAnalysis skorlama job'ı
  # Girdi: session_analysis_id, raw_transcript
  # Çıktı: Güncellenmiş SessionAnalysis kaydı
  def perform(session_analysis_id:, raw_transcript:)
    Rails.logger.info "SessionAnalysisScoringJob started: session_analysis_id=#{session_analysis_id}"

    # Stub implementation
    # Gerçek implementasyonda:
    # 1. Ai::ScoringClient ile skorlama yap
    # 2. SessionAnalysis kaydını güncelle

    session_analysis = SessionAnalysis.find(session_analysis_id)
    lesson = session_analysis.lesson
    course = lesson.course

    # Skorlama yap
    scoring_result = Ai::ScoringClient.analyze_speech(
      raw_transcript: raw_transcript,
      target_language: course.language_code || 'en',
      level: course.level || 'A1'
    )

    # SessionAnalysis kaydını güncelle
    session_analysis.update!(
      raw_transcript: raw_transcript,
      overall_score: scoring_result[:overall_score],
      fluency_score: scoring_result[:fluency_score],
      grammar_score: scoring_result[:grammar_score],
      pronunciation_score: scoring_result[:pronunciation_score],
      feedback_text: scoring_result[:feedback_text]
    )

    Rails.logger.info "SessionAnalysisScoringJob completed: session_analysis_id=#{session_analysis_id}, overall_score=#{scoring_result[:overall_score]}"

    {
      success: true,
      session_analysis_id: session_analysis_id,
      overall_score: scoring_result[:overall_score],
      message: "Session analysis scoring completed (stub)"
    }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "SessionAnalysisScoringJob failed: Record not found - #{e.message}"
    raise
  rescue StandardError => e
    Rails.logger.error "SessionAnalysisScoringJob failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise
  end
end

