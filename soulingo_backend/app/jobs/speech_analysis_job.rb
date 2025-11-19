class SpeechAnalysisJob < ApplicationJob
  queue_as :default

  # Speech-to-Text ve analiz job'ı
  # Girdi: audio_url, user_id, lesson_id, session_analysis_id
  # Çıktı: Transcript ve analiz sonuçları
  def perform(audio_url:, user_id:, lesson_id:, session_analysis_id:)
    Rails.logger.info "SpeechAnalysisJob started: audio_url=#{audio_url}, user_id=#{user_id}, lesson_id=#{lesson_id}, session_analysis_id=#{session_analysis_id}"

    # Stub implementation
    # Gerçek implementasyonda:
    # 1. Media::SttClient ile transcript oluştur
    # 2. Ai::ScoringClient ile skorlama yap
    # 3. SessionAnalysis kaydını güncelle

    # Transcript oluştur (stub)
    transcript_result = Media::SttClient.transcribe(audio_url: audio_url, language: 'en')
    raw_transcript = transcript_result[:transcript]

    # Lesson bilgisini al
    lesson = Lesson.find(lesson_id)
    course = lesson.course

    # Skorlama yap (stub)
    scoring_result = Ai::ScoringClient.analyze_speech(
      raw_transcript: raw_transcript,
      target_language: course.language_code || 'en',
      level: course.level || 'A1'
    )

    # SessionAnalysis kaydını güncelle
    session_analysis = SessionAnalysis.find(session_analysis_id)
    session_analysis.update!(
      raw_transcript: raw_transcript,
      overall_score: scoring_result[:overall_score],
      fluency_score: scoring_result[:fluency_score],
      grammar_score: scoring_result[:grammar_score],
      pronunciation_score: scoring_result[:pronunciation_score],
      feedback_text: scoring_result[:feedback_text]
    )

    Rails.logger.info "SpeechAnalysisJob completed: session_analysis_id=#{session_analysis_id}, overall_score=#{scoring_result[:overall_score]}"

    {
      success: true,
      session_analysis_id: session_analysis_id,
      overall_score: scoring_result[:overall_score],
      message: "Speech analysis completed (stub)"
    }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "SpeechAnalysisJob failed: Record not found - #{e.message}"
    raise
  rescue StandardError => e
    Rails.logger.error "SpeechAnalysisJob failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise
  end
end

