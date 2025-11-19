class Lesson < ApplicationRecord
  belongs_to :course

  # Validations
  validates :title, presence: true
  validates :order_index, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :video_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_nil: true

  # Relationships
  has_many :session_analyses, dependent: :destroy
end

