class SessionAnalysisSerializer < ActiveModel::Serializer
  attributes :id, :overall_score, :fluency_score, :grammar_score, :pronunciation_score,
             :feedback_text, :recorded_video_url, :raw_transcript,
             :session_started_at, :session_ended_at, :created_at, :updated_at

  belongs_to :user
  belongs_to :lesson

  attribute :user_email, if: :include_user_email?
  attribute :lesson_title, if: :include_lesson_title?

  def user_email
    object.user.email
  end

  def include_user_email?
    instance_options[:include_user_email] == true
  end

  def lesson_title
    object.lesson.title
  end

  def include_lesson_title?
    instance_options[:include_lesson_title] == true
  end
end

