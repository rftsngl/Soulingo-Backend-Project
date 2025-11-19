class SessionAnalysis < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  # Validations
  validates :user_id, presence: true
  validates :lesson_id, presence: true
  validates :overall_score, numericality: { in: 0..100 }, allow_nil: true
  validates :fluency_score, numericality: { in: 0..100 }, allow_nil: true
  validates :grammar_score, numericality: { in: 0..100 }, allow_nil: true
  validates :pronunciation_score, numericality: { in: 0..100 }, allow_nil: true
  validates :recorded_video_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_nil: true
end

